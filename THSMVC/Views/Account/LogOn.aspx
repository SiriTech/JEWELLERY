<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<THSMVC.Models.LogOnModel>" %>

<asp:Content ID="loginTitle" ContentPlaceHolderID="TitleContent" runat="server">
    Log On
</asp:Content>

<asp:Content ID="loginContent" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        function Clear() {
            $("#LogOn input[type='text'] ").attr("value", "");
            $("#LogOn input[type='password'] ").attr("value", "");
            $("#statusDiv").css("display", "none");
        }
</script>
     <% using (Html.BeginForm()) { %>
        <div style="clear:both;width:100%;display:inline-block;">
        <div style="width:62%;float:left;">
        <div class="divHead">
                    <span class="divHeading">Jewels</span>
                </div>
                <div class="clear">
                    <div class="divBorder">
                        <%--<p>
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
                            softwares.</p>--%>
                    </div>
                </div>
        </div>
        <div id="LogOn" style="width:35%;float:right;">
                 <div class="divHead">
                    <span class="divHeading">LOG ON</span>
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
                
                <div class="editor-label">
                    <%: Html.LabelFor(m => m.Password) %>
                </div>
                <div class="editor-field">
                    <%: Html.PasswordFor(m => m.Password) %>
                    <%: Html.ValidationMessage("Password", "*")%>
                </div>
                
                <div class="editor-label">
                    <%: Html.CheckBoxFor(m => m.RememberMe) %>
                    <%: Html.LabelFor(m => m.RememberMe) %>
                </div>
                
                <p>
                    <input type="submit" value="Log On" class="rg_button_red" />
                    <input type="button" value="Clear" class="rg_button" onclick="Clear();return false;" />
                </p>
                 
                 <a href="/Account/ForgotPassword" id="Forgotpwd" >Forgot Password? Click here</a>
               
                <div id="statusDiv" style="margin-top:10px;">
                   
                     <%: Html.ValidationSummary(true, "Login was unsuccessful.") %>
                   
                    </div>
               </div>
               </div>
        </div>
        </div>
       
    <% } %>
</asp:Content>
