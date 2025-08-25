<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>Index</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/css/bootstrap.min.css"
	rel="stylesheet" />

<style>
/* 간단 스타일 */
.container {
	max-width: 500px;
	margin: 100px auto;
	padding: 30px;
	border: 3px solid #add8e6;
	border-radius: 15px;
	background: white;
}

h4 {
	font-weight: bold;
	color: navy;
	font-size: 32px;
}

.btn {
	white-space: nowrap;
}
</style>
</head>
<body>

	<c:choose>
		<c:when test="${not empty sessionScope.loginId}">
			<div class="container text-center">
				<h2>${sessionScope.loginId}님,안녕하세요!</h2>
				<div class="d-flex justify-content-center gap-2 mt-3">
					<form action="${pageContext.request.contextPath}/logout.member"
						method="post" id="logoutForm" class="d-flex m-0">
						<button type="submit" class="btn btn-outline-primary"
							name="action" value="logout">로그아웃</button>
					</form>
					<a href="${pageContext.request.contextPath}/mypage.member"
						class="btn btn-outline-primary">마이페이지</a>
					<button type="button" class="btn btn-outline-danger"
						id="withdrawBtn">회원탈퇴</button>
					<a href="${pageContext.request.contextPath}/freeBoard.board"
						class="btn btn-primary">자유게시판</a>
				</div>
			</div>

			<script>
				document.getElementById('withdrawBtn').addEventListener(
						'click',
						function(e) {
							e.preventDefault();
							if (confirm('정말 탈퇴하시겠습니까?')) {
								let form = document
										.getElementById('logoutForm');
								let input = form
										.querySelector('input[name="action"]');
								if (!input) {
									input = document.createElement('input');
									input.type = 'hidden';
									input.name = 'action';
									form.appendChild(input);
								}
								input.value = 'withdraw';
								form.submit();
							}
						});
			</script>

		</c:when>
		<c:otherwise>
			<div class="container">
				<form method="post"
					action="${pageContext.request.contextPath}/login.member">
					<div class="text-center mb-4">
						<h4>Login Box</h4>
					</div>
					<div class="mb-3">
						<label for="inp1" class="form-label">아이디</label> 
						<input
							type="text" id="inp1" class="form-control"
							placeholder="ID를 입력하세요" name="id" autocomplete="username"
							required />
					</div>
					<div class="mb-4">
						<label for="inp2" class="form-label">비밀번호</label> <input
							type="password" id="inp2" class="form-control"
							placeholder="비밀번호를 입력하세요" name="pw"
							autocomplete="current-password" required />
					</div>
					<div class="d-flex justify-content-center mb-3">
						<button type="submit" class="btn btn-primary me-2">로그인</button>
						<a href="${pageContext.request.contextPath}/accession.member"
							class="btn btn-outline-primary">회원가입</a>
					</div>
					<div class="form-check d-flex justify-content-center">
						<input class="form-check-input me-2" type="checkbox"
							id="rememberId" name="remember" /> <label
							class="form-check-label" for="rememberId">ID 기억하기</label>
					</div>
				</form>
			</div>
		</c:otherwise>
	</c:choose>

</body>
</html>
