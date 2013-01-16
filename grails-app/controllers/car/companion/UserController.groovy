package car.companion

import org.springframework.dao.DataIntegrityViolationException

class UserController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    public static final String USER_SESSION_KEY = "user"

    def encryptionService

    def beforeInterceptor = [action: this.&encrypt, only: ['save', 'update']]

    def encrypt() {
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

        Iterator<User> it = resultList.iterator()
        while (it.hasNext()) {
            User currentUser = it.next()
            if (currentUser.email.equals(user.email)) {
                it.remove()
                continue
            }
            if (isNewRequestExists(user, currentUser)) {
                currentUser.canYouSendHimRequest = false
            }

        }

        [
            userInstanceList: resultList,
            isLogged: (user != null),
            currentUser: [name: user?.name, lat: user?.lat, lng: user?.lng]
        ]
    }

    private User getCurrentLoggedUser() {
        (User) session.getAttribute(USER_SESSION_KEY)
    }

    def boolean isNewRequestExists(User sender, User recipient) {
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

    def create() {
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

    boolean isLocationValid() {
        params['lat'] != -1 && params['lng'] != -1
    }

    private void loginUser(User userInstance) {
        session.setAttribute(USER_SESSION_KEY, userInstance)
    }

    def show(Long id) {
        def userInstance = User.get(id)
        if (!userInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'user.label', default: 'User'), id])
            redirect(action: "list")
            return
        }

        [userInstance: userInstance]
    }

    def edit(Long id) {
        def userInstance = User.get(id)
        if (!userInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'user.label', default: 'User'), id])
            redirect(action: "list")
            return
        }

        [userInstance: userInstance]
    }

    def update(Long id, Long version) {
        def userInstance = User.get(id)
        if (!userInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'user.label', default: 'User'), id])
            redirect(action: "list")
            return
        }

        if (version != null) {
            if (userInstance.version > version) {
                userInstance.errors.rejectValue("version", "default.optimistic.locking.failure",
                          [message(code: 'user.label', default: 'User')] as Object[],
                          "Another user has updated this User while you were editing")
                render(view: "edit", model: [userInstance: userInstance])
                return
            }
        }

        userInstance.properties = params

        if (!userInstance.save(flush: true)) {
            render(view: "edit", model: [userInstance: userInstance])
            return
        }

        flash.message = message(code: 'default.updated.message', args: [message(code: 'user.label', default: 'User'), userInstance.id])
        redirect(action: "show", id: userInstance.id)
    }

    def private delete(Long id) {
        def userInstance = User.get(id)
        if (!userInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'user.label', default: 'User'), id])
            redirect(action: "list")
            return
        }

        try {
            userInstance.delete(flush: true)
            flash.message = message(code: 'default.deleted.message', args: [message(code: 'user.label', default: 'User'), id])
            redirect(action: "list")
        }
        catch (DataIntegrityViolationException e) {
            flash.message = message(code: 'default.not.deleted.message', args: [message(code: 'user.label', default: 'User'), id])
            redirect(action: "show", id: id)
        }
    }
}
