import car.companion.User

class BootStrap {

    def init = { servletContext ->
        new User(name:  "Petr", email: "petr@luxoft.com", address: "1", lat: 54.9860357, lng: 73.3974034, hasCar: true, passwd: "123").save(failOnError: true)
        new User(name:  "Ivan", email: "ivan@luxoft.com", address: "1", lat: 54.9762631, lng: 73.3821115, hasCar: true, passwd: "123").save(failOnError: true)
        new User(name:  "Masha", email: "masha@luxoft.com", address: "1", lat: 54.9688974, lng: 73.3846840, hasCar: true, passwd: "123").save(failOnError: true)
    }

    def destroy = {
    }
}
