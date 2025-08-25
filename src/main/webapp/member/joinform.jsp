<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>회원가입 폼</title>
<script
	src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"
	integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo="
	crossorigin="anonymous"></script>
<style>
* {
	box-sizing: border-box;
}

body {
	font-family: sans-serif;
}

.container {
	width: 400px;
	border: 1px solid rgb(62, 139, 255);
	border-radius: 10px;
	margin: auto;
	overflow: hidden;
}

.title {
	background-color: rgb(62, 139, 255);
	color: white;
	text-align: center;
	padding: 10px 0;
	font-size: 16px;
}

.row {
	display: flex;
	align-items: center;
	padding: 6px 15px;
	gap: 10px;
}

.row label {
	width: 80px;
	text-align: right;
	font-size: 14px;
}

.row input[type="text"] {
	flex: 1;
	height: 30px;
	padding: 4px 6px;
}

.row button {
	height: 30px;
	padding: 0 10px;
	font-size: 13px;
	cursor: pointer;
}

.submitblock {
	display: flex;
	justify-content: center;
	gap: 10px;
	padding: 10px 0;
}

.submitblock button {
	width: 100px;
	height: 30px;
	border-radius: 4px;
	font-size: 13px;
}

.submitblock .join-btn {
	background-color: rgb(114, 114, 255);
	color: white;
	border: none;
}

.submitblock .reset-btn {
	background-color: white;
	color: rgb(114, 114, 255);
	border: 1px solid rgb(114, 114, 255);
}
</style>
</head>

<body>

	<div class="container">
		<div class="title">회원 가입 정보 입력</div>
		<form action="/AddMember.MembersController" id="registerform"
			method="post">
			<div class="row">
				<label for="id">ID</label> <input type="text" id="id" name="id"
					placeholder="아이디를 입력하세요">
				<button type="button" id="duplcheck">중복확인</button>
			</div>

			<div class="row">
				<label for="pw">PW</label> <input type="text" id="pw" name="pw"
					placeholder="비밀번호를 입력하세요">
			</div>

			<div class="row">
				<label for="pwcheck">PW 확인</label> <input type="text" id="pwcheck"
					placeholder="비밀번호를 다시 입력하세요">
			</div>

			<div class="row">
				<label for="name">이름</label> <input type="text" id="name"
					name="name" placeholder="이름을 입력하세요">
			</div>

			<div class="row">
				<label for="tel">전화번호</label> <input type="text" id="tel" name="tel"
					placeholder="전화번호를 입력하세요 (예: 010-1234-1234)">
			</div>

			<div class="row">
				<label for="email">이메일</label> <input type="text" id="email"
					name="email" placeholder="이메일을 입력하세요">
			</div>

			<div class="row">
				<label for="zipcode">우편번호</label> <input type="text" id="zipcode"
					placeholder="우편번호" readonly>
				<button type="button" id="addressSearch">찾기</button>
			</div>

			<div class="row">
				<label for="addr">주소</label> <input type="text" id="addr"
					placeholder="주소를 입력하세요">
			</div>

			<div class="row">
				<label for="addrDetail">상세주소</label> <input type="text"
					id="addrDetail" placeholder="상세주소를 입력하세요">
			</div>

			<div class="submitblock">
				<button type="submit" class="join-btn">회원가입</button>
				<button type="reset" class="reset-btn">다시입력</button>
			</div>
		</form>

	</div>
	<script>
		let isDuplicateChecked = false;

		function setDuplicateCheckTrue() {
			isDuplicateChecked = true;
		}

		document.getElementById("addressSearch").onclick = function() {

			let post = new daum.Postcode({
				oncomplete : function(data) {
					let zipcode = document.getElementById("zipcode");
					zipcode.value = data.zonecode;
				}
			})

			post.open();
		}
		$("#id").on("keydown", function(e) {
			isDuplicateChecked = false; // 기본 제출 막기
		    // 검증 후 서버로 전송 등
		});
		$("#duplcheck").on("click",	function() {

					let id = $("#id").val();
					const idRegex = /^[a-z0-9_]{4,12}$/;
					
					if (!id) {
						alert("id를 입력해주세요");
						return false;
					}
					if (!idRegex.test(id)) {
						alert("아이디는 4-12자의 영문 소문자, 숫자, _만 가능합니다.");
						document.getElementById("id").focus();
						return false;
					}
					
					setDuplicateCheckTrue();
					//            	window.open("URL", "0", "옵션(팝업창 크기,위치 등등) (사이즈 안주면 tab으로됨)");

					//window.open("/idcheck.MembersController?id="
							//+ $("#id").val(), "", "width=300,height=200");
					//jsp를 요청하는게 아니라 servlet을 요청한다.
					
					$.ajax({ //아이디 팝업창으로 중복확인하게바꿈 ㅇㅇ
						url:"/idcheck.MembersController",
						data:{id:$("#id").val()},
						success:function(reps){
							if(reps == "true"){
								alert("사용중인 ID입니다.");
							}else if(reps == "false"){
								alert("사용가능한 ID입니다.");
							}
						}
					});
		})

		document.getElementById("registerform").onsubmit = function() {

			if (!isDuplicateChecked) {
				alert("아이디 중복을 확인해주세요.");
				return false;
			}

			let id = $("#id").val();
			let pw = $("#pw").val();
			let pwcheck = $("#pwcheck").val();
			let name = $("#name").val();
			let tel = $("#tel").val();
			let email = $("#email").val();

			const idRegex = /^[a-z0-9_]{4,12}$/;
			const pwRegex = /^[a-zA-Z0-9!@#$%^&*]{8,16}$/;
			const nameRegex = /^[a-zA-Z가-힣]{2,6}$/;
			const emailRegex = /^[A-Za-z\d]{4,12}@[\w]{4,12}((\.com)|(\.co\.kr))$/;
			const telregex = /^010(-?[0-9]{4}){2}$/;

			if (!id) {
				alert("아이디를 입력해주세요.");
				document.getElementById("id").focus();
				return false;
			}
			if (!idRegex.test(id)) {
				alert("아이디는 4-12자의 영문 소문자, 숫자, _만 가능합니다.");
				document.getElementById("id").focus();
				return false;
			}

			// Password validation
			if (!pw) {
				alert("패스워드를 입력해주세요.");
				document.getElementById("pw").focus();
				return false;
			}
			if (!pwRegex.test(pw)) {
				alert("패스워드는 8-16자의 영문, 숫자, 특수문자(!@#$%^&*)만 가능합니다.");
				document.getElementById("pw").focus();
				return false;
			}

			if (!/[a-zA-Z]/.test(pw)) {
				alert("패스워드는 적어도 하나의 영문자를 포함해야 합니다.");
				document.getElementById("pw").focus();
				return false;
			}
			if (!/\d/.test(pw)) {
				alert("패스워드는 적어도 하나의 숫자를 포함해야 합니다.");
				document.getElementById("pw").focus();
				return false;
			}
			if (!/[!@#$%^&*]/.test(pw)) {
				alert("패스워드는 적어도 하나의 특수문자(!@#$%^&*)를 포함해야 합니다.");
				document.getElementById("pw").focus();
				return false;
			}

			if (!pwcheck) {
				alert("패스워드 확인을 입력해주세요.");
				document.getElementById("pwcheck").focus();
				return false;
			}
			if (pw != pwcheck) {
				alert("패스워드와 패스워드 확인이 일치하지 않습니다.");
				document.getElementById("pwcheck").focus();
				return false;
			}

			if (!name) {
				alert("이름을 입력해주세요.");
				document.getElementById("name").focus();
				return false;
			}
			if (!nameRegex.test(name)) {
				alert("이름은 2-20자의 한글 또는 영문만 가능합니다.");
				document.getElementById("name").focus();
				return false;
			}

			if (!tel) {
				alert("전화번호를 입력해주세요.");
				document.getElementById("tel").focus();
				return false;
			}
			if (!telregex.test(tel)) {

				alert("잘못된 전화번호입니다.");
				document.getElementById("tel").focus();
				return false;
			}

			if (!email) {
				alert("이메일을 입력해주세요.");
				document.getElementById("email").focus();
				return false;
			}
			if (!emailRegex.test(email)) {
				alert("유효한 이메일 형식을 입력해주세요.");
				document.getElementById("email").focus();
				return false;
			}

			return true;
		}
	</script>
</body>

</html>