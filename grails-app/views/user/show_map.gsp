
<%@ page import="car.companion.User" %>
<!doctype html>
<html>
	<head>
		<meta name="layout" content="main">
        <meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
		<g:set var="entityName" value="${message(code: 'user.label', default: 'User')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
        <script type="text/javascript"
                src="https://maps.google.com/maps/api/js?sensor=false">
        </script>
        <script type="text/javascript">
            function initialize() {
                var latlng = new google.maps.LatLng(55, 73);

                var myOptions = {
                    zoom: 11,
                    center: latlng,
                    mapTypeId: google.maps.MapTypeId.ROADMAP
                };

                var map = new google.maps.Map(
                   document.getElementById("map_canvas"),
                   myOptions
                );

                var markers = [];
                var content = [];
                var infoWindows = [];

            <g:each in="${userInstanceList}" status="i" var="user">
                setTimeout(function() {
                    markers[${i}] =
                        new google.maps.Marker({
                            title: "${user.name}",
                            map: map,
                            draggable: false,
                            animation: google.maps.Animation.DROP,
                            position: new google.maps.LatLng(${user.lat}, ${user.lng})
                        });

                    content[${i}] = '<div>' + 'INFO' + '</div>';

                    infoWindows[${i}] = new google.maps.InfoWindow({
                        content: content[${i}]
                    });

                    google.maps.event.addListener(markers[${i}], 'click', function(){
                        infoWindows[${i}].open(map, markers[${i}])
                    });
                }, '${i}' * 50);


            </g:each>
            }
        </script>
	</head>
	<body>
        <div id="pageWrapper">
            <div id="menu"></div>
            <div id="map">
                <div id="map_canvas"></div>
            </div>
            <div class="clear"></div>
        </div>

    </body>
</html>
