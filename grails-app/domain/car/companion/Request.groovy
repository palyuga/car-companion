package car.companion

class Request {

    static final Integer NEW = 0;
    static final Integer ACCEPTED = 1;

    User        src
    User        dest
    Integer     status // 0 - NEW, 1 - ACCEPTED
    Date        date
    String requestMessage
    String replyMessage

    // makes many-to-many with the same class
    static hasMany = [src : User, dest : User]

    static belongsTo = User

    static constraints = {
        requestMessage(blank: true, nullable: true)
        replyMessage(blank: true, nullable: true)
    }

    static mapping = {
        sort date: "desc"
    }
}
