
<%@ page import="car.companion.User" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
    <g:set var="entityName" value="${message(code: 'user.label', default: 'User')}" />
    <title>ShareCar</title>
    <script type="text/javascript"
            src="https://maps.google.com/maps/api/js?sensor=false&v=3&libraries=geometry">
    </script>
    <script src="http://code.jquery.com/jquery-1.8.2.js"></script>
    <script src="http://code.jquery.com/ui/1.9.1/jquery-ui.js"></script>
    <script src="${resource(dir: 'js', file: 'sharecar.js')}"></script>
    <script src="${resource(dir: 'js', file: 'jquery.idTabs.min.js')}"></script>

    <script type="text/javascript">
        function initialize() {

            if ($.browser.msie) {
                if ($.browser.version < 10) {
                    window.location.replace("user/browser");
                }
            }


            latlng = new google.maps.LatLng(
                <g:if test="${isLogged}">${currentUser.lat}</g:if><g:else>54.9688974</g:else>,
                <g:if test="${isLogged}">${currentUser.lng}</g:if><g:else>73.3846840</g:else>
            );

            mapZoom = 12;

            var myOptions = {
                zoom: mapZoom,
                center: latlng,
                mapTypeId: google.maps.MapTypeId.ROADMAP
            };

            map = new google.maps.Map(
                document.getElementById("map_canvas"),
                myOptions
            );

            markers = [];
            ids = [];
            content = [];
            infoWindows = [];
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
                                title: "${user.name} ${user.surname}",
                                map: map,
                                draggable: false,
                                animation: google.maps.Animation.DROP,
                                position: new google.maps.LatLng(${user.lat}, ${user.lng})
                            });

                    content[${i}] = '<div class="info"><div>'
                            + '<span class="h">${user.name} ${user.surname}</span>'
                            + '</div> <div> Email: '
                            + '<span class="h3">${user.email}</span>'
                            + '</div> <div>'
                            + '<span class="h">' + (${user.hasCar} ? 'Есть машина' : 'Нет машины') + '</span></div>'
                            + createRequestForm(${user.id})
                            + '</div>';

                    ids[${i}] = ${user.id};

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
                    var timeout = 3000;
                    setInterval(function() {checkNewIncomingRequests()}, timeout);
                    setInterval(function() {showSentRequestsIfNewAnswers()}, timeout * 2 + 133);

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
                    showIncomingRequests();
                    showSentRequests();
                    $("#requests ul").idTabs();
                });


            </g:if>
            <g:else>
                <!-- If user is not logged in -->
                marker = null;

                google.maps.event.addListener(map, 'click', function(event) {
                    placeMarker(event.latLng);
                    storeGeocodingResult(event.latLng);
                });
            </g:else>
        }

    </script>
</head>
<body>
    <div id="menu">
        <div id="menu-content">
            <img width="255" height="66" class="logo" src="./images/car/logo-car.png"/>
            <g:if test="${flash.message}">
                <div class="message" role="status">${flash.message}</div>
            </g:if>
            <g:if test="${!isLogged}">
                <g:form action="login" >

                    <fieldset class="form">
                        <div class="fieldcontain ${hasErrors(bean: userInstance, field: 'email', 'error')} ">
                            <g:textField name="email" required="required" placeholder="Адрес эл. почты"/>
                        </div>
                        <div class="fieldcontain ${hasErrors(bean: userInstance, field: 'passwd', 'error')} ">
                            <g:passwordField name="passwd" placeholder="Пароль" required="required"/>
                        </div>
                    </fieldset>

                    <g:submitButton name="login" id="login-button" class="btn btn-warning" value="Войти" />

                </g:form>
                <g:form action="save">
                    <div class="intro stext">Впервые здесь? Приcоединяйтесь:</div>
                    <fieldset class="form">
                        <div class="fieldcontain ${hasErrors(bean: userInstance, field: 'email', 'error')}">
                            <g:field type="email" value="${userInstance?.email}" class="default-value" name="email" required="required" placeholder="Адрес эл. почты"/>
                        </div>
                        <div class="fieldcontain ${hasErrors(bean: userInstance, field: 'passwd', 'error')} ">
                            <g:passwordField name="passwd" placeholder="Пароль" required="required"/>
                        </div>

                        <div class="fieldcontain ${hasErrors(bean: userInstance, field: 'name', 'error')} ">
                            <g:field type="text" value="${userInstance?.name}" name="name" required="required" placeholder="Имя"/>
                        </div>
                        <div class="fieldcontain ${hasErrors(bean: userInstance, field: 'surname', 'error')} ">
                            <g:textField name="surname" value="${userInstance?.surname}" required="required" placeholder="Фамилия"/>
                        </div>
                        <div class="stext margin-top">Вы можете указать место жительства на карте, либо воспользоваться поиском по ней: </div>
                        <div class="fieldcontain ${hasErrors(bean: userInstance, field: 'address', 'error')} ">
                            <form onsubmit="processAddress()">
                                <div id="geoError"></div>
                                <g:textField id="address" name="address" placeholder="Домашний адрес"/>
                                <a class="btn geobtn" onclick="processAddress()">Найти</a>
                            </form>
                        </div>

                        <div class="margin-frm fieldcontain ${hasErrors(bean: userInstance, field: 'office', 'error')} required">
                            <label class="stext" for="office">
                                <g:message code="user.office.label" default="Расположение офиса" />
                            </label>
                            <g:select id="office" name="office.id" from="${car.companion.Office.list()}" optionKey="id" required="" value="${userInstance?.office?.id}" class="many-to-one"/>
                        </div>

                        <div class="fieldcontain ${hasErrors(bean: userInstance, field: 'hasCar', 'error')} ">
                            <label class="stext" for="hasCar">
                                <g:message code="user.hasCar.label" default="У меня есть машина" />
                            </label>
                            <g:checkBox style="width: 40px" name="hasCar" value="${userInstance?.hasCar}" />
                        </div>
                        <br/>
                        <div style="display: none" class="fieldcontain ${hasErrors(bean: userInstance, field: 'lat', 'error')} required">
                            <g:field type="hidden" name="lat" value="-1" required="" id="latField"/>
                        </div>

                        <div style="display: none" class="fieldcontain ${hasErrors(bean: userInstance, field: 'lng', 'error')} required">
                            <g:field  type="hidden" name="lng" value="-1" required="" id="lngField"/>
                        </div>
                        <g:submitButton name="create" class="btn btn-success" id="register-button" value="Регистрация"/>
                    </fieldset>
                    </g:form>
                <div id="overlay">
                    <table id="descr">
                        <div class="promo">
                            ShareCar — это система поиска попутчиков для поездок домой и на работу
                            <a onclick="closeOverlay()" id="close-overlay"><img src="./images/close-window.png"/></a>
                        </div>
                        <tr>
                            <td>
                                <img width="160" src="./images/1.png"/>
                            </td>
                            <td>
                                <img width="160" src="./images/2.png"/>
                            </td>
                            <td>
                                <img width="160" src="./images/3.png"/>
                            </td>
                            <td>
                                <img width="160" src="./images/4.png"/>
                            </td>
                        </tr>
                        <tr class="descr-text">
                            <td><b>1.</b><br/>Введите свои данные</td>
                            <td>
                                <b>2.</b><br/>Укажите место жительства, либо любое другое место, откуда Вы чаще всего ездите на работу
                            </td>
                            <td><b>3.</b><br/>Ищите работников из своего офиса, живущих неподалеку</td>
                            <td><b>4.</b><br/>Отправляйте запросы, отвечайте на запросы, катайтесь на работу вместе!</td>
                        </tr>
                    </table>
                </div>
            </g:if>
            <g:else>
                <div id="hello"><span class="text">Добро пожаловать, ${currentUser.name}!</span>
                    <span class="link-color">(</span><g:link action="logoff" class="logout-link">Выйти</g:link><span class="link-color">)</span>
                </div>

                <div id="slider-container">
                    <div id="slider"></div>
                    <div class="companions-info">
                        <span class="grey-text">
                            Показаны попутчики в радиусе <span id="amount">1</span> км.
                        </span>
                    </div>
                </div>
                <div id="requests" class="tabs">
                    <ul>
                        <li><a href="#incomeTab">Полученные</a></li>
                        <li><a href="#outcomeTab">Отправленные</a></li>
                    </ul>
                    <div id="incomeTab">
                        <div id="newIncoming"></div>
                        <div id="income"></div>
                    </div>
                    <div id="outcomeTab">
                        <div id="outcome"></div>
                    </div>
                </div>
            </g:else>
        </div>
    </div>
    <div id="map">
        <div id="map_canvas"></div>
    </div>
</body>
</html>
