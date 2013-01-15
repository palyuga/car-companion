function sendRequest(userId) {
    jQuery.ajax({
        type: 'POST',
        data: {'destId': userId, 'requestMessage': $("#messageTo" + userId).val()},
        url: '/car-companion/request/addRequest',
        success:
            function(data,textStatus){
                requestCallback(userId, "Запрос отправлен");
                showSentRequests();
            },
        error:
            function(XMLHttpRequest,textStatus,errorThrown){
                requestCallback(userId, "Ошибка");
            }
    });
    return false;
}

function requestCallback(userId, message){
    $("#req" + userId).html(message);
}

function showSentRequests() {
    jQuery.ajax({
        type: 'POST',
        url: '/car-companion/request/listOutcome',
        dataType: "json",
        success:
            function(data){
                fillSentRequests(data);
            },
        error:
            function(XMLHttpRequest,textStatus,errorThrown){
                fillSentRequests("Ошибка");
            }
    });
}

function showIncomingRequests() {
    jQuery.ajax({
        type: 'POST',
        dataType: 'json',
        url: '/car-companion/request/listIncome',
        success:
            function(data){
                fillIncomingRequests(data);
            },
        error:
            function(XMLHttpRequest,textStatus,errorThrown){
                fillIncomingRequests("Ошибка");
            }
    });
}

function fillIncomingRequests(json) {
    var text = (json.incomeRequests.length != 0)
        ? '' : '<span class=\"h2\"> Нет полученных запросов </span>';
    for (var i = 0, len = json.incomeRequests.length; i < len; ++i) {
        var req = json.incomeRequests[i];
        var replyForm = "";
        var replyMessage = "";

        if (req.request.status == 0) {
            replyForm = createReplyForm(req.request.id);
        } else if (req.request.status == 1) {
            replyMessage = req.request.replyMessage;
        }

        text += "<div class=\"row\"> От пользователя: <a onclick=\"showUserOnMap("
            + req.user.id + ")\">" + req.user.name + " " + req.user.surname + "</a>"
            + replyForm
            + replyMessage
            + "</div>"
    }
    $("#income").html(text);
}

function createReplyForm(requestId) {
    return '<a class="showReplyForm" onclick="showReplyForm(' + requestId + ')">Написать ответ</a>'
        + '<div class="hiddenReplyForm" id="hiddenReplyForm' + requestId + '">'
        + '<textarea class="replyArea" id="replyArea' + requestId
        + '"  maxlength="140"></textarea>'
        + '<a class="btn" onclick="sendReply(' + requestId + ')">Отправить</a>'
        + '</div>'
}

function showReplyForm(requestId) {
    $(".hiddenReplyForm").hide();
    $("#hiddenReplyForm" + requestId).show();
}

function processAddress() {
    var address = $("#address").val();
    if (address != null && address.length != 0) {
         geocode(address)
    }
    return false;
}

function geocode(address) {
    var geocoder = new google.maps.Geocoder();
    var result = "";
    geocoder.geocode( { 'address': "Омск, " + address, 'region': 'RU' },
        function(results, status) {
            if (status == google.maps.GeocoderStatus.OK) {
                var location = results[0].geometry.location;
                map.setCenter(location);
                map.setZoom(mapZoom);
                placeMarker(location);
                storeGeocodingResult(location);
            } else {
                showGeocodingError("Такой адрес неизвестен. Попробуйте указать положение на карте.");
            }
        }
    );
}

function storeGeocodingResult(location) {
    $("#latField").val(location.lat());
    $("#lngField").val(location.lng());

}

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
function showGeocodingError(message) {
    alert("OI!")
    $("#geoError").html(message);
}

function sendReply(requestId) {

}

function createDeclineLink(requestId) {
    return '<a class="reqLink" onclick="declineRequest(' + requestId + ')">'
        + 'Отклонить'
        + '</a>';
}

function acceptRequest(id, message) {
    jQuery.ajax({
        type: 'POST',
        data: {'requestId': id, 'replyMessage': message},
        dataType: 'json',
        url: '/car-companion/request/acceptRequest',
        success:
            showIncomingRequests(),
        error:
            function(XMLHttpRequest,textStatus,errorThrown){
                fillIncomingRequests("Ошибка");
            }
    });


}

function declineRequest(id, message) {
    jQuery.ajax({
        type: 'POST',
        data: {'requestId': id, 'replyMessage': message},
        dataType: 'json',
        url: '/car-companion/request/declineRequest',
        success:
            showIncomingRequests(),
        error:
            function(XMLHttpRequest,textStatus,errorThrown){
                fillIncomingRequests("Ошибка");
            }
    });
}

function fillSentRequests(json) {
    var text = (json.sentRequests.length != 0)
        ? '' : '<div class=\"h2\"> Нет отправленных запросов </div>';
    for (var i = 0, len = json.sentRequests.length; i < len; ++i) {
        var req = json.sentRequests[i];

        text += "<div class=\"row\"> Пользователю:"
            + " <a onclick=\"showUserOnMap(" + req.user.id + ")\">"
            + req.user.name + " " + req.user.surname
            + "</a>"
            + '<div>' + req.request.requestMessage + '</div></div>'
    }
    $("#outcome").html(text);
}

function createRequestForm(recipientId) {
    return '<div id="req' + recipientId + '" class="req">'
        + '<textarea class="messageBox" id="messageTo' + recipientId + '"></textarea>'
        + '<div class="sendRequestLink">'
        + '<a class="btn" onclick="sendRequest(' + recipientId + ')">'
        + 'Отправить запрос'
        + '</a>'
        + '</div></div>';
}

function showUserOnMap(userId) {
    var bounds = new google.maps.LatLngBounds();
    bounds.extend(latlng); // Current user's coordinates

    for (var i = 0; i < markers.length; i++) {
        if (ids[i] == userId) {
            markers[i].setMap(map);
            bounds.extend(markers[i].position);
            infoWindows[i].open(map, markers[i]);
        } else {
            markers[i].setMap(null);
        }
    }
    map.fitBounds(bounds);
}

