package car.companion

import org.springframework.dao.DataIntegrityViolationException

class OfficeController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    }

    def list(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        [officeInstanceList: Office.list(params), officeInstanceTotal: Office.count()]
    }
}
