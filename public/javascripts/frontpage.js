$(document).ready(
  function() {

    // load map
    L.mapbox.accessToken = 'pk.eyJ1IjoicmFuZG9tbSIsImEiOiJjVnloMEJ3In0.LW_7lV49M8U2kCNGf30qCQ';
    var map = L.mapbox.map('map', 'randomm.k2i2p2a1');

    // Disable drag and zoom handlers.
    map.touchZoom.disable();
    map.doubleClickZoom.disable();
    map.scrollWheelZoom.disable();

    var featureLayer = L.mapbox.featureLayer()
      .loadURL('/sites.geojson')
      .on('ready', function(e) {
        var clusterGroup = new L.MarkerClusterGroup();
        e.target.eachLayer(function(layer) {
          clusterGroup.addLayer(layer);
          layer.setIcon(L.mapbox.marker.icon({'marker-symbol': 'circle-stroked', 'marker-color': '998445'}));
          console.log(layer)
          layer.bindPopup(" <h3>" + layer.feature.properties.title + "</h3>\
                            <ul>\
                              <li>ghost wipe data</li>\
                              <li>diffusion tube data</li>\
                              <li>smart citizen kit data</li>\
                            </ul>");
        });
        map.addLayer(clusterGroup);
      });

    // Disable tap handler, if present.
    if (map.tap) map.tap.disable();
  }
);
