#include "kgio.h"
#include "my_fileno.h"
#include "nonblock.h"
#ifdef HAVE_WRITEV
#  include <sys/uio.h>
#  define USE_WRITEV 1
#else
#  define USE_WRITEV 0
static ssize_t assert_writev(int fd, void* iov, int len)
{
	assert(0 && "you should not try to call writev");
	return -1;
}
#  define writev assert_writev
#endif
static VALUE sym_wait_readable, sym_wait_writable;
static VALUE eErrno_EPIPE, eErrno_ECONNRESET;
static ID id_set_backtrace;
#ifndef HAVE_RB_STR_SUBSEQ
#define rb_str_subseq rb_str_substr
#endif

#ifndef HAVE_RB_ARY_SUBSEQ
static inline VALUE my_ary_subseq(VALUE ary, long idx, long len)
{
	VALUE args[2] = {LONG2FIX(idx), LONG2FIX(len)};
	return rb_ary_aref(2, args, ary);
}
#define rb_ary_subseq my_ary_subseq
#endif

/*
 * we know MSG_DONTWAIT works properly on all stream sockets under Linux
 * we can define this macro for other platforms as people care and
 * notice.
 */
#if defined(__linux__) && ! defined(USE_MSG_DONTWAIT)
#  define USE_MSG_DONTWAIT
static const int peek_flags = MSG_DONTWAIT|MSG_PEEK;

/* we don't need these variants, we call kgio_autopush_send/recv directly */
static inline void kgio_autopush_read(VALUE io) { }
static inline void kgio_autopush_write(VALUE io) { }

#else
static const int peek_flags = MSG_PEEK;
static inline void kgio_autopush_read(VALUE io) { kgio_autopush_recv(io); }
static inline void kgio_autopush_write(VALUE io) { kgio_autopush_send(io); }
#endif

NORETURN(static void raise_empty_bt(VALUE, const char *));
NORETURN(static void my_eof_error(void));
NORETURN(static void wr_sys_fail(const char *));
NORETURN(static void rd_sys_fail(const char *));

static void raise_empty_bt(VALUE err, const char *msg)
{
	VALUE exc = rb_exc_new2(err, msg);
	VALUE bt = rb_ary_new();

	rb_funcall(exc, id_set_backtrace, 1, bt);
	rb_exc_raise(exc);
}

static void my_eof_error(void)
{
	raise_empty_bt(rb_eEOFError, "end of file reached");
}

static void wr_sys_fail(const char *msg)
{
	switch (errno) {
	case EPIPE:
		errno = 0;
		raise_empty_bt(eErrno_EPIPE, msg);
	case ECONNRESET:
		errno = 0;
		raise_empty_bt(eErrno_ECONNRESET, msg);
	}
	rb_sys_fail(msg);
}

static void rd_sys_fail(const char *msg)
{
	if (errno == ECONNRESET) {
		errno = 0;
		raise_empty_bt(eErrno_ECONNRESET, msg);
	}
	rb_sys_fail(msg);
}

static void prepare_read(struct io_args *a, int argc, VALUE *argv, VALUE io)
{
	VALUE length;

	a->io = io;
	a->fd = my_fileno(io);
	rb_scan_args(argc, argv, "11", &length, &a->buf);
	a->len = NUM2LONG(length);
	if (NIL_P(a->buf)) {
		a->buf = rb_str_new(NULL, a->len);
	} else {
		StringValue(a->buf);
		rb_str_modify(a->buf);
		rb_str_resize(a->buf, a->len);
	}
	a->ptr = RSTRING_PTR(a->buf);
}

static int read_check(struct io_args *a, long n, const char *msg, int io_wait)
{
	if (n == -1) {
		if (errno == EINTR) {
			a->fd = my_fileno(a->io);
			return -1;
		}
		rb_str_set_len(a->buf, 0);
		if (errno == EAGAIN) {
			if (io_wait) {
				(void)kgio_call_wait_readable(a->io);

				/* buf may be modified in other thread/fiber */
				rb_str_modify(a->buf);
				rb_str_resize(a->buf, a->len);
				a->ptr = RSTRING_PTR(a->buf);
				return -1;
			} else {
				a->buf = sym_wait_readable;
				return 0;
			}
		}
		rd_sys_fail(msg);
	}
	rb_str_set_len(a->buf, n);
	if (n == 0)
		a->buf = Qnil;
	return 0;
}

static VALUE my_read(int io_wait, int argc, VALUE *argv, VALUE io)
{
	struct io_args a;
	long n;

	prepare_read(&a, argc, argv, io);
	kgio_autopush_read(io);

	if (a.len > 0) {
		set_nonblocking(a.fd);
retry:
		n = (long)read(a.fd, a.ptr, a.len);
		if (read_check(&a, n, "read", io_wait) != 0)
			goto retry;
	}
	return a.buf;
}

/*
 * call-seq:
 *
 *	io.kgio_read(maxlen)           ->  buffer
 *	io.kgio_read(maxlen, buffer)   ->  buffer
 *
 * Reads at most maxlen bytes from the stream socket.  Returns with a
 * newly allocated buffer, or may reuse an existing buffer if supplied.
 *
 * This may block and call any method defined to +kgio_wait_readable+
 * for the class.
 *
 * Returns nil on EOF.
 *
 * This behaves like read(2) and IO#readpartial, NOT fread(3) or
 * IO#read which possess read-in-full behavior.
 */
static VALUE kgio_read(int argc, VALUE *argv, VALUE io)
{
	return my_read(1, argc, argv, io);
}

/*
 * Same as Kgio::PipeMethods#kgio_read, except EOFError is raised
 * on EOF without a backtrace.  This method is intended as a
 * drop-in replacement for places where IO#readpartial is used, and
 * may be aliased as such.
 */
static VALUE kgio_read_bang(int argc, VALUE *argv, VALUE io)
{
	VALUE rv = my_read(1, argc, argv, io);

	if (NIL_P(rv)) my_eof_error();
	return rv;
}

/*
 * call-seq:
 *
 *	io.kgio_tryread(maxlen)           ->  buffer
 *	io.kgio_tryread(maxlen, buffer)   ->  buffer
 *
 * Reads at most maxlen bytes from the stream socket.  Returns with a
 * newly allocated buffer, or may reuse an existing buffer if supplied.
 *
 * Returns nil on EOF.
 *
 * Returns :wait_readable if EAGAIN is encountered.
 */
static VALUE kgio_tryread(int argc, VALUE *argv, VALUE io)
{
	return my_read(0, argc, argv, io);
}

#ifdef USE_MSG_DONTWAIT
static VALUE my_recv(int io_wait, int argc, VALUE *argv, VALUE io)
{
	struct io_args a;
	long n;

	prepare_read(&a, argc, argv, io);
	kgio_autopush_recv(io);

	if (a.len > 0) {
retry:
		n = (long)recv(a.fd, a.ptr, a.len, MSG_DONTWAIT);
		if (read_check(&a, n, "recv", io_wait) != 0)
			goto retry;
	}
	return a.buf;
}

/*
 * This method may be optimized on some systems (e.g. GNU/Linux) to use
 * MSG_DONTWAIT to avoid explicitly setting the O_NONBLOCK flag via fcntl.
 * Otherwise this is the same as Kgio::PipeMethods#kgio_read
 */
static VALUE kgio_recv(int argc, VALUE *argv, VALUE io)
{
	return my_recv(1, argc, argv, io);
}

/*
 * Same as Kgio::SocketMethods#kgio_read, except EOFError is raised
 * on EOF without a backtrace
 */
static VALUE kgio_recv_bang(int argc, VALUE *argv, VALUE io)
{
	VALUE rv = my_recv(1, argc, argv, io);

	if (NIL_P(rv)) my_eof_error();
	return rv;
}

/*
 * This method may be optimized on some systems (e.g. GNU/Linux) to use
 * MSG_DONTWAIT to avoid explicitly setting the O_NONBLOCK flag via fcntl.
 * Otherwise this is the same as Kgio::PipeMethods#kgio_tryread
 */
static VALUE kgio_tryrecv(int argc, VALUE *argv, VALUE io)
{
	return my_recv(0, argc, argv, io);
}
#else /* ! USE_MSG_DONTWAIT */
#  define kgio_recv kgio_read
#  define kgio_recv_bang kgio_read_bang
#  define kgio_tryrecv kgio_tryread
#endif /* USE_MSG_DONTWAIT */

static VALUE my_peek(int io_wait, int argc, VALUE *argv, VALUE io)
{
	struct io_args a;
	long n;

	prepare_read(&a, argc, argv, io);
	kgio_autopush_recv(io);

	if (a.len > 0) {
		if (peek_flags == MSG_PEEK)
			set_nonblocking(a.fd);
retry:
		n = (long)recv(a.fd, a.ptr, a.len, peek_flags);
		if (read_check(&a, n, "recv(MSG_PEEK)", io_wait) != 0)
			goto retry;
	}
	return a.buf;
}

/*
 * call-seq:
 *
 *	socket.kgio_trypeek(maxlen)           ->  buffer
 *	socket.kgio_trypeek(maxlen, buffer)   ->  buffer
 *
 * Like kgio_tryread, except it uses MSG_PEEK so it does not drain the
 * socket buffer.  A subsequent read of any type (including another peek)
 * will return the same data.
 */
static VALUE kgio_trypeek(int argc, VALUE *argv, VALUE io)
{
	return my_peek(0, argc, argv, io);
}

/*
 * call-seq:
 *
 *	socket.kgio_peek(maxlen)           ->  buffer
 *	socket.kgio_peek(maxlen, buffer)   ->  buffer
 *
 * Like kgio_read, except it uses MSG_PEEK so it does not drain the
 * socket buffer.  A subsequent read of any type (including another peek)
 * will return the same data.
 */
static VALUE kgio_peek(int argc, VALUE *argv, VALUE io)
{
	return my_peek(1, argc, argv, io);
}

/*
 * call-seq:
 *
 *	Kgio.trypeek(socket, maxlen)           ->  buffer
 *	Kgio.trypeek(socket, maxlen, buffer)   ->  buffer
 *
 * Like Kgio.tryread, except it uses MSG_PEEK so it does not drain the
 * socket buffer.  This can only be used on sockets and not pipe objects.
 * Maybe used in place of SocketMethods#kgio_trypeek for non-Kgio objects
 */
static VALUE s_trypeek(int argc, VALUE *argv, VALUE mod)
{
	if (argc <= 1)
		rb_raise(rb_eArgError, "wrong number of arguments");
	return my_peek(0, argc - 1, &argv[1], argv[0]);
}

static void prepare_write(struct io_args *a, VALUE io, VALUE str)
{
	a->buf = (TYPE(str) == T_STRING) ? str : rb_obj_as_string(str);
	a->ptr = RSTRING_PTR(a->buf);
	a->len = RSTRING_LEN(a->buf);
	a->io = io;
	a->fd = my_fileno(io);
}

static int write_check(struct io_args *a, long n, const char *msg, int io_wait)
{
	if (a->len == n) {
done:
		a->buf = Qnil;
	} else if (n == -1) {
		if (errno == EINTR) {
			a->fd = my_fileno(a->io);
			return -1;
		}
		if (errno == EAGAIN) {
			long written = RSTRING_LEN(a->buf) - a->len;

			if (io_wait) {
				(void)kgio_call_wait_writable(a->io);

				/* buf may be modified in other thread/fiber */
				a->len = RSTRING_LEN(a->buf) - written;
				if (a->len <= 0)
					goto done;
				a->ptr = RSTRING_PTR(a->buf) + written;
				return -1;
			} else if (written > 0) {
				a->buf = rb_str_subseq(a->buf, written, a->len);
			} else {
				a->buf = sym_wait_writable;
			}
			return 0;
		}
		wr_sys_fail(msg);
	} else {
		assert(n >= 0 && n < a->len && "write/send syscall broken?");
		a->ptr += n;
		a->len -= n;
		return -1;
	}
	return 0;
}

static VALUE my_write(VALUE io, VALUE str, int io_wait)
{
	struct io_args a;
	long n;

	prepare_write(&a, io, str);
	set_nonblocking(a.fd);
retry:
	n = (long)write(a.fd, a.ptr, a.len);
	if (write_check(&a, n, "write", io_wait) != 0)
		goto retry;
	if (TYPE(a.buf) != T_SYMBOL)
		kgio_autopush_write(io);
	return a.buf;
}

/*
 * call-seq:
 *
 *	io.kgio_write(str)	-> nil
 *
 * Returns nil when the write completes.
 *
 * This may block and call any method defined to +kgio_wait_writable+
 * for the class.
 */
static VALUE kgio_write(VALUE io, VALUE str)
{
	return my_write(io, str, 1);
}

/*
 * call-seq:
 *
 *	io.kgio_trywrite(str)	-> nil, String or :wait_writable
 *
 * Returns nil if the write was completed in full.
 *
 * Returns a String containing the unwritten portion if EAGAIN
 * was encountered, but some portion was successfully written.
 *
 * Returns :wait_writable if EAGAIN is encountered and nothing
 * was written.
 */
static VALUE kgio_trywrite(VALUE io, VALUE str)
{
	return my_write(io, str, 0);
}

#ifndef HAVE_WRITEV
#define iovec my_iovec
struct my_iovec {
	void  *iov_base;
	size_t iov_len;
};
#endif

/* tests for choosing following constants were done on Linux 3.0 x86_64
 * (Ubuntu 12.04) Core i3 i3-2330M slowed to 1600MHz
 * testing script https://gist.github.com/2850641
 * fill free to make more thorough testing and choose better value
 */

/* test shows that its meaningless to set WRITEV_MEMLIMIT more that 1M
 * even when tcp_wmem set to relatively high value (2M) (in fact, it becomes
 * even slower). 512K performs a bit better in average case. */
#define WRITEV_MEMLIMIT (512*1024)
/* same test shows that custom_writev is faster than glibc writev when
 * average string is smaller than ~500 bytes and slower when average strings
 * is greater then ~600 bytes. 512 bytes were choosen cause current compilers
 * turns x/512 into x>>9 */
#define WRITEV_IMPL_THRESHOLD 512

static unsigned int iov_max = 1024; /* this could be overriden in init */

struct io_args_v {
	VALUE io;
	VALUE buf;
	VALUE vec_buf;
	struct iovec *vec;
	unsigned long iov_cnt;
	size_t batch_len;
	int something_written;
	int fd;
};

static ssize_t custom_writev(int fd, const struct iovec *vec, unsigned int iov_cnt, size_t total_len)
{
	unsigned int i;
	ssize_t result;
	char *buf, *curbuf;
	const struct iovec *curvec = vec;

	/* we do not want to use ruby's xmalloc because
	 * it can fire GC, and we'll free buffer shortly anyway */
	curbuf = buf = malloc(total_len);
	if (buf == NULL) return -1;

	for (i = 0; i < iov_cnt; i++, curvec++) {
		memcpy(curbuf, curvec->iov_base, curvec->iov_len);
		curbuf += curvec->iov_len;
	}

	result = write(fd, buf, total_len);

	/* well, it seems that `free` could not change errno
	 * but lets save it anyway */
	i = errno;
	free(buf);
	errno = i;

	return result;
}

static void prepare_writev(struct io_args_v *a, VALUE io, VALUE ary)
{
	a->io = io;
	a->fd = my_fileno(io);
	a->something_written = 0;

	if (TYPE(ary) == T_ARRAY)
		/* rb_ary_subseq will not copy array unless it modified */
		a->buf = rb_ary_subseq(ary, 0, RARRAY_LEN(ary));
	else
		a->buf = rb_Array(ary);

	a->vec_buf = rb_str_new(0, 0);
	a->vec = NULL;
}

static void fill_iovec(struct io_args_v *a)
{
	unsigned long i;
	struct iovec *curvec;

	a->iov_cnt = RARRAY_LEN(a->buf);
	a->batch_len = 0;
	if (a->iov_cnt == 0) return;
	if (a->iov_cnt > iov_max) a->iov_cnt = iov_max;
	rb_str_resize(a->vec_buf, sizeof(struct iovec) * a->iov_cnt);
	curvec = a->vec = (struct iovec*)RSTRING_PTR(a->vec_buf);

	for (i=0; i < a->iov_cnt; i++, curvec++) {
		/* rb_ary_store could reallocate array,
		 * so that ought to use RARRAY_PTR */
		VALUE str = RARRAY_PTR(a->buf)[i];
		long str_len, next_len;

		if (TYPE(str) != T_STRING) {
			str = rb_obj_as_string(str);
			rb_ary_store(a->buf, i, str);
		}

		str_len = RSTRING_LEN(str);

		/* lets limit total memory to write,
		 * but always take first string */
		next_len = a->batch_len + str_len;
		if (i && next_len > WRITEV_MEMLIMIT) {
			a->iov_cnt = i;
			break;
		}
		a->batch_len = next_len;

		curvec->iov_base = RSTRING_PTR(str);
		curvec->iov_len = str_len;
	}
}

static long trim_writev_buffer(struct io_args_v *a, long n)
{
	long i;
	long ary_len = RARRAY_LEN(a->buf);
	VALUE *elem = RARRAY_PTR(a->buf);

	if (n == (long)a->batch_len) {
		i = a->iov_cnt;
		n = 0;
	} else {
		for (i = 0; n && i < ary_len; i++, elem++) {
			n -= RSTRING_LEN(*elem);
			if (n < 0) break;
		}
	}

	/* all done */
	if (i == ary_len) {
		assert(n == 0 && "writev system call is broken");
		a->buf = Qnil;
		return 0;
	}

	/* partially done, remove fully-written buffers */
	if (i > 0)
		a->buf = rb_ary_subseq(a->buf, i, ary_len - i);

	/* setup+replace partially written buffer */
	if (n < 0) {
		VALUE str = RARRAY_PTR(a->buf)[0];
		long str_len = RSTRING_LEN(str);
		str = rb_str_subseq(str, str_len + n, -n);
		rb_ary_store(a->buf, 0, str);
	}
	return RARRAY_LEN(a->buf);
}

static int writev_check(struct io_args_v *a, long n, const char *msg, int io_wait)
{
	if (n >= 0) {
		if (n > 0) a->something_written = 1;
		return trim_writev_buffer(a, n);
	} else if (n == -1) {
		if (errno == EINTR) {
			a->fd = my_fileno(a->io);
			return -1;
		}
		if (errno == EAGAIN) {
			if (io_wait) {
				(void)kgio_call_wait_writable(a->io);
				return -1;
			} else if (!a->something_written) {
				a->buf = sym_wait_writable;
			}
			return 0;
		}
		wr_sys_fail(msg);
	}
	return 0;
}

static VALUE my_writev(VALUE io, VALUE str, int io_wait)
{
	struct io_args_v a;
	long n;

	prepare_writev(&a, io, str);
	set_nonblocking(a.fd);

	do {
		fill_iovec(&a);
		if (a.iov_cnt == 0)
			n = 0;
		else if (a.iov_cnt == 1)
			n = (long)write(a.fd, a.vec[0].iov_base, a.vec[0].iov_len);
		/* for big strings use library function */
		else if (USE_WRITEV && a.batch_len / WRITEV_IMPL_THRESHOLD > a.iov_cnt)
			n = (long)writev(a.fd, a.vec, a.iov_cnt);
		else
			n = (long)custom_writev(a.fd, a.vec, a.iov_cnt, a.batch_len);
	} while (writev_check(&a, n, "writev", io_wait) != 0);
	rb_str_resize(a.vec_buf, 0);

	if (TYPE(a.buf) != T_SYMBOL)
		kgio_autopush_write(io);
	return a.buf;
}

/*
 * call-seq:
 *
 *	io.kgio_writev(array)	-> nil
 *
 * Returns nil when the write completes.
 *
 * This may block and call any method defined to +kgio_wait_writable+
 * for the class.
 *
 * Note: it uses +Array()+ semantic for converting argument, so that
 * it will succeed if you pass something else.
 */
static VALUE kgio_writev(VALUE io, VALUE ary)
{
	return my_writev(io, ary, 1);
}

/*
 * call-seq:
 *
 *	io.kgio_trywritev(array)	-> nil, Array or :wait_writable
 *
 * Returns nil if the write was completed in full.
 *
 * Returns an Array of strings containing the unwritten portion
 * if EAGAIN was encountered, but some portion was successfully written.
 *
 * Returns :wait_writable if EAGAIN is encountered and nothing
 * was written.
 *
 * Note: it uses +Array()+ semantic for converting argument, so that
 * it will succeed if you pass something else.
 */
static VALUE kgio_trywritev(VALUE io, VALUE ary)
{
	return my_writev(io, ary, 0);
}

#ifdef USE_MSG_DONTWAIT
/*
 * This method behaves like Kgio::PipeMethods#kgio_write, except
 * it will use send(2) with the MSG_DONTWAIT flag on sockets to
 * avoid unnecessary calls to fcntl(2).
 */
static VALUE my_send(VALUE io, VALUE str, int io_wait)
{
	struct io_args a;
	long n;

	prepare_write(&a, io, str);
retry:
	n = (long)send(a.fd, a.ptr, a.len, MSG_DONTWAIT);
	if (write_check(&a, n, "send", io_wait) != 0)
		goto retry;
	if (TYPE(a.buf) != T_SYMBOL)
		kgio_autopush_send(io);
	return a.buf;
}

/*
 * This method may be optimized on some systems (e.g. GNU/Linux) to use
 * MSG_DONTWAIT to avoid explicitly setting the O_NONBLOCK flag via fcntl.
 * Otherwise this is the same as Kgio::PipeMethods#kgio_write
 */
static VALUE kgio_send(VALUE io, VALUE str)
{
	return my_send(io, str, 1);
}

/*
 * This method may be optimized on some systems (e.g. GNU/Linux) to use
 * MSG_DONTWAIT to avoid explicitly setting the O_NONBLOCK flag via fcntl.
 * Otherwise this is the same as Kgio::PipeMethods#kgio_trywrite
 */
static VALUE kgio_trysend(VALUE io, VALUE str)
{
	return my_send(io, str, 0);
}
#else /* ! USE_MSG_DONTWAIT */
#  define kgio_send kgio_write
#  define kgio_trysend kgio_trywrite
#endif /* ! USE_MSG_DONTWAIT */

/*
 * call-seq:
 *
 *	Kgio.tryread(io, maxlen)           ->  buffer
 *	Kgio.tryread(io, maxlen, buffer)   ->  buffer
 *
 * Returns nil on EOF.
 * Returns :wait_readable if EAGAIN is encountered.
 *
 * Maybe used in place of PipeMethods#kgio_tryread for non-Kgio objects
 */
static VALUE s_tryread(int argc, VALUE *argv, VALUE mod)
{
	if (argc <= 1)
		rb_raise(rb_eArgError, "wrong number of arguments");
	return my_read(0, argc - 1, &argv[1], argv[0]);
}

/*
 * call-seq:
 *
 *	Kgio.trywrite(io, str)    -> nil, String or :wait_writable
 *
 * Returns nil if the write was completed in full.
 *
 * Returns a String containing the unwritten portion if EAGAIN
 * was encountered, but some portion was successfully written.
 *
 * Returns :wait_writable if EAGAIN is encountered and nothing
 * was written.
 *
 * Maybe used in place of PipeMethods#kgio_trywrite for non-Kgio objects
 */
static VALUE s_trywrite(VALUE mod, VALUE io, VALUE str)
{
	return my_write(io, str, 0);
}

/*
 * call-seq:
 *
 *	Kgio.trywritev(io, array)    -> nil, Array or :wait_writable
 *
 * Returns nil if the write was completed in full.
 *
 * Returns a Array of strings containing the unwritten portion if EAGAIN
 * was encountered, but some portion was successfully written.
 *
 * Returns :wait_writable if EAGAIN is encountered and nothing
 * was written.
 *
 * Maybe used in place of PipeMethods#kgio_trywritev for non-Kgio objects
 */
static VALUE s_trywritev(VALUE mod, VALUE io, VALUE ary)
{
	return kgio_trywritev(io, ary);
}

void init_kgio_read_write(void)
{
	VALUE mPipeMethods, mSocketMethods;
	VALUE mKgio = rb_define_module("Kgio");
	VALUE mWaiters = rb_const_get(mKgio, rb_intern("DefaultWaiters"));

	sym_wait_readable = ID2SYM(rb_intern("wait_readable"));
	sym_wait_writable = ID2SYM(rb_intern("wait_writable"));

	rb_define_singleton_method(mKgio, "tryread", s_tryread, -1);
	rb_define_singleton_method(mKgio, "trywrite", s_trywrite, 2);
	rb_define_singleton_method(mKgio, "trywritev", s_trywritev, 2);
	rb_define_singleton_method(mKgio, "trypeek", s_trypeek, -1);

	/*
	 * Document-module: Kgio::PipeMethods
	 *
	 * This module may be used used to create classes that respond to
	 * various Kgio methods for reading and writing.  This is included
	 * in Kgio::Pipe by default.
	 */
	mPipeMethods = rb_define_module_under(mKgio, "PipeMethods");
	rb_define_method(mPipeMethods, "kgio_read", kgio_read, -1);
	rb_define_method(mPipeMethods, "kgio_read!", kgio_read_bang, -1);
	rb_define_method(mPipeMethods, "kgio_write", kgio_write, 1);
	rb_define_method(mPipeMethods, "kgio_writev", kgio_writev, 1);
	rb_define_method(mPipeMethods, "kgio_tryread", kgio_tryread, -1);
	rb_define_method(mPipeMethods, "kgio_trywrite", kgio_trywrite, 1);
	rb_define_method(mPipeMethods, "kgio_trywritev", kgio_trywritev, 1);

	/*
	 * Document-module: Kgio::SocketMethods
	 *
	 * This method behaves like Kgio::PipeMethods, but contains
	 * optimizations for sockets on certain operating systems
	 * (e.g. GNU/Linux).
	 */
	mSocketMethods = rb_define_module_under(mKgio, "SocketMethods");
	rb_define_method(mSocketMethods, "kgio_read", kgio_recv, -1);
	rb_define_method(mSocketMethods, "kgio_read!", kgio_recv_bang, -1);
	rb_define_method(mSocketMethods, "kgio_write", kgio_send, 1);
	rb_define_method(mSocketMethods, "kgio_writev", kgio_writev, 1);
	rb_define_method(mSocketMethods, "kgio_tryread", kgio_tryrecv, -1);
	rb_define_method(mSocketMethods, "kgio_trywrite", kgio_trysend, 1);
	rb_define_method(mSocketMethods, "kgio_trywritev", kgio_trywritev, 1);
	rb_define_method(mSocketMethods, "kgio_trypeek", kgio_trypeek, -1);
	rb_define_method(mSocketMethods, "kgio_peek", kgio_peek, -1);

	/*
	 * Returns the client IP address of the socket as a string
	 * (e.g. "127.0.0.1" or "::1").
	 * This is always the value of the Kgio::LOCALHOST constant
	 * for UNIX domain sockets.
	 */
	rb_define_attr(mSocketMethods, "kgio_addr", 1, 1);
	id_set_backtrace = rb_intern("set_backtrace");
	eErrno_EPIPE = rb_const_get(rb_mErrno, rb_intern("EPIPE"));
	eErrno_ECONNRESET = rb_const_get(rb_mErrno, rb_intern("ECONNRESET"));
	rb_include_module(mPipeMethods, mWaiters);
	rb_include_module(mSocketMethods, mWaiters);

#ifdef HAVE_WRITEV
	{
#  ifdef IOV_MAX
		unsigned int sys_iov_max = IOV_MAX;
#  else
		unsigned int sys_iov_max = sysconf(_SC_IOV_MAX);
#  endif
		if (sys_iov_max < iov_max)
			iov_max = sys_iov_max;
	}
#endif
}
