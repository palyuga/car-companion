package car.companion

class RequestController {

    def index() { }

    def addRequest() {
        User user = (User)session.getAttribute("user")
        if (user != null) {
            User destUser = User.findById(Long.parseLong(params['destId'].toString()));
            if (destUser != null) {
                new Request(
                    src: user,
                    dest: destUser,
                    status: Request.NEW,
                    date: new Date(),
                    requestMessage: params['requestMessage']
                ).save(failOnError: true)
            }
        }
        render(contentType:"text/json") {
            [result : true]
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

    def replyRequest() {
        Request request = Request.findById(Long.parseLong(params['requestId'].toString()))
        def res = false
        if (request != null) {
            request.status = Request.ANSWERED;
            request.replyMessage = params['replyMessage'];
            request.save(failOnError: true);
            res = true
        }
        render(contentType:"text/json") {
            [result: res]
        }
    }
}
