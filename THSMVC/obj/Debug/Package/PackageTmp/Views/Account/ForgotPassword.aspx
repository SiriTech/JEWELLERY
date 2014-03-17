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
        <fieldset>
                <legend>Content</legend>
        </fieldset>
        </div>
        <div id="ForgotPassword" style="width:35%;float:right;">
            <fieldset>
                <legend>Retrieve Password</legend>
                
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
               
            </fieldset>
        </div>
        </div>
       
    <% } %>  
</asp:Content>
