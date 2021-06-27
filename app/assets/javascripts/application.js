// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery3
//= require popper
//= require bootstrap-sprockets
//= require rails-ujs
// require "chart_js"
// require "jquery_raty.js"
//= require activestorage
//= require turbolinks
//= require_tree .

/*global $*/

$(document).on('turbolinks:load', function() {
  $(document).ready(function () {
    var hsize = $(window).height() - 250;
    $(".chats").css("height", hsize + "px");
  });
});


$(document).on('turbolinks:load', function() {
  var ctx = document.getElementById("bookLineChart");
  var bookLineChart = new Chart(ctx, {
    type: 'line',
    data: {
      labels: gon.days,
      datasets: [
        {
          label: 'Daily',
          data: gon.daily_counts,
          borderColor: "rgba(255,0,0,1)",
          backgroundColor: "rgba(0,0,0,0)"
        }
      ]
    },
    options: {
      scales: {
        yAxes: [
          {
            ticks: {
              suggestedMax: 10,
              suggestedMin: 0,
              stepSize: 1
            }
          }
        ]
      }
    }
  });
});