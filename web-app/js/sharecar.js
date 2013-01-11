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
        ? '' : '<div class=\"h2\"> Нет полученных запросов </div>';
    for (var i = 0, len = json.incomeRequests.length; i < len; ++i) {
        var req = json.incomeRequests[i];

        if (req.request.status == 0) {
            status = createAcceptLink(req.request.id) + createDeclineLink(req.request.id);
        } else if (req.request.status == 1) {
            status = "Принят";
        } else if (req.request.status == 2) {
            status = "Отклонен";
        }
        text += "<div class=\"row\"> От пользователя: <span class=\"hh\">" + req.user.name + " " + req.user.surname + "</span>"
            + "<br/> <span class=\"hh\">" + status + "</span></div>"
    }
    $("#income").html(text);
}

function createAcceptLink(requestId) {
    return '<a class="reqLink" onclick="acceptRequest(' + requestId + ')">'
        + 'Принять'
        + '</a>';
}

function createDeclineLink(requestId) {
    return '<a class="reqLink" onclick="declineRequest(' + requestId + ')">'
        + 'Отклонить'
        + '</a>';
}

function fillSentRequests(json) {
    var text = (json.sentRequests.length != 0)
        ? '' : '<div class=\"h2\"> Нет отправленных запросов </div>';
    for (var i = 0, len = json.sentRequests.length; i < len; ++i) {
        var req = json.sentRequests[i];
        var status = "Не рассмотрен";
        if (req.request.status == 1) {
            status = "Принят";
        } else if (req.request.status == 2) {
            status = "Отклонен";
        }
        text += "<div class=\"row\"> Пользователю: <span class=\"hh\">" + req.user.name + " " + req.user.surname + "</span>"
            + '<div>' + req.request.requestMessage + '</div>'
            + "<br/> Статус: <span class=\"hh\">" + status + "</span></div>"
    }
    $("#outcome").html(text);
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

function createRequestForm(recipientId) {
    return '<div id="req' + recipientId + '" class="req">'
        + '<textarea class="messageBox" id="messageTo' + recipientId + '"></textarea>'
        + '<div class="sendRequestLink">'
        + '<a class="reqLink" onclick="sendRequest(' + recipientId + ')">'
        + 'Отправить запрос'
        + '</a>'
        + '</div></div>';
}