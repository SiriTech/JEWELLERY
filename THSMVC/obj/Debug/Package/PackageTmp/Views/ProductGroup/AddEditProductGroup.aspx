<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<THSMVC.Models.ProductGroupModel>" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript">
        $(document).ready(function () { $("#ProductGroup1").focus(); });
        function Back() {
            ClearMsg();
            $("#divProductGroupMaster").show();
            $("#CreateProductGroup").show();
            $("#backToList").hide();
            $("#divCreateProductGroup").hide();
            $("#list").trigger("reloadGrid");
        }
        function submitProductGroup() {
            ClearMsg();
            var msg = '';
            if ($("#ProductGroup1").val() == '') {
                msg= 'Please enter Product Group';
            }
            if (msg != "") {
                Failure(msg);
                return;
            }
            $.ajax({
                type: "POST",
                url: "/ProductGroup/SubmitProductGroup",
                data: {
                    Id: $("#hdnID").val(),
                    ProductGroup1: $("#ProductGroup1").val()
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
        <div id="AddEditProductGroup">
            <div class="clear">
                <div class="ContentdivHead" onclick="toggleContentDivHead(this,'#divAddEditProductGroup');">
                    <span class="divHeading">Product Group</span>
                </div>
                <div class="clear">
                    <div class="ContentdivBorder" id="divAddEditProductGroup">
                        <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                                <span class="ValidationSpan">*</span> Product Group
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.ProductGroup1, new { maxlength = 100, autocomplete = "off", title="Type in Product Group" })%>
                            </div>
                        </div>
                        <div id="divButtons" class="clear" style="margin-top: 10px; margin-bottom: 20px;">
                            <center>
                                <input type="button" value="<%= Model.BtnText %>" class="rg_button_red" onclick="submitProductGroup(); return false;" />
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
