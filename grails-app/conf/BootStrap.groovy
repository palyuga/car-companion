
import car.companion.Office
import car.companion.User

class BootStrap {

    def encryptionService

    def enc(String password) {
        encryptionService.encrypt(password)
    }

    def init = {
        servletContext ->
        Office o1 = new Office(name: "Маркса", lat: new Double(72), lng: new Double(55)).save(failOnError: true, flush: true);
        Office o2 = new Office(name: "Учебная", lat: new Double(80), lng: new Double(55)).save(failOnError: true, flush: true);

        new User(name:  "Petr", email: "petr@luxoft.com", address: "1", office: o1, lat: 54.9660357, lng: 73.3374034, hasCar: false, passwd: enc("123")).save(failOnError: true)
        new User(name:  "Ivan", email: "ivan@luxoft.com", address: "1", office: o1, lat: 54.9762631, lng: 73.3821115, hasCar: true, passwd: enc("123")).save(failOnError: true)
        new User(name:  "Masha", email: "masha@luxoft.com", address: "1", office: o1, lat: 54.9688974, lng: 73.3846840, hasCar: true, passwd: enc("123")).save(failOnError: true)
        new User(name:  "Klava", email: "klava.love@luxoft.com", address: "1", office: o1, lat: 54.9888974, lng: 73.3346840, hasCar: false, passwd: enc("123")).save(failOnError: true)
        new User(name:  "Sasha", email: "sanyok1975@luxoft.com", address: "1", office: o1, lat: 54.9460357, lng: 73.3274034, hasCar: true, passwd: enc("123")).save(failOnError: true)
        new User(name:  "Sergey", email: "sergio-lion@luxoft.com", address: "1", office: o1, lat: 54.9362631, lng: 73.3921115, hasCar: true, passwd: enc("123")).save(failOnError: true)
        new User(name:  "Andrey", email: "dyusha02@luxoft.com", address: "1", office: o1, lat: 54.9588974, lng: 73.3446840, hasCar: false, passwd: enc("123")).save(failOnError: true)
        new User(name:  "Ksyusha", email: "ksushasha@luxoft.com", address: "1", office: o1, lat: 54.9488974, lng: 73.3246840, hasCar: true, passwd: enc("123")).save(failOnError: true)


        new User(name:  "Stepan", email: "stepan@luxoft.com", address: "1", office: o1, lat: 54.9660357, lng: 73.3374034, hasCar: true, passwd: enc("123")).save(failOnError: true)
        new User(name:  "Mihail", email: "mishanya@luxoft.com", address: "1", office: o1, lat: 54.9762631, lng: 73.3821115, hasCar: false, passwd: enc("123")).save(failOnError: true)
        new User(name:  "Vasiliy", email: "vasyok@luxoft.com", address: "1", office: o2, lat: 54.9688974, lng: 73.3846840, hasCar: true, passwd: enc("123")).save(failOnError: true)
        new User(name:  "Ippolit", email: "ippolit@luxoft.com", address: "1", office: o2, lat: 54.9888974, lng: 73.3346840, hasCar: false, passwd: enc("123")).save(failOnError: true)

    }

    def destroy = {
    }
}
