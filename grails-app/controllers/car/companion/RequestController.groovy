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

    // find all requests that comes to user from other users
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
                resultList << [request: r, user: r.src]
            }
        }
        render(contentType:"text/json") {
            [incomeRequests: resultList]
        }
    }

    // final all requests that were sent by user
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

    def acceptRequest() {
        Request request = Request.findById(Long.parseLong(params['requestId'].toString()))
        def res = false
        if (request != null) {
            request.status = Request.ACCEPTED;
            request.replyMessage = params['replyMessage'];
            request.save(failOnError: true);
            res = true
        }
        render(contentType:"text/json") {
            [result: res]
        }
    }

    def declineRequest() {
        Request request = Request.findById(Long.parseLong(params['requestId'].toString()))
        def res = false
        if (request != null) {
            request.status = Request.DECLINED;
            request.replyMessage = params['replyMessage'];
            request.save(failOnError: true);
            res = true
        }
        render(contentType:"text/json") {
            [result: res]
        }
    }

    def isNewRequestExists() {
        def result = false
        if (params['recipientId'] != null) {
            User sender = (User)session.getAttribute("user")
            User recipient = User.findById(Long.parseLong(params['recipientId'].toString()))

            if (sender != null && recipient != null) {
                Request request = Request.findByStatusAndSrcAndDest(
                        Request.NEW,
                        sender,
                        recipient
                )
                result = (request != null)
            }
        }
        render(contentType:"text/json") {
            [result: result]
        }
    }
}
