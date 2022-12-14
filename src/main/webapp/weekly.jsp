<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>weekly todo list</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-kenU1KFdBIe4zVF0s0G1M5b4hcpxyD9F7jL+jjXkk+Q2h455rYXK/7HAuoJl+0I4" crossorigin="anonymous"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.0/font/bootstrap-icons.css">
<link rel="stylesheet" href="weekly.css">
<link rel="stylesheet" href="header.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.4.0/Chart.min.js"></script>
</head>
<body>
	<%@ page import = "java.util.List" %>
	<%@ page import = "java.util.Date" %>
	<%@ page import = "java.util.ArrayList" %>
	<%@ page import = "web_group_project.Todo" %>
	<%@ page import = "java.sql.Connection" %>
	<%@ page import = "java.sql.DriverManager"%>
	<%@ page import = "java.sql.ResultSet"%>
	<%@ page import = "java.sql.SQLException"%>
	<%@ page import = "java.sql.Statement"%>
	
	<% String startDate; %>
	<% int cnt = 0; %>
	<% int complete = 0; %>
	<%
	Connection conn = null;
	Statement stmt = null;
	ResultSet result = null;
	request.setCharacterEncoding("utf-8");
	String sYear = request.getParameter("year");
	String sMonth = request.getParameter("month");
	String sDate = request.getParameter("date");
	
	String year = sYear;
	String month = sMonth;
	String date = sDate;
	if (year == null) {
		Date today = new Date();
		year = String.valueOf(today.getYear() + 1900);
		month = String.valueOf(today.getMonth() + 1);;
		date = String.valueOf(today.getDate());;
	}
	List<String> dates = new ArrayList<>();
	for (int i = 0; i < 7; i++) {
		startDate = year + "/" + month + "/" + date;
		dates.add(startDate);
		date = String.valueOf(Integer.valueOf(date) + 1);
		startDate = year + "/" + month + "/" + date;
		Date d = new Date(startDate);
		year = String.valueOf(d.getYear() + 1900);
		month = String.valueOf(d.getMonth() + 1);
		date = String.valueOf(d.getDate());
	}
	List<Todo> todoList = new ArrayList<>();
	try {
		String jdbcDriver = "jdbc:mariadb://localhost:3306/WebProgramming";
		String dbUser = "root";
		String dbPass = "";
		conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass);
		stmt = conn.createStatement();

		String query = "SELECT * FROM todoList;";
		result = stmt.executeQuery(query);
		while (result.next()) {
			Todo todo = new Todo();
			todo.setId(result.getInt(1));
			todo.setDate(result.getString(2));
			todo.setSummary(result.getString(3));
			todo.setDescription(result.getString(4));
			todo.setChecked(result.getString(5));
			todoList.add(todo);
		}
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
	
	<%! String summary; %>
	<%! String description; %>
	
	<%!
	public void setMessage(String s, String d) {
		summary = s;
		description = d;
	}
	%>
	
	<%@ include file="./header.jsp" %>
	
	<div class="calendar">
		<%
			for (int i = 0; i < 7; i++) {
				String[] day = {"sun", "mon", "tue", "wed", "thu", "fri", "sat"};
		%>
		<div class="day <%=day[i]%>">
			<div class="content">
				<h1><%= day[i] %></h1>
				<h2><%= dates.get(i) %></h2>
				<div class="todo-list">
					<ul class="list-group">
					<%
					for (Todo todo : todoList) {
						if (dates.get(i).equals(todo.getDate())) {
							cnt++;
					%>
					  <li class="list-group-item">
					  <form class="checkForm" action="backend/checkWeek.jsp" method="post">
					  <%! String checked; %>
					  <%
					  if (todo.getChecked() == null) {
						  checked = "";
					  } else if (todo.getChecked().equals("0")) {
						  checked = "";
					  } else if (todo.getChecked().equals("1")) {
						  checked = "checked";
						  complete++;
					  }
					  %>
					  	<input type="hidden" name="startYear" id="startYear" value="<%=sYear%>">
				      	<input type="hidden" name="startMonth" id="startMonth" value="<%=sMonth%>">
				      	<input type="hidden" name="startDate" id="startDate" value="<%=sDate%>">
					  	<input type="hidden" name="id" value="<%= todo.getId()%>">	
				    	<input class="form-check-input me-1" type="checkbox" value="<%=todo.getChecked() %>" name="checked" onchange="this.form.submit()" id=<%=todo.getId()%> + "CheckboxStretched" <%=checked%> >
					  </form>
					    <div class="describe" data-bs-toggle="modal" data-bs-target="#describeModal" onclick="setMessage('<%=todo.getSummary()%>', '<%=todo.getDescription()%>', '<%=todo.getId()%>')"> <%=todo.getSummary() %> </div>
					  </li>
					  <%
						}
					}
					  %>
					</ul>
				</div>
			</div>
			<i class="bi bi-plus-square" type="button" class="btn btn-primary" onclick="schedule(<%= dates.get(i).split("/")[0] %>, <%= dates.get(i).split("/")[1] %>, <%= dates.get(i).split("/")[2] %>)" data-bs-toggle="modal" data-bs-target="#addModal">새로운 일정을 추가하세요</i>
		</div>
		<%
			}
		%>
		<div class="todo">
			<div class="content">
				<h2>Weekly Todo</h2>
				<h3>남은 할 일 개수 <%= cnt - complete %></h3>
				<div>
			  		<canvas class="chart" id="myChart"></canvas>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 일정을 추가하는 modal -->
	<div class="modal fade" id="addModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
	  <div class="modal-dialog modal-sm">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h1 class="modal-title fs-5" id="exampleModalLabel">일정 추가</h1>
	        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
	      </div>
	      <form action="./backend/addWeek.jsp" method="post">
		      <div class="modal-body">
		      	<input type="hidden" name="year" id="year" value="">
		      	<input type="hidden" name="month" id="month" value="">
		      	<input type="hidden" name="date" id="date" value="">
		      	<input type="hidden" name="startYear" id="startYear" value="<%=sYear%>">
		      	<input type="hidden" name="startMonth" id="startMonth" value="<%=sMonth%>">
		      	<input type="hidden" name="startDate" id="startDate" value="<%=sDate%>">
		        <p>요약:</p> 
		        <textarea name="summary" cols="20" rows="1"></textarea>
		        <p>상세: </p> 
		        <textarea name="description" cols="20" rows="5"></textarea>
		      </div>
		      <div class="modal-footer">
		        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
		        <button type="submit" class="btn btn-primary">할 일 저장</button>
		      </div>
	      </form>
	    </div>
	  </div>
	</div>
	
	<!-- 상세한 일정을 확인하는 modal -->
	<div class="modal fade" id="describeModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
	  <div class="modal-dialog modal-sm">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h1 class="modal-title fs-5" id="exampleModalLabel">일정 추가</h1>
	        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
	      </div>
		      <form action="./backend/updateWeek.jsp" method="post">
		      <div class="modal-body">
		      	<input type="hidden" name="year" id="year" value="">
		      	<input type="hidden" name="month" id="month" value="">
		      	<input type="hidden" name="date" id="date" value="">
		      	<input type="hidden" name="startYear" id="startYear" value="<%=sYear%>">
		      	<input type="hidden" name="startMonth" id="startMonth" value="<%=sMonth%>">
		      	<input type="hidden" name="startDate" id="startDate" value="<%=sDate%>">
		      	<input type="hidden" name="id" id="updateId" value="">
		        <p>요약:</p> 
		        <textarea id="modal-summary" name="summary" value="" cols="20" rows="1"></textarea>
		        <p>상세: </p> 
		        <textarea id="modal-description" name="description" value="" cols="20" rows="5"></textarea>
		      </div>
		      <div class="modal-footer">
		        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
		        <button type="submit" name="action" value="update" class="btn btn-primary">수정</button>
		        <button type="submit" name="action" value="delete" class="btn btn-primary">삭제</button>
		      </div>
	      </form>
	    </div>
	  </div>
	</div>
	
	<script>
		function schedule(y,m,d){
			document.getElementById('year').value=y;
			document.getElementById('month').value=m;
			document.getElementById('date').value=d;
		}
	</script>
	
		<script>
		function setMessage(s, de, id){
			document.getElementById('modal-summary').value = s;
			document.getElementById('modal-description').value = de;
			document.getElementById('updateId').value = id;
		}
	</script>
	
	<script>
	  const ctx = document.getElementById('myChart');
	  
	  const data = {
			  labels: [
			    '완료한 일',
			    '남은 할 일'
			  ],
			  datasets: [{
			    label: 'My First Dataset',
			    data: [<%= complete %>, <%= cnt - complete %>],
			    backgroundColor: [
			      'rgb(54, 162, 235)',
			      'rgb(255, 99, 132)'
			    ],
			    hoverOffset: 4
			  }]
			};
	  
	  const config = {
			  type: 'doughnut',
			  data: data,
			  options: {
				  responsive: false
			  }
			};
	
	  new Chart(ctx, config);
	</script>
</body>
</html>