// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
//= require bootstrap

// Replace link targets with JavaScript handlers to prevent iOS fullscreen web
// app from opening links in extra browser app
if (navigator.userAgent.match(/(ipod|iphone|ipad)/i)) {
	$(function() {
		$('body a[href]').click(function(e) {
	  	e.preventDefault();
	    top.location.href = this;
	  });
	});
}

//hide notification bars after a few seconds
$('.alert').delay(10000).fadeOut('slow');
