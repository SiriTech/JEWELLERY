<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<THSMVC.Models.ProductModel>" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript">
        $(document).ready(function () { $("#ProductName").focus(); });
        function Back() {
            ClearMsg();
            $("#divProductMaster").show();
            $("#CreateProduct").show();
            $("#backToList").hide();
            $("#divCreateProduct").hide();
            $("#list").trigger("reloadGrid");
        }
        function submitProduct() {
            ClearMsg();
            var msg = '';
            if ($("#ProductName").val() == '') {
                msg = 'Please enter Product Name<br/>';
            }
            if ($("#ProductCategoryId").val() == "") {
                msg += "Please select Product Category<br/>";
            }
            if ($("#ProductGroupId").val() == "") {
                msg += "Please select Product Group<br/>";
            }
            if (msg != "") {
                Failure(msg);
                return;
            }
            $.ajax({
                type: "POST",
                url: "/Product/SubmitProduct",
                data: {
                    Id: $("#hdnID").val(),
                    ProductName: $("#ProductName").val(),
                    ShortForm: $("#ShortForm").val(),
                    ValueAddedByPerc: $("#ValueAddedByPerc").val(),
                    ValueAddedFixed: $("#ValueAddedFixed").val(),
                    MakingChargesPerGram: $("#MakingChargesPerGram").val(),
                    MakingChargesFixed: $("#MakingChargesFixed").val(),
                    IsStone: $('#chkIsStone').is(':checked'),
                    IsWeightless: $("#chkIsWeightLess").is(':checked'),
                    ProductCategoryId: $("#ProductCategoryId").val(),
                    ProductGroupId: $("#ProductGroupId").val()
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
        <div id="AddEditProduct">
            <div class="clear">
                <div class="ContentdivHead" onclick="toggleContentDivHead(this,'#divAddEditProduct');">
                    <span class="divHeading">Product</span>
                </div>
                <div class="clear">
                    
                    <div class="ContentdivBorder" id="divAddEditProduct">
                    <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                               <span class="ValidationSpan">*</span> Product Category
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.DropDownListFor(m => m.ProductCategoryId, Model.ProductCategories, "Select Category", new { title="Select Product Category from the list" })%>
                            </div>
                        </div>
                         <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                               <span class="ValidationSpan">*</span> Product Group
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.DropDownListFor(m => m.ProductGroupId, Model.ProductGroups, "Select Group", new { title="Select Product Group from the list" })%>
                            </div>
                        </div>
                        <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                                <span class="ValidationSpan">*</span> Product Name
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.ProductName, new { maxlength = 100, autocomplete = "off", title="Type in Product Name" })%>
                            </div>
                        </div>
                        <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                                Short From
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.ShortForm, new { maxlength = 100, autocomplete = "off", title="Type in Short From" })%>
                            </div>
                        </div>
                        <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                                 Value Added By Percentage
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.ValueAddedByPerc, new { maxlength = 100, autocomplete = "off", title="Type in Value Added By Percentage" })%>
                            </div>
                        </div>
                         <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                                Value Added Fixed
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.ValueAddedFixed, new { maxlength = 100, autocomplete = "off", title="Type in Value Added Fixed" })%>
                            </div>
                        </div>
                        <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                                Making Charges Per Gram
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.MakingChargesPerGram, new { maxlength = 100, autocomplete = "off", title="Type in Making Charges Per Gram" })%>
                            </div>
                        </div>
                        <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                                Making Charges Fixed
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.MakingChargesFixed, new { maxlength = 100, autocomplete = "off", title="Type in Making Charges Fixed" })%>
                            </div>
                        </div>
                        <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                                Is Stone
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <% if(Model.IsStone){ %>
                                <input type="checkbox" id="chkIsStone" checked="checked" />
                                <%}else{ %>
                                <input type="checkbox" id="chkIsStone" />
                                <%} %>
                            </div>
                        </div>
                        <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                               Is Weightless
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <% if (Model.IsWeightless)
                                   { %>
                                <input type="checkbox" id="chkIsWeightLess" checked="checked" />
                                <%}else{ %>
                                <input type="checkbox" id="chkIsWeightLess" />
                                <%} %>
                            </div>
                        </div>
                        
                        <div id="divButtons" class="clear" style="margin-top: 10px; margin-bottom: 20px;">
                            <center>
                                <input type="button" value="<%= Model.BtnText %>" class="rg_button_red" onclick="submitProduct(); return false;" />
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
