<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<THSMVC.Models.AssignTestModel>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>AssignTest</title>
    
</head>
<body>
    <div class="clear">
        <div id="AssignTest">
            <div class="clear">
                <div class="ContentdivHead" onclick="toggleContentDivHead(this,'#divTestName');">
                    <span class="divHeading">Test Name</span>
                </div>
                <div class="clear">
                    <div class="ContentdivBorder" id="divTestName">
                        <div class="clear" style="text-align: center; margin-top: 10px;">
                            <span id="spnTestName" style="font-size: 25px; font-family: Arial,Sans-Serif;">
                                <%=Html.Encode(Model.TestName) %></span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="clear">
                <div class="ContentdivHead" onclick="toggleContentDivHead(this,'#divAssignUsers');">
                    <span class="divHeading">Users for this test</span>
                </div>
                <div class="clear">
                    <div class="ContentdivBorder" id="divAssignUsers">
                        <%if (Model.Assigned)
                          { %>
                        <%= Model.TreeView %>
                        <div>
                            Selected keys: <span id="echoSelection3">-</span></div>
                        <div>
                            Selected root keys: <span id="echoSelectionRootKeys3">-</span></div>
                        <div>
                            Selected root nodes: <span id="echoSelectionRoots3">-</span></div>
                        <%}
                          else
                          { %>
                        <div class="clear" style="text-align: center; margin-top: 10px;">
                            <span id="spnTestComments" style="font-size: 15px; font-family: Arial,Sans-Serif;
                                display: block;">No Users assigned to this test. Click "Assign Users" to assign
                                users to this test.</span><br />
                            <input type="button" class="g-button g-button-submit" id="btnAssignUsers" value="Assign Users"
                                style="margin-right: 5px;" />
                        </div>
                        <%} %>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%-- <script type="text/javascript">
        $(document).ready(function () {
            $("#browser").treeview();
        });
    </script>--%>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#tree3").dynatree({
                checkbox: true,
                selectMode: 3,
                onSelect: function (select, node) {
                    // Get a list of all selected nodes, and convert to a key array:
                    var selKeys = $.map(node.tree.getSelectedNodes(), function (node) {
                        return node.data.key;
                    });
                    $("#echoSelection3").text(selKeys.join(", "));

                    // Get a list of all selected TOP nodes
                    var selRootNodes = node.tree.getSelectedNodes(true);
                    // ... and convert to a key array:
                    var selRootKeys = $.map(selRootNodes, function (node) {
                        return node.data.key;
                    });
                    $("#echoSelectionRootKeys3").text(selRootKeys.join(", "));
                    $("#echoSelectionRoots3").text(selRootNodes.join(", "));
                },
                onDblClick: function (node, event) {
                    node.toggleSelect();
                },
                onKeydown: function (node, event) {
                    if (event.which == 32) {
                        node.toggleSelect();
                        return false;
                    }
                }
            });
            $('#tree3 .dynatree-icon').remove();
        });
    </script>
</body>
</html>
