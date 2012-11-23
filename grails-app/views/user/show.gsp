
<%@ page import="car.companion.User" %>
<!doctype html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'user.label', default: 'User')}" />
		<title><g:message code="default.show.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#show-user" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="show-user" class="content scaffold-show" role="main">
			<h1><g:message code="default.show.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<ol class="property-list user">
			
				<g:if test="${userInstance?.email}">
				<li class="fieldcontain">
					<span id="email-label" class="property-label"><g:message code="user.email.label" default="Email" /></span>
					
						<span class="property-value" aria-labelledby="email-label"><g:fieldValue bean="${userInstance}" field="email"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${userInstance?.city}">
				<li class="fieldcontain">
					<span id="city-label" class="property-label"><g:message code="user.city.label" default="City" /></span>
					
						<span class="property-value" aria-labelledby="city-label"><g:fieldValue bean="${userInstance}" field="city"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${userInstance?.contactInfo}">
				<li class="fieldcontain">
					<span id="contactInfo-label" class="property-label"><g:message code="user.contactInfo.label" default="Contact Info" /></span>
					
						<span class="property-value" aria-labelledby="contactInfo-label"><g:fieldValue bean="${userInstance}" field="contactInfo"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${userInstance?.hasCar}">
				<li class="fieldcontain">
					<span id="hasCar-label" class="property-label"><g:message code="user.hasCar.label" default="Has Car" /></span>
					
						<span class="property-value" aria-labelledby="hasCar-label"><g:formatBoolean boolean="${userInstance?.hasCar}" /></span>
					
				</li>
				</g:if>
			
				<g:if test="${userInstance?.homeAddress}">
				<li class="fieldcontain">
					<span id="homeAddress-label" class="property-label"><g:message code="user.homeAddress.label" default="Home Address" /></span>
					
						<span class="property-value" aria-labelledby="homeAddress-label"><g:fieldValue bean="${userInstance}" field="homeAddress"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${userInstance?.lat}">
				<li class="fieldcontain">
					<span id="lat-label" class="property-label"><g:message code="user.lat.label" default="Lat" /></span>
					
						<span class="property-value" aria-labelledby="lat-label"><g:fieldValue bean="${userInstance}" field="lat"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${userInstance?.lng}">
				<li class="fieldcontain">
					<span id="lng-label" class="property-label"><g:message code="user.lng.label" default="Lng" /></span>
					
						<span class="property-value" aria-labelledby="lng-label"><g:fieldValue bean="${userInstance}" field="lng"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${userInstance?.name}">
				<li class="fieldcontain">
					<span id="name-label" class="property-label"><g:message code="user.name.label" default="Name" /></span>
					
						<span class="property-value" aria-labelledby="name-label"><g:fieldValue bean="${userInstance}" field="name"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${userInstance?.office}">
				<li class="fieldcontain">
					<span id="office-label" class="property-label"><g:message code="user.office.label" default="Office" /></span>
					
						<span class="property-value" aria-labelledby="office-label"><g:link controller="office" action="show" id="${userInstance?.office?.id}">${userInstance?.office?.encodeAsHTML()}</g:link></span>
					
				</li>
				</g:if>
			
				<g:if test="${userInstance?.surname}">
				<li class="fieldcontain">
					<span id="surname-label" class="property-label"><g:message code="user.surname.label" default="Surname" /></span>
					
						<span class="property-value" aria-labelledby="surname-label"><g:fieldValue bean="${userInstance}" field="surname"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${userInstance?.time}">
				<li class="fieldcontain">
					<span id="time-label" class="property-label"><g:message code="user.time.label" default="Time" /></span>
					
						<span class="property-value" aria-labelledby="time-label"><g:fieldValue bean="${userInstance}" field="time"/></span>
					
				</li>
				</g:if>
			
			</ol>
			<g:form>
				<fieldset class="buttons">
					<g:hiddenField name="id" value="${userInstance?.id}" />
					<g:link class="edit" action="edit" id="${userInstance?.id}"><g:message code="default.button.edit.label" default="Edit" /></g:link>
					<g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
				</fieldset>
			</g:form>
		</div>
	</body>
</html>
