<%@ page import="car.companion.Request" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <g:set var="entityName" value="${message(code: 'request.label', default: 'Request')}"/>
    <title><g:message code="default.show.label" args="[entityName]"/></title>
</head>

<body>
<a href="#show-request" class="skip" tabindex="-1"><g:message code="default.link.skip.label"
                                                              default="Skip to content&hellip;"/></a>

<div class="nav" role="navigation">
    <ul>
        <li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
        <li><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]"/></g:link></li>
        <li><g:link class="create" action="create"><g:message code="default.new.label"
                                                              args="[entityName]"/></g:link></li>
    </ul>
</div>

<div id="show-request" class="content scaffold-show" role="main">
    <h1><g:message code="default.show.label" args="[entityName]"/></h1>
    <g:if test="${flash.message}">
        <div class="message" role="status">${flash.message}</div>
    </g:if>
    <ol class="property-list request">

        <g:if test="${requestInstance?.date}">
            <li class="fieldcontain">
                <span id="date-label" class="property-label"><g:message code="request.date.label"
                                                                        default="Date"/></span>

                <span class="property-value" aria-labelledby="date-label"><g:formatDate
                        date="${requestInstance?.date}"/></span>

            </li>
        </g:if>

        <g:if test="${requestInstance?.dest}">
            <li class="fieldcontain">
                <span id="dest-label" class="property-label"><g:message code="request.dest.label"
                                                                        default="Dest"/></span>

                <span class="property-value" aria-labelledby="dest-label"><g:link controller="user" action="show"
                                                                                  id="${requestInstance?.dest?.id}">${requestInstance?.dest?.encodeAsHTML()}</g:link></span>

            </li>
        </g:if>

        <g:if test="${requestInstance?.src}">
            <li class="fieldcontain">
                <span id="src-label" class="property-label"><g:message code="request.src.label" default="Src"/></span>

                <span class="property-value" aria-labelledby="src-label"><g:link controller="user" action="show"
                                                                                 id="${requestInstance?.src?.id}">${requestInstance?.src?.encodeAsHTML()}</g:link></span>

            </li>
        </g:if>

        <g:if test="${requestInstance?.status}">
            <li class="fieldcontain">
                <span id="status-label" class="property-label"><g:message code="request.status.label"
                                                                          default="Status"/></span>

                <span class="property-value" aria-labelledby="status-label"><g:fieldValue bean="${requestInstance}"
                                                                                          field="status"/></span>

            </li>
        </g:if>

    </ol>
    <g:form>
        <fieldset class="buttons">
            <g:hiddenField name="id" value="${requestInstance?.id}"/>
            <g:link class="edit" action="edit" id="${requestInstance?.id}"><g:message code="default.button.edit.label"
                                                                                      default="Edit"/></g:link>
            <g:actionSubmit class="delete" action="delete"
                            value="${message(code: 'default.button.delete.label', default: 'Delete')}"
                            onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');"/>
        </fieldset>
    </g:form>
</div>
</body>
</html>
