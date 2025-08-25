package controllers;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import DTO.LoginDTO;
import dao.UserDAO;

@WebServlet("*.member")
public class Member extends HttpServlet {

    // GET 요청 처리 메서드
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 요청 URI에서 컨텍스트 경로를 제외한 부분을 명령어로 추출 (예: /login.member)
        String cmd = request.getRequestURI().substring(request.getContextPath().length());

        try {
            switch (cmd) {
                case "/accession.member":  // 회원가입 폼 요청
                    request.getRequestDispatcher("/member/joinform.jsp").forward(request, response);
                    break;

                case "/idcheck.member":    // 아이디 중복 검사 요청
                    String id = request.getParameter("id");
                    // DAO를 통해 해당 아이디가 이미 존재하는지 확인
                    boolean isIdExist = UserDAO.getInstance().getIdIfExist(id);
                    // 결과를 JSP에 전달
                    request.setAttribute("result", isIdExist);
                    request.getRequestDispatcher("/member/idcheck.jsp").forward(request, response);
                    break;

//                case "/login.member":      // 로그인 폼 요청
//                    request.getRequestDispatcher("/member/login.jsp").forward(request, response);
//                    break;

                case "/logout.member":     // 로그아웃 요청(GET)
                    HttpSession session = request.getSession(false);
                    if (session != null) session.invalidate();  // 세션 무효화하여 로그아웃 처리
                    response.sendRedirect(request.getContextPath() + "/index.jsp");  // 메인 페이지로 이동
                    break;

                case "/mypage.member":     // 마이페이지 요청
                    session = request.getSession(false);
                    // 로그인 상태가 아니면 로그인 페이지로 리다이렉트
                    if (session == null || session.getAttribute("loginId") == null) {
                        response.sendRedirect(request.getContextPath() + "/login.member");
                        return;
                    }
                    String userId = (String) session.getAttribute("loginId");
                    // DAO에서 회원 정보 조회
                    LoginDTO member = UserDAO.getInstance().getUser(userId);
                    if (member == null) {
                        request.setAttribute("message", "회원 정보를 찾을 수 없습니다.");
                        request.getRequestDispatcher("/error.jsp").forward(request, response);
                        return;
                    }
                    // 회원 정보를 JSP에 전달하여 마이페이지 표시
                    request.setAttribute("member", member);
                    request.getRequestDispatcher("/member/mypage.jsp").forward(request, response);
                    break;

                default:
                    // 지원하지 않는 요청이면 404 에러 응답
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            // 예외 발생 시 error.jsp로 이동
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }

    // POST 요청 처리 메서드
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String cmd = request.getRequestURI().substring(request.getContextPath().length());
        request.setCharacterEncoding("UTF-8");  // POST 데이터 한글 인코딩 처리
        HttpSession session = request.getSession(false);

        try {
            switch (cmd) {
                case "/signup.member":   // 회원가입 처리
                    String id = request.getParameter("id");
                    String pw = request.getParameter("pw");
                    String name = request.getParameter("name");
                    String phone = request.getParameter("phone");
                    String email = request.getParameter("email");
                    String zipcode = request.getParameter("zipcode");
                    String address1 = request.getParameter("address1");
                    String address2 = request.getParameter("address2");

                    // 암호화
                    String encryptedPw = UserDAO.encrypt(pw);

                    // DAO를 통해 회원 정보를 DB에 저장
                    int result = UserDAO.getInstance().interUser(id, encryptedPw, name, phone, email, zipcode, address1, address2);

                    if (result > 0) {
                        request.setAttribute("message", "회원가입이 성공적으로 완료되었습니다.");
                        request.getRequestDispatcher("/member/result.jsp").forward(request, response);
                    } else {
                        request.setAttribute("message", "회원가입에 실패했습니다.");
                        request.getRequestDispatcher("/error.jsp").forward(request, response);
                    }
                    break;

                case "/login.member":    // 로그인 처리
                    id = request.getParameter("id");
                    pw = request.getParameter("pw");

                    // DAO에서 로그인 성공 여부 확인 (비밀번호 검증 포함)
                    boolean loginSuccess = UserDAO.getInstance().loginCheck(id, pw);
                    if (loginSuccess) {
                        // 로그인 성공 시 세션 생성 및 로그인 아이디 저장
                        HttpSession newSession = request.getSession();
                        newSession.setAttribute("loginId", id);
                        // 메인 페이지로 리다이렉트
                        response.sendRedirect(request.getContextPath() + "/index.jsp");
                    } else {
                        // 로그인 실패 시 메시지와 함께 결과 페이지 출력
                        request.setAttribute("message", "로그인 실패");
                        request.getRequestDispatcher("/member/loginResult.jsp").forward(request, response);
                    }
                    break;

                case "/logout.member":   // 로그아웃 및 회원탈퇴, 회원정보 수정 처리
                    String action = request.getParameter("action");

                    if ("logout".equals(action)) {
                        // 로그아웃 처리: 세션 무효화 후 메인 페이지 이동
                        if (session != null) session.invalidate();
                        response.sendRedirect(request.getContextPath() + "/index.jsp");
                        return;

                    } else if ("withdraw".equals(action)) {
                        // 회원 탈퇴 처리
                        if (session != null) {
                            String userId = (String) session.getAttribute("loginId");
                            if (userId != null) {
                                int delResult = UserDAO.getInstance().deleteMember(userId);
                                if (delResult > 0) {
                                    session.invalidate();  // 탈퇴 성공 시 세션 무효화
                                    response.sendRedirect(request.getContextPath() + "/member/goodbye.jsp");
                                    return;
                                } else {
                                    request.setAttribute("message", "회원 탈퇴 실패");
                                    request.getRequestDispatcher("/error.jsp").forward(request, response);
                                    return;
                                }
                            }
                        }
                        // 로그인 상태가 아니라면 로그인 페이지로 이동
                        response.sendRedirect(request.getContextPath() + "/login.member");
                        return;

                    } else if ("update".equals(action)) {
                        // 회원정보 수정 처리
                        if (session == null || session.getAttribute("loginId") == null) {
                            response.sendRedirect(request.getContextPath() + "/login.member");
                            return;
                        }
                        String userId = (String) session.getAttribute("loginId");

                        // 수정할 회원 정보 파라미터 수집
                        String newPhone = request.getParameter("phone");
                        String newEmail = request.getParameter("email");
                        String newZipcode = request.getParameter("zipcode");
                        String newAddress1 = request.getParameter("address1");
                        String newAddress2 = request.getParameter("address2");
                        String newPw = request.getParameter("pw");

                        String encryptedNewPw = null;
                        // 새 비밀번호가 입력된 경우에만 암호화
                        if (newPw != null && !newPw.trim().isEmpty()) {
                            encryptedNewPw = UserDAO.encrypt(newPw);
                        }

                        // DAO를 통해 회원정보 전체 업데이트 시도
                        int updateResult = UserDAO.getInstance().updateMember(
                                userId, newPhone, newEmail, newZipcode, newAddress1, newAddress2);

                        if (updateResult > 0) {
                            // 수정 성공 시 업데이트된 회원정보를 조회하여 마이페이지에 전달
                        	LoginDTO updatedMember = UserDAO.getInstance().getUser(userId);
                            request.setAttribute("member", updatedMember);
                            request.setAttribute("message", "회원정보가 성공적으로 수정되었습니다.");
                            request.getRequestDispatcher("/member/mypage.jsp").forward(request, response);
                        } else {
                            // 실패 시 에러 페이지로 이동
                            request.setAttribute("message", "회원정보 수정에 실패했습니다.");
                            request.getRequestDispatcher("/error.jsp").forward(request, response);
                        }
                        return;

                    } else {
                        // 알 수 없는 액션인 경우 기본적으로 로그아웃 처리
                        if (session != null) session.invalidate();
                        response.sendRedirect(request.getContextPath() + "/index.jsp");
                        return;
                    }

                default:
                    // 정의되지 않은 POST 요청에 대해 404 에러 응답
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            // 예외 발생 시 에러 페이지로 이동
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }
}
