package DTO;

import java.sql.Timestamp;

/**
 * 
 */
public class BoardDTO {

	private String writer;
	private String title;
	private String contents;
	private Timestamp write_Date;   
	private int viewCount;    
	private int board_seq; 


	public BoardDTO() {

	}



	public BoardDTO(String writer, String title, String contents, Timestamp write_Date, int viewCount) {
		super();
		this.writer = writer;
		this.title = title;
		this.contents = contents;
		this.write_Date = write_Date;
		this.viewCount = viewCount;
	}
	public BoardDTO(String writer, String title, String contents) {
		this.writer = writer;
		this.title = title;
		this.contents = contents;
	}

	public BoardDTO(int board_seq, String writer, String title, String contents, Timestamp write_Date, int viewCount) {
	    this.board_seq = board_seq;
	    this.writer = writer;
	    this.title = title;
	    this.contents = contents;
	    this.write_Date = write_Date;
	    this.viewCount = viewCount;
	}
	
	public String getWriter() {
		return writer;
	}



	public void setWriter(String writer) {
		this.writer = writer;
	}



	public String getTitle() {
		return title;
	}

	public int getBoard_seq() {
	    return board_seq;
	}

	public void setBoard_seq(int board_seq) {
	    this.board_seq = board_seq;
	}

	public void setTitle(String title) {
		this.title = title;
	}



	public String getContents() {
		return contents;
	}



	public void setContents(String contents) {
		this.contents = contents;
	}



	public Timestamp getWrite_Date() {
		return write_Date;
	}



	public void setWriteDate(Timestamp write_Date) {
		this.write_Date = write_Date;
	}



	public int getViewCount() {
		return viewCount;
	}



	public void setViewCount(int viewCount) {
		this.viewCount = viewCount;
	}




}
