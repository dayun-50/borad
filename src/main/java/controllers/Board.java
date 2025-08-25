package controllers;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import DAO.BoardDAO;
import DAO.CommentDAO;
import DTO.BoardDTO;
import DTO.CommentDTO;

// *.board로 끝나는 모든 요청을 처리하는 서블릿 지정
@WebServlet("*.board")
public class Board extends HttpServlet {

    // 게시글과 댓글 데이터베이스 접근 객체 싱글톤 인스턴스 가져오기
    private BoardDAO dao = BoardDAO.getInstance();
    private CommentDAO commentDao = CommentDAO.getInstance();

    // 한 페이지당 보여줄 게시글 수
    private static final int recordCountPerPage = 5;
    // 페이지 네비게이션에 표시할 페이지 번호 수
    private static final int naviCountPerPage = 5;

    // GET 요청 처리
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 요청 URI에서 contextPath 부분 제거 후 명령어 추출
        String cmd = request.getRequestURI().substring(request.getContextPath().length());

        try {
            switch (cmd) {
                case "/freeBoard.board":          // 게시글 목록 보기
                    listBoards(request, response);
                    break;
                case "/detail.board":             // 게시글 상세 보기 + 댓글 보기
                    showDetail(request, response);
                    break;
                case "/write.board":              // 글쓰기 폼 보여주기
                    showWriteForm(request, response);
                    break;
                case "/edit.board":               // 글 수정 폼 보여주기
                    showEditForm(request, response);
                    break;
                case "/editComment.board":        // 댓글 수정 폼 보여주기
                    showEditCommentForm(request, response);
                    break;
                default:
                    // 알 수 없는 경로일 경우 404 에러 반환
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            // 처리 중 에러 발생 시 에러 메시지 전달 후 에러 페이지로 이동
            request.setAttribute("errorMsg", "게시판 처리 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    // POST 요청 처리
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 요청 URI에서 contextPath 부분 제거 후 명령어 추출
        String cmd = request.getRequestURI().substring(request.getContextPath().length());

        try {
            switch (cmd) {
                case "/write.board":            // 새 글 작성 처리
                    writeBoard(request, response);
                    break;
                case "/edit.board":             // 글 수정 처리
                    editBoard(request, response);
                    break;
                case "/delete.board":           // 글 삭제 처리
                    deleteBoard(request, response);
                    break;
                case "/addComment.board":       // 댓글 등록 처리
                    addComment(request, response);
                    break;
                case "/editComment.board":      // 댓글 수정 처리
                    updateComment(request, response);
                    break;
                case "/deleteComment.board":    // 댓글 삭제 처리
                    deleteComment(request, response);
                    break;
                default:
                    // 알 수 없는 경로일 경우 404 에러 반환
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            // 처리 중 에러 발생 시 에러 메시지 전달 후 에러 페이지로 이동
            request.setAttribute("errorMsg", "게시글 처리 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    // 게시글 목록 보기 메소드
    private void listBoards(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 파라미터로 전달된 현재 페이지 번호
        String pageStr = request.getParameter("page");
        int currentPage = 1; // 기본 페이지는 1페이지

        try {
            if (pageStr != null) currentPage = Integer.parseInt(pageStr);
        } catch (NumberFormatException ignored) {}

        // 전체 게시글 수 조회
        int recordTotalCount = dao.getTotalBoardCount();

        // 전체 페이지 수 계산 (전체 게시글 수 / 한 페이지당 게시글 수)
        int pageTotalCount = (recordTotalCount + recordCountPerPage - 1) / recordCountPerPage;
        if (pageTotalCount == 0) pageTotalCount = 1;

        // 현재 페이지가 전체 페이지 수보다 크거나 작으면 보정
        if (currentPage > pageTotalCount) currentPage = pageTotalCount;
        if (currentPage < 1) currentPage = 1;

        // 현재 페이지에 해당하는 게시글 시작 번호, 끝 번호 계산
        int startRow = (currentPage - 1) * recordCountPerPage + 1;
        int endRow = currentPage * recordCountPerPage;

        // DB에서 해당 페이지 게시글 목록 조회
        List<BoardDTO> list = dao.getBoardsByPage(startRow, endRow);

        // 페이지 네비게이션 시작, 끝 번호 계산
        int startNavi = ((currentPage - 1) / naviCountPerPage) * naviCountPerPage + 1;
        int endNavi = startNavi + naviCountPerPage - 1;
        if (endNavi > pageTotalCount) endNavi = pageTotalCount;

        // 이전, 다음 네비게이션 표시 여부 결정
        boolean needPrev = startNavi > 1;
        boolean needNext = endNavi < pageTotalCount;

        // JSP에 전달할 속성들 세팅
        request.setAttribute("list", list);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", pageTotalCount);
        request.setAttribute("startNavi", startNavi);
        request.setAttribute("endNavi", endNavi);
        request.setAttribute("needPrev", needPrev);
        request.setAttribute("needNext", needNext);

        // 게시판 목록 JSP로 포워드
        request.getRequestDispatcher("/board/freeBoard.jsp").forward(request, response);
    }

    // 게시글 상세보기 + 댓글 목록 불러오기
    private void showDetail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String seqStr = request.getParameter("board_seq");
        if (seqStr == null) {
            // board_seq 파라미터 없으면 게시판 목록으로 리다이렉트
            response.sendRedirect(request.getContextPath() + "/freeBoard.board");
            return;
        }

        int board_seq = Integer.parseInt(seqStr);

        // 조회수 증가
        dao.incrementViewCount(board_seq);

        // 게시글 상세정보 조회
        BoardDTO board = dao.getBoardBySeq(board_seq);
        if (board == null) {
            // 게시글 없으면 에러 페이지로 이동
            request.setAttribute("errorMsg", "존재하지 않는 게시글입니다.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        // 해당 게시글에 달린 댓글 목록 조회
        List<CommentDTO> commentList = commentDao.getCommentsByParentSeq(board_seq);

        // 현재 로그인한 사용자 ID 조회 (세션에서)
        HttpSession session = request.getSession(false);
        String loginId = (session != null) ? (String) session.getAttribute("loginId") : null;

        // JSP에 게시글, 댓글, 로그인ID 전달
        request.setAttribute("board", board);
        request.setAttribute("loginId", loginId);
        request.setAttribute("commentList", commentList);
        request.getRequestDispatcher("/board/detail.jsp").forward(request, response);
    }

    // 글쓰기 화면 보여주기
    private void showWriteForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 로그인 여부 확인 (세션에 loginId가 있어야 함)
        HttpSession session = request.getSession(false);
        String writer = (session != null) ? (String) session.getAttribute("loginId") : null;

        if (writer == null) {
            // 로그인 안 되어있으면 로그인 페이지로 리다이렉트
            response.sendRedirect(request.getContextPath() + "/login.member");
            return;
        }

        // 작성자 정보를 JSP에 전달하고 글쓰기 페이지로 이동
        request.setAttribute("writer", writer);
        request.getRequestDispatcher("/board/write.jsp").forward(request, response);
    }

    // 새 글 작성 처리
    private void writeBoard(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        // 한글 인코딩 설정
        request.setCharacterEncoding("UTF-8");

        // 로그인 여부 확인
        HttpSession session = request.getSession(false);
        String writer = (session != null) ? (String) session.getAttribute("loginId") : null;
        if (writer == null) {
            response.sendRedirect(request.getContextPath() + "/login.member");
            return;
        }

        // 제목, 내용 파라미터 받기
        String title = request.getParameter("title");
        String contents = request.getParameter("contents");

        // 제목 또는 내용이 비어 있으면 오류 메시지 띄우고 다시 글쓰기 페이지
        if (title == null || title.trim().isEmpty() || contents == null || contents.trim().isEmpty()) {
            request.setAttribute("errorMsg", "제목과 내용을 모두 입력하세요.");
            request.getRequestDispatcher("/board/write.jsp").forward(request, response);
            return;
        }

        // DTO 객체 생성 후 데이터 세팅
        BoardDTO board = new BoardDTO();
        board.setWriter(writer.trim());
        board.setTitle(title.trim());
        board.setContents(contents.trim());

        // DB에 게시글 등록 시도
        boolean success = dao.insertBoard(board);

        if (success) {
            // 성공하면 게시글 목록 페이지로 리다이렉트
            response.sendRedirect(request.getContextPath() + "/freeBoard.board");
        } else {
            // 실패하면 오류 메시지와 함께 글쓰기 페이지 다시 표시
            request.setAttribute("errorMsg", "게시글 등록에 실패했습니다.");
            request.getRequestDispatcher("/board/write.jsp").forward(request, response);
        }
    }

    // 게시글 삭제 처리
    private void deleteBoard(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String seqStr = request.getParameter("board_seq");
        if (seqStr == null) {
            // board_seq 없으면 게시글 목록으로 리다이렉트
            response.sendRedirect(request.getContextPath() + "/freeBoard.board");
            return;
        }

        int board_seq = Integer.parseInt(seqStr);
        BoardDTO board = dao.getBoardBySeq(board_seq);

        if (board == null) {
            // 삭제할 게시글 없으면 에러 페이지
            request.setAttribute("errorMsg", "삭제할 게시글이 없습니다.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        // 로그인된 사용자와 게시글 작성자 일치 여부 확인
        HttpSession session = request.getSession(false);
        String loginId = (session != null) ? (String) session.getAttribute("loginId") : null;
        if (loginId == null || !loginId.equals(board.getWriter())) {
            request.setAttribute("errorMsg", "본인 게시글만 삭제할 수 있습니다.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        // 삭제 시도 후 결과에 따라 처리
        if (dao.deleteBoard(board_seq)) {
            response.sendRedirect(request.getContextPath() + "/freeBoard.board");
        } else {
            request.setAttribute("errorMsg", "게시글 삭제에 실패했습니다.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    // 게시글 수정 폼 보여주기
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String seqStr = request.getParameter("board_seq");
        if (seqStr == null) {
            // 파라미터 없으면 목록으로 이동
            response.sendRedirect(request.getContextPath() + "/freeBoard.board");
            return;
        }
        int board_seq = Integer.parseInt(seqStr);
        BoardDTO board = dao.getBoardBySeq(board_seq);
        if (board == null) {
            // 수정할 게시글이 없으면 에러 페이지
            request.setAttribute("errorMsg", "수정할 게시글이 없습니다.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        // 로그인 사용자와 게시글 작성자가 일치하는지 체크
        HttpSession session = request.getSession(false);
        String loginId = (session != null) ? (String) session.getAttribute("loginId") : null;
        if (loginId == null || !loginId.equals(board.getWriter())) {
            request.setAttribute("errorMsg", "본인 게시글만 수정할 수 있습니다.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        // 게시글 정보를 JSP에 전달하여 수정폼 출력
        request.setAttribute("board", board);
        request.getRequestDispatcher("/board/edit.jsp").forward(request, response);
    }

    // 게시글 수정 처리
    private void editBoard(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 한글 인코딩 처리
        request.setCharacterEncoding("UTF-8");

        // 파라미터 받기
        String seqStr = request.getParameter("board_seq");
        String title = request.getParameter("title");
        String contents = request.getParameter("contents");

        // 입력값 검사
        if (seqStr == null || title == null || title.trim().isEmpty() || contents == null || contents.trim().isEmpty()) {
            request.setAttribute("errorMsg", "번호, 제목, 내용을 모두 입력하세요.");
            request.getRequestDispatcher("/board/edit.jsp").forward(request, response);
            return;
        }

        int board_seq = Integer.parseInt(seqStr);
        BoardDTO board = dao.getBoardBySeq(board_seq);
        if (board == null) {
            request.setAttribute("errorMsg", "존재하지 않는 게시글입니다.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        // 로그인 사용자와 게시글 작성자 체크
        HttpSession session = request.getSession(false);
        String loginId = (session != null) ? (String) session.getAttribute("loginId") : null;
        if (loginId == null || !loginId.equals(board.getWriter())) {
            request.setAttribute("errorMsg", "본인 게시글만 수정할 수 있습니다.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        // 제목, 내용 업데이트
        board.setTitle(title.trim());
        board.setContents(contents.trim());

        // DB 업데이트 시도
        if (dao.updateBoard(board)) {
            // 성공 시 상세보기 페이지로 리다이렉트
            response.sendRedirect(request.getContextPath() + "/detail.board?board_seq=" + board_seq);
        } else {
            // 실패 시 에러 메시지와 함께 수정 폼 다시 표시
            request.setAttribute("errorMsg", "게시글 수정에 실패했습니다.");
            request.getRequestDispatcher("/board/edit.jsp").forward(request, response);
        }
    }

    // 댓글 등록 처리
    private void addComment(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // 로그인 체크
        HttpSession session = request.getSession(false);
        String writer = (session != null) ? (String) session.getAttribute("loginId") : null;
        if (writer == null) {
            response.sendRedirect(request.getContextPath() + "/login.member");
            return;
        }

        // 댓글의 부모 게시글 번호와 댓글 내용 받기
        String parentSeqStr = request.getParameter("board_seq");
        String contents = request.getParameter("comment_contents");

        if (parentSeqStr == null || contents == null || contents.trim().isEmpty()) {
            request.setAttribute("errorMsg", "댓글 내용을 입력하세요.");
            request.getRequestDispatcher("/board/detail.jsp").forward(request, response);
            return;
        }

        int parent_seq = Integer.parseInt(parentSeqStr);

        // 댓글 DTO 생성 및 데이터 세팅
        CommentDTO comment = new CommentDTO();
        comment.setWriter(writer);
        comment.setContents(contents.trim());
        comment.setParent_seq(parent_seq);

        // DB에 댓글 등록 시도
        boolean success = commentDao.insertComment(comment);

        if (success) {
            // 성공 시 게시글 상세보기로 리다이렉트
            response.sendRedirect(request.getContextPath() + "/detail.board?board_seq=" + parent_seq);
        } else {
            request.setAttribute("errorMsg", "댓글 등록에 실패했습니다.");
            request.getRequestDispatcher("/board/detail.jsp").forward(request, response);
        }
    }

    // 댓글 수정 폼 보여주기
    private void showEditCommentForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String commentSeqStr = request.getParameter("comment_seq");
        if (commentSeqStr == null) {
            response.sendRedirect(request.getContextPath() + "/freeBoard.board");
            return;
        }

        int comment_seq = Integer.parseInt(commentSeqStr);
        CommentDTO comment = commentDao.getCommentBySeq(comment_seq);

        if (comment == null) {
            request.setAttribute("errorMsg", "수정할 댓글이 없습니다.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        // 로그인 사용자와 댓글 작성자 체크
        HttpSession session = request.getSession(false);
        String loginId = (session != null) ? (String) session.getAttribute("loginId") : null;
        if (loginId == null || !loginId.equals(comment.getWriter())) {
            request.setAttribute("errorMsg", "본인 댓글만 수정할 수 있습니다.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        // 댓글 객체를 JSP에 전달하여 수정폼 출력
        request.setAttribute("comment", comment);
        request.getRequestDispatcher("/board/editComment.jsp").forward(request, response);
    }

    // 댓글 수정 처리
    private void updateComment(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // 파라미터 받기
        String commentSeqStr = request.getParameter("comment_seq");
        String boardSeqStr = request.getParameter("board_seq");
        String contents = request.getParameter("comment_contents");

        // 필수 입력값 검사
        if (commentSeqStr == null || boardSeqStr == null || contents == null || contents.trim().isEmpty()) {
            request.setAttribute("errorMsg", "모든 정보를 입력하세요.");
            request.getRequestDispatcher("/board/editComment.jsp").forward(request, response);
            return;
        }

        int comment_seq = Integer.parseInt(commentSeqStr);
        int board_seq = Integer.parseInt(boardSeqStr);

        CommentDTO comment = commentDao.getCommentBySeq(comment_seq);
        if (comment == null) {
            request.setAttribute("errorMsg", "존재하지 않는 댓글입니다.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        // 로그인 사용자와 댓글 작성자 체크
        HttpSession session = request.getSession(false);
        String loginId = (session != null) ? (String) session.getAttribute("loginId") : null;
        if (loginId == null || !loginId.equals(comment.getWriter())) {
            request.setAttribute("errorMsg", "본인 댓글만 수정할 수 있습니다.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        // 내용 업데이트
        comment.setContents(contents.trim());

        // DB 수정 시도
        boolean success = commentDao.updateComment(comment);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/detail.board?board_seq=" + board_seq);
        } else {
            request.setAttribute("errorMsg", "댓글 수정에 실패했습니다.");
            request.setAttribute("comment", comment);
            request.getRequestDispatcher("/board/editComment.jsp").forward(request, response);
        }
    }

    // 댓글 삭제 처리
    private void deleteComment(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String commentSeqStr = request.getParameter("comment_seq");
        String boardSeqStr = request.getParameter("board_seq");

        System.out.println("deleteComment 호출됨");
        System.out.println("comment_seq=" + commentSeqStr + ", board_seq=" + boardSeqStr);

        if (commentSeqStr == null || boardSeqStr == null) {
            response.sendRedirect(request.getContextPath() + "/freeBoard.board");
            return;
        }

        int comment_seq = Integer.parseInt(commentSeqStr);
        int board_seq = Integer.parseInt(boardSeqStr);

        CommentDTO comment = commentDao.getCommentBySeq(comment_seq);
        if (comment == null) {
            request.setAttribute("errorMsg", "삭제할 댓글이 없습니다.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        // 로그인 사용자와 댓글 작성자 체크
        HttpSession session = request.getSession(false);
        String loginId = (session != null) ? (String) session.getAttribute("loginId") : null;
        if (loginId == null || !loginId.equals(comment.getWriter())) {
            request.setAttribute("errorMsg", "본인 댓글만 삭제할 수 있습니다.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        // 댓글 삭제 시도
        boolean success = commentDao.deleteComment(comment_seq);
        if (success) {
            // 성공하면 게시글 상세보기 페이지로 리다이렉트
            response.sendRedirect(request.getContextPath() + "/detail.board?board_seq=" + board_seq);
        } else {
            request.setAttribute("errorMsg", "댓글 삭제에 실패했습니다.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

}
