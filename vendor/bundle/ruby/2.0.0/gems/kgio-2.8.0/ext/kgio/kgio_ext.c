#include "kgio.h"
#include <sys/utsname.h>
#include <stdio.h>
/* true if TCP Fast Open is usable */
unsigned kgio_tfo;

static void tfo_maybe(void)
{
	VALUE mKgio = rb_define_module("Kgio");

	/* Deal with the case where system headers have not caught up */
	if (KGIO_TFO_MAYBE) {
		/* Ensure Linux 3.7 or later for TCP_FASTOPEN */
		struct utsname buf;
		unsigned maj, min;

		if (uname(&buf) != 0)
			rb_sys_fail("uname");
		if (sscanf(buf.release, "%u.%u", &maj, &min) != 2)
			return;
		if (maj < 3 || (maj == 3 && min < 7))
			return;
	}

	/*
	 * KGIO_TFO_MAYBE will be false if a distro backports TFO
	 * to a pre-3.7 kernel, but includes the necessary constants
	 * in system headers
	 */
#if defined(MSG_FASTOPEN) && defined(TCP_FASTOPEN)
	rb_define_const(mKgio, "TCP_FASTOPEN", INT2NUM(TCP_FASTOPEN));
	rb_define_const(mKgio, "MSG_FASTOPEN", INT2NUM(MSG_FASTOPEN));
	kgio_tfo = 1;
#endif
}

void Init_kgio_ext(void)
{
	tfo_maybe();
	init_kgio_wait();
	init_kgio_read_write();
	init_kgio_connect();
	init_kgio_accept();
	init_kgio_autopush();
	init_kgio_poll();
	init_kgio_tryopen();
}
