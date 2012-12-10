package car.companion

class Request {

    static final Integer NEW = 0;
    static final Integer ACCEPTED = 1;
    static final Integer DECLINED = 2;

    User        src
    User        dest
    Integer     status // 0 - NEW, 1 - ACCEPTED, 2 - DECLINED
    Date        date

    // makes many-to-many with the same class
    static hasMany = [src : User, dest : User]

    static belongsTo = User
}
