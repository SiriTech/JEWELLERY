<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<THSMVC.Models.RegisterModel>" %>

<asp:Content ID="registerTitle" ContentPlaceHolderID="TitleContent" runat="server">
    Register
</asp:Content>

<asp:Content ID="registerContent" ContentPlaceHolderID="MainContent" runat="server">
   <script type="text/javascript">
       function Clear() {
           $("#Register input[type='text'] ").attr("value", "");
           $("#Register input[type='password'] ").attr("value", "");
       }
</script>
    <h2>
        Create a New Account</h2>
    <% using (Html.BeginForm())
       { %>
    <%: Html.ValidationSummary(true, "Account creation was unsuccessful. Please correct the errors and try again.") %>
    <div style="clear: both; display: inline-block; width: 100%;">
        <div style="width: 40%; float: left;">
            <fieldset>
                <legend>Account Information</legend>
                <div id="Register">
                    <div class="clear">
                        <div class="editor-label FloatLeft" style="width: 30%;">
                            <%: Html.LabelFor(m => m.UserName) %>
                        </div>
                        <div class="editor-field">
                            <%: Html.TextBoxFor(m => m.UserName) %>
                        </div>
                    </div>
                    <div class="clear">
                        <div class="editor-label FloatLeft" style="width: 30%;">
                            <%: Html.LabelFor(m => m.Email) %>
                        </div>
                        <div class="editor-field">
                            <%: Html.TextBoxFor(m => m.Email) %>
                        </div>
                    </div>
                    <div class="clear">
                        <div class="editor-label FloatLeft" style="width: 30%;">
                            <%: Html.LabelFor(m => m.Password) %>
                        </div>
                        <div class="editor-field">
                            <%: Html.PasswordFor(m => m.Password) %>
                        </div>
                    </div>
                    <div class="clear">
                        <div class="editor-label FloatLeft" style="width: 30%;">
                            <%: Html.LabelFor(m => m.ConfirmPassword) %>
                        </div>
                        <div class="editor-field">
                            <%: Html.PasswordFor(m => m.ConfirmPassword) %>
                        </div>
                    </div>
                    <%--<div class="clear">
                        <div class="editor-label FloatLeft" style="width: 30%;">
                            <%: Html.LabelFor(m => m.CreationMode) %>
                        </div>
                        <div class="editor-field">
                            <%: Html.DropDownList("SelectedCreationMode", Model.CreationMode)%>
                        </div>
                    </div>--%>
                    <div class="clear" style="margin-top: 10px;">
                     <div class="FloatRight" style="margin-right: 10%;">
                                <input type="submit" value="Register" /> 
                                 <input type="button" value="Clear" onclick="Clear();return false;" />
                                 </div>
                    </div>
                    <div style="margin-top: 5px;">
                        <center>
                            <div>
                                <%: Html.ValidationMessageFor(m => m.UserName) %>
                            </div>
                            <div>
                                <%: Html.ValidationMessageFor(m => m.Email) %>
                            </div>
                            <div>
                                <%: Html.ValidationMessageFor(m => m.Password) %>
                            </div>
                            <div>
                                <%: Html.ValidationMessageFor(m => m.ConfirmPassword) %>
                            </div>
                        </center>
                    </div>
                </div>
            </fieldset>
        </div>
        <div style="width: 58%; float: right;">
            <fieldset>
                <legend>Content</legend>
            </fieldset>
        </div>
    </div>
    <% } %>
    <script type="text/javascript">
        document.getElementById('Register').style.clear;
        document.getElementById('Register').className = 'linkChange';
    </script>
</asp:Content>
