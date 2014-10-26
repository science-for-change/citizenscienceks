$(document).ready(
  function() {
    $(".hero").height($(window).height());
    setInterval(function() {
      var nav = $('.full-width-top-bar');
      var bg = $('.top-bar-background');
      if (nav.offset().top > 50 && bg.is(":hidden")) {
        bg.fadeIn();
      } else if (nav.offset().top < 50 && bg.is(":visible")) {
        bg.fadeOut();
      }
    }, 500);
    $(window).resize(function() {
      $(".hero").height($(window).height());
    });
  }
);
