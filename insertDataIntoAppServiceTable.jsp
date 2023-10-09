<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.SQLException" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
        <meta charset="UTF-8">
        <link rel="stylesheet" type="text/css" href="resource/styles.css">
        <title>Insert Data into App Service Table</title>
</head>
<body>

<%
        Connection connection = null;
        PreparedStatement preparedStatement = null;

        try {
                // Import necessary Java classes
                Class.forName("org.postgresql.Driver");
                String url = "jdbc:postgresql://postgres:5432/applications_data";
                String user = "admin";
                String password = "admin";

                // Establish a connection to the database
                connection = DriverManager.getConnection(url, user, password);

                // Retrieve form data
                int appCode = Integer.parseInt(request.getParameter("appCode"));
                String serviceName = request.getParameter("serviceName");
                String serviceType = request.getParameter("serviceType");
                String serviceSubType = request.getParameter("serviceSubType");
                String serviceDescription = request.getParameter("serviceDescription");

                // Create a SQL query to insert data into app_service table
                String query = "INSERT INTO app_service (app_code, name, type, sub_type, description) VALUES (?, ?, ?, ?, ?)";
                preparedStatement = connection.prepareStatement(query);
                preparedStatement.setInt(1, appCode);
                preparedStatement.setString(2, serviceName);
                preparedStatement.setString(3, serviceType);
                preparedStatement.setString(4, serviceSubType);
                preparedStatement.setString(5, serviceDescription);

                // Execute the SQL query
                int rowsAffected = preparedStatement.executeUpdate();

                if (rowsAffected > 0) {
%>
<h2>Data inserted successfully into App Service Table.</h2>
<%
} else {
%>
<h2>Failed to insert data into App Service Table.</h2>
<%
        }
} catch (Exception e) {
        e.printStackTrace();
%>
<h2>An error occurred while processing your request.</h2>
<%
        } finally {
                // Close the resources
                try {
                        if (preparedStatement != null) {
                                preparedStatement.close();
                        }
                        if (connection != null) {
                                connection.close();
                        }
                } catch (SQLException e) {
                        e.printStackTrace();
                }
        }
%>

<!-- Add a button to go back to the main page -->
<a href="index.jsp">Go back to the main page</a>

</body>
</html>
