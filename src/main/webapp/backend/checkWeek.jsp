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
	String id = request.getParameter("id");
	String checked = request.getParameter("checked");
	
	String sYear = request.getParameter("startYear");
	String sMonth = request.getParameter("startMonth");
	String sDate = request.getParameter("startDate");
	log(sYear);
	
	if (checked == null) {
		checked = "0";
	} else if (checked.equals("0")) {
		checked = "1";
	}

	try {
		String jdbcDriver = "jdbc:mariadb://localhost:3306/WebProgramming";
		String dbUser = "root";
		String dbPass = "";
		conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass);
		stmt = conn.createStatement();
		String query = "";
		query = "UPDATE ToDoList SET checked='" + checked + "' WHERE idtodoList=" + id + ";";
		stmt.executeQuery(query);
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