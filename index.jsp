<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" type="text/css" href="resource/styles.css">
    <title>Display and Insert PostgreSQL Data</title>
</head>
<body>

<h1>Search Applications</h1>
<form method="get" action="search.jsp">
    <input type="text" name="searchTerm" placeholder="Enter search term">
    <label><input type="radio" name="searchContext" value="applications" checked> Applications</label>
    <label><input type="radio" name="searchContext" value="app_service"> App Service</label>
    <input type="submit" value="Search">
</form>


    <%
    String url = "jdbc:postgresql://postgres:5432/applications_data";
    String user = "admin";
    String password = "admin";
    Connection connection = null;
    Statement statement = null;
    ResultSet resultSet = null;
    try {
        // Import necessary Java classes
        Class.forName("org.postgresql.Driver");


        // Establish a connection to the database
        connection = DriverManager.getConnection(url, user, password);

        // Create a SQL query for applications
        String appQuery = "SELECT * FROM applications";
        statement = connection.createStatement();
        resultSet = statement.executeQuery(appQuery);
%>
<h1>Applications Data</h1>
<table border="1">
    <tr>
        <th>App Code</th>
        <th>Name</th>
        <th>App Group</th>
        <th>App Type</th>
        <th>Description</th>
        <th>App Cost</th>
        <th>Last Modified</th>
    </tr>
    <%
        while (resultSet.next()) {
    %>
    <tr>
        <td><%= resultSet.getInt("app_code") %></td>
        <td><%= resultSet.getString("name") %></td>
        <td><%= resultSet.getString("app_group") %></td>
        <td><%= resultSet.getString("app_type") %></td>
        <td><%= resultSet.getString("description") %></td>
        <td><%= resultSet.getDouble("app_cost") %></td>
        <td><%= resultSet.getTimestamp("last_modified") %></td>
    </tr>
    <%
        }
        // Close the resources for applications
        resultSet.close();
        statement.close();
    %>
</table>

<h1>App Service Data</h1>
<table border="1">
    <tr>
        <th>App Code</th>
        <th>Service Code</th>
        <th>Name</th>
        <th>Type</th>
        <th>Sub Type</th>
        <th>Description</th>
        <th>Last Modified</th>
    </tr>
    <%
        // Create a SQL query for app_service
        String serviceQuery = "SELECT * FROM app_service";
        statement = connection.createStatement();
        resultSet = statement.executeQuery(serviceQuery);
        while (resultSet.next()) {
    %>
    <tr>
        <td><%= resultSet.getInt("app_code") %></td>
        <td><%= resultSet.getInt("service_code") %></td>
        <td><%= resultSet.getString("name") %></td>
        <td><%= resultSet.getString("type") %></td>
        <td><%= resultSet.getString("sub_type") %></td>
        <td><%= resultSet.getString("description") %></td>
        <td><%= resultSet.getTimestamp("last_modified") %></td>
    </tr>
    <%
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (resultSet != null) {
                    resultSet.close();
                }
                if (statement != null) {
                    statement.close();
                }
                if (connection != null) {
                    connection.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    %>
</table>

<!-- Add a button for inserting data into applications table -->
<div class="form-container">
    <div class="form">
        <h2>Insert Data into Applications Table</h2>
        <form method="post" action="insertDataIntoApplicationsTable.jsp">
            <div class="form-input">
                <input type="hidden" name="table" value="applications">
                Name: <input type="text" name="appName" required><br>
                App Group: <input type="text" name="appGroup"><br>
                App Type: <input type="text" name="appType"><br>
                Description: <input type="text" name="appDescription"><br>
                App Cost: <input type="number" name="appCost" step="0.01"><br>
                <input type="submit" value="Insert into Applications">
            </div>
        </form>
    </div>
    <div class="form">
        <!-- Add a button for inserting data into app_service table -->
        <h2>Insert Data into App Service Table</h2>
        <form method="post" action="insertDataIntoAppServiceTable.jsp">
            <div class="form-input">
                <input type="hidden" name="table" value="app_service">
                App Code:
                <select name="appCode">
                    <%
                        try {
                            // Establish a connection to the database
                            connection = DriverManager.getConnection(url, user, password);
                            statement = connection.createStatement();
                            String appCodeQuery = "SELECT app_code, name FROM applications";
                            resultSet = statement.executeQuery(appCodeQuery);
                            while (resultSet.next()) {
                    %>
                    <option value="<%= resultSet.getInt("app_code") %>"><%= resultSet.getString("name") %></option>
                    <%
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        } finally {
                            try {
                                if (resultSet != null) {
                                    resultSet.close();
                                }
                                if (statement != null) {
                                    statement.close();
                                }
                                if (connection != null) {
                                    connection.close();
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        }
                    %>
                </select><br>
                Name: <input type="text" name="serviceName" required><br>
                Type: <input type="text" name="serviceType"><br>
                Sub Type: <input type="text" name="serviceSubType"><br>
                Description: <input type="text" name="serviceDescription"><br>
                <input type="submit" value="Insert into App Service">
            </div>
        </form>
    </div>
</div>
</body>
</html>