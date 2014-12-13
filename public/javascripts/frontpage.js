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
        if (layer.feature.properties.has_ghost_wipes) {
          popup_html  += '    <button type="button" class="btn btn-default map-btn" data-toggle="modal" data-datapath="/sites/'+layer.feature.properties.site_id+'/ghost_wipes.json" data-header="'+layer.feature.properties.title+', Ghost Wipe Data" data-target="#modal" data-datatype="ghost">Ghost Wipes</button>'
        }
        if (layer.feature.properties.has_diffusion_tubes) {
          popup_html  += '    <button type="button" class="btn btn-default map-btn" data-toggle="modal" data-datapath="/sites/'+layer.feature.properties.site_id+'/diffusion_tubes.json" data-siteid="'+layer.feature.properties.site_id+'" data-header="'+layer.feature.properties.title+', Diffusion Tube Data" data-target="#modal" data-datatype="diffusion">Diffusion Tubes</button>'
        }
        if (layer.feature.properties.has_sck_devices) {
          popup_html  += '    <button type="button" class="btn btn-default map-btn" data-toggle="modal" data-datapath="/sites/'+layer.feature.properties.site_id+'/smart_citizen_kit_data.json" data-siteid="'+layer.feature.properties.site_id+'" data-header="'+layer.feature.properties.title+', Smart Citizen Kit Data" data-target="#modal" data-datatype="smart">Smart Citizen Kit</button>'
        }
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
      if (button.data('datatype') == "diffusion") {
        draw_diffusion_modal(response, modal);
      } else if (button.data('datatype') == "ghost") {
        draw_ghost_modal(response, modal);
      } else if (button.data('datatype') == "smart") {
        console.log(response)
        draw_smart_modal(response, modal);
      }
    });
  });

  $('#modal').on('hide.bs.modal', function (event) {
    var modal = $(this)
    modal.find('.modal-nav-container').html('')
    modal.find('.modal-header').find('h4').html('')
    modal.find('.modal-chart-container').html('')
  });
});

function human_date(date_string) {
  if (! date_string) return ""
  var date_arr = date_string.split('-');
  var date = new Date(date_arr[0], date_arr[1], date_arr[2]);
  return date.getDate() + "/" + date.getMonth() + "/" + date.getFullYear();
}

function draw_diffusion_modal(response, modal) {
  var nav_html = '<div class="btn-group" role="group" aria-label="...">\
                    <button id="so2_µg_m3" type="button" class="btn btn-default chart-btn">SO<sub>2</sub> µg m<sup>3</sup></button>\
                    <button id="so2_µg_ppb" type="button" class="btn btn-default chart-btn">SO<sub>2</sub> ppb</button>\
                    <button id="mg_m3" type="button" class="btn btn-default chart-btn">NO<sub>2</sub> mg/m<sup>3</sup></button>\
                    <button id="ppb" type="button" class="btn btn-default chart-btn">NO<sub>2</sub> ppb</button>\
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
        text: 'SO2 ppb'
      },
      xAxis: {
        categories: names
      },
      yAxis: {
        min: 0,
        title: {
          text: 'SO2 ppb'
        }
      },
      legend: {
        enabled: false
      },
      series: [{
        name: "SO2 ppb ",
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
        text: 'no2 ug / m3'
      },
      xAxis: {
        categories: names
      },
      yAxis: {
        min: 0,
        title: {
          text: 'no2 ug / m3'
        }
      },
      legend: {
        enabled: false
      },
      series: [{
        name: "no2 ug / m3",
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
        text: 'no2 ppb'
      },
      xAxis: {
        categories: names
      },
      yAxis: {
        min: 0,
        title: {
          text: 'no2 ppb'
        }
      },
      legend: {
        enabled: false
      },
      series: [{
        name: "no2 ppb",
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
}

function draw_ghost_modal(response, modal) {
  var nav_html = '<div class="btn-group" role="group" aria-label="...">\
                    <button id="As" type="button" class="btn btn-default chart-btn">As</button>\
                    <button id="Cd" type="button" class="btn btn-default chart-btn">Cd</button>\
                    <button id="Cr" type="button" class="btn btn-default chart-btn">Cr</button>\
                    <button id="Cu" type="button" class="btn btn-default chart-btn">Cu</button>\
                    <button id="Hg" type="button" class="btn btn-default chart-btn">Hg</button>\
                    <button id="Ni" type="button" class="btn btn-default chart-btn">Ni</button>\
                    <button id="Pb" type="button" class="btn btn-default chart-btn">Pb</button>\
                    <button id="Se" type="button" class="btn btn-default chart-btn">Se</button>\
                    <button id="Zn" type="button" class="btn btn-default chart-btn">Zn</button>\
                  </div>';
  modal.find('.modal-nav-container').html(nav_html)

  $('#Cd').on('click', function() {

    var names = $.map(response, function(item) { return human_date(item.sampling_date) });
    var data = $.map(response, function(item) { return parseFloat(item.Cd) });

    $data = response

    $('.modal-chart-container').highcharts({
      chart: {
        type: 'column'
      },
      title: {
        text: 'Cd'
      },
      xAxis: {
        categories: names
      },
      yAxis: {
        min: 0,
        title: {
          text: ''
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

  $('#Cr').on('click', function() {

    var names = $.map(response, function(item) { return human_date(item.sampling_date) });
    var data = $.map(response, function(item) { return parseFloat(item.Cr) });

    $data = response

    $('.modal-chart-container').highcharts({
      chart: {
        type: 'column'
      },
      title: {
        text: 'Cr'
      },
      xAxis: {
        categories: names
      },
      yAxis: {
        min: 0,
        title: {
          text: ''
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

  $('#Cu').on('click', function() {

    var names = $.map(response, function(item) { return human_date(item.sampling_date) });
    var data = $.map(response, function(item) { return parseFloat(item.Cu) });

    $data = response

    $('.modal-chart-container').highcharts({
      chart: {
        type: 'column'
      },
      title: {
        text: 'Cu'
      },
      xAxis: {
        categories: names
      },
      yAxis: {
        min: 0,
        title: {
          text: ''
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

  $('#Hg').on('click', function() {

    var names = $.map(response, function(item) { return human_date(item.sampling_date) });
    var data = $.map(response, function(item) { return parseFloat(item.Hg) });

    $data = response

    $('.modal-chart-container').highcharts({
      chart: {
        type: 'column'
      },
      title: {
        text: 'Hg'
      },
      xAxis: {
        categories: names
      },
      yAxis: {
        min: 0,
        title: {
          text: ''
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

  $('#Ni').on('click', function() {

    var names = $.map(response, function(item) { return human_date(item.sampling_date) });
    var data = $.map(response, function(item) { return parseFloat(item.Ni) });

    $data = response

    $('.modal-chart-container').highcharts({
      chart: {
        type: 'column'
      },
      title: {
        text: 'Ni'
      },
      xAxis: {
        categories: names
      },
      yAxis: {
        min: 0,
        title: {
          text: ''
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

  $('#Pb').on('click', function() {

    var names = $.map(response, function(item) { return human_date(item.sampling_date) });
    var data = $.map(response, function(item) { return parseFloat(item.Pb) });

    $data = response

    $('.modal-chart-container').highcharts({
      chart: {
        type: 'column'
      },
      title: {
        text: 'Pb'
      },
      xAxis: {
        categories: names
      },
      yAxis: {
        min: 0,
        title: {
          text: ''
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

  $('#Se').on('click', function() {

    var names = $.map(response, function(item) { return human_date(item.sampling_date) });
    var data = $.map(response, function(item) { return parseFloat(item.Se) });

    $data = response

    $('.modal-chart-container').highcharts({
      chart: {
        type: 'column'
      },
      title: {
        text: 'Se'
      },
      xAxis: {
        categories: names
      },
      yAxis: {
        min: 0,
        title: {
          text: ''
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

  $('#Zn').on('click', function() {

    var names = $.map(response, function(item) { return human_date(item.sampling_date) });
    var data = $.map(response, function(item) { return parseFloat(item.Zn) });

    $data = response

    $('.modal-chart-container').highcharts({
      chart: {
        type: 'column'
      },
      title: {
        text: 'Zn'
      },
      xAxis: {
        categories: names
      },
      yAxis: {
        min: 0,
        title: {
          text: ''
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

}

function draw_smart_modal(response, modal) {
  var nav_html = '<div class="btn-group" role="group" aria-label="...">\
                    <button id="NO2" type="button" class="btn btn-default chart-btn">NO2 data</button>\
                    <button id="CO" type="button" class="btn btn-default chart-btn">CO data</button>\
                  </div>';
  modal.find('.modal-nav-container').html(nav_html)

  $('#CO').on('click', function() {

    var names = $.map(response.co_daily_averages, function(item) { return human_date(item.timestamp) });
    var data = $.map(response.co_daily_averages, function(item) { return parseFloat(item.average_co) });

    $('.modal-chart-container').highcharts({
      title: {
        text: 'CO ppm'
      },
      xAxis: {
        categories: names,
      },
      yAxis: {
        title: {
          text: 'CO ppm'
        },
        plotLines: [{
            value: 0,
            width: 1,
            color: '#808080'
        }]
      },
      legend: {
        enabled: false
      },
      series: [{
        name: "CO ppm",
        data: data
      }]
    });

  });

  $('#NO2').on('click', function() {

    var names = $.map(response.no2_daily_averages, function(item) { return human_date(item.timestamp) });
    var data = $.map(response.no2_daily_averages, function(item) { return parseFloat(item.average_no2) });

    $('.modal-chart-container').highcharts({
      title: {
        text: 'NO2 ppm'
      },
      xAxis: {
        categories: names,
      },
      yAxis: {
        title: {
          text: 'NO2 ppm'
        },
        plotLines: [{
            value: 0,
            width: 1,
            color: '#808080'
        }]
      },
      legend: {
        enabled: false
      },
      series: [{
        name: "NO2 ppm",
        data: data
      }]
    });

  });

}

