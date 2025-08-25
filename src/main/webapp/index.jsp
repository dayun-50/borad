<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>



<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Login Box</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<style>
.container {
	width: 400px;
	border: 1px solid rgb(62, 139, 255);
	border-radius: 10px;
	padding: 10px;
	margin: auto;
}

.container>div, .container form>div {
	display: flex;
	justify-content: center;
	padding: 2px;
}

.title {
	width: 100%;
	color: rgb(62, 139, 255);
	font-size: 25px;
}

.idblock, .pwblock {
	width: 100%;
}

.idtxt, .pwtxt {
	width: 20%;
	text-align: right;
	margin-right: 10px;
}

.btnbox {
	display: flex;
	justify-content: center;
	gap: 10px;
	margin-top: 5px;
}

.submitblockbtn1 {
	width: 55px;
	height: 25px;
	background-color: rgb(114, 114, 255);
	color: white;
	border: 1px solid rgb(114, 114, 255);
	cursor: pointer;
}

.submitblockbtn2 {
	width: 70px;
	height: 25px;
	background-color: white;
	color: rgb(114, 114, 255);
	border: 1px solid rgb(114, 114, 255);
	cursor: pointer;
}

</style>
</head>
<!-- el에다 key를 넣으면 value가 나온다. 
이 값이 null이면 로그인을 안한 상태.-->
<body>

	<c:choose>
		<c:when test="${loginId==null}">

			<div class="container">
				<div class="title">Login Box</div>

				<form method="post">
					<div class="idblock">
						<div class="idtxt">아이디</div>
						<div class="idtype">
							<input type="text" name="id" placeholder="ID">
						</div>
					</div>

					<div class="pwblock">
						<div class="pwtxt">비밀번호</div>
						<div>
							<input type="password" name="pw" placeholder="PW">
						</div>
					</div>

					<div class="btnbox">
						<button type="submit" formaction="/login.member"
							formmethod="post" class="submitblockbtn1">로그인</button>
						<button type="submit" formaction="/accession.member"
							formmethod="get" class="submitblockbtn2">회원가입</button>
					</div>

					<div>
						<label><input type="checkbox" name="rememberId">ID기억하기</label>
					</div>
				</form>
			</div>
		</c:when>

		<c:otherwise>

			<table border="1">
				<tr>
					<th colspan="4">${loginId}님안녕하세요.</th>
				</tr>
				<tr>
					<td id="ang">
						<form action="/boardMain.BoardControllers" method="get" style="display:inline;">
							<button>회원게시판</button>
						</form>
					</td>
					<td><a href="/mypage.MembersController"><button>마이페이지</button></a>
					</td>
					<td><a href="/logout.MembersController"><button>로그아웃</button></a>
					</td>
					<td>
						<form id="deleteForm" action="/logout.member"
							method="post">
							<button type="button" id="deletememberbtn">회원탈퇴</button>
						</form>
					</td>
				</tr>
			</table>
			${mypage}님안녕하세요.
			<c:choose>
				<c:when test="${mypage=='true'}">
					<c:forEach var="i" items="${list}">
						<table border="1px">
							<tr>
								<th>ID</th>
								<th>NAME</th>
								<th>PHONE</th>
								<th>EMAIL</th>
								<th>zip_code</th>
								<th>address1</th>
								<th>address2</th>
								<th>JOIN_DATE</th>
								<th></th>
								<th></th>
							</tr>

							<tr>
								<td>${i.id}</td>
								<td>${i.name}</td>
								
								<form action="/updatedata.MembersController" method="get">
								<td><input readonly type=text id="phone" name="phone" value="${i.phone}"></td>
								<td><input readonly type=text id="email" name="email" value="${i.email}"></td>
									<td><input readonly type=text id="zipcode" name="zipcode" value="${i.zipcode}"></td>
								<td><input readonly type=text id="address1" name="address1" value="${i.address1}"></td>
								<td><input readonly type=text id="address2" name="address2" value="${i.address2}"></td>
								<td>"${i.join_date}"</td>
								<td id="updatebtn">
									<button type="button" id="updatebtn">수정하기</button>
								</td>
								
								<td id="backtd">
									
										<button type="button" id="backbtn">뒤로가기</button>
									
								</td>
								<td id="updatecleartd">
										<button type="submit" style=" display: none;" id="updateclearbtn">수정완료</button>
								</td>
								</form>

							</tr>
						</table>
						
						<script>
						$("#updatebtn").click(function() {
						    $("#phone").removeAttr("readonly");
						    $("#email").removeAttr("readonly");
						    $("#zipcode").removeAttr("readonly");
						    $("#address1").removeAttr("readonly");
						    $("#address2").removeAttr("readonly");
						    	
						    $(this).hide();
						    $("#backbtn").hide();
						    $("#updateclearbtn").show();
						  });
						
						$("#updateclearbtn").click(function() {
						    $("#phone").attr("readonly",true);
						    $("#email").attr("readonly",true);
						    $("#zipcode").attr("readonly",true);
						    $("#address1").attr("readonly",true);
						    $("#address2").attr("readonly",true);
						    $(this).hide();
						    $("#backbtn").show();
						    $("#updatebtn").show();
						  });
						</script>
					</c:forEach>
				</c:when>
			</c:choose>
			<script>
				
				function deleteMember() {
					 document.getElementById('deleteForm').submit();
				}
				
				$("#deletememberbtn").on("click",	function() {
					window.open("/deletecheck.MembersController?id=${loginId}", "", "width=300,height=200");
				});
				
				$(function(){ // == doucment.onload 페이지에관련된 모든 코드가 끝날때 실행됨
					$.ajax({
						
					});
				})
			</script>
		</c:otherwise>
	</c:choose>




</body>

</html>