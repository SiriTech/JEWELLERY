<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<THSMVC.Models.CreateMenuModel>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>CreateMenu</title>
    <script type="text/javascript">
        function GetOrder() {
            if ($("#MenuId").val() == "" || $("#GroupId").val() =="") {
                return;
            }
            else {
                $.ajax({
                    type: "POST",
                    url: "/Admin/GetOrder",
                    data: {
                        InstanceId: $("#InstanceId").val(),
                        MenuId: $("#MenuId").val(),
                        GroupId: $("#GroupId").val()
                    },
                    dataType: "json",
                    async: false,
                    beforeSend: function () {
                        $.blockUI();   //this is great plugin - 'blockUI'
                    },
                    success: function (result) {
                        ClearMsg();
                        $("#Order").val(result.message);
                        $.unblockUI();
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        $.unblockUI();
                        var errMsg = "<P>Error Loading: " + XMLHttpRequest.responseText + "<br/>";
                        $("#status").html(errMsg).show("slow");
                    }
                });
            }
        }
        function LoadParentMenus(obj) {
            $.ajax({
                type: "POST",
                url: "/Admin/LoadParentMenus",
                data: {
                    InstanceId: $("#InstanceId").val()
                },
                dataType: "json",
                async: false,
                beforeSend: function () {
                    $.blockUI();   //this is great plugin - 'blockUI'
                },
                success: function (menus) {
                    ClearMsg();
                    $("#CreateMenu select[id=MenuId]").find('option').remove();
                        $Menu = $("#CreateMenu select[id=MenuId]");
                        $Menu.append('<option value="">Select Parent Menu</option>');
                        $.each(menus, function (i, menu) {
                            $Menu.append('<option value="' + menu.Value + '">' + menu.Text + '</option>');
                        });
                        $.unblockUI();
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    $.unblockUI();
                    var errMsg = "<P>Error Loading: " + XMLHttpRequest.responseText + "<br/>";
                    $("#status").html(errMsg).show("slow");
                }
            });
        }
        function clearForm() {
            $('#UserGeneralInfo input[type=text],select').each(function () {
                $(this).val("");

                if ($(this).is("select") & $(this)[0].size > 1) {
                    $(this)[0].options.length = 0;
                }
            });
        }
        function CreateMenu() {
            ClearMsg();
            $("#statusDiv").css("display", "none");
            var msg;
            msg = ""
            if ($("#CreateMenu select[id=InstanceId]").val() == "") {
                msg = msg +  "Instance Required <br/>";
            }
            if ($("#CreateMenu input[id=Name]").val() == "") {
                msg = msg + "Name Required <br/>";
            }
            if ($("#CreateMenu input[id=ActionName]").val() == "") {
                msg = msg + "Action Name Required <br/>";
            }
            if ($("#CreateMenu input[id=ControllerName]").val() == "") {
                msg = msg + "Controller Name Required <br/>";
            }
            if ($("#CreateMenu input[id=Order]").val() == "") {
                msg = msg + "Order Required <br/>";
            }
            if ($("#CreateMenu input[id=Level]").val() == "") {
                msg = msg + "Level Required <br/>";
            }
            if (msg != "") {
                msg = "<center>" + msg + "</center>"
                $("#validationDiv").css("display", "block");
                document.getElementById('validationDiv').innerHTML = msg;
                $("#validationDiv").fadeTo(7000, 1).hide(1000);
                window.scroll(0, 0);
                return false;
            }
            if (msg == "") {
                $.ajax({
                    type: "POST",
                    url: "/Admin/CreateMenu",
                    data: {
                        InstanceId: $("#InstanceId").val(),
                        MenuId: $("#MenuId").val(),
                        Name: $("#Name").val(),
                        ActionName: $("#ActionName").val(),
                        ControllerName: $("#ControllerName").val(),
                        GroupId: $("#GroupId").val(),
                        Order: $("#Order").val(),
                        Level: $("#Level").val()
                    },
                    dataType: "json",
                    async: false,
                    beforeSend: function () {
                        $.blockUI();   //this is great plugin - 'blockUI'
                    },
                    success: function (result) {
                        if (result.success) {
                            Success(result.message);
                        }
                        else {
                            Failure(result.message);
                        }
                        $.unblockUI();
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        $.unblockUI();
                        var errMsg = "<P>Error Loading: " + XMLHttpRequest.responseText + "<br/>";
                        $("#status").html(errMsg).show("slow");
                    }
                });
            }
        }
    </script>
</head>
<body>
    <div id="CreateMenu">
    <div id="validationDiv" style="margin-top: 10px; font-weight: bold; color: Red;">
                    </div>
                    <div id="statusDiv" style="margin-top: 10px;">
                        <center>
                            <span id="_status" style="font-size: 1px; font-weight: bold;"></span>
                        </center>
                    </div>
        <div class="clear">
            <div class="divHead">
                <span class="divHeading">Create Menu</span>
            </div>
            <div class="clear">
                <div class="divBorder">
                    <div class="clear">
                        <div class="editor-label FloatLeft" style="width: 40%;">
                           <span class="ValidationSpan">*</span> Instance
                        </div>
                        <div class="editor-field">
                            <%= Html.DropDownListFor(m => m.InstanceId, Model.Instances, "Select Instance", new { onchange="LoadParentMenus(this);" })%>
                        </div>
                    </div>
                    <div class="clear">
                        <div class="editor-label FloatLeft" style="width: 40%;">
                             Parent Menu
                        </div>
                        <div class="editor-field">
                             <%= Html.DropDownListFor(m => m.MenuId, Model.Menus, "Select Parent Menu")%>
                        </div>
                    </div>
                    <div class="clear">
                        <div class="editor-label FloatLeft" style="width: 40%;">
                            <span class="ValidationSpan">*</span> Menu Name
                        </div>
                        <div class="editor-field">
                            <%= Html.TextBoxFor(m => m.Name, new { maxlength = 100, autocomplete = "off" })%>
                        </div>
                    </div>
                    <div class="clear">
                        <div class="editor-label FloatLeft" style="width: 40%;">
                            <span class="ValidationSpan">*</span> Action
                        </div>
                        <div class="editor-field">
                            <%= Html.TextBoxFor(m => m.ActionName, new { maxlength = 200, autocomplete = "off" })%>
                        </div>
                    </div>
                    <div class="clear">
                        <div class="editor-label FloatLeft" style="width: 40%;">
                           <span class="ValidationSpan">*</span> Controller
                        </div>
                        <div class="editor-field">
                            <%= Html.TextBoxFor(m => m.ControllerName, new { maxlength = 200, autocomplete = "off" })%>
                        </div>
                    </div>
                    <div class="clear">
                        <div class="editor-label FloatLeft" style="width: 40%;">
                             <span class="ValidationSpan">*</span> Group
                        </div>
                        <div class="editor-field">
                             <%= Html.DropDownListFor(m => m.GroupId, Model.Groups, "Select Group", new { onchange="GetOrder();" })%>
                        </div>
                    </div>
                    <div class="clear">
                        <div class="editor-label FloatLeft" style="width: 40%;">
                            <span class="ValidationSpan">*</span> Order
                        </div>
                        <div class="editor-field">
                           <%= Html.TextBoxFor(m => m.Order, new { maxlength = 4, autocomplete = "off" })%>
                        </div>
                    </div>
                    <div class="clear">
                        <div class="editor-label FloatLeft" style="width: 40%;">
                            <span class="ValidationSpan">*</span> Level (0 or 1)
                        </div>
                        <div class="editor-field">
                             <%= Html.TextBoxFor(m => m.Level, new { maxlength = 4, autocomplete = "off" })%>
                        </div>
                    </div>
                    <div id="divButtons" class="clear" style="margin-top: 10px;">
                        <center>
                            <input type="button" value="Create" class="rg_button_red" onclick="CreateMenu();return false;" />
                            <input type="button" class="rg_button"  value="Clear" onclick="clearForm();return false;" />
                        </center>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
