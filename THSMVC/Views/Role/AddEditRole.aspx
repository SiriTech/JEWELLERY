<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<THSMVC.Models.RoleModel>" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <script type="text/javascript">
        $(document).ready(function () { $("#RoleName").focus(); });
        function Back() {
            ClearMsg();
            $("#divRoleMaster").show();
            $("#CreateRole").show();
            $("#backToList").hide();
            $("#divCreateRole").hide();
            $("#list").trigger("reloadGrid");
        }
        function submitRole() {
            ClearMsg();
            var msg = '';
            if ($("#RoleName").val() == '') {
                msg = 'Please enter Role';
            }
            if (msg != "") {
                Failure(msg);
                return;
            }
            $.ajax({
                type: "POST",
                url: "/Role/SubmitRole",
                data: {
                    Id: $("#hdnID").val(),
                    RoleName: $("#RoleName").val()
                },
                dataType: "json",
                beforeSend: function () {
                    $.blockUI();
                },
                success: function (response) {
                    if (response.success) {
                        Success(response.message);
                        setTimeout("Back();", 1000);
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
        <div id="AddEditRole">
            <div class="clear">
                <div class="ContentdivHead" onclick="toggleContentDivHead(this,'#divAddEditRole');">
                    <span class="divHeading">Role</span>
                </div>
                <div class="clear">
                    <div class="ContentdivBorder" id="divAddEditRole">
                        <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                                <span class="ValidationSpan">*</span> Role Name
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.RoleName, new { maxlength = 100, autocomplete = "off", title="Type in Role Name" })%>
                            </div>
                        </div>
                        <div id="divButtons" class="clear" style="margin-top: 10px; margin-bottom: 20px;">
                            <center>
                                <input type="button" value="<%= Model.BtnText %>" class="rg_button_red" onclick="submitRole(); return false;" />
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
