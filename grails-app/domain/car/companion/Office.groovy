package car.companion

class Office {

    String name
    Double lat
    Double lng

    String toString() {
        name
    }

    static hasMany = [users : User];
    static constraints = {
        name(blank: false, unique: true)
    }
    static fetchMode = [users: 'eager']
}
