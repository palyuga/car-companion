package car.companion

class Request {

    static final Integer NEW = 0;
    static final Integer VIEWED_BY_RECIPIENT = 1;
    static final Integer ANSWERED = 2;
    static final Integer ANSWERED_AND_VIEWED_BY_SENDER = 3;


    User        src
    User        dest
    Integer     status // Possible status values are in the constant fields above
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
