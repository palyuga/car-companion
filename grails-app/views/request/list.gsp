<%@ page import="car.companion.Request" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <g:set var="entityName" value="${message(code: 'request.label', default: 'Request')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>

<body>
<a href="#list-request" class="skip" tabindex="-1"><g:message code="default.link.skip.label"
                                                              default="Skip to content&hellip;"/></a>

<div class="nav" role="navigation">
    <ul>
        <li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
        <li><g:link class="create" action="create"><g:message code="default.new.label"
                                                              args="[entityName]"/></g:link></li>
    </ul>
</div>

<div id="list-request" class="content scaffold-list" role="main">
    <h1><g:message code="default.list.label" args="[entityName]"/></h1>
    <g:if test="${flash.message}">
        <div class="message" role="status">${flash.message}</div>
    </g:if>
    <table>
        <thead>
        <tr>

            <g:sortableColumn property="date" title="${message(code: 'request.date.label', default: 'Date')}"/>

            <th><g:message code="request.dest.label" default="Dest"/></th>

            <th><g:message code="request.src.label" default="Src"/></th>

            <g:sortableColumn property="status" title="${message(code: 'request.status.label', default: 'Status')}"/>

        </tr>
        </thead>
        <tbody>
        <g:each in="${requestInstanceList}" status="i" var="requestInstance">
            <tr class="${(i % 2) == 0 ? 'even' : 'odd'}">

                <td><g:link action="show"
                            id="${requestInstance.id}">${fieldValue(bean: requestInstance, field: "date")}</g:link></td>

                <td>${fieldValue(bean: requestInstance, field: "dest")}</td>

                <td>${fieldValue(bean: requestInstance, field: "src")}</td>

                <td>${fieldValue(bean: requestInstance, field: "status")}</td>

            </tr>
        </g:each>
        </tbody>
    </table>

    <div class="pagination">
        <g:paginate total="${requestInstanceTotal}"/>
    </div>
</div>
</body>
</html>
