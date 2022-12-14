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
	String year = request.getParameter("year");
	String month = request.getParameter("month");
	String date = request.getParameter("date");
	
	String sYear = request.getParameter("startYear");
	String sMonth = request.getParameter("startMonth");
	String sDate = request.getParameter("startDate");
	
	String action = request.getParameter("action");
	
	String summary = request.getParameter("summary");
	
	String description = request.getParameter("description");
	
	String id = request.getParameter("id");

	try {
		String jdbcDriver = "jdbc:mariadb://localhost:3306/WebProgramming";
		String dbUser = "root";
		String dbPass = "";
		conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass);
		stmt = conn.createStatement();
		String dateFormatted = year + "/" + month + "/" +date;
		String query = "";
		if (action.equals("update")) {
			query = "UPDATE ToDoList SET summary='" + summary + "', description='" + description + "' WHERE idtodoList=" + id + ";";	
		} else if(action.equals("delete")){
			query = "DELETE FROM ToDoList WHERE idtodoList=" + id + ";";
		}
		stmt.executeQuery(query);
		log("../weekly.jsp?year=" + sYear + "&month=" + sMonth + "&date=" + sDate);
		response.sendRedirect("../weekly.jsp?year=" + sYear + "&month=" + sMonth + "&date=" + sDate);
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