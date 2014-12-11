$(document).ready(function() {

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
        var popup_html = '<div class="tooltip-container">\
                            <h3>' + layer.feature.properties.title + '</h3>\
                            <div class="btn-group-vertical" role="group" aria-label="...">'
//        if (layer.feature.properties.has_ghost_wipes) {
//          popup_html  += '    <button type="button" class="btn btn-default map-btn" data-toggle="modal" data-datapath="/sites/'+layer.feature.properties.site_id+'/ghost_wipes.json" data-header="'+layer.feature.properties.title+', Ghost Wipe Data" data-target="#modal">Ghost Wipes</button>'
//        }
        if (layer.feature.properties.has_diffusion_tubes) {
          popup_html  += '    <button type="button" class="btn btn-default map-btn" data-toggle="modal" data-datapath="/sites/'+layer.feature.properties.site_id+'/diffusion_tubes.json" data-siteid="'+layer.feature.properties.site_id+'" data-header="'+layer.feature.properties.title+', Diffusion Tube Data" data-target="#modal">Diffusion Tubes</button>'
        }
//        if (layer.feature.properties.has_sck_devices) {
//          popup_html  += '    <button type="button" class="btn btn-default map-btn" data-toggle="modal" data-header="'+layer.feature.properties.title+' Smart Citizen Data" data-target="#modal">Smart Citizen Kit Data</button>'
//        }
        popup_html    += "</div></div>"
        layer.bindPopup(popup_html);
      });
      map.addLayer(clusterGroup);
    });

  // Disable tap handler, if present.
  if (map.tap) map.tap.disable();

  $('#modal').on('show.bs.modal', function (event) {
    var modal = $(this)
    var button = $(event.relatedTarget);
    var headline = button.data('header');
    var datapath =  button.data('datapath');
    modal.find('.modal-header').find('h4').text(headline);
    $.ajax({
      url: datapath,
    }).done(function(response) {

      // diffusion tubes
      var nav_html = '<div class="btn-group" role="group" aria-label="...">\
                        <button id="µg_s_total" type="button" class="btn btn-default chart-btn">µg S Total</button>\
                        <button id="µg_s_blank" type="button" class="btn btn-default chart-btn">µg S Blank</button>\
                        <button id="so2_µg_m3" type="button" class="btn btn-default chart-btn">SO<sub>2</sub> µg m<sup>3</sup></button>\
                        <button id="so2_µg_ppb" type="button" class="btn btn-default chart-btn">SO<sub>2</sub> µg ppb</button>\
                        <button id="mg_m3" type="button" class="btn btn-default chart-btn">mg m<sup>3</sup></button>\
                        <button id="ppb" type="button" class="btn btn-default chart-btn">ppb</button>\
                        <button id="no2_µg" type="button" class="btn btn-default chart-btn">NO<sub>2</sub> µg</button>\
                      </div>';
      modal.find('.modal-nav-container').html(nav_html)
      $('#µg_s_total').on('click', function() {

        var names = $.map(response, function(item) { return human_date(item.date_installed) + " - " + human_date(item.date_removed) });
        var data = $.map(response, function(item) { return item.µg_s_total });

        $('.modal-chart-container').highcharts({
          chart: {
            type: 'column'
          },
          title: {
            text: 'Total Micrograms of Sulphur'
          },
          xAxis: {
            categories: names
          },
          yAxis: {
            min: 0,
            title: {
              text: 'Micrograms'
            }
          },
          legend: {
            enabled: false
          },
          series: [{
            name: "µg S total",
            data: data
          }]
        });
      });

      $('#µg_s_blank').on('click', function() {

        var names = $.map(response, function(item) { return human_date(item.date_installed) + " - " + human_date(item.date_removed) });
        var data = $.map(response, function(item) { return item.µg_s_blank });

        $('.modal-chart-container').highcharts({
          chart: {
            type: 'column'
          },
          title: {
            text: 'Micrograms of Sulphur, blank'
          },
          xAxis: {
            categories: names
          },
          yAxis: {
            min: 0,
            title: {
              text: 'Micrograms'
            }
          },
          legend: {
            enabled: false
          },
          series: [{
            name: "µg S blank",
            data: data
          }]
        });
      });

      $('#so2_µg_m3').on('click', function() {

        var names = $.map(response, function(item) { return human_date(item.date_installed) + " - " + human_date(item.date_removed) });
        var data = $.map(response, function(item) { return item.so2_µg_m3 });

        $('.modal-chart-container').highcharts({
          chart: {
            type: 'column'
          },
          title: {
            text: 'SO2 µg m3'
          },
          xAxis: {
            categories: names
          },
          yAxis: {
            min: 0,
            title: {
              text: 'SO2 µg m3'
            }
          },
          legend: {
            enabled: false
          },
          series: [{
            name: "SO2 µg m3",
            data: data
          }]
        });
      });
      $('#so2_µg_ppb').on('click', function() {

        var names = $.map(response, function(item) { return human_date(item.date_installed) + " - " + human_date(item.date_removed) });
        var data = $.map(response, function(item) { return item.so2_µg_ppb });

        $('.modal-chart-container').highcharts({
          chart: {
            type: 'column'
          },
          title: {
            text: 'SO2 µg ppb'
          },
          xAxis: {
            categories: names
          },
          yAxis: {
            min: 0,
            title: {
              text: 'SO2 µg ppb'
            }
          },
          legend: {
            enabled: false
          },
          series: [{
            name: "SO2 µg ppb ",
            data: data
          }]
        });
      });
      $('#mg_m3').on('click', function() {

        var names = $.map(response, function(item) { return human_date(item.date_installed) + " - " + human_date(item.date_removed) });
        var data = $.map(response, function(item) { return item.mg_m3 });

        $('.modal-chart-container').highcharts({
          chart: {
            type: 'column'
          },
          title: {
            text: 'mg m3'
          },
          xAxis: {
            categories: names
          },
          yAxis: {
            min: 0,
            title: {
              text: 'mg m3'
            }
          },
          legend: {
            enabled: false
          },
          series: [{
            name: "mg m3",
            data: data
          }]
        });
      });
      $('#ppb').on('click', function() {

        var names = $.map(response, function(item) { return human_date(item.date_installed) + " - " + human_date(item.date_removed) });
        var data = $.map(response, function(item) { return item.ppb });

        $('.modal-chart-container').highcharts({
          chart: {
            type: 'column'
          },
          title: {
            text: 'ppb'
          },
          xAxis: {
            categories: names
          },
          yAxis: {
            min: 0,
            title: {
              text: 'ppb'
            }
          },
          legend: {
            enabled: false
          },
          series: [{
            name: "ppb",
            data: data
          }]
        });
      });
      $('#no2_µg').on('click', function() {

        var names = $.map(response, function(item) { return human_date(item.date_installed) + " - " + human_date(item.date_removed) });
        var data = $.map(response, function(item) { return item.no2_µg });

        $('.modal-chart-container').highcharts({
          chart: {
            type: 'column'
          },
          title: {
            text: 'no2 µg'
          },
          xAxis: {
            categories: names
          },
          yAxis: {
            min: 0,
            title: {
              text: 'no2 µg'
            }
          },
          legend: {
            enabled: false
          },
          series: [{
            name: "no2 µg",
            data: data
          }]
        });
      });
    });
  });
});

function human_date(date_string) {
  var date_arr = date_string.split('-');
  var date = new Date(date_arr[0], date_arr[1], date_arr[2]);
  return date.getDate() + "/" + date.getMonth() + "/" + date.getFullYear();
}
