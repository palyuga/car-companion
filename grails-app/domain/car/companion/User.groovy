package car.companion

class User {

    String name
    String surname
    String email
    String passwd
    Boolean hasCar
    String address
    Double lat
    Double lng
    Boolean canYouSendHimRequest = true

    static belongsTo = [office: Office]

    // makes many-to-many with the same class
    static hasMany = [incomeRequests: Request, outcomeRequests: Request]
    static mappedBy = [incomeRequests: "dest", outcomeRequests: "src"]

    static constraints = {
        email(blank: false, unique: true, email: true)
    }

}
