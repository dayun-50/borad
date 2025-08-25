<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>자유게시판</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Nanum+Gothic&display=swap');

        body {
            font-family: 'Nanum Gothic', '맑은 고딕', Malgun Gothic, Arial, sans-serif;   
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            min-height: 100vh;
            align-items: flex-start;
            padding-top: 60px;
        }
        .container {
            background: #ffffffcc; /* 살짝 투명한 흰색 */
            padding: 45px 55px;
            border-radius: 16px;
            box-shadow: 0 8px 28px rgba(135, 206, 235, 0.4);
            width: 700px;
            max-width: 95vw;
            backdrop-filter: saturate(180%) blur(12px);
            border: 2px solid #87CEEB; /* skyblue 테두리 */
        }
        h2 {
            color: #1e90ff; /* DodgerBlue 좀 더 선명한 하늘색 계열 */
            text-align: center;
            margin-bottom: 40px;
            font-weight: 800;
            font-size: 32px;
            text-shadow: 0 1px 4px rgba(135, 206, 235, 0.8); /* 배경 흐림 효과 */
        }
        .btn-group {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-bottom: 35px;
        }
        .btn-write {
            padding: 14px 32px;
            background: linear-gradient(45deg, #7ec8ff, #00bfff);
            color: #fff;
            font-weight: 700;
            font-size: 18px;
            border-radius: 14px;
            text-decoration: none;
            box-shadow: 0 6px 18px rgba(30, 144, 255, 0.6);
            border: none;
            cursor: pointer;
            user-select: none;
            transition: background 0.3s ease, box-shadow 0.3s ease;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            white-space: nowrap;
        }
        .btn-write:hover {
            background: linear-gradient(45deg, #00bfff, #7ec8ff);
            box-shadow: 0 8px 24px rgba(30, 144, 255, 0.9);
        }
        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0 16px;
            box-sizing: border-box;
        }
        thead tr {
            background: linear-gradient(90deg, #87CEEB, #00bfff);
            color: white;
            border-radius: 16px;
            box-shadow: 0 6px 14px rgba(30, 144, 255, 0.5);
        }
        thead th {
            padding: 18px 16px;
            font-weight: 700;
            font-size: 17px;
            border: none;
            text-align: center;
            user-select: none;
        }
        tbody tr {
            background: #f0f9ff;
            transition: background-color 0.3s ease;
            border-radius: 16px;
            box-shadow: 0 3px 10px rgba(135, 206, 235, 0.2);
        }
        tbody tr:hover {
            background-color: #d1eaff;
        }
        tbody td {
            padding: 16px 14px;
            text-align: center;
            font-size: 15.5px;
            color: #164d7a;
            border: none;
            vertical-align: middle;
            word-break: break-word;
            user-select: text;
        }
        tbody td a {
            color: #1e90ff;
            font-weight: 600;
            text-decoration: none;
            transition: color 0.2s ease;
        }
        tbody td a:hover {
            text-decoration: underline;
            color: #007acc;
        }
        .no-data {
            text-align: center;
            color: #5899e2;
            font-style: italic;
            padding: 50px 0;
            font-size: 16px;
            user-select: none;
        }
        /* 페이징 네비게이터 스타일 */
        .pagination {
            display: flex;
            list-style: none;
            padding-left: 0;
            justify-content: center;
            margin-top: 20px;
        }
        .pagination li {
            margin: 0 4px;
        }
        .pagination .page-item.disabled .page-link {
            pointer-events: none;
            color: #adb5bd;
            background-color: #e9ecef;
            border-color: #dee2e6;
        }
        .pagination .page-item.active .page-link {
            z-index: 1;
            color: #fff;
            background-color: #1e90ff;
            border-color: #1e90ff;
        }
        .pagination .page-link {
            position: relative;
            display: block;
            padding: 6px 12px;
            color: #1e90ff;
            background-color: #fff;
            border: 1px solid #dee2e6;
            border-radius: 0.25rem;
            text-decoration: none;
            user-select: none;
        }
        .pagination .page-link:hover {
            color: #0056b3;
            background-color: #e9ecef;
            border-color: #dee2e6;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>자유게시판 목록</h2>
        
        <div class="btn-group">
            <button onclick="history.back()" class="btn-write">돌아가기</button>
            <a href="write.board" class="btn-write">글쓰기</a>
        </div>

        <table>
            <thead>
                <tr>
                    <th>번호</th>
                    <th>제목</th>
                    <th>작성자</th>
                    <th>날짜 / 작성일</th>
                    <th>조회수</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty list}">
                        <c:forEach var="board" items="${list}">
                            <tr>
                                <td>${board.board_seq}</td>
                                <td><a href="detail.board?board_seq=${board.board_seq}">${board.title}</a></td>
                                <td>${board.writer}</td>
                                <td>${board.write_date}</td>
                                <td>${board.view_count}</td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="5" class="no-data">등록된 게시글이 없습니다.</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>

        <!-- 페이징 네비게이터 -->
        <c:if test="${totalPages > 1}">
            <nav aria-label="Page navigation">
                <ul class="pagination">

                    <!-- 이전 페이지 버튼 -->
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <a class="page-link" href="freeBoard.board?page=${currentPage - 1}" aria-label="Previous">
                            <span aria-hidden="true">&laquo;</span>
                        </a>
                    </li>

                    <!-- 페이지 번호들 -->
                    <c:forEach var="i" begin="${startNavi}" end="${endNavi}">
    <li class="page-item ${i == currentPage ? 'active' : ''}">
        <a class="page-link" href="freeBoard.board?page=${i}">${i}</a>
    </li>
</c:forEach>

                    <!-- 다음 페이지 버튼 -->
                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <a class="page-link" href="freeBoard.board?page=${currentPage + 1}" aria-label="Next">
                            <span aria-hidden="true">&raquo;</span>
                        </a>
                    </li>

                </ul>
            </nav>
        </c:if>
    </div>
</body>
</html>