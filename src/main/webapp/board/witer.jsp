<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
table {
	border-collapse: collapse;
	width: 700px;
	margin: 20px auto;
}

th, td {
	border: 1px solid #000;
	padding: 5px;
}

th {
	text-align: center;
}

input[type="text"] {
	width: 100%;
	padding: 5px;
	box-sizing: border-box;
}

textarea {
	width: 100%;
	height: 300px;
	padding: 5px;
	box-sizing: border-box;
	resize: none;
}

.btn-box {
	text-align: right;
	padding: 5px;
}

.btn-box button {
	padding: 5px 10px;
	margin-left: 5px;
	cursor: pointer;
}
</style>
</head>
<body>
	<form action="/insertPost.BoardControllers" method="post">
		<table>
			<tr>
				<th colspan="2">자유게시판 글 작성하기</th>
			</tr>
			<tr>
				<td colspan="2"><input type="text" name="title"
					placeholder="글 제목을 입력하세요."></td>
			</tr>
			<tr>
				<td colspan="2"><textarea name="content"
						placeholder="글 내용을 입력하세요."></textarea></td>
			</tr>
			<tr>
				<td colspan="2" class="btn-box">
					<button type="button" onclick="location.href='/boardMain.BoardControllers'">목록으로</button>
					<button type="submit">작성완료</button>
				</td>
			</tr>
		</table>
	</form>
</body>
</html>