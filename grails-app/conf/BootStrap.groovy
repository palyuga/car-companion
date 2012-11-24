import car.companion.Office

class BootStrap {

    def init = {
        servletContext ->
        new Office(name: "Маркса", lat: new Double(72), lng: new Double(55)).save();
        new Office(name: "Учебная", lat: new Double(80), lng: new Double(55)).save();
    }
    def destroy = {
    }
}
