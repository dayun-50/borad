<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<title>ID 중복 확인</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/css/bootstrap.min.css" rel="stylesheet" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/js/bootstrap.bundle.min.js"></script>
<style>
    body {
        padding: 20px;
        background-color: #f8f9fa;
    }
    .btn {
        width: 100px;
    }
</style>
</head>
<body>
    <c:choose>
        <c:when test="${result == false}">
            <div class="card text-center">
                <div class="card-header">ID 중복확인</div>
                <div class="card-body">
                    <h5 class="card-title text-primary fw-bold">사용할 수 있는 ID입니다.</h5>
                    <p class="card-text">입력하신 ID를 사용하시겠습니까?</p>
                    <button class="btn btn-primary" onclick="useId()">확인</button>
                    <button class="btn btn-outline-primary" onclick="window.close()">취소</button>
                </div>
            </div>
        </c:when>
        <c:when test="${result == true}">
            <div class="card text-center">
                <div class="card-header">ID 중복확인</div>
                <div class="card-body">
                    <h5 class="card-title text-danger fw-bold">사용할 수 없는 ID입니다.</h5>
                    <p class="card-text">다른 ID를 입력해주세요.</p>
                    <button class="btn btn-primary" onclick="window.close()">확인</button>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <script>
                alert("잘못된 접근입니다.");
                window.close();
            </script>
        </c:otherwise>
    </c:choose>

    <script>
        function useId() {
            // 부모창의 ID 입력란에 값 넣고 팝업 닫기
            opener.document.getElementById('id').value = opener.document.getElementById('id').value.trim();
            window.close();
        }
    </script>
</body>
</html>
