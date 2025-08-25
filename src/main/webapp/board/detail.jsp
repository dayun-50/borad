<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 상세</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<style>
#container {
	width: 500px;
	min-height: 520px;
	border: 1px solid #ddd;
	border-radius: 8px;
	padding: 20px;
	box-sizing: border-box;
	background-color: #fafafa;
	font-family: '맑은 고딕', sans-serif;
	color: #333;
	margin: 40px auto;
}

.post-title {
	font-size: 22px;
	font-weight: 700;
	margin-bottom: 5px;
	color: #222;
}

.post-meta {
	font-size: 13px;
	color: #666;
	margin-bottom: 15px;
	line-height: 1.4;
}

.post-content {
	font-size: 16px;
	white-space: pre-wrap;
	min-height: 320px;
	margin-bottom: 20px;
}

#commentArea {
	margin-top: 20px;
	border-top: 1px solid #ddd;
	padding-top: 10px;
}

#commentArea form {
	display: flex;
	gap: 10px;
}

#commentArea input[type="text"] {
	flex: 1;
	padding: 8px;
	font-size: 14px;
	border: 1px solid #ccc;
	border-radius: 4px;
}

#commentArea button[type="submit"] {
	padding: 8px 15px;
	font-size: 14px;
	border-radius: 4px;
	background-color: #3a3a3a;
	color: white;
	border: none;
	cursor: pointer;
	transition: background-color 0.3s ease;
}

#commentArea button[type="submit"]:hover {
	background-color: #5a5a5a;
}

/* 버튼 그룹 수정 */
.btn-group {
	display: flex;
	gap: 12px;
	justify-content: flex-end; /* 오른쪽 정렬 */
	margin-top: 20px; /* 본문과 간격 */
}

.btn {
	padding: 10px 18px;
	background-color: #3a3a3a;
	color: white;
	border: none;
	border-radius: 6px;
	cursor: pointer;
	font-weight: 600;
	font-size: 14px;
	box-shadow: 0 2px 6px rgba(0, 0, 0, 0.25);
	transition: background-color 0.3s ease;
}

.btn:hover {
	background-color: #5a5a5a;
}

#editArea input[type="text"], #editArea textarea {
	width: 100%;
	font-size: 16px;
	padding: 8px;
	box-sizing: border-box;
	border-radius: 4px;
	border: 1px solid #ccc;
	margin-bottom: 10px;
	font-family: '맑은 고딕', sans-serif;
}

#editArea textarea {
	height: 300px;
	white-space: pre-wrap;
	resize: vertical;
}

#editArea .btn-group {
	justify-content: flex-start;
	margin-top: 20px;
}

#commentList {
	margin-top: 20px;
	border-top: 1px solid #ddd;
	padding-top: 15px;
}

.comment-items {
	list-style: none;
	padding: 0;
	margin: 0;
}

.comment-item {
	padding: 10px 0;
	border-bottom: 1px solid #eee;
	font-size: 14px;
}

.comment-writer {
	font-weight: 600;
	color: #555;
}

.comment-date {
	font-size: 12px;
	color: #999;
	margin-bottom: 5px;
}

.comment-content {
	white-space: pre-wrap; /* 줄바꿈 유지 */
	color: #333;
}
</style>
</head>
<body>
	<c:choose>
		<c:when test="${serch == 1}">
			<div id="container">
				<!-- 읽기 모드 -->
				<div id="readArea">
					<div class="post-title" id="readTitle">${list[0].title}</div>
					<div class="post-meta">
						${list[0].writer}<br> ${list[0].write_date} | ${count}
					</div>
					<hr>
					<div class="post-content" id="readContent">${list[0].contents}</div>


					<div class="btn-group">
						<form action="/boardMain.BoardControllers" method="get"
							style="margin: 0;">
							<button class="btn" type="submit">목록으로</button>
						</form>

						<form action="/delList.BoardControllers" method="get"
							style="margin: 0;">
							<input type="hidden" name="seq" value="${list[0].seq}" />
							<button class="btn" type="submit">삭제</button>
						</form>

						<button class="btn" id="btnEdit" type="button">수정</button>
					</div>




					<div id="commentArea">
						<form id="commentForm" action="/reply.BoardControllers"
							method="post">
							<input type="hidden" name="postSeq" value="${list[0].seq}" /> <input
								type="text" name="comment" placeholder="댓글을 남겨보세요." required />
							<button type="submit">등록</button>
						</form>
					</div>

					<div id="commentList">
						<c:if test="${not empty relist}">
							<ul class="comment-items">
								<c:forEach var="comment" items="${relist}">
									<li class="comment-item">
										<div class="comment-writer">${comment.writer}</div>
										<div class="comment-content aa" id="content-${comment.seq}">${comment.contents}</div>
										<div class="comment-date">${comment.write_date}</div>
										<div class="comment-btn-group" style="margin-top: 5px;">
											<c:if test="${id == comment.writer}">
												<div id="gg">
													<button type="button" class="btn-comment-edit"
														data-comment-id="${comment.seq}">수정</button>
													<form action="/deleteReply.BoardControllers" method="post"
														style="display: inline;">
														<input type="hidden" name="postSeq" value="${list[0].seq}" />
														<input type="hidden" name="replySeq"
															value="${comment.seq}" />
														<button type="submit"
															onclick="return confirm('댓글을 삭제하시겠습니까?');">삭제</button>
													</form>
												</div>
												<form action="/upreply.BoardControllers">
													<input type="hidden" name="replySeq" value="${comment.seq}" />
													<input type="hidden" name="postSeq" value="${list[0].seq}" />
													<input type="hidden" name="comment" class="edit-comment" />
													<div id="dd" style="display: none;">
														<button type="button" class="btn-comment-edit dd"
															data-comment-id="${comment.seq}">수정완료</button>
													</div>
												</form>
											</c:if>
										</div>
									</li>
								</c:forEach>
							</ul>
						</c:if>
						<c:if test="${empty relist}">
							<p>댓글이 없습니다.</p>
						</c:if>
					</div>


				</div>

				<!-- 수정 모드 -->
				<div id="editArea" style="display: none;">
					<form id="editForm" action="/update.BoardControllers" method="post">
						<input type="hidden" name="seq" value="${list[0].seq}" /> <input
							type="text" name="title" id="editTitle" placeholder="제목을 입력하세요" />
						<textarea name="content" id="editContent" placeholder="내용을 입력하세요"></textarea>
						<div class="btn-group">
							<button class="btn" type="submit">수정 완료</button>
							<button class="btn" type="button" id="btnCancel">취소</button>
						</div>
					</form>
				</div>
			</div>

			<script>
				$(function() {
					$('#btnEdit').click(function() {
						$('#editTitle').val($('#readTitle').text().trim());
						$('#editContent').val($('#readContent').text().trim());
						$('#readArea').hide();
						$('#editArea').show();
					});

					$('#btnCancel').click(function() {
						$('#editArea').hide();
						$('#readArea').show();
					});
				});

				$(function() {
				    // 수정 버튼 클릭
				    $(document).on("click", ".btn-comment-edit", function() {
				        var commentId = $(this).data("comment-id");
				        $("#content-" + commentId).attr("contenteditable", true).css({"border":"1px solid #000"});
				        $("#gg").hide();
				        $("#dd").show();
				    });
				    
				    
				    $(document).on("click", ".btn-comment-edit", function(e){
				        e.preventDefault(); // form 제출 잠시 막기
				        var commentId = $(this).data("comment-id");
				        var content = $("#content-" + commentId).html(); // div 내용 가져오기
				        $(this).closest("form").find(".edit-comment").val(content); // hidden input에 값 넣기
				        $(this).closest("form")[0].submit(); // form 제출
				    });
				});	
			</script>
		</c:when>

		<c:otherwise>
			<div id="container">
				<div class="post-title">${list[0].title}</div>
				<div class="post-meta">
					${list[0].writer}<br> ${list[0].write_date} | ${count}
				</div>
				<hr>
				<div class="post-content">${list[0].contents}</div>

				<div class="btn-group" style="margin-top: 20px;">
					<form action="/boardMain.BoardControllers" method="get"
						style="margin: 0;">
						<button class="btn">목록으로</button>
					</form>
				</div>


				<div id="commentArea">
					<form id="commentForm" action="/reply.BoardControllers"
						method="post">
						<input type="hidden" name="postSeq" value="${list[0].seq}" /> <input
							type="text" name="comment" placeholder="댓글을 남겨보세요." required />
						<button type="submit">등록</button>
					</form>
				</div>

				<div id="commentList">
					<c:if test="${not empty relist}">
						<ul class="comment-items">
							<c:forEach var="comment" items="${relist}">
								<li class="comment-item">
									<div class="comment-writer">${comment.writer}</div>
									<div class="comment-content" id="content-${comment.seq}">${comment.contents}</div>
									<div class="comment-date">${comment.write_date}</div>
									<div class="comment-btn-group" style="margin-top: 5px;">
										<c:if test="${id == comment.writer}">
											<button type="button" class="btn-comment-edit"
												data-comment-id="${comment.seq}">수정</button>
											<form action="/deleteReply.BoardControllers" method="post"
												style="display: inline;">
												<input type="hidden" name="postSeq" value="${list[0].seq}" />
												<input type="hidden" name="replySeq" value="${comment.seq}" />
												<button type="submit"
													onclick="return confirm('댓글을 삭제하시겠습니까?');">삭제</button>
											</form>
										</c:if>
									</div>
								</li>
							</c:forEach>
						</ul>
					</c:if>
					<c:if test="${empty relist}">
						<p>댓글이 없습니다.</p>
					</c:if>
				</div>

			</div>
		</c:otherwise>
	</c:choose>
</body>
</html>
