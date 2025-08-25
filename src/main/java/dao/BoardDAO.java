package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import dto.BoardDTO;

public class BoardDAO {
	private static BoardDAO instance;

	public synchronized static BoardDAO getInstance() {
		if(instance==null)
		{
			instance = new BoardDAO();
		}
		return instance;
	}

	private Connection getConnection() throws Exception{ 
		Context ctx=new InitialContext();
		DataSource ds =(DataSource)ctx.lookup("java:comp/env/jdbc/oracle");
		return ds.getConnection();

	}

	public int interUser(String writer,String title,String contents)throws Exception {   //데이터 넣기
		String sql = "INSERT INTO board (seq, writer, title, contents) " +
				"VALUES (board_seq.nextval, ?, ? ,?)";
		try(Connection con=getConnection();PreparedStatement pstat = con.prepareStatement(sql);) {
			pstat.setString(1, writer);
			pstat.setString(2, title);
			pstat.setString(3, contents);

			return pstat.executeUpdate();
		}
	}

	public List<BoardDTO> getboard() throws Exception { //데이터 검색
		String sql = "SELECT seq, writer, title, contents, write_date, view_count FROM board ORDER BY seq desc";
		List<BoardDTO> list = new ArrayList<>();

		try (Connection con = getConnection();
				PreparedStatement pstat = con.prepareStatement(sql);
				ResultSet rs = pstat.executeQuery()) {

			while (rs.next()) {
				list.add(new BoardDTO(
						rs.getInt("seq"),
						rs.getString("writer"),
						rs.getString("title"),
						rs.getString("contents"),
						rs.getString("write_date"),
						rs.getInt("view_count")
						));
			}
		}
		return list;
	}


	//시퀸스에 따라 찾기
	public BoardDTO getBoardBySeq(int seq) throws Exception {
		String sql = "SELECT seq, writer, title, contents, write_date, view_count FROM board WHERE seq = ?";
		try (Connection conn = getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, seq);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					return new BoardDTO(
							rs.getInt("seq"),
							rs.getString("writer"),
							rs.getString("title"),
							rs.getString("contents"),
							rs.getString("write_date"),
							rs.getInt("view_count")
							);
				}
			}
		}
		return null;
	}

	public String findWriter(int seq) throws Exception{
		String sql="SELECT writer from board where seq=?";
		try(Connection conn=getConnection();
				PreparedStatement ps=conn.prepareStatement(sql)){
			ps.setInt(1,seq);
			try(ResultSet rs=ps.executeQuery()){
				if(rs.next()) {
					return rs.getString("writer");

				}else {
					return null;
				}
			}
		}
	}

	public boolean deleteContacts(int seq)throws Exception{
		String sql="Delete From board where seq =?";
		try(Connection con=getConnection();
				PreparedStatement pstat=con.prepareStatement(sql)){
			pstat.setInt(1, seq);
			int result=pstat.executeUpdate();	

			return result >0;

		}

	}

	public int Updatecontents(String title,String contents,int seq)throws Exception{
		String sql = "UPDATE board SET title=?, contents=?, write_date=SYSTIMESTAMP  WHERE seq =?";
		try(Connection con=getConnection();
				PreparedStatement pstat=con.prepareStatement(sql);){
			pstat.setString(1, title);
			pstat.setString(2, contents);
			pstat.setInt(3, seq);

			return pstat.executeUpdate();
		}

	}


	public int updateseq(int seq) throws Exception {
		String sql="Update board set view_count=view_count+1 where seq= ?"; //업데이트 문
		try(Connection con=getConnection();
				PreparedStatement pstat=con.prepareStatement(sql);){

			pstat.setInt(1, seq);
			return pstat.executeUpdate();
		} 

	}

	public  int getRecordTotalCount() throws Exception{
		String sql="Select count(*) from board";
		try(Connection con=getConnection();
				PreparedStatement pstat=con.prepareStatement(sql);
				ResultSet rs=pstat.executeQuery()){
			rs.next();
			return rs.getInt(1);
		}
	}

	public List<BoardDTO> selectFromto(int from, int to) throws Exception {
	    String sql = "SELECT * FROM ("
	               + " SELECT board.*, ROW_NUMBER() OVER (ORDER BY seq DESC) AS rn"
	               + " FROM board"
	               + ") "
	               + " WHERE rn BETWEEN ? AND ?"
	               + " ORDER BY seq DESC";

	    List<BoardDTO> list = new ArrayList<>();

	    try (Connection con = getConnection();
	         PreparedStatement pstat = con.prepareStatement(sql)) {

	        pstat.setInt(1, from);
	        pstat.setInt(2, to);

	        try (ResultSet rs = pstat.executeQuery()) {
	            while (rs.next()) {
	                list.add(new BoardDTO(
	                    rs.getInt("seq"),
	                    rs.getString("writer"),
	                    rs.getString("title"),
	                    rs.getString("contents"),
	                    rs.getString("write_date"),
	                    rs.getInt("view_count")
	                ));
	            }
	        }
	    }
	    return list;
	}

//	public String getPageNavi(int currentPage) throws Exception{
//
//
//		int recordTotalCount=this.getRecordTotalCount();
//		int recordCountPerPage = Config.RECORD_COUNT_PER_PAGE;
//		int naviCountPerPage =Config.NAVI_COUNT_PER_PAGE;
//
//		int pageTotalCount =0;
//
//		if(recordTotalCount % recordCountPerPage > 0)  {
//			pageTotalCount=recordTotalCount / recordCountPerPage+1;
//		}else {
//			pageTotalCount=recordTotalCount / recordCountPerPage;
//		}
//
//		if(currentPage<1) {
//			currentPage=1;
//		}else if(currentPage>pageTotalCount) {
//			currentPage=pageTotalCount;
//
//		}
//
//		int startNavi= (currentPage-1) /naviCountPerPage *naviCountPerPage+1;
//
//
//		int endNavi=startNavi+(naviCountPerPage-1);
//
//		if(endNavi>pageTotalCount) {
//			endNavi=pageTotalCount;
//		}
//
//	
//
//
//		boolean needPrev=true;
//		boolean needNext=true;
//
//		if(startNavi==1) {needPrev=false;}
//		if(endNavi==pageTotalCount) { needNext=false;}
//
//		StringBuilder sb=new StringBuilder(); //여러 문자열 넣을때 사용하는 클라스 
//
//		if(needPrev) {
//			sb.append("<a href='/list.board?cpage="+(startNavi-1)+"'>< </a>");
//		}
//
//		for(int i=startNavi; i<=endNavi; i++) {
//			sb.append("<a href='/list.board?cpage="+i+"'>"+i+"</a> ");
//
//		}
//		if(needNext) {
//			sb.append("<a href='/list.board?cpage="+(endNavi+1)+"'>></a>");
//		}
//		return sb.toString();  //하나로 뭉쳐서 보내
//	}



}
