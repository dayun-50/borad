package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import dto.ReplyDTO;

public class ReplyDAO {
	
	private static ReplyDAO instance;

	public synchronized static ReplyDAO getInstance() {
		if(instance==null)
		{
			instance = new ReplyDAO();
		}
		return instance;
	}

	private Connection getConnection() throws Exception{ 
		Context ctx=new InitialContext();
		DataSource ds =(DataSource)ctx.lookup("java:comp/env/jdbc/oracle");
		return ds.getConnection();

	}
	
	
	public int ReplyInsert(String writer,String contents,int parent_seq) throws SQLException, Exception {
		String sql = "INSERT INTO reply(seq, writer, contents, write_date, parent_seq) " +
	             "VALUES (reply_seq.nextval, ?, ?, SYSDATE, ?)";
	
		try(Connection con=getConnection();PreparedStatement pstat=con.prepareStatement(sql);){
			pstat.setString(1,writer);
			pstat.setString(2,contents);
			pstat.setInt(3,parent_seq);
			
			return pstat.executeUpdate();
		}
	}
	
	public List<ReplyDTO> getReplyList(int parent_seq) throws Exception {
	    String sql = "SELECT seq, writer, contents, write_date, parent_seq FROM reply WHERE parent_seq = ? ORDER BY write_date ASC";
	    List<ReplyDTO> list = new ArrayList<>();

	    try (Connection con = getConnection();
	         PreparedStatement ps = con.prepareStatement(sql)) {
	        ps.setInt(1, parent_seq);
	        try (ResultSet rs = ps.executeQuery()) {
	            while (rs.next()) {
	                list.add(new ReplyDTO(
	                    rs.getInt("seq"),
	                    rs.getString("writer"),
	                    rs.getString("contents"),
	                    rs.getTimestamp("write_date"),
	                    rs.getInt("parent_seq")
	                ));
	            }
	        }
	    }
	    
	    
	    return list;
	}
	public boolean deleteMember(int seq) throws Exception {
		String sql = "DELETE FROM reply WHERE seq = ?";
		try (Connection con = getConnection();
				PreparedStatement pstat = con.prepareStatement(sql)) {
			pstat.setInt(1,seq);
			int result = pstat.executeUpdate();  // ✅ 여기 수정!!
			
			return result > 0;  // 삭제된 행이 있으면 true 반환
		}
	}
	
	public int UpdateContants(String contents,int seq)throws Exception{
		String sql="Update reply set contents=? , write_date = SYSDATE  where seq=?";
		try(Connection con=getConnection();
				PreparedStatement pstat =con.prepareStatement(sql)){
			pstat.setString(1, contents);
			pstat.setInt(2, seq);
			
			return pstat.executeUpdate();
		}
	}
}
