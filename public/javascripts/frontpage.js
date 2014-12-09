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
          var popup_html = '<div class="tooltip-container">\
                              <h3>' + layer.feature.properties.title + '</h3>\
                              <div class="btn-group-vertical" role="group" aria-label="...">'
          if (layer.feature.properties.has_ghost_wipes) {
            popup_html  += '    <button type="button" class="btn btn-default map-btn">Ghost Wipes</button>'
          }
          if (layer.feature.properties.has_diffusion_tubes) {
            popup_html  += '    <button type="button" class="btn btn-default map-btn">Diffusion Tubes</button>'
          }
          if (layer.feature.properties.has_sck_devices) {
            popup_html  += '    <button type="button" class="btn btn-default map-btn">Smart Citizen Kit Data</button>'
          }
          popup_html    += "</div></div>"
          layer.bindPopup(popup_html);
        });
        map.addLayer(clusterGroup);
      });

    // Disable tap handler, if present.
    if (map.tap) map.tap.disable();
  }
);
