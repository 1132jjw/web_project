	<%@ page import = "java.sql.Connection" %>
	<%@ page import = "java.sql.DriverManager"%>
	<%@ page import = "java.sql.ResultSet"%>
	<%@ page import = "java.sql.SQLException"%>
	<%@ page import = "java.sql.Statement"%>
	<%@ page import = "java.util.List"%>
	<%@ page import = "java.util.ArrayList"%>
	<%
	Connection conn = null;
	Statement stmt = null;
	ResultSet result = null;
	List<String> list = new ArrayList<>();
	
	request.setCharacterEncoding("utf-8");
	
	String action = request.getParameter("action");
	
	String summary = request.getParameter("summary");
	
	String description = request.getParameter("description");
	
	String id = request.getParameter("id");
	
	String back_year = request.getParameter("b_year2");
	String back_month = request.getParameter("b_month2");

	try {
		String jdbcDriver = "jdbc:mariadb://localhost:3306/WebProgramming";
		String dbUser = "root";
		String dbPass = "";
		conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass);
		stmt = conn.createStatement();
		String query = "";
		if (action.equals("update")) {
			query = "UPDATE ToDoList SET summary='" + summary + "', description='" + description + "' WHERE idtodoList=" + id + ";";	
		} else if(action.equals("delete")){
			query = "DELETE FROM ToDoList WHERE idtodoList=" + id + ";";
		}
		stmt.executeQuery(query);
		response.sendRedirect("../MyCalendar.jsp?year=" + back_year + "&month=" + back_month);
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		try {
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	%>