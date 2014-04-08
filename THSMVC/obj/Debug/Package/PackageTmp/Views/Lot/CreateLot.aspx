<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<THSMVC.Models.LotMasterModel>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>CreateUser</title>
    <script type="text/javascript">
        $(document).ready(function () {
            
        });
      
        function clearForm() {

        }
    </script>
</head>
<body>

    <div style="clear: both; width: 100%; display: block;">
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
                                             <%= Html.TextBoxFor(m => m.ProductGroupId, new { maxlength = 10, autocomplete = "off", title="Type in Lot Name" })%>
                                        </div>
                                    </div>
                            </div>
                            <div class="clear">
                                    <div class="clear">
                                        <div class="editor-label FloatLeft" style="width: 40%;">
                                            <span class="ValidationSpan">*</span> Weight
                                        </div>
                                        <div class="editor-field" style="text-align: left;">
                                             <%= Html.TextBoxFor(m => m.Weight, new { maxlength = 10, autocomplete = "off", title="Type in Lot Name" })%>
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
                                            <span class="ValidationSpan">*</span> Dealer Id
                                        </div>
                                        <div class="editor-field" style="text-align: left;">
                                             <%= Html.TextBoxFor(m => m.DealerId, new { maxlength = 10, autocomplete = "off", title="Type in Lot Name" })%>
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