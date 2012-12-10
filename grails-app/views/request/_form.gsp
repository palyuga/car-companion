<%@ page import="car.companion.Request" %>



<div class="fieldcontain ${hasErrors(bean: requestInstance, field: 'date', 'error')} required">
    <label for="date">
        <g:message code="request.date.label" default="Date"/>
        <span class="required-indicator">*</span>
    </label>
    <g:datePicker name="date" precision="day" value="${requestInstance?.date}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: requestInstance, field: 'dest', 'error')} required">
    <label for="dest">
        <g:message code="request.dest.label" default="Dest"/>
        <span class="required-indicator">*</span>
    </label>
    <g:select id="dest" name="dest.id" from="${car.companion.User.list()}" optionKey="id" required=""
              value="${requestInstance?.dest?.id}" class="many-to-one"/>
</div>

<div class="fieldcontain ${hasErrors(bean: requestInstance, field: 'src', 'error')} required">
    <label for="src">
        <g:message code="request.src.label" default="Src"/>
        <span class="required-indicator">*</span>
    </label>
    <g:select id="src" name="src.id" from="${car.companion.User.list()}" optionKey="id" required=""
              value="${requestInstance?.src?.id}" class="many-to-one"/>
</div>

<div class="fieldcontain ${hasErrors(bean: requestInstance, field: 'status', 'error')} required">
    <label for="status">
        <g:message code="request.status.label" default="Status"/>
        <span class="required-indicator">*</span>
    </label>
    <g:field name="status" type="number" value="${requestInstance.status}" required=""/>
</div>

