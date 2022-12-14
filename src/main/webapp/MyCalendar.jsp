<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.time.DayOfWeek" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>MyCalendar</title>
<link rel="stylesheet" href="calendar.css">
</head>
<body>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="web_group_project.Todo" %>
<%@ page import = "java.sql.Connection" %>
<%@ page import = "java.sql.DriverManager"%>
<%@ page import = "java.sql.ResultSet"%>
<%@ page import = "java.sql.SQLException"%>
<%@ page import = "java.sql.Statement"%>

<%
	Connection conn = null;
	Statement stmt = null;
	ResultSet result = null;
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

<%
	Calendar cal = Calendar.getInstance();
	Calendar today = Calendar.getInstance();
	int year = cal.get(Calendar.YEAR);
	int month = cal.get(Calendar.MONTH);
	int date = cal.get(Calendar.DATE);
	int today_year = today.get(Calendar.YEAR);
	int today_month = today.get(Calendar.MONTH);
	int today_date = today.get(Calendar.DATE);
	
	try{
		year = Integer.parseInt(request.getParameter("year"));
		month = Integer.parseInt(request.getParameter("month"));
		
		if(month>=12){
			year++;
			month =0;
		}else if(month <= -1){
			year--;
			month =11;
		}
	}catch(Exception e){
		
	}
%>

	<table width="770" border="1" cellpadding="5" cellspacing="0">
		<tr>
			<th colspan="7">
				<a class="move" href="?year=<%=year-1%>&month=<%=month%>">
					<img src="img/angle-double-left.png">
				</a>
				<a class="move" href="?year=<%=year%>&month=<%=month-1%>">
					<img src="img/angle-left.png">
				</a>
				<div class="date"><%=year %>. <%=month+1%></div>
				<a class="move" href="?year=<%=year%>&month=<%=month+1%>">
					<img src="img/angle-right.png">
				</a>
				<a class="move" href="?year=<%=year+1%>&month=<%=month%>">
					<img src="img/angle-double-right.png">
				</a>
			</th>
		</tr>
		<tr>
			<th class="day">Sun</th>
			<th class="day">Mon</th>
			<th class="day">Tue</th>
			<th class="day">Wed</th>
			<th class="day">Thu</th>
			<th class="day">Fri</th>
			<th class="day">Sat</th>
		</tr>
		<tr>
		<%
			cal.set(year,month,1);
			int first_day = cal.get(Calendar.DAY_OF_WEEK);
			int this_month_last_date=cal.getActualMaximum(Calendar.DATE);
			
			if(month==0){
				cal.set(Calendar.YEAR,year-1);
				cal.set(Calendar.MONTH,12);
			}
			else{
				cal.set(Calendar.MONTH,month-1);
			}
			int prev_month_last_date = cal.getActualMaximum(Calendar.DATE);
			
			
			cal.set(year,month,date);
			int p_year=year;
			int p_month=month-1;
			int n_year=year;
			int n_month=month+1;
			if(p_month==-1){
				p_year--;
				p_month=11;
			}
			if(n_month==12){
				n_month=0;
				n_year++;
			}
			for(int i = 1; i<first_day;i++){
				%>
				<td class="prev" width="110px">
				<%
				if(i==1){
				%>	
					<a class="weekly" type="button" href='weekly.jsp?year=<%=year%>&month=<%=p_month + 1%>&date=<%=prev_month_last_date + i + 1 - first_day %>'>weekly</a>
				<%
				}
				%>
				<a href="#pop_up" class="btn_open" onclick="schedule(<%=year%>,<%=month-1%>,<%=prev_month_last_date + i + 1 - first_day%>,<%=year%>,<%=month%>)">
				<%=prev_month_last_date + i + 1 - first_day %>
				</a>
				<div class="todoList">
				<%
				String selectedDate = p_year + "/" + (p_month+1) + "/" + (prev_month_last_date + i + 1 - first_day);
				for (Todo todo : todoList) {
					if (todo.getDate().equals(selectedDate)) {
				%>
				
				<div href="#pop_up2" class="btn_open has_schedule" onclick="schedule2('<%=todo.getId()%>', '<%=todo.getSummary()%>', '<%=todo.getDescription()%>',<%=year%>,<%=month%>)"><a href="#"><%= todo.getSummary() %></a></div>
				<%
					}
				}
				%>
				</div>
				</td>
				
				<%
			}
			
			for(int i = 1;i<=this_month_last_date;i++){
				cal.set(Calendar.DATE,i);
				if(today_year==year && today_month==month && today_date==i){
					%>
					<td class="this today">
					<%
					
						if(cal.get(Calendar.DAY_OF_WEEK)==1){
							%>	
							<a class="weekly" href='weekly.jsp?year=<%=year%>&month=<%=month + 1%>&date=<%=i%>'>weekly</a>
						<%
						}
					%>
					<a href="#pop_up" class="btn_open" onclick="schedule(<%=year%>,<%=month%>,<%=i%>,<%=year%>,<%=month%>)">
					<%=i %>
					</a>
					<div class="todoList">
					<%
					String selectedDate = year + "/" + (month+1) + "/" + i;
					for (Todo todo : todoList) {
						if (todo.getDate().equals(selectedDate)) {
					%>
					<div href="#pop_up2" class="btn_open has_schedule" onclick="schedule2('<%=todo.getId()%>', '<%=todo.getSummary()%>', '<%=todo.getDescription()%>,<%=year%>,<%=month%>')"><a href="#"><%= todo.getSummary() %></a></div>
					<%
						}
					}
					%>
					</div>
						</td>
						<%
				}
				else{
					%>
					<td class="this">
										<%
					
						if(cal.get(Calendar.DAY_OF_WEEK)==1){
							%>	
							<a class="weekly" type="button" href='weekly.jsp?year=<%=year%>&month=<%=month + 1%>&date=<%=i %>'>weekly</a>
						<%
						}
					%>
					<a href="#pop_up" class="btn_open" onclick="schedule(<%=year%>,<%=month%>,<%=i%>,<%=year%>,<%=month%>)">
					<%=i %>
					</a>
					<div class="todoList">
					<%
					String selectedDate = year + "/" + (month+1) + "/" + i;
					for (Todo todo : todoList) {
						if (todo.getDate().equals(selectedDate)) {
					%>
					<div href="#pop_up2" class="btn_open has_schedule" onclick="schedule2('<%=todo.getId()%>', '<%=todo.getSummary()%>', '<%=todo.getDescription()%>',<%=year%>,<%=month%>)"><a href="#"><%= todo.getSummary() %></a></div>
					<%
						}
					}
					%>
					</div>
					</td>
					<%
				}
				
				if(cal.get(Calendar.DAY_OF_WEEK)==7 && i!= this_month_last_date){
					out.println("</tr><tr>");
				}
			}
			for(int i = 1;i<=7 - cal.get(Calendar.DAY_OF_WEEK);i++){
				
				%>
				<td class="next">
				<a href="#pop_up" class="btn_open" onclick="schedule(<%=year%>,<%=month+1%>,<%=i%>,<%=year%>,<%=month%>)">
				<%=i %>
				</a>
				<div class="todoList">
				<%
					String selectedDate = n_year + "/" + (n_month+1) + "/" + i;
					for (Todo todo : todoList) {
						if (todo.getDate().equals(selectedDate)) {
					%>
					<div href="#pop_up2" class="btn_open has_schedule" onclick="schedule2('<%=todo.getId()%>', '<%=todo.getSummary()%>', '<%=todo.getDescription()%>',<%=year%>,<%=month%>)"><a href="#"><%= todo.getSummary() %></a></div>
					<%
						}
					}
				%>
				</div>
				</td>
				<%
			}
		%>
		</tr>
	</table>

	<iframe name="post_frame" id="post_frame" style="display:none" frame_border="0"></iframe>
	
	<div id="pop_up" class="pop_wrap" style="display:none">
		<div class="pop_inner">
			<form action="./backend/addMonth.jsp" method="post">
				<input name="year" type="hidden" id="form_year" value="">
				<input name="month" type="hidden" id="form_month" value="">
				<input name="date" type="hidden" id="form_date" value="">
				<input name="b_year" type="hidden" id="back_year" value="">
				<input name="b_month" type="hidden" id="back_month" value="">
				<div id="sch">
					
				</div>
				<div class="schedule1">
					<p>일정 요약 : </p> 
					<textarea name="summary" cols="20" rows="1"></textarea>
				</div>
				<div class="schedule2">
					<p>일정 상세 : </p> 
					<textarea name="description" cols="20" rows="5"></textarea><br>
				</div>
				<input type="submit" class="btn_close" value="추가">
				<button type="button" class="btn_close">취소</button>
			</form>
		</div>
	</div>
	
	<div id="pop_up2" class="pop_wrap" style="display:none">
		<div class="pop_inner">
			<form action="./backend/updateMonth.jsp" method="post">
		      	<input type="hidden" name="id" id="updateId" value="">
		      	<input name="b_year2" type="hidden" id="back_year2" value="">
				<input name="b_month2" type="hidden" id="back_month2" value="">
				<div class="schedule1">
		     		<p>요약</p>
		        	<textarea id="modal-summary" name="summary" value="" cols="20" rows="1"></textarea>
		        </div>
		        <div class="schedule2">
		        	<p>상세: </p> 
					<textarea id="modal-description" name="description" value="" cols="20" rows="5"></textarea>
				</div>
		        	<button type="button" class="btn btn_close btn-secondary" data-bs-dismiss="modal">닫기</button>
			        <button type="submit" name="action" value="update" class="btn btn_close btn-primary">수정</button>
		    	    <button type="submit" name="action" value="delete" class="btn btn_close btn-primary">삭제</button>
		   	</form>
		</div>
	</div>
	
	<script>
		var y, m, d;
		const tmp = document.getElementById('sch');
		function schedule(y,m,d,y2,m2){
			if(m<0){
				y=y-1;
				m=11;
			}
			else if(m>11){
				y=y+1;
				m=0;
			}
			m+=1;
			tmp.innerHTML=y + "년" + " " + m + "월" + " " + d + "일" + " 일정추가";
			document.getElementById('form_year').value=y;
			document.getElementById('form_month').value=m;
			document.getElementById('form_date').value=d;
			document.getElementById('back_year').value=y2;
			document.getElementById('back_month').value=m2;
		}
		function schedule2(id, summary, description,y,m){
			document.getElementById('updateId').value=id;
			document.getElementById('modal-summary').value=summary;
			document.getElementById('modal-description').value=description;
			document.getElementById('back_year2').value=y;
			document.getElementById('back_month2').value=m;
		}
		
		var target = document.querySelectorAll('.btn_open');
		var btnPopClose = document.querySelectorAll('.pop_wrap .btn_close');
		var targetID;
		
		for(var i = 0; i < target.length; i++){
			target[i].addEventListener('click', function(){
				targetID = this.getAttribute('href');
				document.querySelector(targetID).style.display = 'block';
			});
		}
		
		for(var j = 0; j < target.length; j++){
			btnPopClose[j].addEventListener('click', function(){
				this.parentNode.parentNode.parentNode.style.display = 'none';
				document.querySelector('.pop_wrap').style.diplay='none';
			});
		}
	</script>
</body>
</html>