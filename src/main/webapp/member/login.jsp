<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>로그인</title>
</head>
<body>
    <h2>로그인</h2>
    <form action="${pageContext.request.contextPath}/login.member" method="post">
        <label>ID:</label>
        <input type="text" name="id" required><br>
        <label>PW:</label>
        <input type="password" name="pw" required><br>
        <button type="submit">로그인</button>
    </form>
</body>
</html>