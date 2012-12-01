
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

                var userImage = new google.maps.MarkerImage(
                        '../images/user.png',
                        new google.maps.Size(24,24),
                        new google.maps.Point(0,0),
                        new google.maps.Point(0,24)
                );



            <g:each in="${userInstanceList}" status="i" var="user">
                setTimeout(function() {
                    markers[${i}] =
                            new google.maps.Marker({
                                icon: userImage,
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
                }, '${i}' * 50);


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
                    $( "#slider" ).slider({
                        value: 1,
                        min: 0,
                        max: 15,
                        step: 1,
                        slide: function( event, ui ) {
                            $( "#amount" ).val( ui.value + " km");
                            var mylatlng = new google.maps.LatLng(${currentUser.lat}, ${currentUser.lng});

                            for (var i = 0; i < markers.length; i++) {
                                var userLatLng = markers[i].position;
                                var distance = google.maps.geometry.spherical.computeDistanceBetween(userLatLng, mylatlng);
                                if (distance/1000 > ui.value || 1 > 0) {
                                    markers[i].visible = false;
                                } else {
                                    markers[i].visible = true;
                                }
                            }
                        }
                    });
                    $( "#amount" ).val($( "#slider" ).slider( "value" ) + " km");
                });
            </g:if>
        }
    </script>
</head>
<body>
<div id="pageWrapper">
    <div id="menu">
        <g:if test="${!isLogged}">

            <img class="logo" src="../images/car/logo.png"/>
            <g:form action="login" >

                <fieldset class="form">
                    <div class="fieldcontain ${hasErrors(bean: userInstance, field: 'email', 'error')} ">
                        <label for="email">
                            <g:message code="user.passwd.label" default="Email" />
                        </label><br/>
                        <g:textField name="email" />
                    </div>
                    <div class="fieldcontain ${hasErrors(bean: userInstance, field: 'passwd', 'error')} ">
                        <label for="passwd">
                            <g:message code="user.passwd.label" default="Password" />
                        </label><br/>
                        <g:passwordField name="passwd"/>
                    </div>
                </fieldset>
                <fieldset class="buttons">
                    <g:submitButton name="login" class="login" value="" />
                </fieldset>
            </g:form>
            <g:form action="save" >
                <fieldset class="form">
                    <div class="fieldcontain ${hasErrors(bean: userInstance, field: 'email', 'error')}">
                        <label for="email">
                            <g:message code="user.email.label" default="Email" />
                            <span class="required-indicator">*</span>
                        </label>
                        <g:field type="email" name="email" required="" value="${userInstance?.email}"/>
                    </div>
                    <div class="fieldcontain ${hasErrors(bean: userInstance, field: 'passwd', 'error')} ">
                        <label for="passwd">
                            <g:message code="user.passwd.label" default="Password" />
                        </label><br/>
                        <g:passwordField name="passwd"/>
                    </div>

                    <div class="fieldcontain ${hasErrors(bean: userInstance, field: 'address', 'error')} ">
                        <label for="address">
                            <g:message code="user.address.label" default="Address" />

                        </label>
                        <g:textField name="address" value="${userInstance?.address}"/>
                    </div>

                    <div class="fieldcontain ${hasErrors(bean: userInstance, field: 'hasCar', 'error')} ">
                        <label for="hasCar">
                            <g:message code="user.hasCar.label" default="Has Car" />
                        </label>
                        <g:checkBox style="width: 40px"name="hasCar" value="${userInstance?.hasCar}" />
                    </div>

                    <div style="display: none" class="fieldcontain ${hasErrors(bean: userInstance, field: 'lat', 'error')} required">

                        <g:field type="hidden" name="lat" value="-1" required=""/>
                    </div>

                    <div style="display: none" class="fieldcontain ${hasErrors(bean: userInstance, field: 'lng', 'error')} required">

                        <g:field  type="hidden" name="lng" value="-1" required=""/>
                    </div>

                    <div class="fieldcontain ${hasErrors(bean: userInstance, field: 'name', 'error')} ">
                        <label for="name">
                            <g:message code="user.name.label" default="Name" />

                        </label>
                        <g:textField name="name" value="${userInstance?.name}"/>
                    </div>

                    <div class="fieldcontain ${hasErrors(bean: userInstance, field: 'office', 'error')} required">
                        <label for="office">
                            <g:message code="user.office.label" default="Office" />
                            <span class="required-indicator">*</span>
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
