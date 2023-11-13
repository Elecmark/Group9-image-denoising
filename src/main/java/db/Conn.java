package db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class Conn {
	private Connection con = null;
	private PreparedStatement stmt = null;
	private ResultSet rs = null;
	
	public void connDB() throws Exception {
	    String url = "jdbc:mysql://localhost:3306/testdb";
	    String username = "root";
	    String password = "214588Pdh";
	    Class.forName("com.mysql.cj.jdbc.Driver");
	    con = DriverManager.getConnection(url, username, password);
	}

	
	public void closeDB() throws SQLException {
		if (rs != null) {
			rs.close();
			rs = null;
		}
		if (stmt != null) {
			stmt.close();
			stmt = null;
		}
		if (con != null) {
			con.close();
			con = null;
		}
	}
	
	public ResultSet SelectedSql(String sql) throws SQLException {
		if (sql == null || sql.equals(""))
			return null;
		sql = sql.trim(); // 去掉字符串两边的空格
		stmt = con.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
		rs = stmt.executeQuery();
		return rs;
	}
	
	public void UpdateSQL(String sql) throws SQLException {
		stmt = con.prepareStatement(sql);
		stmt.executeUpdate();
	}
	
	public ResultSet QuerySQL(String sql) throws SQLException {
	    stmt = con.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
	    rs = stmt.executeQuery();
	    return rs;
	}
	
	public PreparedStatement getPreparedStatement(String sql) throws SQLException {
	    return con.prepareStatement(sql);
	}

}
