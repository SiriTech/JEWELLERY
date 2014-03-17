<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<THSMVC.Models.CategoryModel>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Category</title>
    <script type="text/javascript">
        function SubmitCategory() {
            ClearMsg();
            var msg;
            msg = ""
            if ($("#OnlineTestCategory input[id=Category]").val() == "") {
                msg = "Category Name Required <br/>";
            }
            if (msg != "") {
                Failure(msg);
                return false;
            }
            $.ajax({
                type: "POST",
                url: "/OnlineTest/OnlineTestCategory",
                data: {
                    Category: $("#OnlineTestCategory input[id=Category]").val(),
                    Id: $("#hdnCatId").val()
                },
                dataType: "json",
                traditional: true,
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
            $("#OnlineTestCategory input[id=Category]").val("");
        }
        function CatSearch() {
            LoadContentByActionAndController("ManageCategory", "OnlineTest", "Manage Category");
        }
    </script>
</head>
<body>
   <div id="OnlineTestCategory">
        <div id="divbackToSearch" style="float: left;">
            <input type="button" class="rg_button_red upper" title="Back" value="Back To Categories"
                onclick="CatSearch()" />
        </div>
            <div class="clear">
                <div class="ContentdivHead" onclick="toggleContentDivHead(this,'#divCategory');">
                    <span class="divHeading"><%= Html.Encode(Model.text) %> Category</span> <span class="divRightHeading"><span
                        class="ValidationSpan">*</span> Indicates mandatory fields</span>
                </div>
                <div class="clear">
                    <div class="ContentdivBorder" id="divCategory">
                        <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                                <span class="ValidationSpan">*</span> Category
                            </div>
                            <div class="editor-field">
                                 <%= Html.TextBoxFor(m => m.Category, new { maxlength = 100, autocomplete = "off", title="Type in Category Name" })%>
                                 <%= Html.HiddenFor(m => m.Id, new { id="hdnCatId" })%>
                            </div>
                        </div>
                        <div id="divButtons" class="clear" style="margin-top: 10px;">
                            <center>
                                <input type="button" value="<%= Html.Encode(Model.text) %>" class="rg_button_red" onclick="SubmitCategory();return false;" />
                                <input type="button" value="Clear" class="rg_button" onclick="Clear();return false;" />
                            </center>
                        </div>
                       
                    </div>
                </div>
            </div>
        </div>
</body>
</html>
