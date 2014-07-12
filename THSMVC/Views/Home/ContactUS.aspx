<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	ContactUS
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<script type="text/javascript">
    function Clear() {
        $("#divSubmitQuery input[type='text'] ").attr("value", "");
        $("#divSubmitQuery textarea").attr("value", "");
        $("#statusDiv").css("display", "none");

    }
    function submitQuery() {
        $("#statusDiv").css("display", "none");
        var Name = document.getElementById('Name');
        var Email = document.getElementById('Email');
        var Phone = document.getElementById('Phone');
        var Query = document.getElementById('Query');
        var msg;
        msg = "";
        if (Name.value == "")
            msg = msg + "Name Required <br/>";
        if (Email.value == "")
            msg = msg + "Email Required <br/>";
        if (Phone.value == "")
            msg = msg + "Phone Required <br/>";
        if (Query.value == "")
            msg = msg + "Query Required";
        if (msg != "") {
            msg = "<center>" + msg + "</center>";
            $("#validationDiv").css("display", "block");
            document.getElementById('validationDiv').innerHTML = msg;
            $("#validationDiv").fadeTo(10000, 1).hide(1000);
            return false;
        }
        $.ajax(
            {
                type: "POST",
                url: "/Home/ContactUS",
                data: "Name=" + Name.value + "&Email=" + Email.value + "&Phone=" + Phone.value + "&Query=" + Query.value,
                beforeSend: function () {
                    $.blockUI();
                },
                complete: function () {
                    $.unblockUI();
                },
                success: function (result) {
                    if (result.success) {
                        $("#statusDiv").css("display", "block");
                        $("#_status").text(result.message); // show status message with animation
                        $("#_status").animate({ fontSize: "1em" }, { duration: 500 }).animate({ color: "green" }, { duration: 1000 });
                        $("#statusDiv").css("border", "1px dashed green");
                        $("#statusDiv").fadeTo(7000, 1).hide(1000);
                        $("#divSubmitQuery input[type='text'] ").attr("value", "");
                        $("#divSubmitQuery textarea").attr("value", "");
                    }
                    else {
                        $("#statusDiv").css("display", "block");
                        $("#_status").text(result.message); // show status message with animation
                        $("#_status").animate({ fontSize: "1em" }, { duration: 500 }).animate({ color: "red" }, { duration: 1000 });
                        $("#statusDiv").css("border", "1px dashed red");
                        $("#statusDiv").fadeTo(7000, 1).hide(1000);
                    }
                },
                error: function (req, status, error) {
                    $("#_status").slideDown(250).text("Sorry! Please try again later."); // show status message with animation
                }
            });

    }
    </script>
    <div class="clear">
        <div class="FloatRight" style="width: 49%;">
           <div class="divHead">
                            <span class="divHeading">LOCATED AT</span>
                        </div>
            <div class="clear">
                <div class="divBorder">
                    <div class="clear">
                        <div style="width: 50%; float: left; font-family: Helvetica, Arial, Verdana, sans-serif;
                            line-height: 20px; padding-top: 15px; padding-left: 15px;">
                            <strong>Dinesh</strong>
                            <%--<br />
                            B-4, Sai Saptagiri Residency<br />
                            Opp. Sanathnagar main bus stand.<br />
                            Sanathnagar. Hyderabad.<br />
                            Andhra Pradesh, India.<br />
                            <br />
                            Ph : +91 9603682175<br />
                            Email : <a href="mailto:kollisreekanth@gmail.com">kollisreekanth@gmail.com</a><br />--%>
                        </div>
                        <div style="float: right; width: 40%; padding-top: 15px;">
                            <img src="../../images/contactus.jpg" height="150px" width="100%" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div id="divSubmitQuery" style="width: 49%;float:left;">
               <div class="divHead">
                            <span class="divHeading">Submit Comments/Feedback</span>
                        </div>
            <div class="clear">
                <div class="divBorder">
                    <div class="clear">
                        <div class="editor-label FloatLeft" style="width: 30%;">
                           <span class="validation-summary-errors">*</span> Name
                        </div>
                        <div class="editor-field FloatLeft">
                            <input type="text" id="Name" />
                        </div>
                    </div>
                    <div class="clear">
                        <div class="editor-label FloatLeft" style="width: 30%;">
                           <span class="validation-summary-errors">*</span> Email
                        </div>
                        <div class="editor-field FloatLeft">
                            <input type="text" id="Email" />
                        </div>
                    </div>
                    <div class="clear">
                        <div class="editor-label FloatLeft" style="width: 30%;">
                           <span class="validation-summary-errors">*</span> Phone
                        </div>
                        <div class="editor-field FloatLeft">
                            <input type="text" id="Phone" />
                        </div>
                    </div>
                    <div class="clear">
                        <div class="editor-label FloatLeft" style="width: 30%;">
                           <span class="validation-summary-errors">*</span> Comments/Feedback
                        </div>
                        <div class="editor-field FloatLeft">
                           <textarea id="Query"></textarea>
                        </div>
                    </div>
                     <div class="clear" style="margin-top: 10px;">
                         <center>
                            <input type="submit" value="Submit" class="rg_button_red" onclick="submitQuery();return false;" />
                            <input type="button" value="Clear" class="rg_button" onclick="Clear();return false;" />
                        </center>
                    </div>
                    <div id="validationDiv" style="margin-top: 10px; font-weight: bold; color: Red;">
                    </div>
                     <div id="statusDiv" style="margin-top:10px;">
                    <center>
                    <span id="_status" style="font-size:1px;font-weight:bold;"></span>
                    </center>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        document.getElementById('Contact').className = 'menuChange';
    </script>
</asp:Content>
