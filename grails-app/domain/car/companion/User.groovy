package car.companion

class User {

    String name
    String email
    String passwd
    Boolean hasCar
    String address
    Double lat
    Double lng
    Office office

    static belongsTo = [office: Office]
    static constraints = {
        email(blank: false, unique: true, email: true)
    }
}
