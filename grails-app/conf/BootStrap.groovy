
import car.companion.Office
import car.companion.User
import car.companion.Request
import car.companion.RequestController

class BootStrap {

    def encryptionService

    def enc(String password) {
        encryptionService.encrypt(password)
    }

    def init = {
        servletContext ->
        Office o1 = new Office(name: "Маркса", lat: new Double(72), lng: new Double(55)).save(failOnError: true, flush: true);
        Office o2 = new Office(name: "Учебная", lat: new Double(80), lng: new Double(55)).save(failOnError: true, flush: true);

        User pet = new User(name:  "Пётр Иванович", surname: "Троцкий", email: "petr@luxoft.com", address: "пр. Маркса, 34", office: o1, lat: 54.9460357, lng: 73.3374034, hasCar: false, passwd: enc("123")).save(failOnError: true)
        User iva = new User(name:  "Ваня", surname: "Керенский", email: "ivan@luxoft.com", address: "ул. Фугенфирова, 20", office: o1, lat: 54.9762631, lng: 73.3321115, hasCar: true, passwd: enc("123")).save(failOnError: true)
        User mas = new User(name:  "Маша", surname:  "Витте", email: "masha@luxoft.com", address: "ул. Строителей 2", office: o1, lat: 54.9688974, lng: 73.3846840, hasCar: true, passwd: enc("123")).save(failOnError: true)
        User kla = new User(name:  "Клава", surname:  "Риббентроп", email: "klava.love@luxoft.com", address: "ул. Князева 12", office: o1, lat: 54.9888974, lng: 73.3346840, hasCar: false, passwd: enc("123")).save(failOnError: true)
        User sas = new User(name:  "Александр", surname: "Геринг", email: "sanyok1975@luxoft.com", address: "ул. Повстанцев 33", office: o1, lat: 54.9460357, lng: 73.3274034, hasCar: true, passwd: enc("123")).save(failOnError: true)
        User ser = new User(name:  "Сережа", surname: "Столыпин", email: "sergio-lion@luxoft.com", address: "ул. Андреева 12", office: o1, lat: 54.9362631, lng: 73.3921115, hasCar: true, passwd: enc("123")).save(failOnError: true)
        User and = new User(name:  "Андрей", surname: "Андрюша", email: "dyusha02@luxoft.com", address: "ул. Космологическая 18", office: o1, lat: 54.9588974, lng: 73.3446840, hasCar: false, passwd: enc("123")).save(failOnError: true)
        User ksy = new User(name:  "Ксюша", surname: "Крупская", email: "ksushasha@luxoft.com", address: "ул. Колымова 11", office: o1, lat: 54.9488974, lng: 73.3246840, hasCar: true, passwd: enc("123")).save(failOnError: true)

        User ste = new User(name:  "Степан", surname: "Боров", email: "stepan@luxoft.com", address: "ул. Бутакова 12", office: o1, lat: 54.9660357, lng: 73.3374034, hasCar: true, passwd: enc("123")).save(failOnError: true)
        User mih = new User(name:  "Миша", surname: "Кувалда", email: "mishanya@luxoft.com", address: "ул. Магистральная 9", office: o1, lat: 54.9762631, lng: 73.3821115, hasCar: false, passwd: enc("123")).save(failOnError: true)
        User vas = new User(name:  "Василий", surname: "Тигр", email: "vasyok@luxoft.com", address: "ул. Молодых Гвардейцев 12", office: o2, lat: 54.9688974, lng: 73.3846840, hasCar: true, passwd: enc("123")).save(failOnError: true)
        User ipp = new User(name:  "Ипполит", surname: "Борщ", email: "ippolit@luxoft.com", address: "ул. Степана Разина 32", office: o2, lat: 54.9888974, lng: 73.3346840, hasCar: false, passwd: enc("123")).save(failOnError: true)
    }

    def destroy = {
    }
}
