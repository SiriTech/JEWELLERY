<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<THSMVC.Models.CreateTestModel>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>CreateTest</title>
    <script type="text/javascript">
        function SubmitTestName() {
            ClearMsg();
            var msg;
            msg = ""
            if ($("#CreateOnlineTest input[id=TestName]").val() == "") {
                msg = "Test Name Required <br/>";
            }
            if ($("#CreateOnlineTest select[id=CategoryId]").val() == "") {
                msg = msg + "Category Required";
            }
            if (msg != "") {
                Failure(msg);
                return false;
            }
            $.ajax({
                type: "POST",
                url: "/OnlineTest/CreateTestName",
                data:{
                TestName: $("#CreateOnlineTest input[id=TestName]").val(),
                CategoryId: $("#CreateOnlineTest select[id=CategoryId]").val(),
                Id: $("#hdnTestId").val()
                },
                dataType: "json",
                traditional:true,
                beforeSend: function () {
                     $.blockUI(); 
                },
                success: function (result) {
                    if (result.success) {
                        ClearMsg();
                        Success(result.message);
                    }
                    else
                        Failure(result.message);
                    $.unblockUI();
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    $.unblockUI();
                    Error(XMLHttpRequest, textStatus, errorThrown);
                }
            });
        }
        function Clear() {
            ClearMsg();
            $("#CreateOnlineTest input[id=TestName]").val("");
            $("#CreateOnlineTest select[id=CategoryId]").val("");
        }
        function TestSearch() {
            var menuId = $("#hdnMenuId").val();
            LoadFirstContent(menuId, "My Tests");
            //LoadContentByActionAndController("ManageTests", "OnlineTest", "My Tests");
        }
    </script>
</head>
<body>
    <div id="CreateOnlineTest">
     <div id="divbackToSearch" style="float: left;">
            <input type="button" class="rg_button_red upper" title="Back" value="Back To My Tests"
                onclick="TestSearch()" />
        </div>
            <div class="clear">
                <div class="ContentdivHead" onclick="toggleContentDivHead(this,'#divCreateTest');">
                    <span class="divHeading"><%= Html.Encode(Model.BtnText) %> Online Test</span> <span class="divRightHeading"><span
                        class="ValidationSpan">*</span> Indicates mandatory fields</span>
                </div>
                <div class="clear">
                    <div class="ContentdivBorder" id="divCreateTest">
                        <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                                <span class="ValidationSpan">*</span> Test Name
                            </div>
                            <div class="editor-field">
                                 <%= Html.TextBoxFor(m => m.TestName, new { maxlength = 50, autocomplete = "off", title="Type in your Test Name" })%>
                                 <%= Html.HiddenFor(m => m.Id, new { id="hdnTestId" })%>
                                  <%= Html.HiddenFor(m => m.MenuId, new { id="hdnMenuId" })%>
                            </div>
                        </div>
                        <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                                <span class="ValidationSpan">*</span> Category
                            </div>
                            <div class="editor-field">
                                 <%= Html.DropDownListFor(m => m.CategoryId, Model.Categories, "Select Category", new { title = "Select the Category" })%>
                            </div>
                        </div>
                        <div id="divButtons" class="clear" style="margin-top: 10px;">
                            <center>
                                <input type="button" value="<%= Html.Encode(Model.BtnText) %>" class="rg_button_red" onclick="SubmitTestName();return false;" />
                                <input type="button" value="Clear" class="rg_button" onclick="Clear();return false;" />
                            </center>
                        </div>
                       
                    </div>
                </div>
            </div>
        </div>
</body>
</html>
