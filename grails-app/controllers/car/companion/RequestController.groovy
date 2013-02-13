package car.companion

import org.codehaus.groovy.runtime.DefaultGroovyMethods

class RequestController {

    def index() { }

    def addRequest() {
        def result = false
        if (params['requestMessage'] != null && params['destId'] != null) {
            User user = (User)session.getAttribute("user")
            if (user != null) {
                User destUser = User.findById(Long.parseLong(params['destId'].toString()));
                if (destUser != null) {
                    new Request(
                        src: user,
                        dest: destUser,
                        status: Request.NEW,
                        date: new Date(),
                        requestMessage: (GString.EMPTY + (params['requestMessage'])).encodeAsHTML()
                    ).save(failOnError: true)
                    result = true;
                }
            }

        }
        render(contentType:"text/json") {
            [result : result]
        }
    }

    def listIncome(Integer status) {
        User user = (User)session.getAttribute("user")
        def resultList = []
        if (user != null) {
            def requests;
            if (params['status'] == null) {
                requests = Request.findAllByDest(user);
            } else {

                requests = Request.findAllByDestAndStatus(
                    user,
                    Integer.parseInt(params['status'].toString())
                );
            }

            for (Request r : requests) {
                r.src = User.findById(r.src.id)
                markAsViewedIfNew(r)
                resultList << [request: r, user: r.src]
            }
        }
        render(contentType:"text/json") {
            [incomeRequests: resultList]
        }
    }

    private void markAsViewedIfNew(Request r) {
        if (r.status == Request.NEW) {
            r.status = Request.VIEWED_BY_RECIPIENT;
            r.save(failOnError: true);
        }
    }

    def listOutcome() {
        User user = (User)session.getAttribute("user")
        def resultList = []
        if (user != null) {
            def requests
            def answeredRequests = Request.findAllBySrcAndStatus(user, Request.ANSWERED)

            markAsViewed(answeredRequests)

            if (params['status'] == null) {
                requests = Request.findAllBySrc(user);
            } else {
                requests = Request.findAllBySrcAndStatus(
                    user,
                    Integer.parseInt(params['status'].toString())
                );
            }
            for (Request r : requests) {
                r.dest = User.findById(r.dest.id)
                resultList << [request : r, user: r.dest]
            }
        }
        render(contentType:"text/json") {
            [sentRequests: resultList]
        }
    }

    def private markAsViewed(List<Request> answeredRequests) {
        for (Request answeredRequest : answeredRequests) {
            answeredRequest.setStatus(Request.ANSWERED_AND_VIEWED_BY_SENDER)
            answeredRequest.save()
        }
    }

    def isThereNewAnsweredRequests() {
        User user = (User)session.getAttribute("user")
        def boolean result = Request.findBySrcAndStatus(user, Request.ANSWERED) != null
        render(contentType: "text/json") {
            [result: result]
        }
    }

    def replyRequest() {
        def res = false
        if (params['requestId'] != null && params['replyMessage'] != null) {
            Request request = Request.findById(Long.parseLong(params['requestId'].toString()))

            if (request != null) {
                request.status = Request.ANSWERED;
                request.replyMessage = (GString.EMPTY + params['replyMessage']).encodeAsHTML();
                request.save(failOnError: true);
                res = true
            }
        }
        render(contentType:"text/json") {
            [result: res]
        }
    }
}
