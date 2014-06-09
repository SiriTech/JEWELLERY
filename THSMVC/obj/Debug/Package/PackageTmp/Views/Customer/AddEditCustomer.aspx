<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<THSMVC.Models.CustomerModel>" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript">
        $(document).ready(function () {
            

        });

        
        function Back() {
            ClearMsg();
            $("#divCustomerMaster").show();
            $("#CreateCustomer").show();
            $("#backToList").hide();
            $("#divCreateCustomer").hide();
            $("#list").trigger("reloadGrid");
        }

        function submitCustomer() {
            debugger;
            ClearMsg();
            var msg = '';
            if ($("#Name").val() == '') {
                msg = 'Please enter Customer Name<br/>';
            }
            if (msg != "") {
                Failure(msg);
                return;
            }
            $.ajax({
                type: "POST",
                url: "/Customer/SubmitCustomer",
                data: {
                    Id: $("#hdnID").val(),
                    Name: $("#Name").val(),
                    CustometNumber: $("#CustometNumber").val(),
                    Address: $("#Address").val(),
                    City: $("#City").val(),
                    State: $("#State").val(),
                    Pin: $("#Pin").val(),
                    Mobile: $('#Mobile').val(),
                    PhoneNumber: $("#PhoneNumber").val(),
                    EmailAddress: $("#EmailAddress").val()
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
                    <span class="divHeading">Customer</span>
                </div>
                <div class="clear">
                    
                    <div class="ContentdivBorder" id="divAddEditProduct">
                    <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                               <span class="ValidationSpan">*</span> Customer Name
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.Name, new { maxlength = 100, autocomplete = "off", title="Type in Customer Name" })%>
                            </div>
                        </div>
                         <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                                Address
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.Address, new { maxlength = 100, autocomplete = "off", title="Type in Customer Address" })%>
                            </div>
                        </div>
                        <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                                City
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.City, new { maxlength = 100, autocomplete = "off", title="Type in City" })%>
                            </div>
                        </div>
                        <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                                State
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.State, new { maxlength = 100, autocomplete = "off", title="Type in State" })%>
                            </div>
                        </div>
                        <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                                 Pin
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.Pin, new { maxlength = 6, autocomplete = "off", title="Type in Pin Number" })%>
                            </div>
                        </div>
                         <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                                Mobile Number
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.Mobile, new { maxlength = 12, autocomplete = "off", title="Type in Mobile Number" })%>
                            </div>
                        </div>
                        <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                                Phone Number
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.PhoneNumber, new { maxlength = 15, autocomplete = "off", title="Type in Phone Number" })%>
                            </div>
                        </div>
                        <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                                E-Mail Address
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.EmailAddress, new { maxlength = 50, autocomplete = "off", title="Type in E-Mail Address" })%>
                            </div>
                        </div>
                        <div id="divButtons" class="clear" style="margin-top: 10px; margin-bottom: 20px;">
                            <center>
                                <input type="button" value="<%= Model.BtnText %>" class="rg_button_red" onclick="submitCustomer(); return false;" />
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
