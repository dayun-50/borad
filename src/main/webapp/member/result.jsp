<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>회원가입 결과</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body {
            background-color: #f8f9fa;
            text-align: center;
            margin-top: 100px;
        }
        .message-box {
            max-width: 400px;
            margin: 0 auto;
            padding: 30px;
            background-color: white;
            border: 3px solid #add8e6;
            border-radius: 15px;
        }
    </style>
</head>
<body>
    <div class="message-box">
        <h4>회원가입 결과</h4>
        <p>${message}</p>
        <button class="btn btn-primary" onclick="location.href='/index.jsp'">로그인 페이지로 이동</button>
    </div>
</body>
</html>
