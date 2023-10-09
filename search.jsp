<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" type="text/css" href="resource/styles.css">
    <title>Search Results</title>
</head>
<body>
<%
    String searchTerm = request.getParameter("searchTerm");
    String searchContext = request.getParameter("searchContext");

    String url = "jdbc:postgresql://postgres:5432/applications_data";
    String user = "admin";
    String password = "admin";
    Connection connection = null;
    Statement statement = null;
    ResultSet resultSetApplications = null;
    ResultSet resultSetAppService = null;
    try {
        Class.forName("org.postgresql.Driver");
        connection = DriverManager.getConnection(url, user, password);
        if ("applications".equals(searchContext)) {
            // Search in applications table
            String applicationsQuery = "SELECT * FROM applications WHERE to_tsvector('english', name) @@ to_tsquery(?)";
            PreparedStatement applicationsPreparedStatement = connection.prepareStatement(applicationsQuery);
            applicationsPreparedStatement.setString(1, searchTerm);
            resultSetApplications = applicationsPreparedStatement.executeQuery();

            // Search in app_service table
            String appServiceQuery = "SELECT * FROM app_service WHERE app_code IN (SELECT app_code FROM applications WHERE to_tsvector('english', name) @@ to_tsquery(?))";
            PreparedStatement appServicePreparedStatement = connection.prepareStatement(appServiceQuery);
            appServicePreparedStatement.setString(1, "%" + searchTerm + "%");
            resultSetAppService = appServicePreparedStatement.executeQuery();
        } else if ("app_service".equals(searchContext)) {
            // Search in app_service table
            String appServiceQuery = "SELECT * FROM app_service WHERE to_tsvector('english', name) @@ to_tsquery(?)";
            PreparedStatement appServicePreparedStatement = connection.prepareStatement(appServiceQuery);
            appServicePreparedStatement.setString(1, searchTerm);
            resultSetAppService = appServicePreparedStatement.executeQuery();
// Search in applications table where app_code matches
            String matchingApplicationsQuery = "SELECT a.app_code, a.name, a.app_group, a.app_type, a.description, a.app_cost, a.last_modified " +
                    "FROM applications a " +
                    "INNER JOIN app_service s ON a.app_code = s.app_code " +
                    "WHERE to_tsvector('english', s.name) @@ to_tsquery(?)";

            PreparedStatement matchingApplicationsPreparedStatement = connection.prepareStatement(matchingApplicationsQuery);
            matchingApplicationsPreparedStatement.setString(1, searchTerm);
            resultSetApplications = matchingApplicationsPreparedStatement.executeQuery();

        }

%>

<h2>Search Results</h2>
<h3>Applications</h3>
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
        while (resultSetApplications.next()) {
    %>
    <tr>
        <td><%= resultSetApplications.getInt("app_code") %></td>
        <td><%= resultSetApplications.getString("name") %></td>
        <td><%= resultSetApplications.getString("app_group") %></td>
        <td><%= resultSetApplications.getString("app_type") %></td>
        <td><%= resultSetApplications.getString("description") %></td>
        <td><%= resultSetApplications.getDouble("app_cost") %></td>
        <td><%= resultSetApplications.getTimestamp("last_modified") %></td>
    </tr>
    <%
        }
    %>
</table>

<h3>App Service</h3>
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
        while (resultSetAppService.next()) {
    %>
    <tr>
        <td><%= resultSetAppService.getInt("app_code") %></td>
        <td><%= resultSetAppService.getInt("service_code") %></td>
        <td><%= resultSetAppService.getString("name") %></td>
        <td><%= resultSetAppService.getString("type") %></td>
        <td><%= resultSetAppService.getString("sub_type") %></td>
        <td><%= resultSetAppService.getString("description") %></td>
        <td><%= resultSetAppService.getTimestamp("last_modified") %></td>
    </tr>
    <%
        }
    %>
</table>

<%
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
    }
%>

</body>
</html>