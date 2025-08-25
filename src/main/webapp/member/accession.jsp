<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>회원가입</title>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/css/bootstrap.min.css" rel="stylesheet" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/js/bootstrap.bundle.min.js"></script>

<style>
body {
	background-color: #f8f9fa;
}

.container {
	max-width: 420px;
	margin: 100px auto;
	padding: 30px;
	border: 3px solid #add8e6;
	border-radius: 15px;
	background-color: #fff;
}

h5 {
	color: #003366;
	font-weight: 700;
	margin-bottom: 30px;
	text-align: center;
	font-size: 1.5rem;
}

.d-flex {
	display: flex;
	align-items: center;
	margin-bottom: 15px;
}

.login-label {
	width: 70px;
	font-weight: 700;
	color: #003366;
	margin-right: 10px;
}

.login-input {
	flex: 1;
	border: 1px solid #ccc;
	border-radius: 6px;
	padding: 8px 10px;
	font-size: 1rem;
}

.login-input::placeholder {
	color: #aaa;
	font-size: 0.9rem;
}

/* 완전한 버튼 border + 포커스 테두리 제거 */
.btn-primary,
.btn-outline-primary {
	border: none !important;
	box-shadow: none !important;
	outline: none !important;
	background-color: #add8e6;
	color: #000;
	font-weight: 700;
	border-radius: 10px;
	transition: background-color 0.3s ease;
}

.btn-primary:hover,
.btn-outline-primary:hover {
	background-color: #93c7f9;
	box-shadow: none !important;
	border: none !important;
	color: #000;
}

.btn-group {
	display: flex;
	justify-content: center;
	gap: 20px;
	margin-top: 25px;
}

.btn-group button {
	width: 120px;
	font-weight: 700;
}

/* Firefox 내부 포커스 테두리 제거 */
button::-moz-focus-inner {
	border: 0 !important;
}


</style>

</head>

<body>
<div class="container">
	<form action="/signup.member" method="post" id="signupForm" onsubmit="return validateForm()">
		<h5>회원 가입 정보 입력</h5>

		<div class="d-flex">
			<label class="login-label" for="id">id</label>
			<input type="text" id="id" name="id" class="form-control login-input" placeholder="아이디를 입력하세요" required />
			<button type="button" class="btn btn-primary ms-2" id="repeat">중복확인</button>
		</div>

		<div class="d-flex">
			<label class="login-label" for="pw">pw</label>
			<input type="password" id="pw" name="pw" class="form-control login-input" placeholder="비밀번호를 입력하세요" required />
		</div>

		<div class="d-flex">
			<label class="login-label" for="pwConfirm">pw 확인</label>
			<input type="password" id="pwConfirm" name="pwConfirm" class="form-control login-input" placeholder="비밀번호를 다시 입력하세요" required />
		</div>

		<div class="d-flex">
			<label class="login-label" for="name">이름</label>
			<input type="text" id="name" name="name" class="form-control login-input" placeholder="이름을 입력하세요" required />
		</div>

		<div class="d-flex">
			<label class="login-label" for="phone">전화번호</label>
			<input type="text" id="phone" name="phone" class="form-control login-input" placeholder="전화번호를 입력하세요(예:010-1234-5678)" required />
		</div>

		<div class="d-flex">
			<label class="login-label" for="email">이메일</label>
			<input type="email" id="email" name="email" class="form-control login-input" placeholder="이메일을 입력하세요" />
		</div>

		<div class="d-flex">
			<label class="login-label" for="zonecode">우편번호</label>
			<input type="text" id="zonecode" name="zipcode" class="form-control login-input" placeholder="우편번호" readonly required />
			<button type="button" class="btn btn-primary ms-2" id="search">찾기</button>
		</div>

		<div class="d-flex">
			<label class="login-label" for="address1">주소</label>
			<input type="text" id="address1" name="address1" class="form-control login-input" placeholder="주소를 입력하세요" readonly required />
		</div>

		<div class="d-flex">
			<label class="login-label" for="address2">상세주소</label>
			<input type="text" id="address2" name="address2" class="form-control login-input" placeholder="상세주소를 입력하세요" />
		</div>

		<div class="btn-group">
			<button type="submit" class="btn btn-primary">회원가입</button>
			<button type="reset" class="btn btn-outline-primary">다시입력</button>
		</div>
	</form>
</div>

<script>
    // Daum 우편번호 찾기
    $("#search").on("click", function (e) {
        e.preventDefault();
        new daum.Postcode({
            oncomplete: function (data) {
                $("#zonecode").val(data.zonecode);
                $("#address1").val(data.roadAddress);
            }
        }).open();
    });

    // ID 중복확인 팝업
    $("#repeat").on("click", function (e) {
        e.preventDefault();
        var id = $("#id").val().trim();
        if (!id) {
            alert("ID를 입력하세요.");
            return;
        }
        window.open("/idcheck.member?id=" + encodeURIComponent(id), "", "width=400,height=200");
    });
	
    // ajax로 하면 패이지 변환 없이 확인 가능
    //$("#repeat").on("click", function(e) {
    //    e.preventDefault();

    //   var id = $("#id").val().trim();
    //    if (!id) {
    //        alert("ID를 입력하세요.");
    //        return;
    //    }

    //    $.ajax({
    //        url: "/idcheck.member",
    //        type: "get",
    //        data: { id: id },
    //        success: function(response) {
                // response는 서버에서 보내는 중복 확인 결과
                // 예: "사용 가능", "이미 존재"
     //           $("#idCheckResult").text(response); // 결과를 보여줄 div
     //       },
     //       error: function() {
     //           alert("서버와 통신 중 오류가 발생했습니다.");
     //       }
     //   });
    //});
    
    // 유효성 검사 함수
    function validateForm() {
        const pw = document.querySelector('input[name="pw"]').value;
        const pwConfirm = document.querySelector('input[name="pwConfirm"]').value;
        const email = document.querySelector('input[name="email"]').value.trim();

        // 비밀번호 검사: 특수문자, 대문자, 소문자, 숫자 각 1개 이상, 최소 8자
        const pwRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$/;
        if (!pwRegex.test(pw)) {
            alert("비밀번호는 8자 이상이며, 대문자, 소문자, 숫자, 특수문자를 각각 1개 이상 포함해야 합니다.");
            return false;
        }

        // 비밀번호 확인 일치 여부
        if (pw !== pwConfirm) {
            alert("비밀번호와 비밀번호 확인이 일치하지 않습니다.");
            return false;
        }

        // 이메일 검사: 입력했을 때만 검사 (빈 문자열이면 통과)
        if (email !== "") {
            const emailRegex = /^[^\s@]+@[^\s@]+\.(com|co\.kr)$/;
            if (!emailRegex.test(email)) {
                alert("이메일 형식이 올바르지 않습니다. (.com 또는 .co.kr로 끝나야 합니다.)");
                return false;
            }
        }

        return true; // 모두 통과하면 제출 허용
    }
</script>

</body>
</html>
