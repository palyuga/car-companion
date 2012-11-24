package car.companion

class GeoLocatingService {

    def locate(String address) {
        def base = "http://maps.googleapis.com/maps/api/geocode/xml?"
        def params = []
        params << "address=" + URLEncoder.encode(address)
        params << "sensor=false"
        def url = new URL(base + params.join("&"))
        def connection = url.openConnection()

        def result = [:]
        if(connection.responseCode == 200){
            def xml = connection.content.text
            def geonames = new XmlSlurper().parseText(xml)
            result.lat = Double.valueOf(geonames.result.geometry.location.lat as String)
            result.lng = Double.valueOf(geonames.result.geometry.location.lng as String)
        } else {
            throw new RuntimeException(
                "Geo service responded with bad response code:" + connection.responseCode
            )
        }
        return result;
    }
}
