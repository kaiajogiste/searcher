<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="org.apache.solr.client.solrj.SolrClient" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" type="text/css" href="resource/styles.css">
    <title>Insert Data into Applications Table</title>
</head>
<body>
<%
    Connection connection = null;
    PreparedStatement preparedStatement = null;
    SolrClient solr = null;

    try {
        // Import necessary Java classes
        Class.forName("org.postgresql.Driver");
        String url = "jdbc:postgresql://postgres:5432/applications_data";
        String user = "admin";
        String password = "admin";

        // Establish a connection to the database
        connection = DriverManager.getConnection(url, user, password);

        // Retrieve form data
        String appName = request.getParameter("appName");
        String appGroup = request.getParameter("appGroup");
        String appType = request.getParameter("appType");
        String appDescription = request.getParameter("appDescription");
        double appCost = Double.parseDouble(request.getParameter("appCost"));

        // Create a SQL query to insert data into applications table
        String query = "INSERT INTO applications (name, app_group, app_type, description, app_cost) VALUES (?, ?, ?, ?, ?)";
        preparedStatement = connection.prepareStatement(query);
        preparedStatement.setString(1, appName);
        preparedStatement.setString(2, appGroup);
        preparedStatement.setString(3, appType);
        preparedStatement.setString(4, appDescription);
        preparedStatement.setDouble(5, appCost);

        // Execute the SQL query
        int rowsAffected = preparedStatement.executeUpdate();

        if (rowsAffected > 0) {
%>
<h2>Data inserted successfully into Applications Table.</h2>
<%
} else {
%>
<h2>Failed to insert data into Applications Table.</h2>
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
            if (solr != null) {
                solr.close();
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
