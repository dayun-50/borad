<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>마이페이지</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/css/bootstrap.min.css" rel="stylesheet" />
<!-- 다음 주소찾기 API -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<style>
.container {
    max-width: 600px;
    margin: 100px auto;
    padding: 30px;
    border: 3px solid #add8e6;
    border-radius: 15px;
    background-color: #fff;
}
h2 {
    color: navy;
    font-weight: bold;
    margin-bottom: 30px;
    text-align: center;
}
.label-title {
    font-weight: 700;
    color: #003366;
}
.value {
    font-size: 1.1rem;
}
.edit-mode {
    display: none;
}
.view-mode {
    display: inline;
}
</style>
</head>
<body>
<div class="container">
    <h2>마이페이지 - 회원 정보</h2>

    <form action="${pageContext.request.contextPath}/logout.member" method="post" id="memberForm" onsubmit="return validateForm()">
        <input type="hidden" name="action" value="update">
        <input type="hidden" name="id" value="${member.id}">

        <dl class="row">
            <dt class="col-sm-3 label-title">아이디</dt>
            <dd class="col-sm-9 value">${member.id}</dd>

            <dt class="col-sm-3 label-title">이름</dt>
            <dd class="col-sm-9 value">
                <span class="view-mode">${member.name}</span>
                <input type="text" name="name" value="${member.name}" class="form-control edit-mode">
            </dd>

            <dt class="col-sm-3 label-title">전화번호</dt>
            <dd class="col-sm-9 value">
                <span class="view-mode">${member.phone}</span>
                <input type="text" name="phone" value="${member.phone}" class="form-control edit-mode" placeholder="예: 010-1234-5678 또는 01012345678">
            </dd>

            <dt class="col-sm-3 label-title">이메일</dt>
            <dd class="col-sm-9 value">
                <span class="view-mode">${member.email}</span>
                <input type="email" name="email" value="${member.email}" class="form-control edit-mode" placeholder="예: example@example.com">
            </dd>

            <!-- 비밀번호는 처음엔 안보임, 수정 모드일 때만 나타남 -->
            <dt class="col-sm-3 label-title edit-mode">비밀번호</dt>
            <dd class="col-sm-9 value edit-mode">
                <input type="password" name="pw" class="form-control" placeholder="변경할 비밀번호 입력">
            </dd>

            <dt class="col-sm-3 label-title edit-mode">비밀번호 확인</dt>
            <dd class="col-sm-9 value edit-mode">
                <input type="password" name="pwConfirm" class="form-control" placeholder="비밀번호 확인 입력">
            </dd>

            <dt class="col-sm-3 label-title">우편번호</dt>
            <dd class="col-sm-9 value">
                <span class="view-mode" id="addrZipcodeView">${member.zipcode}</span>
                <div class="edit-mode">
                    <div class="input-group" style="max-width: 250px;">
                        <input type="text" id="zipcode" name="zipcode" value="${member.zipcode}" class="form-control">
                        <button type="button" class="btn btn-secondary" id="btnPostcode">주소 찾기</button>
                    </div>
                </div>
            </dd>

            <dt class="col-sm-3 label-title">주소</dt>
            <dd class="col-sm-9 value">
                <span class="view-mode">${member.address1} ${member.address2}</span>
                <div class="edit-mode">
                    <input type="text" name="address1" value="${member.address1}" class="form-control mb-2">
                    <input type="text" name="address2" value="${member.address2}" class="form-control">
                </div>
            </dd>

            <dt class="col-sm-3 label-title">가입일</dt>
            <dd class="col-sm-9 value">${member.join_date}</dd>
        </dl>

        <div class="text-center mt-4">
            <button type="button" id="editBtn" class="btn btn-warning">수정하기</button>
            <button type="submit" id="saveBtn" class="btn btn-success" style="display:none;">저장</button>
            <button type="button" id="cancelBtn" class="btn btn-secondary" style="display:none;">취소</button>
            <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-primary">뒤로가기</a>
        </div>
    </form>
</div>

<script>
// 수정 모드 토글
document.getElementById("editBtn").onclick = function() {
    document.querySelectorAll(".view-mode").forEach(el => el.style.display = "none");
    document.querySelectorAll(".edit-mode").forEach(el => el.style.display = "block");
    document.getElementById("editBtn").style.display = "none";
    document.getElementById("saveBtn").style.display = "inline-block";
    document.getElementById("cancelBtn").style.display = "inline-block";
};

// 취소 시 다시 원복
document.getElementById("cancelBtn").onclick = function() {
    document.querySelectorAll(".view-mode").forEach(el => el.style.display = "inline");
    document.querySelectorAll(".edit-mode").forEach(el => el.style.display = "none");
    document.getElementById("editBtn").style.display = "inline-block";
    document.getElementById("saveBtn").style.display = "none";
    document.getElementById("cancelBtn").style.display = "none";
};

// 다음 우편번호 찾기 API 호출
document.getElementById("btnPostcode").onclick = function() {
    new daum.Postcode({
        oncomplete: function(data) {
            // 우편번호 입력란, 보여주는 곳, 주소 입력란에 값 세팅
            document.getElementById('zipcode').value = data.zonecode;
            document.getElementById('addrZipcodeView').textContent = data.zonecode;
            document.querySelector('input[name="address1"]').value = data.roadAddress;
            // 상세주소(address2)는 사용자가 직접 입력
        }
    }).open();
};

// 유효성 검사 함수
function validateForm() {
    const pw = document.querySelector('input[name="pw"]').value;
    const pwConfirm = document.querySelector('input[name="pwConfirm"]').value;
    const email = document.querySelector('input[name="email"]').value.trim();
    const phone = document.querySelector('input[name="phone"]').value.trim();
    
    // 하이픈 제거한 순수 숫자만 체크
    const phoneClean = phone.replace(/-/g, '');
    const phoneRegex = /^\d{10,11}$/;
    if (!phoneRegex.test(phoneClean)) {
        alert("전화번호 형식이 올바르지 않습니다. 숫자 10~11자리로 입력하세요. 예: 010-1234-5678 또는 01012345678");
        return false;
    }

    // 비밀번호가 입력된 경우에만 검사 (변경할 때만)
    if (pw.length > 0) {
        const pwRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$/;
        if (!pwRegex.test(pw)) {
            alert("비밀번호는 8자 이상이며, 대문자, 소문자, 숫자, 특수문자를 각각 1개 이상 포함해야 합니다.");
            return false;
        }
        if (pw !== pwConfirm) {
            alert("비밀번호와 비밀번호 확인이 일치하지 않습니다.");
            return false;
        }
    }

    // 이메일 검사: 입력했을 때만 검사
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
