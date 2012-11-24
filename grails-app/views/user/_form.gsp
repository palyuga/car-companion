<%@ page import="car.companion.User" %>



<div class="fieldcontain ${hasErrors(bean: userInstance, field: 'email', 'error')} required">
	<label for="email">
		<g:message code="user.email.label" default="Email" />
		<span class="required-indicator">*</span>
	</label>
	<g:field type="email" name="email" required="" value="${userInstance?.email}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: userInstance, field: 'address', 'error')} ">
	<label for="address">
		<g:message code="user.address.label" default="Address" />
		
	</label>
	<g:textField name="address" value="${userInstance?.address}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: userInstance, field: 'hasCar', 'error')} ">
	<label for="hasCar">
		<g:message code="user.hasCar.label" default="Has Car" />
		
	</label>
	<g:checkBox name="hasCar" value="${userInstance?.hasCar}" />
</div>

<div class="fieldcontain ${hasErrors(bean: userInstance, field: 'lat', 'error')} required">
	<label for="lat">
		<g:message code="user.lat.label" default="Lat" />
		<span class="required-indicator">*</span>
	</label>
	<g:field name="lat" value="${fieldValue(bean: userInstance, field: 'lat')}" required=""/>
</div>

<div class="fieldcontain ${hasErrors(bean: userInstance, field: 'lng', 'error')} required">
	<label for="lng">
		<g:message code="user.lng.label" default="Lng" />
		<span class="required-indicator">*</span>
	</label>
	<g:field name="lng" value="${fieldValue(bean: userInstance, field: 'lng')}" required=""/>
</div>

<div class="fieldcontain ${hasErrors(bean: userInstance, field: 'name', 'error')} ">
	<label for="name">
		<g:message code="user.name.label" default="Name" />
		
	</label>
	<g:textField name="name" value="${userInstance?.name}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: userInstance, field: 'office', 'error')} required">
	<label for="office">
		<g:message code="user.office.label" default="Office" />
		<span class="required-indicator">*</span>
	</label>
	<g:select id="office" name="office.id" from="${car.companion.Office.list()}" optionKey="id" required="" value="${userInstance?.office?.id}" class="many-to-one"/>
</div>

<div class="fieldcontain ${hasErrors(bean: userInstance, field: 'passwd', 'error')} ">
	<label for="passwd">
		<g:message code="user.passwd.label" default="Passwd" />
		
	</label>
	<g:textField name="passwd" value="${userInstance?.passwd}"/>
</div>

