// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require modernizr.custom.20589
//= require_tree .

if (Modernizr.geolocation) {
	$(document).ready(function(){
      $("#locationButton").html("<button id=\"findLocation\">Use your location</button>");
	  $("#findLocation").click(init_geolocation);
	});

	function init_geolocation(){
		navigator.geolocation.getCurrentPosition(handle_geolocation_query);
	}

	function handle_geolocation_query(position){
		$.ajax({
		  url: "http://ws.geonames.org/findNearbyPostalCodesJSON",
		  dataType: "json",
		  data: {
			lat: position.coords.latitude,
			lng: position.coords.longitude
		},
		success: function( data ) {
			$("input#place").val(data.postalCodes[0].placeName + ', ' + data.postalCodes[0].adminName1 + ', ' + data.postalCodes[0].postalCode );
		}	
		});
	}
}
