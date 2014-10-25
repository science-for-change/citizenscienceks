$(document).ready(
  function() {
    setInterval(function() {
      var e = $('.fixed-nav');
      if (e.offset().top > 50 && e.hasClass("at-top")) {
        e.addClass("scrolled-down", 400);
        e.removeClass("at-top");
      } else if (e.offset().top < 50 && e.hasClass("scrolled-down")) {
        e.addClass("at-top");
        e.removeClass("scrolled-down", 400);
      }
    }, 500);
  }
);
