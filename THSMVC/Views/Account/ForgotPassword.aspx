<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<THSMVC.Models.ForgotPasswordModel>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	ForgotPassword
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<script type="text/javascript">
    function Clear() {
        $("#ForgotPassword input[type='text'] ").attr("value", "");
        $("#statusDiv").css("display", "none");
    }
</script>
<% using (Html.BeginForm()) { %>
        <div style="clear:both;width:100%;display:inline-block;">
        <div style="width:62%;float:left;">
         <div class="divHead">
                    <span class="divHeading">EDU BOOK</span>
                </div>
                <div class="clear">
                    <div class="divBorder">
                        <p>
                            <font style="font-size: large">Edu Book</font> is an Online Management tool for
                            Schools/Colleges in the world. User data management, Attendance Management, Leave
                            management, Pay roll system, Automatic Timetable generation etc., in a secured way.
                            Edu Book provides value to your school/college.</p>
                        <p>
                            Edu Book collaborates Students, Parents and Teachers, So that the parents can enhance
                            their children's performance . Edu Book is a cloud based application, Which can
                            be accessed from anywhere in the world.</p>
                        <p>
                            Edu Book is providing <a style="color: Green;" href="/Home/ContactUS"><b>1 Month Free
                                Trail</b></a> for any school/college. Your Data during the trial period can
                            be maintained upto 30 days from your trial period expiration date.</p>
                        <p>
                            Edu Book is very cheap as never before, than any of the other school/college management
                            softwares.</p>
                    </div>
                </div>
        </div>
        <div id="ForgotPassword" style="width:35%;float:right;">
                 <div class="divHead">
                    <span class="divHeading">Retrieve Password</span>
                </div>
                 <div class="clear">
                    <div class="divBorder">
                <div class="editor-label">
                    <%: Html.LabelFor(m => m.UserName) %>
                </div>
                <div class="editor-field">
                    <%: Html.TextBoxFor(m => m.UserName) %>
                    <%: Html.ValidationMessage("UserName", "*")%>
                </div>
                <p>
                    <input type="submit" value="Submit" class="rg_button_red" />
                    <input type="button" value="Clear" class="rg_button" onclick="Clear();return false;" />
                </p>
                <div id="statusDiv" style="margin-top:10px;">
                    <center>
                        <%
                            if (ViewData["Password"] != null)
                            {
                        %>
                        <span id="_status" style="font-size: 12px; font-weight: bold;color:Green;"><%:ViewData["Password"]%></span>
                        <%
                            } %>
                    </center>
                    <%: Html.ValidationSummary(true, "unsuccessful.") %>
                    
                    
                    </div>
               </div>
               </div>
        </div>
        </div>
       
    <% } %>  
</asp:Content>
