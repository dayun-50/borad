<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<style>
table {
	border-collapse: collapse;
	width: 100%;
	text-align: center;
}

th, td {
	border: 1px solid #000;
	padding: 5px;
}

.title {
	width: 60%;
	text-align: left;
}

.no-content {
	height: 200px;
	text-align: center;
	vertical-align: middle;
	color: gray;
}

.pagination {
	text-align: center;
	padding: 10px 0;
}

.btn-write {
	float: right;
	margin-top: 5px;
	padding: 5px 10px;
	cursor: pointer;
	margin-left: 5px;
}
</style>

</head>
<body>
	<c:choose>

		<c:when test="${result}">

			<table>
				<tr>
					<th></th>
					<th>제목</th>
					<th>작성자</th>
					<th>날짜</th>
					<th>조회</th>

				</tr>
				<c:forEach var="i" items="${list }">
					<tr>
						<td>${i.seq }</td>
						<td><a href="/detail.BoardControllers?seq=${i.seq}">${i.title }</a></td>
						<td>${i.writer }</td>
						<td>${i.write_date }</td>
						<td>${i.view_count }</td>
					</tr>
				</c:forEach>
			</table>

			<div class="pagination" id="pageNavi"></div>

			<form action="/write.BoardControllers" method="get">
				<button class="btn-write">글 작성하기</button>
			</form>
			<form action="/mypage.MembersController" method="get">
				<button class="btn-write">뒤로가기</button>
			</form>
		</c:when>

		<c:otherwise>
			<h3 style="text-align: center;">자유게시판</h3>

			<table>
				<tr>
					<th></th>
					<th>제목</th>
					<th>작성자</th>
					<th>날짜</th>
					<th>조회</th>
				</tr>
				<tr>
					<td colspan="5" class="no-content">표시할 내용이 없습니다.</td>
				</tr>
			</table>

			<div class="pagination" id="pageNavi"></div>

			<form action="/write.BoardControllers" method="get">
				<button class="btn-write">글 작성하기</button>
			</form>
			<form action="/mypage.MembersController" method="get">
				<button class="btn-write">뒤로가기</button>
			</form>
		</c:otherwise>

	</c:choose>

	<script>
		let recordTotalCount = parseInt("${recordTotalCount}");
		let recordCountPerPage = parseInt("${recordCountPerPage}");
		let naviCountPerPage = parseInt("${naviCountPerPage}");
		let currentPage = parseInt("${currentPage}");

		let pageTotalCount = Math.ceil(recordTotalCount / recordCountPerPage);
		if(currentPage < 1) {
			currentPage=1;
		}else if(currentPage > pageTotalCount) {
			currentPage = pageTotalCount;
		}
		
		let startNavi = Math.floor((currentPage - 1) / naviCountPerPage)
				* naviCountPerPage + 1;
		
		let endNavi = startNavi + (naviCountPerPage - 1);
		if (endNavi > pageTotalCount)
			endNavi = pageTotalCount;

		let html = "";
		let needPrev = true;
		let needNext = true;
		
		if(startNavi == 1) {needPrev = false;}
		if(endNavi == pageTotalCount) {needNext = false;}

		if (needPrev) {
			html += "<a href='/boardMain.BoardControllers?cpage=" + (startNavi - 1) + "'>< </a>";
	      }

	      for (let i = startNavi; i <= endNavi; i++) {
	    	  html += "<a href='/boardMain.BoardControllers?cpage=" + i + "'>" + i + "</a> ";
	      }

	      if (needNext) {
	    	  html += "<a href='/boardMain.BoardControllers?cpage=" + (endNavi + 1) + "'>> </a>";
	      }
	    
		document.getElementById("pageNavi").innerHTML = html;
	</script>
</body>
</html>