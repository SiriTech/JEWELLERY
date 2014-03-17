<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<IEnumerable<THSMVC.Models.ManageRole>>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>ManageRoles</title>
    <script type="text/javascript">
        function GetMenuItemsByRole(obj) {
            $("#spnSelectedRole").text($(obj).text());
            $.ajax({
                type: "POST",
                url: "Admin/GetMenuItemsByRole",
                data: "RoleId=" + $(obj).attr("id"),
                dataType: "html",
                beforeSend: function () {
                    $.blockUI();   //this is great plugin - 'blockUI'
                },
                success: function (result) {
                    $("#divSelectedRole").show();
                    $("#divMenuItems").show();
                    $("#divManageRoles").hide();
                    $("#divMenuItems").html(result);
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
        <div id="divManageRoles">
            <div class="clear">
                <div class="ContentdivHead" id="divManageRoleHead" onclick="toggleContentDivHead(this,'#divManageRole');">
                    <span class="divHeading">Select Role to assign/remove menu items</span>
                </div>
                <div class="clear">
                    <div class="ContentdivBorder" id="divManageRole">
                        <table width="100%" class="gm" id="tblTemplatePreview">
                            <thead>
                                <tr>
                                    <th class="gm">
                                        Role
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                                <% bool chk = true;
                                   foreach (var p in Model)
                                   {
                                       chk = false;
                                %>
                                <tr>
                                    <td class="gm">
                                        <a id="<%= p.RoleId %>" onclick="GetMenuItemsByRole(this);" style="cursor: pointer;
                                            font-weight: bold; color: Gray;"><span>
                                                <%= p.RoleName %></span></a>
                                    </td>
                                </tr>
                                <%} %>
                                <% if (chk)
                                   { %>
                                <tr>
                                    <td colspan="3">
                                        Oops! Something went wrong!.
                                    </td>
                                </tr>
                                <%}
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <div id="divSelectedRole" style="display:none;">
            <div class="clear">
                <div class="ContentdivHead" id="div1" onclick="toggleContentDivHead(this,'#divSelectedRolecontent');">
                    <span class="divHeading">Selected Role</span>
                </div>
                <div class="clear">
                    <div class="ContentdivBorder" id="divSelectedRolecontent" style="border:1px solid #FEF5FC;">
                    <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 50%;">
                               <b>Selected Role:</b>
                            </div>
                            <div class="editor-field">
                                <span id="spnSelectedRole" style="color: Purple; font-size: 14px;"></span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div id="divMenuItems"></div>
    </div>
</body>
</html>
