<%@ page import="car.companion.Office" %>



<div class="fieldcontain ${hasErrors(bean: officeInstance, field: 'lat', 'error')} required">
	<label for="lat">
		<g:message code="office.lat.label" default="Lat" />
		<span class="required-indicator">*</span>
	</label>
	<g:field name="lat" value="${fieldValue(bean: officeInstance, field: 'lat')}" required=""/>
</div>

<div class="fieldcontain ${hasErrors(bean: officeInstance, field: 'lng', 'error')} required">
	<label for="lng">
		<g:message code="office.lng.label" default="Lng" />
		<span class="required-indicator">*</span>
	</label>
	<g:field name="lng" value="${fieldValue(bean: officeInstance, field: 'lng')}" required=""/>
</div>

<div class="fieldcontain ${hasErrors(bean: officeInstance, field: 'name', 'error')} ">
	<label for="name">
		<g:message code="office.name.label" default="Name" />
		
	</label>
	<g:textField name="name" value="${officeInstance?.name}"/>
</div>

