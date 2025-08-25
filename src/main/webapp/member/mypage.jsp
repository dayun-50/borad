<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    >
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<table>
		<tr>
			<th>
				ID
			</th>
			<th>
				NAME
			</th>
			
			<th>
				PHONE
			</th>
			
			<th>
				EMAIL
			</th>
			
			<th>
				JOIN_DATE
			</th>
		</tr>
		
		<c:forEach var="i" items="${list}">
			<tr>
				<td>${i.id } </td>
				<td>${i.name } </td>
				<td>${i.phone } </td>
				<td>${i.email } </td>
				<td>${i.join_date } </td>
			</tr>	
		</c:forEach>
	</table>
	
</body>
</html>