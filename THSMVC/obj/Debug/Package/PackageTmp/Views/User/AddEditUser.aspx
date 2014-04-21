<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<THSMVC.Models.UserModel>" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript">
        $(document).ready(function () { $("#Name").focus(); });
        function Back() {
            ClearMsg();
            $("#divUserMaster").show();
            $("#CreateUser").show();
            $("#backToList").hide();
            $("#divCreateUser").hide();
            $("#list").trigger("reloadGrid");
        }
        function submitUser() {
            ClearMsg();
            var msg = '';
            if ($("#Name").val() == '') {
                msg = 'Please enter Name<br/>';
            }
            if ($("#Username").val() == '') {
                msg += 'Please enter Username<br/>';
            }
            if ($("#Password").val() == '') {
                msg += 'Please enter Password<br/>';
            }
            if ($("#RoleId").val() == '') {
                msg += 'Please enter RoleId<br/>';
            }
            
            if (msg != "") {
                Failure(msg);
                return;
            }
            $.ajax({
                type: "POST",
                url: "/User/SubmitUser",
                data: {
                    Id: $("#hdnID").val(),
                    Name: $("#Name").val(),
                    Address: $("#Address").val(),
                    City: $("#City").val(),
                    State: $("#State").val(),
                    PinCode: $("#PinCode").val(),
                    Mobile: $("#Mobile").val(),
                    Phone: $("#Phone").val(),
                    Email: $("#Email").val(),
                    Username: $("#Username").val(),
                    Password: $("#Password").val(),
                    RoleId: $("#RoleId").val()
                },
                dataType: "json",
                beforeSend: function () {
                    $.blockUI();
                },
                success: function (response) {
                    if (response.success) {
                        Success(response.message);
                    }
                    else
                        Failure(response.message);
                    $.unblockUI();
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    $.unblockUI();
                    Error(XMLHttpRequest, textStatus, errorThrown);
                }
            });
        }
    </script>
</head>
<body>
   <div class="clear">
        <div id="AddEditUser">
            <div class="clear">
                <div class="ContentdivHead" onclick="toggleContentDivHead(this,'#divAddEditUser');">
                    <span class="divHeading">User</span>
                </div>
                <div class="clear">
                    <div class="ContentdivBorder" id="divAddEditUser">
                        <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                                <span class="ValidationSpan">*</span> Name
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.Name, new { maxlength = 100, autocomplete = "off", title="Type in Name" })%>
                            </div>
                        </div>
                        <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                                Address
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.Address, new { maxlength = 100, autocomplete = "off", title="Type in Address" })%>
                            </div>
                        </div>
                        <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                                City
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.City, new { maxlength = 100, autocomplete = "off", title="Type in City" })%>
                            </div>
                        </div>
                        <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                                State
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.State, new { maxlength = 100, autocomplete = "off", title="Type in State" })%>
                            </div>
                        </div>
                        <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                                Pin Code
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.PinCode, new { maxlength = 100, autocomplete = "off", title="Type in Pin Code" })%>
                            </div>
                        </div>
                        <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                               Mobile
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.Mobile, new { maxlength = 100, autocomplete = "off", title="Type in Mobile" })%>
                            </div>
                        </div>
                         <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                               Phone
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.Phone, new { maxlength = 100, autocomplete = "off", title="Type in Phone" })%>
                            </div>
                        </div>
                         <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                               Email
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.Email, new { maxlength = 100, autocomplete = "off", title="Type in Email" })%>
                            </div>
                        </div>
                         <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                               <span class="ValidationSpan">*</span> Username
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.Username, new { maxlength = 100, autocomplete = "off", title="Type in Username" })%>
                            </div>
                        </div>
                         <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                               <span class="ValidationSpan">*</span> Password
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.Password, new { maxlength = 100, autocomplete = "off", title="Type in Password" })%>
                            </div>
                        </div>
                         <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                               <span class="ValidationSpan">*</span> Role
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.DropDownListFor(m => m.RoleId, Model.Roles, "Select Role", new { title="Select Role from the list" })%>
                            </div>
                        </div>
                        <div id="divButtons" class="clear" style="margin-top: 10px; margin-bottom: 20px;">
                            <center>
                                <input type="button" value="<%= Model.BtnText %>" class="rg_button_red" onclick="submitUser(); return false;" />
                                <input type="button" value="Clear" class="rg_button" onclick="clearForm(); return false;" />
                                <%= Html.HiddenFor(m => m.Id, new { id = "hdnID"})%>
                            </center>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
