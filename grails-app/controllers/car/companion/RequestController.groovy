package car.companion

class RequestController {

    def index() { }

    def addRequest(User s, User d) {
        new Request(src: s, dest: d, status: Request.NEW, date: new Date()).save(failOnError: true)
    }

    // find all requests that comes to user from other users
    def listIncome(User user, Integer status) {
        def resultList = Request.findAllByDestAndStatus(user, status);
        [incomeRequests: resultList]
    }

    // final all requests that were sent by user
    def listOutcome(User user, Integer status) {
        def resultList = Request.findAllBySrcAndStatus(user, status);
        [outcomeRequests: resultList]
    }

    def acceptRequest(Request request) {
        request.status = Request.ACCEPTED;
        request.save(failOnError: true);
    }

    def declineRequest(Request request) {
        request.status = Request.DECLINED;
        request.save(failOnError: true);
    }
}
