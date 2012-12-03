package car.companion

class EncryptionService {

    def SALT = 'm0u$7aCh3'

    def encrypt(String password) {
        (password + SALT).encodeAsMD5()
    }

    def isPasswordHasHash(String password, String hash) {
        encrypt(password) equals (hash)
    }
}
