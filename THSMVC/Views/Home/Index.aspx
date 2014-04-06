<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<THSMVC.Models.GoldRateModel>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Home Page
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="clear">
        <div class="editor-label FloatLeft" style="width: 35%;">
            
        </div>
        <div class="editor-field FloatLeft" style="width:32%;">
        <div class="clear">
        <div class="divHead FloatLeft">
            <span class="divHeading">Gold and Silver Rate</span>
        </div>
        <div class="clear">
            <div class="divBorder" style="background-color:rgb(78, 108, 122);color:White;">
                <div class="clear">
                    <div class="editor-label FloatLeft" style="width: 25%;">
                        <span class="ValidationSpan">*</span> Select City
                    </div>
                    <div class="editor-field FloatLeft">
                        <%= Html.DropDownListFor(m => m.goldRate, Model.goldRates,"Select City", new { onChange = "GoldRateChange();return false;", title = "Select City from the list" })%>
                    </div>
                </div>
                <div class="clear">
                    <div class="editor-label FloatLeft" style="width: 25%;padding-top:17px;font-weight:bolder;font-size:12px;">
                        Gold Rate
                    </div>
                    <div class="editor-field FloatLeft">
                    <%= Html.TextBoxFor(m => m.GoldWt, new { style = "width:65px;height:40px;font-size:25px;background-color:Yellow;" })%>
                        <%--<input type="text" id="txtGoldWeight"  value="Wt." />--%>
                        <span id="spnGoldEquals">=</span>
                        <%= Html.TextBoxFor(m => m.GoldPrice, new { style = "width:125px;height:40px;font-size:25px;background-color:Yellow;" })%>
                       <%-- <input type="text" id="txtGoldPrice" value="Price" style="width:125px;height:40px;font-size:25px;background-color:Yellow;" />--%>
                    </div>
                </div>
                <div class="clear">
                    <div class="editor-label FloatLeft" style="width: 25%;padding-top:17px;font-weight:bolder;font-size:12px;">
                        Silver Rate
                    </div>
                    <div class="editor-field FloatLeft">
                    <%= Html.TextBoxFor(m => m.SilverWt, new { style = "width:65px;height:40px;font-size:25px;background-color:#E7E0E0;" })%>
                        <%--<input type="text" id="txtSilverWeight" value="Wt." style="width:65px;height:40px;font-size:25px;background-color:#E7E0E0;" />--%>
                        <span id="spnSilverEquals">=</span>
                        <%= Html.TextBoxFor(m => m.SilverPrice, new { style = "width:125px;height:40px;font-size:25px;background-color:#E7E0E0;" })%>
                        <%--<input type="text" id="txtSilverPrice" value="Price" style="width:125px;height:40px;font-size:25px;background-color:#E7E0E0;" />--%>
                    </div>
                </div>
                <% if (!Model.IsConnected)
                   { %>
                 <div id="divButtons" class="clear" style="margin-top: 10px; margin-bottom: 5px;">
                <center>
                    <input type="button" value="Update" id="btnSave" class="rg_button_red" onclick="UpdateRates();return false;" />
                </center>
            </div>
            <%} %>
            </div>
        </div>
    </div>
        </div>
    </div>
    
    <script type="text/javascript">
        document.getElementById('Home').className = 'menuChange';
        var City = '<%=Model.SelectedCity %>';
        $("#goldRate option:contains(" + City + ")").attr('selected', true);
        function UpdateRates() {
            var val = $("#goldRate").find(":selected").val();
            var goldWt = $("#GoldWt").val();
            var goldPrice = $("#GoldPrice").val();
            var silverWt = $("#SilverWt").val();
            var silverPrice = $("#SilverPrice").val();
            var value = $("#goldRate").find(":selected").text();
            if (val == "") {
                alert("Please select City");
                return;
            }
            if (goldWt == "") {
                alert("Please enter Gold Weight");
                return;
            }
            if (goldPrice == "") {
                alert("Please enter Gold Price");
                return;
            }
            if (silverWt == "") {
                alert("Please enter Silver Weight");
                return;
            }
            if (silverPrice == "") {
                alert("Please enter Silver Price");
                return;
            }
            $.ajax({
                type: "POST",
                url: "/Home/UpdateGoldRate",
                data: { GoldWt: goldWt, GoldPrice: goldPrice, SilverWt: silverWt, SilverPrice: silverPrice, SelectedCity: value },
                dataType: "json",
                beforeSend: function () {
                    $.blockUI();   //this is great plugin - 'blockUI'
                },
                success: function (result) {

                    $.unblockUI();
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    $.unblockUI();
                    Error(XMLHttpRequest, textStatus, errorThrown);
                }
            });
        }
        function GoldRateChange() {
            var value = $("#goldRate").find(":selected").text();
            var val = $("#goldRate").find(":selected").val();
            if (val != "" && val != "$") {
                $.ajax({
                    type: "POST",
                    url: "/Home/GetGoldRate",
                    data: "Url=" + val,
                    dataType: "json",
                    beforeSend: function () {
                        $.blockUI();   //this is great plugin - 'blockUI'
                    },
                    success: function (result) {
                        if (result.success) {
                            $("#GoldWt").val(result.GoldWt);
                            $("#GoldPrice").val(result.GoldRate);
                            $("#SilverWt").val(result.SilverWt);
                            $("#SilverPrice").val(result.SilverRate);
                            $("#btnSave").hide();
                        }
                        else {
                            $("#GoldWt").val("No");
                            $("#GoldPrice").val("Connection");
                            $("#SilverWt").val("No");
                            $("#SilverPrice").val("Connection");
                            $("#btnSave").show();
                        }
                        $.unblockUI();
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        $.unblockUI();
                        Error(XMLHttpRequest, textStatus, errorThrown);
                    }
                });
            }
            else {
                $("#txtGoldWeight").val("Wt.");
                $("#txtGoldPrice").val("Price");
                $("#txtSilverWeight").val("Wt.");
                $("#txtSilverPrice").val("Price");
            }
            return;
        }
    </script>
</asp:Content>
