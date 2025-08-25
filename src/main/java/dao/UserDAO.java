package dao;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import DTO.LoginDTO;

public class UserDAO {
	private static UserDAO instance;

	public synchronized static UserDAO getInstance() {
		if(instance==null)
		{
			instance = new UserDAO();
		}
		return instance;
	}

	private Connection getConnection() throws Exception{ 
		Context ctx=new InitialContext();
		DataSource ds =(DataSource)ctx.lookup("java:comp/env/jdbc/oracle");
		return ds.getConnection();

	}
	public int interUser(String id,String pw,String name,String phone,
			String email,String zipcode,String address1,String address2 )throws Exception {
		String sql="insert into members values(?,?,?,?,?,?,?,?,CURRENT_TIMESTAMP)";
		try(Connection con=getConnection();PreparedStatement pstat = con.prepareStatement(sql);) {
			pstat.setString(1,id);
			pstat.setString(2,pw);
			pstat.setString(3,name);
			pstat.setString(4,phone);
			pstat.setString(5,email);
			pstat.setString(6,zipcode);
			pstat.setString(7,address1);
			pstat.setString(8,address2);

			return pstat.executeUpdate();
		}
	}
	public LoginDTO getUser(String id) throws Exception {
	    String sql = "SELECT * FROM members WHERE id = ?";
	    
	    try (Connection con = getConnection();
	         PreparedStatement pstat = con.prepareStatement(sql)) {

	        pstat.setString(1, id);
	        try (ResultSet rs = pstat.executeQuery()) {
	            if (rs.next()) {
	                return new LoginDTO(
	                    rs.getString("id"),
	                    rs.getString("pw"),
	                    rs.getString("name"),
	                    rs.getString("phone"),
	                    rs.getString("email"),
	                    rs.getString("zipcode"),
	                    rs.getString("address1"),
	                    rs.getString("address2"),
	                    rs.getTimestamp("join_date_timestamp")
	                );
	            }
	        }
	    }
	    return null;
	}
	
	public boolean getIdIfExist(String id) throws Exception {
		String sql = "SELECT id FROM members WHERE id = ?";
		try (Connection con = getConnection();
				PreparedStatement pstat = con.prepareStatement(sql)) {
			pstat.setString(1, id);
			try (ResultSet rs = pstat.executeQuery()) {
				if (rs.next()) {
					return true; // 존재하면 해당 id 반환
				} else {
					return false; // 없으면 null
				}
			}
		}
	}

	public boolean loginCheck(String id,String pw)throws Exception{

		String sql="SELECT id, pw FROM members where id=? and pw=?";
		try(Connection con=getConnection();
				PreparedStatement pstat=con.prepareStatement(sql)){
			pstat.setString(1, id);
			pstat.setString(2, pw);
			try(ResultSet rs =pstat.executeQuery()){
				if(rs.next()) {
					return true;
				}else {
					return false;
				}
			}
		}
	}
	public int deleteMember(String id) throws Exception {
		String sql = "DELETE FROM members WHERE id=?";
		try (Connection con = getConnection();
				PreparedStatement pstat = con.prepareStatement(sql)) {
			pstat.setString(1, id);
			int result = pstat.executeUpdate();  // ✅ 여기 수정!!
			
			return result;  
		}
	}
	public int updateMember(String phone,String email,String zipcode,String address1,String address2,String id) throws Exception{
		String sql="Update members set phone=?,email=?,zipcode=?,address1=?,address2=? where id=?";
		try(Connection con=getConnection();
				PreparedStatement pstat=con.prepareStatement(sql);){
			pstat.setString(1, phone);
			pstat.setString(2, email);
			pstat.setString(3, zipcode);
			pstat.setString(4,address1);
			pstat.setString(5,address2);
			pstat.setString(6,id);
			
			return pstat.executeUpdate();
		}
	}
	
	public static String encrypt(String text) { //SHA 암호화
		try {
			MessageDigest md = MessageDigest.getInstance("SHA-512");
			byte[] bytes = text.getBytes(StandardCharsets.UTF_8);
			byte[] digest = md.digest(bytes);

			StringBuilder builder = new StringBuilder();
			for (byte b : digest) {
				builder.append(String.format("%02x", b));
			}
			return builder.toString();

		} catch (NoSuchAlgorithmException e) {
			throw new RuntimeException("SHA-512 암호화 실패", e);
		}
	}

	}






