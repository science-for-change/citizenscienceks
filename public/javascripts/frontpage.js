$(document).ready(
  function() {

    // resize hero image to 100% height
    $(".hero").height($(window).height());

    // animation for top bar background
    setInterval(function() {
      if ($('.fixed').is(':hidden')) return;
      var nav = $('.full-width-top-bar');
      var bg = $('.top-bar-background');
      if (nav.offset().top > 50 && bg.is(':hidden')) {
        bg.fadeIn();
      } else if (nav.offset().top < 50 && bg.is(':visible')) {
        bg.fadeOut();
      }
    }, 500);

    // handle window resize for hero image
    $(window).resize(function() {
      $(".hero").height($(window).height());
    });

    // load map
    L.mapbox.accessToken = 'pk.eyJ1IjoicmFuZG9tbSIsImEiOiJjVnloMEJ3In0.LW_7lV49M8U2kCNGf30qCQ';
    var map = L.mapbox.map('map', 'randomm.k2i2p2a1');

    // Disable drag and zoom handlers.
    map.touchZoom.disable();
    map.doubleClickZoom.disable();
    map.scrollWheelZoom.disable();

    var featureLayer = L.mapbox.featureLayer()
      .loadURL('/sites.geojson')
      .addTo(map);


    // Disable tap handler, if present.
    if (map.tap) map.tap.disable();
  }
);
