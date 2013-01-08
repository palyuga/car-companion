
<%@ page import="car.companion.User" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
    <g:set var="entityName" value="${message(code: 'user.label', default: 'User')}" />
    <title><g:message code="default.list.label" args="[entityName]" /></title>
    <g:javascript library="application" />
    <modalbox:modalIncludes />
    <script type="text/javascript"
            src="https://maps.google.com/maps/api/js?sensor=false&v=3&libraries=geometry">
    </script>
    <script src="http://code.jquery.com/jquery-1.8.2.js"></script>
    <script src="http://code.jquery.com/ui/1.9.1/jquery-ui.js"></script>
    <script src="${resource(dir: 'js', file: 'sharecar.js')}"></script>
    <script src="${resource(dir: 'js', file: 'inline-labels.js')}"></script>
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
                        'images/man.png',
                        new google.maps.Size(24,24),
                        new google.maps.Point(0,0),
                        new google.maps.Point(0,24)
                );

                var pedestrianImage = new google.maps.MarkerImage(
                        'images/car/user.png',
                        new google.maps.Size(32,32),
                        new google.maps.Point(0,0),
                        new google.maps.Point(0,32)
                );

                var carImage = new google.maps.MarkerImage(
                        'images/car/car.png',
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

                    content[${i}] = '<div class="info"><div> Меня зовут '
                            + '<span class="h">${user.name} ${user.surname}</span>'
                            + '</div> <div>'
                            + 'Я живу на <span class="h">${user.address}</span>'
                            + '</div> <div>'
                            + 'У меня <span class="h">' + (${user.hasCar} ? 'есть машина' : 'нет машины') + '</span></div>'
                            + ((${user.canYouSendHimRequest}) ? createRequestForm(${user.id}) : "Ваш запрос еще не рассмотрен")
                            + '</div>';

                    infoWindows[${i}] = new google.maps.InfoWindow({
                        content: content[${i}]
                    });

                    google.maps.event.addListener(markers[${i}], 'click', function(){
                        infoWindows[${i}].open(map, markers[${i}])
                    });

                    var mylatlng = new google.maps.LatLng(${currentUser.lat}, ${currentUser.lng});
                    var bounds = new google.maps.LatLngBounds();
                    bounds.extend(mylatlng);
                    for (var i = 0; i < markers.length; i++) {
                        var userLatLng = markers[i].position;
                        var distance = google.maps.geometry.spherical.computeDistanceBetween(userLatLng, mylatlng);
                        if (distance/1000 > 1) {
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
                            $( "#amount" ).html( ui.value );
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
                showIncomingRequests();
                showSentRequests();
            </g:if>
            <g:else>
                <!-- If user is not logged in -->
                var marker = null;
                function placeMarker(location) {
                    deleteEarlyPlacedMarker();
                    marker = new google.maps.Marker({
                        position: location,
                        map: map
                    });
                }

                function deleteEarlyPlacedMarker() {
                    if (marker != null) {
                        marker.setMap(null);
                    }
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

    </script>
</head>
<body>
    <div id="menu">
        <img class="logo" src="images/car/logo.png"/>
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
                <div class="stext marg-left">Впервые здесь? Приcоединяйтесь:</div>
                <fieldset class="form">
                    <div class="fieldcontain ${hasErrors(bean: userInstance, field: 'email', 'error')}">
                        <g:field type="email" class="default-value" name="email" required="" value="Адрес эл. почты"/>
                    </div>
                    <div class="fieldcontain ${hasErrors(bean: userInstance, field: 'passwd', 'error')} ">
                        <g:passwordField name="passwd" id="password2"/>
                        <input id="password-clear2" value="Пароль"/>
                    </div>

                    <div class="fieldcontain ${hasErrors(bean: userInstance, field: 'name', 'error')} ">
                        <g:field type="text" name="name" class="default-value" required="" value="Имя"/>
                    </div>
                    <div class="fieldcontain ${hasErrors(bean: userInstance, field: 'surname', 'error')} ">
                        <g:textField name="surname" class="default-value" required="" value="Фамилия"/>
                    </div>
                    <div class="stext marg-left">Вы можете указать положение на карте, либо ввести адрес:</div>
                    <div class="fieldcontain ${hasErrors(bean: userInstance, field: 'address', 'error')} ">
                        <g:textField name="address" class="default-value" required="" value="Домашний адрес"/>
                    </div>

                    <div class="fieldcontain ${hasErrors(bean: userInstance, field: 'hasCar', 'error')} ">
                        <label class="stext" for="hasCar">
                            <g:message code="user.hasCar.label" default="У меня есть машина" />
                        </label>
                        <g:checkBox style="width: 40px"name="hasCar" value="${userInstance?.hasCar}" />
                    </div>
                    <br/>
                    <div style="display: none" class="fieldcontain ${hasErrors(bean: userInstance, field: 'lat', 'error')} required">
                        <g:field type="hidden" name="lat" value="-1" required="" id="latField"/>
                    </div>

                    <div style="display: none" class="fieldcontain ${hasErrors(bean: userInstance, field: 'lng', 'error')} required">
                        <g:field  type="hidden" name="lng" value="-1" required="" id="lngField"/>
                    </div>



                    <div class="fieldcontain ${hasErrors(bean: userInstance, field: 'office', 'error')} required">
                        <label class="stext" for="office">
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
            <div id="hello"><span class="text">Добро пожаловать, ${currentUser.name}!</span>
                <g:link id="logout-link" action="logoff">(Выйти)</g:link>
            </div>


            <div id="slider"></div>
            <div class="companions-info">
                <span class="grey-text">
                    Показаны попутчики в радиусе <span id="amount">1</span> км.
                </span>
            </div>
            <div id="requests">
                <div id="income"></div>
                <div id="outcome"></div>
            </div>       s
        </g:else>
    </div>
    <div id="map">
        <div id="map_canvas"></div>
    </div>
</body>
</html>
