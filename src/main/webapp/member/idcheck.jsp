<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>


<!DOCTYPE html>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"
        integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
.container {
	width: 280px;
	height: 150px;
}

.container .text {
	padding-top: 60px;
	width: 100%;
	display: flex;
	justify-content: center;
	text-align: center;
}

.container .btn {
	display: flex;
	justify-content: center;
	width: 100%;
	padding-top: 5px;
}

.container .btn button {
	color: white;
	background-color: rgba(104, 104, 240, 0.664);
	border: 1px solid rgba(104, 104, 240, 0.664);
	margin: 1px;
	border-radius: 5px;
}

.container .btn1 {
	padding-top: 10px;
	display: flex;
	justify-content: center;
	width: 100%;
}

.container .btn1 button {
	color: white;
	background-color: rgba(104, 104, 240, 0.664);
	border: 1px solid rgba(104, 104, 240, 0.664);;
	border-radius: 5px;
}
</style>
</head>
<body>
	<c:choose>
		<c:when test="${result == true}">
			<div class="container">
				<div class="text">사용중인 아이디입니다.</div>
				<div class="btn1">
					<form>
						<button id="okBtn">확인</button>
					</form>
				</div>
			</div>
			<script>
			$("#okBtn").on("click",function(){
				opener.document.getElementById("id").value="";
				opener.setDuplicateCheckTrue();
				window.close();
			});
			</script>
		</c:when>

		<c:when test="${result == false}">
			<div class="container">
				<div class="text">
					사용가능한 아이디입니다.<br> 아이디를 사용하시겠습니까?
				</div>

				<div class="btn">
					<form>
						<button id="okBtn">사용</button>
					</form>
					<form>
						<button id="cancelBtn">취소</button>
					</form>
				</div>
			</div>
			<script>
			$("#okBtn").on("click",function(){
				opener.setDuplicateCheckTrue();
				window.close();
			});

			$("#cancelBtn").on("click",function(){
				opener.document.getElementById("id").value="";
				opener.setDuplicateCheckTrue();
				window.close();
			});
			</script>
		</c:when>
	</c:choose>
</body>
</html>