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
        <fieldset>
                <legend>Content</legend>
        </fieldset>
        </div>
        <div id="LogOn" style="width:35%;float:right;">
            <fieldset>
                <legend>Account Information</legend>
                
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
               
            </fieldset>
        </div>
        </div>
       
    <% } %>
</asp:Content>
