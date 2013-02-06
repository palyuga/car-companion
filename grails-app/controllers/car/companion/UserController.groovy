package car.companion

import org.springframework.dao.DataIntegrityViolationException

class UserController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    public static final String USER_SESSION_KEY = "user"

    def encryptionService

    def beforeInterceptor = [action: this.&encrypt, only: ['save', 'update']]

    def private encrypt() {
        params['lat'] = Double.valueOf(params['lat'] as String)
        params['lng'] = Double.valueOf(params['lng'] as String)
        params.put("passwd", encryptionService.encrypt(params['passwd']))
    }

    def index() {
        redirect(action: "list", params: params)
    }

    def list(Integer max) {

        User user = getCurrentLoggedUser()
        def resultList = []

        if (user != null) {
            user.refresh()
            resultList = User.findAllByOffice(user.office)
        }

        excludeUserFromList(user, resultList)

        [
            userInstanceList: resultList,
            isLogged: (user != null),
            currentUser: [name: user?.name, lat: user?.lat, lng: user?.lng]
        ]
    }

    private void excludeUserFromList(User user, List resultList) {
        Iterator<User> it = resultList.iterator()
        while (it.hasNext()) {
            User currentUser = it.next()
            if (currentUser.email.equals(user.email)) {
                it.remove()
                break
            }
        }
    }

    def private User getCurrentLoggedUser() {
        (User) session.getAttribute(USER_SESSION_KEY)
    }

    def private boolean isNewRequestExists(User sender, User recipient) {
        Request request = Request.findByStatusAndSrcAndDest(
                Request.NEW,
                sender,
                recipient
        )
        return request != null
    }

    def login() {
        def email = params['email']
        def passwordFromForm = params['passwd'].toString()
        def user = User.findByEmail(email.toString())

        if (user != null) {
            if (encryptionService.isPasswordHasHash(passwordFromForm, user.passwd.toString())) {
                loginUser(user)
            } else {
                flash.message = "Неправильно введен пароль"
            }
        } else {
            flash.message = "Пользователь '" + email + "' не существует"
        }

        redirect(action: "list");
    }

    def logoff() {
        session.invalidate();
        redirect(action: "list");
    }

    def private create() {
        [userInstance: new User(params)]
    }

    def save() {
        def userInstance = new User(params)

        if (isLocationValid()) {

            if (userInstance.save(flush: true)) {

                //If registration is successful user will be logged in
                loginUser(userInstance)
                redirect(action: "list")
            } else {
                flash.message = message(
                        code: 'default.created.message',
                        args: [message(code: 'user.label', default: 'User'),userInstance.id]
                )
                render(view: "list", model: [userInstance: userInstance])

            }
        } else {
            flash.message = "Похоже, Вы не указали свое положение на карте"
            render(view: "list", model: [userInstance: userInstance])
        }
    }

    def private boolean isLocationValid() {
        params['lat'] != -1 && params['lng'] != -1
    }

    def private void loginUser(User userInstance) {
        session.setAttribute(USER_SESSION_KEY, userInstance)
    }

    def alist(Integer max){
        params.max = Math.min(max ?: 100, 1000)
        [userInstanceList: User.list(params), userInstanceTotal: Office.count()]
    }

    def browser() {

    }
}
