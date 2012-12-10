
<%@ page import="car.companion.User" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
    <g:set var="entityName" value="${message(code: 'user.label', default: 'User')}" />
    <title><g:message code="default.list.label" args="[entityName]" /></title>
    <script type="text/javascript"
            src="https://maps.google.com/maps/api/js?sensor=false&v=3&libraries=geometry">
    </script>
    <script src="http://code.jquery.com/jquery-1.8.2.js"></script>
    <script src="http://code.jquery.com/ui/1.9.1/jquery-ui.js"></script>
    <link rel="stylesheet" href="../css/jquery-ui-1.9.2.custom.min.css"/>
    <script type="text/javascript">
        function initialize() {
            var latlng = new google.maps.LatLng(
                    <g:if test="${isLogged}">${currentUser.lat}</g:if><g:else>54.9688974</g:else>,
                    <g:if test="${isLogged}">${currentUser.lng}</g:if><g:else>73.3846840</g:else>
            );

            var myOptions = {
                zoom: 12,
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
            <g:if test="${isLogged}">
                var curUserImage = new google.maps.MarkerImage(
                        '../images/man.png',
                        new google.maps.Size(24,24),
                        new google.maps.Point(0,0),
                        new google.maps.Point(0,24)
                );

                var pedestrianImage = new google.maps.MarkerImage(
                        '../images/car/user.png',
                        new google.maps.Size(32,32),
                        new google.maps.Point(0,0),
                        new google.maps.Point(0,32)
                );

                var carImage = new google.maps.MarkerImage(
                        '../images/car/car.png',
                        new google.maps.Size(32,32),
                        new google.maps.Point(0,0),
                        new google.maps.Point(0,32)
                );


            var delayBetweenDropping = 50;
            <g:each in="${userInstanceList}" status="i" var="user">

                setTimeout(function() {
                    markers[${i}] =
                            new google.maps.Marker({
                                icon: (${user.hasCar}) ? carImage : pedestrianImage,
                                title: "${user.name}",
                                map: map,
                                draggable: false,
                                animation: google.maps.Animation.DROP,
                                position: new google.maps.LatLng(${user.lat}, ${user.lng})
                            });

                    content[${i}] = '<div>' + '${user.name}' + '</div> <div>'
                            + '${user.address}' + '</div> <div>'
                            + (${user.hasCar} ? 'Есть машина' : 'Нет машины') + '</div> <div>'
                            + 'Email: ' + '${user.email}' + '</div>';

                    infoWindows[${i}] = new google.maps.InfoWindow({
                        content: content[${i}]
                    });

                    google.maps.event.addListener(markers[${i}], 'click', function(){
                        infoWindows[${i}].open(map, markers[${i}])
                    });
                },
                '${i}' * delayBetweenDropping);


            </g:each>
                var currentUser = new google.maps.Marker({
                    title: "Это Вы",
                    icon: curUserImage,
                    map: map,
                    draggable: false,
                    animation: google.maps.Animation.DROP,
                    position: new google.maps.LatLng(${currentUser.lat}, ${currentUser.lng})
                });

                $(function() {
                    $("#slider").slider({
                        value: 1,
                        min: 1,
                        max: 15,
                        step: 1,
                        slide: function( event, ui ) {
                            $( "#amount" ).val( ui.value + " km");
                            var mylatlng = new google.maps.LatLng(${currentUser.lat}, ${currentUser.lng});
                            var bounds = new google.maps.LatLngBounds();
                            bounds.extend(mylatlng);
                            for (var i = 0; i < markers.length; i++) {
                                var userLatLng = markers[i].position;
                                var distance = google.maps.geometry.spherical.computeDistanceBetween(userLatLng, mylatlng);
                                if (distance/1000 > ui.value) {
                                    if (markers[i].map != null) {
                                        markers[i].setMap(null);
                                    }
                                } else {
                                    bounds.extend(userLatLng);
                                    if (markers[i].map == null) {
                                        markers[i].setMap(map);
                                    }
                                }
                            }
                            map.fitBounds(bounds);
                        }
                    });
                    $( "#amount" ).val($( "#slider" ).slider( "value" ) + " km");
                });
            </g:if>
            <g:else>
                <!-- If user is not logged in -->
                var marker = null;
                function placeMarker(location) {
                    if (marker != null) {
                        marker.setMap(null);
                    }
                    marker = new google.maps.Marker({
                        position: location,
                        map: map
                    });
                }

                function fillLatLngFields(location) {
                    $("#latField").val(location.lat());
                    $("#lngField").val(location.lng());
                }

                google.maps.event.addListener(map, 'click', function(event) {
                    placeMarker(event.latLng);
                    fillLatLngFields(event.latLng);
                });
            </g:else>
        }

        $(document).ready(function() {
            $('#password-clear').show();
            $('#password').hide();

            $('#password-clear').focus(function() {
                $('#password-clear').hide();
                $('#password').show();
                $('#password').focus();
            });
            $('#password').blur(function() {
                if($('#password').val() == '') {
                    $('#password-clear').show();
                    $('#password').hide();
                }
            });

            $('#password-clear2').show();
            $('#password2').hide();

            $('#password-clear2').focus(function() {
                $('#password-clear2').hide();
                $('#password2').show();
                $('#password2').focus();
            });
            $('#password2').blur(function() {
                if($('#password2').val() == '') {
                    $('#password-clear2').show();
                    $('#password2').hide();
                }
            });

            $('.default-value').each(function() {
                var default_value = this.value;
                $(this).focus(function() {
                    if(this.value == default_value) {
                        this.value = '';
                    }
                });
                $(this).blur(function() {
                    if(this.value == '') {
                        this.value = default_value;
                    }
                });
            });

        });

    </script>
</head>
<body>
<div id="pageWrapper">
    <div id="menu">
        <img class="logo" src="../images/car/logo.png"/>
        <g:if test="${flash.message}">
            <div class="message" role="status">${flash.message}</div>
        </g:if>
        <g:if test="${!isLogged}">


            <g:form action="login" >

                <fieldset class="form">
                    <div class="fieldcontain ${hasErrors(bean: userInstance, field: 'email', 'error')} ">
                        <g:textField name="email" class="default-value" value="Адрес эл. почты"/>
                    </div>
                    <div class="fieldcontain ${hasErrors(bean: userInstance, field: 'passwd', 'error')} ">
                        <g:passwordField id="password" name="passwd"/>
                        <input id="password-clear" value="Пароль"/>
                    </div>
                </fieldset>
                <fieldset class="buttons">
                    <g:submitButton name="login" class="login" value="" />
                </fieldset>
            </g:form>
            <g:form action="save" >
                <img src="../images/car/firsttime.png" id="firsttime"/>
                <fieldset class="form">
                    <div class="fieldcontain ${hasErrors(bean: userInstance, field: 'email', 'error')}">
                        <g:field type="email" class="default-value" name="email" required="" value="Адрес эл. почты"/>
                    </div>
                    <div class="fieldcontain ${hasErrors(bean: userInstance, field: 'passwd', 'error')} ">
                        <g:passwordField name="passwd" id="password2"/>
                        <input id="password-clear2" value="Пароль"/>
                    </div>

                    <div class="fieldcontain ${hasErrors(bean: userInstance, field: 'name', 'error')} ">
                        <g:textField name="name" class="default-value" value="Имя"/>
                    </div>
                    Вы можете указать положение на карте, либо ввести адрес:
                    <div class="fieldcontain ${hasErrors(bean: userInstance, field: 'address', 'error')} ">
                        <g:textField name="address" class="default-value" value="Домашний адрес"/>
                    </div>

                    <div class="fieldcontain ${hasErrors(bean: userInstance, field: 'hasCar', 'error')} ">
                        <label for="hasCar">
                            <g:message code="user.hasCar.label" default="У меня есть машина" />
                        </label>
                        <g:checkBox style="width: 40px"name="hasCar" value="${userInstance?.hasCar}" />
                    </div>

                    <div style="display: none" class="fieldcontain ${hasErrors(bean: userInstance, field: 'lat', 'error')} required">
                        <g:field type="hidden" name="lat" value="-1" required="" id="latField"/>
                    </div>

                    <div style="display: none" class="fieldcontain ${hasErrors(bean: userInstance, field: 'lng', 'error')} required">
                        <g:field  type="hidden" name="lng" value="-1" required="" id="lngField"/>
                    </div>



                    <div class="fieldcontain ${hasErrors(bean: userInstance, field: 'office', 'error')} required">
                        <label for="office">
                            <g:message code="user.office.label" default="Расположение офиса" />
                        </label>
                        <g:select id="office" name="office.id" from="${car.companion.Office.list()}" optionKey="id" required="" value="${userInstance?.office?.id}" class="many-to-one"/>
                    </div>
                </fieldset>
                <fieldset class="buttons">
                    <g:submitButton name="create" class="save" id="register" value=""/>
                </fieldset>
            </g:form>


        </g:if>
        <g:else>
            <div>Привет, ${currentUser.name}! <g:link action="logoff">Выйти</g:link></div>
            <div id="slider"></div>
            <input type="text" id="amount" style="border: 0; color: #3f454a; font-weight: bold;" />
        </g:else>
    </div>
    <div id="map">
        <div id="map_canvas"></div>
    </div>
    <div class="clear"></div>
</div>

</body>
</html>
