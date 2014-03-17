<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<%
    if (Session["UserId"] != null)
    {
%>
<img alt="settings" width="20px" height="20px" style="vertical-align:bottom;" src="../../images/Settings.png" /> Welcome <b><%=Page.User.Identity.Name.ToString() %></b>!
        [ <a id="LogOff" href="/Account/LogOff">Log Off</a> ]
<%
    }
    else {
%> 
        [ <a id="LogOn" href="/Account/LogOn">Log On</a> ]
         <%--Don't have an account? [ <a id="Register" href="/Account/Register">Register</a> ]--%>
<%
    }
%>

