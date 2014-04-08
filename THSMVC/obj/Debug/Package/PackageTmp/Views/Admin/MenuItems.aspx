<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<THSMVC.Models.MenuItems>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>MenuItems</title>
    <style type="text/css">
        .MenuItems
        {
            height: 2em;
            padding-left: 10px;
        }
        div.ContentdivBorderMenu div:nth-child(even)
        {
            background: #FFFFFF;
        }
        div.ContentdivBorderMenu div:nth-child(odd)
        {
            background: #F3F5FC;
        }
    </style>
    <script src="../../Scripts/tristate-0.9.1-min.js" type="text/javascript"></script>
    <script type="text/javascript">
        function ExpandAll(obj) {
            //$("div[id^='divManageMenuItemsHead']").click();
            //$("div.ContentdivBorderMenu").show();
            if ($(obj).text() == "Expand All") {
                $(obj).text("Collapse All");
                $("div.ContentdivBorderMenu").show();
                $(".ContentdivHeadOverMenu").attr("class", "ContentdivHeadMenu");
            }
            else {
                $(obj).text("Expand All");
                $("div.ContentdivBorderMenu").hide();
                $(".ContentdivHeadMenu").attr("class", "ContentdivHeadOverMenu");
            }
        }
        function SelectAll(obj) {
            if ($(obj).text() == "Select All") {
                $(obj).text("UnSelect All");
                $("input:checkbox:not(:checked)").click();
            }
            else {
                $(obj).text("Select All");
                $("input:checkbox:checked").click();
            }
        }
        $("#btnAssignMenuCancel").click(function () {
            $("#divMenuItems").hide();
            $("#divSelectedRole").hide();
            $("#divManageRoles").show();
        });
        $("#btnAssignMenu").click(function () {
            var checkedItems = "";
            $('input:checkbox:checked').each(function () {
                checkedItems += $(this).attr("id") + ",";
            });
            $.ajax({
                type: "POST",
                url: "Admin/AssignRemoveMenuItems",
                data: "MenuItems=" + checkedItems + "&RoleId=" + $("#hdnRoleId").val(),
                dataType: "json",
                beforeSend: function () {
                    $.blockUI();   //this is great plugin - 'blockUI'
                },
                success: function (result) {
                    ClearMsg();
                    if (result.success)
                        Success(result.message);
                    else
                        Failure(result.message)
                    $.unblockUI();
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    $.unblockUI();
                    Error(XMLHttpRequest, textStatus, errorThrown);
                }
            });
        });
    </script>
</head>
<body>
    <input type="hidden" id="hdnRoleId" value="<%= Model.RoleId %>" />
    <div>
        <div class="clear">
            <div class="ContentdivHead" id="div1" onclick="toggleContentDivHead(this,'#divMenuitemcontent');">
                <span class="divHeading">SelectMenu items to assign/remove</span>
            </div>
            <div class="clear">
                <div class="ContentdivBorder" id="divMenuitemcontent" style="border: 1px solid #666;
                    padding-top: 20px;">
                    <div id="LeftMenu" style="width: 100%; margin-bottom: 3px;">
                        <div style="line-height: 2em;" class="leftMenudiv">
                            <a onclick="ExpandAll(this);" href="#">Expand All</a> &nbsp;&nbsp;<a onclick="SelectAll(this);"
                                href="#">Select All</a>
                        </div>
                    </div>
                    <div>
                        <% foreach (var p in Model.ParentMenuItems)
                           {
                               var name = p.Name.ToString().Replace(' ', '_');
                        %>
                        <div class="clear">
                            <div class="ContentdivHeadOverMenu" id="divManageMenuItemsHead<%=
    name %>" onclick="toggleContentDivHeadMenu(this,'#divManageMenuItemsContent<%= name
    %>');">
                                <span id="tristateBox<%= name %>" style="cursor: default;">&nbsp;
                                    <input type="hidden" id="tristateBoxState<%= name %>" name="tristateBoxState<%= name %>"
                                        value="0" />
                                </span><span class="divHeading">
                                    <%= p.Name %></span>
                            </div>
                            <div class="clear">
                                <div class="ContentdivBorderMenu" style="display: none; border: 1px solid #F3F5FC;"
                                    id="divManageMenuItemsContent<%= name %>">
                                    <% var lstSubMenuItems = Model.AllMenuItems.Where(s => s.ParentId == p.Id); foreach (var sub in lstSubMenuItems)
                                       { %>
                                    <%if (sub.@checked == 1)
                                      { %>
                                    <div class="MenuItems">
                                        <input type="checkbox" id="<%= sub.Id %>" checked="checked" />
                                        <%}
                                      else
                                      { %>
                                        <div class="MenuItems">
                                            <input id="<%= sub.Id %>" type="checkbox" />
                                            <%} %>
                                            <%= sub.Name%></div>
                                        <%} %>
                                        <script type="text/javascript"> initTriStateCheckBox('tristateBox<%=
    name %>', 'divManageMenuItemsContent<%= name %>', false); </script>
                                    </div>
                                </div>
                            </div>
                            <%} %>
                        </div>
                        <div id="divButtons" class="clear" style="margin-top: 10px;">
                            <center>
                                <input type="button" id="btnAssignMenu" value="Save" class="rg_button_red
    upper" title="Assign Menu Items" />
                                <input type="button" id="btnAssignMenuCancel" value="Cancel" class="rg_button" title="Cancel" />
                            </center>
                        </div>
                    </div>
                </div>
            </div>
        </div>
</body>
</html>
