package car.companion

import org.springframework.dao.DataIntegrityViolationException

class UserController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def geoLocatingService

    def beforeInterceptor = [action: this.&setGeoLocation, only: ['save', 'update']]

    def setGeoLocation() {
        def coords = geoLocatingService.locate(params['address']);
        params.putAll(coords);
    }

    def index() {
        redirect(action: "list", params: params)
    }

    def list(Integer max) {

        User user = (User)session.getAttribute("user")
        def resultList = []
        if (user != null) {
            user.refresh()
            resultList = User.findAllByOffice(user.office)
        }
        Iterator<User> it = resultList.iterator();
        while (it.hasNext()) {
            User u = it.next();
            if (u.email.equals(user.email)) {
                it.remove();
                break;
            }
        }

        [userInstanceList: resultList,
         isLogged: (user != null),
         currentUser: [lat: user?.lat, lng: user?.lng]]
    }

    def login() {
        def email = params['email']
        def passwd = params['passwd']
        def user = User.findByEmail(email.toString());
        if (user != null && user.passwd.toString().equals(passwd.toString())) {
            session.setAttribute("user", user);
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
        if (!userInstance.save(flush: true)) {
            render(view: "create", model: [userInstance: userInstance])
            return
        }

        flash.message = message(code: 'default.created.message', args: [message(code: 'user.label', default: 'User'), userInstance.id])
        redirect(action: "list")
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

    def delete(Long id) {
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
