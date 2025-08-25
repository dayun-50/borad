<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head><title>로그인 결과</title></head>
<body>
    <h3>${message}</h3>
    <c:choose>
        <c:when test="${message == '로그인 성공'}">
            <a href="${pageContext.request.contextPath}/index.jsp">메인 페이지로 이동</a>
        </c:when>
        <c:otherwise>
            <a href="${pageContext.request.contextPath}/login.member">다시 로그인</a>
        </c:otherwise>
    </c:choose>
</body>
</html>