package car.companion

class User {

    String name
    String surname
    Boolean hasCar;
    String city = "Omsk"
    String homeAddress
    String time
    String email
    String contactInfo
    Double lat
    Double lng
    Office office


    static belongsTo = [office: Office]
    static constraints = {
        email(blank: false, unique: true, email: true)
    }



}
