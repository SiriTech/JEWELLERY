<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<THSMVC.Models.ProductCategoryModel>" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript">
        $(document).ready(function () { $("#ProductCategory1").focus(); });
        function Back() {
            ClearMsg();
            $("#divProductCategoryMaster").show();
            $("#CreateProductCategory").show();
            $("#backToList").hide();
            $("#divCreateProductCategory").hide();
            $("#list").trigger("reloadGrid");
        }
        function submitProductCategory() {
            ClearMsg();
            var msg = '';
            if ($("#ProductCategory1").val() == '') {
                msg = 'Please enter Product Category';
            }
            if (msg != "") {
                Failure(msg);
                return;
            }
            $.ajax({
                type: "POST",
                url: "/ProductCategory/SubmitProductCategory",
                data: {
                    Id: $("#hdnID").val(),
                    ProductCategory1: $("#ProductCategory1").val()
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
        <div id="AddEditProductCategory">
            <div class="clear">
                <div class="ContentdivHead" onclick="toggleContentDivHead(this,'#divAddEditProductCategory');">
                    <span class="divHeading">Product Category</span>
                </div>
                <div class="clear">
                    <div class="ContentdivBorder" id="divAddEditProductCategory">
                        <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                                <span class="ValidationSpan">*</span> Product Category
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.ProductCategory1, new { maxlength = 100, autocomplete = "off", title="Type in Product Category" })%>
                            </div>
                        </div>
                        <div id="divButtons" class="clear" style="margin-top: 10px; margin-bottom: 20px;">
                            <center>
                                <input type="button" value="<%= Model.BtnText %>" class="rg_button_red" onclick="submitProductCategory(); return false;" />
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
