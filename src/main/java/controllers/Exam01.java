package controllers;

public class Exam01 {
	public static void main(String[] args) {

		// 1. 전체 레코드가 몇 개인지?
		int recordTotalCount = 147;

		// 2. 한 페이지 당 몇개의 게시글을 보여줄지?
		int recordCountPerPage = 10;
		
		// 3. 한번에 네비게이터를 몇개씩 보여줄지?
		int naviCountPerPage = 10;
		
		// 4. 전체 몇 페이지가 생성 될 지?
		int pageTotalCount = 0;
		
		if(recordTotalCount % recordCountPerPage > 0) {
			pageTotalCount = recordTotalCount / recordCountPerPage + 1;
		}else { 
			pageTotalCount = recordTotalCount / recordCountPerPage;
		}
		
		int currentPage = 4; // 현재 내가 클릭해 둔 페이지
		
		if(currentPage < 1) {
			currentPage = 1;
		}else if(currentPage > pageTotalCount) {
			currentPage = pageTotalCount;
		}
		
		// 네비게이터의 시작 값
		int startNavi = (currentPage-1) / naviCountPerPage * naviCountPerPage + 1;
		
		// 네비게이터의 끝 값
		int endNavi = startNavi + naviCountPerPage - 1;
		
		if(endNavi > pageTotalCount) {
			endNavi = pageTotalCount;
		}
		
		System.out.println("현재 위치 : " + currentPage); // 4
		System.out.println("네비 시작 : " + startNavi);   // 1
		System.out.println("네비 종료 : " + endNavi);     // 10
		
		boolean needPrev = true;
		boolean needNext = true;
		
		if(startNavi == 1){needPrev = false;}
		if(endNavi == pageTotalCount) {needNext = false;}
		
		StringBuilder sb = new StringBuilder();
		
		if(needPrev) {
			//System.out.print("< ");
			sb.append("< ");
		}
		
		for(int i = startNavi; i <= endNavi; i++) {
			//System.out.print(i + " ");
			sb.append(i + " ");
		}
		if(needNext) {
			//System.out.print(">");
			sb.append(">");
		}
//		return sb.toString();
	}
}
