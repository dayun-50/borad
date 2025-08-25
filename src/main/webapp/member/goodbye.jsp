<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>회원 탈퇴 완료</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body>
<div class="container text-center" style="margin-top: 100px;">
    <h2>회원 탈퇴가 정상적으로 처리되었습니다.</h2>
    <p>그동안 이용해 주셔서 감사합니다.</p>
    <a href="<%=request.getContextPath()%>/index.jsp" class="btn btn-primary mt-4">메인 페이지로 돌아가기</a>
</div>
</body>
</html>