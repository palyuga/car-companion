function sendRequest(userId) {
    jQuery.ajax({
        type: 'POST',
        data: {'destId': userId, 'requestMessage': $("#messageTo" + userId).val()},
        url: '/request/addRequest',
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
    $("#messageTo" + userId).val("");
    $("#reqNotify" + userId).html(message);
}

function showSentRequests() {
    jQuery.ajax({
        type: 'POST',
        url: '/request/listOutcome',
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
        url: '/request/listIncome',
        success:
            function(data){
                fillIncomingRequests(data);
                showNewIncomingRequests();
            },
        error:
            function(XMLHttpRequest,textStatus,errorThrown){
                fillIncomingRequests("Ошибка");
            }
    });
}

function showNewIncomingRequests() {
    jQuery.ajax({
        type: 'POST',
        dataType: 'json',
        data: {'status' : 0},
        url: '/request/listIncome',
        success:
            function(data){
                fillNewIncomingRequests(data);
            },
        error:
            function(XMLHttpRequest,textStatus,errorThrown){
                fillNewIncomingRequests("Ошибка");
            }
    });
}

function fillNewIncomingRequests(json) {
    var text = "";
    if (json.incomeRequests.length > 0) {

        for (var i = 0, len = json.incomeRequests.length; i < len; ++i) {
            var req = json.incomeRequests[i];
            var replyForm = createReplyForm(req.request.id);
            text += "<div class=\"row\"><a class=\"showUserLink\" onclick=\"showUserOnMap("
                + req.user.id + ")\">" + req.user.name + " " + req.user.surname + "</a>"
                + "<div class=\"reqDate\">" + $.datepicker.formatDate('dd.mm.yy', new Date(req.request.date)) + "</div>"
                + "<div class=\"reqMessage\">" + req.request.requestMessage + "</div>"
                + replyForm
                + "</div>"

        }
    }
    $("#newIncoming").html(text);
}

function checkNewIncomingRequests() {
    jQuery.ajax({
        type: 'POST',
        dataType: 'json',
        data: {'status' : 0},
        url: '/request/listIncome',
        success:
            function(data){
                prependNewIncomingRequests(data);
            },
        error:
            function(XMLHttpRequest,textStatus,errorThrown){
                fillNewIncomingRequests("Ошибка");
            }
    });
}

function clearNoIncomingMessage() {
    if ($("#noIncomingReq") != null) {
        $("#noIncomingReq").html("")
    }
}

function prependNewIncomingRequests(json) {
    if (json.incomeRequests.length > 0) {
        var text = "";
        for (var i = 0, len = json.incomeRequests.length; i < len; ++i) {
            var req = json.incomeRequests[i];
            var replyForm = createReplyForm(req.request.id);
            text += "<div class=\"row\"><a class=\"showUserLink\" onclick=\"showUserOnMap("
                + req.user.id + ")\">" + req.user.name + " " + req.user.surname + "</a>"
                + "<div class=\"reqDate\">" + $.datepicker.formatDate('dd.mm.yy', new Date(req.request.date)) + "</div>"
                + "<div class=\"reqMessage\">" + req.request.requestMessage + "</div>"
                + replyForm
                + "</div>"

        }
        clearNoIncomingMessage();
        $("#newIncoming").prepend($(text).fadeIn('slow'));
    }
}

function fillIncomingRequests(json) {
    var text = (json.incomeRequests.length != 0)
        ? '' : '<div id="noIncomingReq" class=\"h2\"> Нет полученных запросов </div>';
    for (var i = 0, len = json.incomeRequests.length; i < len; ++i) {
        var req = json.incomeRequests[i];
        var replyForm = "";
        var replyMessage = "";

        if (req.request.status == 0 || req.request.status == 1) {
            replyForm = createReplyForm(req.request.id);
        } else if (req.request.status > 1) {
            replyMessage = req.request.replyMessage;
        }

        text += "<div class=\"row\"><a class=\"showUserLink\" onclick=\"showUserOnMap("
            + req.user.id + ")\">" + req.user.name + " " + req.user.surname + "</a>"
            + "<div class=\"reqDate\">" + $.datepicker.formatDate('dd.mm.yy', new Date(req.request.date)) + "</div>"
            + "<div class=\"reqMessage\">" + req.request.requestMessage + "</div>"
            + replyForm
            + '<div class="replyMessage">' + replyMessage + '</div>'
            + "</div>"
    }
    $("#income").html(text);
}

function createReplyForm(requestId) {
    return '<a class="showReplyForm" onclick="showReplyForm(' + requestId + ')">Написать ответ</a>'
        + '<div class="hiddenReplyForm" id="hiddenReplyForm' + requestId + '">'
        + '<textarea class="replyArea" id="replyArea' + requestId
        + '"  maxlength="140"></textarea>'
        + '<a class="btn replyBtn" onclick="sendReply(' + requestId + ')">Ответить</a>'
        + '</div>'
}

function showReplyForm(requestId) {
    var replyFormId = "#hiddenReplyForm" + requestId;
    $(".hiddenReplyForm:not(" + replyFormId + ")").hide();
    if (!$(replyFormId).is(":visible")) {
        $(replyFormId).show();
    } else {
        $(replyFormId).hide();
    }
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
    $("#geoError").html(message);
}

function sendReply(requestId) {
    jQuery.ajax({
        type: 'POST',
        data: {'requestId': requestId, 'replyMessage': $("#replyArea" + requestId). val()},
        dataType: 'json',
        url: '/request/replyRequest',
        success:
            function() {
                showIncomingRequests();
            },
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
        var reply = "";
        if (req.request.status == 0 || req.request.status == 1) {
           reply = 'Этот запрос еще не рассмотрен';
        } else if (req.request.status > 1) {
           reply = '<div class="reqMessage">' + req.request.replyMessage + '</div>';
        }
        text += "<div class=\"row\">"
            + "<a class=\"showUserLink\" onclick=\"showUserOnMap(" + req.user.id + ")\">"
            + req.user.name + " " + req.user.surname
            + "</a>"
            + "<div class=\"reqDate\">" + $.datepicker.formatDate('dd.mm.yy', new Date(req.request.date)) + "</div>"
            + '<div class="replyMessage">' + req.request.requestMessage + '</div>'
            + reply
            + '</div>'
    }
    $("#outcome").html(text);
}

function createRequestForm(recipientId) {
    return '<div id="req' + recipientId + '" class="req">'

        + '<textarea placeholder="Текст сообщения" class="messageBox" id="messageTo' + recipientId + '" maxlength="140"></textarea>'
        + '<div class="sendRequestLink">'
        + '<div id="reqNotify' + recipientId + '" class="reqNotify"></div>'
        + '<div><a class="btn" onclick="sendRequest(' + recipientId + ')">'
        + 'Отправить'
        + '</a></div>'
        + '</div></div>';
}

function showUserOnMap(userId) {
    var bounds = new google.maps.LatLngBounds();
    bounds.extend(latlng); // Current user coordinates

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

