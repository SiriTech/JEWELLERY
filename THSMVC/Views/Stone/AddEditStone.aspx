<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<THSMVC.Models.StoneModel>" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <script type="text/javascript">
        $(document).ready(function () { $("#StoneName").focus(); });
        function Back() {
            ClearMsg();
            $("#divStoneMaster").show();
            $("#CreateStone").show();
            $("#backToList").hide();
            $("#divCreateStone").hide();
            $("#list").trigger("reloadGrid");
        }
        function submitStone() {
            ClearMsg();
            var msg = '';
            if ($("#StoneName").val() == '') {
                msg = 'Please enter Stone Name<br/>';
            }
            if ($("#StoneShortForm").val() == '') {
                msg += 'Please enter Stone Short Form<br/>';
            }
            if (msg != "") {
                Failure(msg);
                return;
            }
            $.ajax({
                type: "POST",
                url: "/Stone/SubmitStone",
                data: {
                    Id: $("#hdnID").val(),
                    StoneName: $("#StoneName").val(),
                    StoneShortForm: $("#StoneShortForm").val(),
                    StonePerCarat: $("#StonePerCarat").val(),
                    IsStoneWeightless: $("#chkIsWeightLess").is(':checked')
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
        <div id="AddEditStone">
            <div class="clear">
                <div class="ContentdivHead" onclick="toggleContentDivHead(this,'#divAddEditStone');">
                    <span class="divHeading">Stone</span>
                </div>
                <div class="clear">
                    <div class="ContentdivBorder" id="divAddEditStone">
                        <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                                <span class="ValidationSpan">*</span> Stone Name
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.StoneName, new { maxlength = 100, autocomplete = "off", title="Type in Stone Name" })%>
                            </div>
                        </div>
                        <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                                <span class="ValidationSpan">*</span> Stone Short Form
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.StoneShortForm, new { maxlength = 100, autocomplete = "off", title="Type in Stone Short form" })%>
                            </div>
                        </div>
                         <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                                 Stone Per Carat
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.StonePerCarat, new { maxlength = 100, autocomplete = "off", title="Type in Stone Per Carat" })%>
                            </div>
                        </div>
                        <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                               Is Stone Weightless
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <% if (Model.IsStoneWeightless)
                                   { %>
                                <input type="checkbox" id="chkIsWeightLess" checked="checked" />
                                <%}else{ %>
                                <input type="checkbox" id="chkIsWeightLess" />
                                <%} %>
                            </div>
                        </div>
                        <div id="divButtons" class="clear" style="margin-top: 10px; margin-bottom: 20px;">
                            <center>
                                <input type="button" value="<%= Model.BtnText %>" class="rg_button_red" onclick="submitStone(); return false;" />
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
