<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<THSMVC.Models.LotMasterModel>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>CreateUser</title>
    <script type="text/javascript">
        $(document).ready(function () {
            $('#IsMRP').change(function () {
                if ($(this).is(':checked')) {
                    $("#divMRP").show();
                    $("#divWeight").hide();
                } else {
                    $("#divMRP").hide();
                    $("#divWeight").show();
                }
            });

            $("#Weight").keydown(function (event) {
                if (event.shiftKey == true) {
                    event.preventDefault();
                }

                if ((event.keyCode >= 48 && event.keyCode <= 57) || (event.keyCode >= 96 && event.keyCode <= 105) || event.keyCode == 8 || event.keyCode == 9 || event.keyCode == 37 || event.keyCode == 39 || event.keyCode == 46 || event.keyCode == 190) {

                } else {
                    event.preventDefault();
                }

                if ($(this).val().indexOf('.') !== -1 && event.keyCode == 190)
                    event.preventDefault();
            });
            $('#Weight').bind("cut copy paste", function (e) {
                e.preventDefault();
            });

            $("#MRP").keydown(function (event) {
                if (event.shiftKey == true) {
                    event.preventDefault();
                }

                if ((event.keyCode >= 48 && event.keyCode <= 57) || (event.keyCode >= 96 && event.keyCode <= 105) || event.keyCode == 8 || event.keyCode == 9 || event.keyCode == 37 || event.keyCode == 39 || event.keyCode == 46 || event.keyCode == 190) {

                } else {
                    event.preventDefault();
                }

                if ($(this).val().indexOf('.') !== -1 && event.keyCode == 190)
                    event.preventDefault();
            });
            $('#MRP').bind("cut copy paste", function (e) {
                e.preventDefault();
            });


            $("#Qty").keydown(function (event) {
                if (event.shiftKey == true) {
                    event.preventDefault();
                }

                if ((event.keyCode >= 48 && event.keyCode <= 57) || (event.keyCode >= 96 && event.keyCode <= 105) || event.keyCode == 8 || event.keyCode == 9 || event.keyCode == 37 || event.keyCode == 39 || event.keyCode == 46 || event.keyCode == 190) {

                } else {
                    event.preventDefault();
                }

                if ($(this).val().indexOf('.') !== -1 && event.keyCode == 190)
                    event.preventDefault();
            });
            $('#Qty').bind("cut copy paste", function (e) {
                e.preventDefault();
            });

        });

        function CheckForNumerics(event) {
            if (event.shiftKey == true) {
                event.preventDefault();
            }

            if ((event.keyCode >= 48 && event.keyCode <= 57) || (event.keyCode >= 96 && event.keyCode <= 105) || event.keyCode == 8 || event.keyCode == 9 || event.keyCode == 37 || event.keyCode == 39 || event.keyCode == 46 || event.keyCode == 190) {

            } else {
                event.preventDefault();
            }

            if ($(this).val().indexOf('.') !== -1 && event.keyCode == 190)
                event.preventDefault();

        }
        function clearForm() {
            $('#divCreateLot').find('input:text').val('');
            $('#divCreateLot').find(':checked').each(function () {
                $(this).removeAttr('checked');
            });
        }
    </script>
</head>
<body>

    <div id="divCreateLot" style="clear: both; width: 100%; display: block;">
         <div class="clear">
                <div class="ContentdivHead" onclick="toggleContentDivHead(this,'#divLotInfo');">
                    <span class="divHeading">Lot Information</span>
                </div>
                <div class="clear">
                    <div class="ContentdivBorder" id="divLotInfo">
                        <div class="clear">
                            <%-- <div class="FloatLeft" style="width: 80%;">--%>
                            <div class="clear">
                                    <div class="clear">
                                        <div class="editor-label FloatLeft" style="width: 40%;">
                                            <span class="ValidationSpan">*</span> Lot Name
                                        </div>
                                        <div class="editor-field" style="text-align: left;">
                                            <%= Html.TextBoxFor(m => m.LotName, new { maxlength = 10, autocomplete = "off", title="Type in Lot Name" })%>
                                        </div>
                                    </div>
                            </div>
                            
                            <div class="clear">
                                    <div class="clear">
                                        <div class="editor-label FloatLeft" style="width: 40%;">
                                            <span class="ValidationSpan">*</span> Product Group
                                        </div>
                                        <div class="editor-field" style="text-align: left;">
                                            <%-- <%= Html.TextBoxFor(m => m.ProductGroupId, new { maxlength = 10, autocomplete = "off", title="Type in Lot Name" })%>--%>
                                             <%=  Html.DropDownListFor(model => model.ProductGroupId, Model.ProductGroupList.Select(x => new SelectListItem { Text = x.ProductGroup1.ToString(), Value = x.Id.ToString() }),"Select Product Group")%>
                                        </div>
                                    </div>
                            </div>

                            <div class="clear">
                                    <div class="clear">
                                        <div class="editor-label FloatLeft" style="width: 40%;">
                                            Is MRP
                                        </div>
                                        <div class="editor-field" style="text-align: left;">
                                             <%--<%= Html.TextBoxFor(m => m.Qty, new { maxlength = 10, autocomplete = "off", title="Type in Lot Name" })%>--%>
                                           
                                             <%= Html.CheckBox("IsMRP", this.Model.IsMRP)%>
                                        </div>
                                    </div>
                            </div>

                            <div class="clear" id="divWeight">
                                    <div class="clear">
                                        <div class="editor-label FloatLeft" style="width: 40%;">
                                            <span class="ValidationSpan">*</span> Weight
                                        </div>
                                        <div class="editor-field" style="text-align: left;">
                                             <%= Html.TextBoxFor(m => m.Weight, new { maxlength = 10, autocomplete = "off", title="Type in Lot Name" })%>
                                        </div>
                                    </div>
                            </div>

                            <div class="clear" id="divMRP" style="display:none">
                                    <div class="clear">
                                        <div class="editor-label FloatLeft" style="width: 40%;">
                                          <span class="ValidationSpan">*</span>  MRP
                                        </div>
                                        <div class="editor-field" style="text-align: left;">
                                             <%= Html.TextBoxFor(m => m.MRP, new { autocomplete = "off", title="Type in MRP" })%>
                                        </div>
                                    </div>
                            </div>

                            <div class="clear">
                                    <div class="clear">
                                        <div class="editor-label FloatLeft" style="width: 40%;">
                                            <span class="ValidationSpan">*</span> No Of Peices
                                        </div>
                                        <div class="editor-field" style="text-align: left;">
                                             <%= Html.TextBoxFor(m => m.Qty, new { maxlength = 10, autocomplete = "off", title="Type in Lot Name" })%>
                                        </div>
                                    </div>
                            </div>

                            <div class="clear">
                                    <div class="clear">
                                        <div class="editor-label FloatLeft" style="width: 40%;">
                                             Dealer
                                        </div>
                                        <div class="editor-field" style="text-align: left;">
                                             <%--<%= Html.TextBoxFor(m => m.DealerId, new { maxlength = 10, autocomplete = "off", title="Type in Lot Name" })%>--%>
                                             <%=  Html.DropDownListFor(model => model.DealerId, Model.DealerList.Select(x => new SelectListItem { Text = x.DealerName.ToString(), Value = x.DealerId.ToString() }),"Select Dealer")%>
                                        </div>
                                    </div>
                            </div>

                            <div class="clear">
                                    <div class="clear">
                                        <div class="editor-label FloatLeft" style="width: 40%;">
                                            Difference allowed
                                        </div>
                                        <div class="editor-field" style="text-align: left;">
                                             <%= Html.TextBoxFor(m => m.DiffAllowed, new { autocomplete = "off", title="Enter Difference allowed" })%>
                                        </div>
                                    </div>
                            </div>
                           
                        </div>
                    </div>
                </div>
            </div>

            <div id="divButtons" class="clear" style="margin-top: 10px; margin-bottom: 20px;">
                <center>
                    <input type="button" value="OK, Create" class="rg_button_red" onclick="CreateLot_Submit();return false;" />
                    <input type="button" value="Clear" class="rg_button" onclick="clearForm();return false;" />
                    <%= Html.HiddenFor(m => m.LotId, new { id = "hdnLotID"})%>
                </center>
            </div>
    </div>
</body>
</html>