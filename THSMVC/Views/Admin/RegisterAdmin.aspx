<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<THSMVC.Models.RegisterAdminModel>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>RegisterAdmin</title>
    <script type="text/javascript">
        function RegisterAdminClear() {
            $("#RegisterAdmin input[type='text'] ").attr("value", "");
            $("#RegisterAdmin input[type='password'] ").attr("value", "");
            $("#RegisterAdmin select").find('option:first').attr('selected', 'selected');
            ClearMsg();
        }
        function RegisterAdmin() {
            ClearMsg();
            $("#statusDiv").css("display", "none");
            
            var msg;
            msg = "";
            if (getElement('UserName').value == "") {
                msg = "User Name Required <br/>";
            }
            if (getElement('Email').value == "") {
                msg = msg + " Email Required <br/>";
            }
            if (getElement('Password').value == "") {

                msg = msg + " Password Required <br/>";
            }
            else {
                if (getElement('Password').value.length < 5) {
                    msg = msg + " Password must be atleast 5 characters long <br/>";
                }
            }
            if (getElement('ConfirmPassword').value == "") {
                msg = msg + " Confirm Password Required <br/>";
            }
            if (getElement('Password').value != getElement('ConfirmPassword').value) {
                msg = msg + " Password and Confirm password must be same ";
            }
            if (getElement('Instance').selectedIndex == 0) {
                msg = msg + " Select Instance <br/>";
            }
            if (msg != "") {
                msg = "<center>" + msg + "</center>"
                $("#validationDiv").css("display", "block");
                document.getElementById('validationDiv').innerHTML = " Please correct the following errors and try again <br/>" + msg;
                $("#validationDiv").fadeTo(10000, 1).hide(1000);
                window.scroll(0, 0);
                return false;
            }
            $.ajax(
            {
                type: "POST",
                url: "/Admin/RegisterAdmin",
                data: {
                    UserName: $("#UserName").val(),
                    Email: $("#Email").val(),
                    Password: $("#Password").val(),
                    Instance: $("#Instance").val()
                },
                beforeSend: function () {
                    $.blockUI();
                },
                complete: function () {
                    $.unblockUI();
                },
                success: function (result) {
                    if (result.success) {
                        Success(result.message);
                    }
                    else {
                        Failure(result.message);
                    }
                },
                error: function (req, status, error) {
                    Error(req, status, error);
                }
            });
        }
    </script>
</head>
<body>
    <div id="RegisterAdmin">
     <div id="validationDiv" style="margin-top: 10px; font-weight: bold; color: Red;">
                    </div>
                    <div id="statusDiv" style="margin-top: 10px;">
                        <center>
                            <span id="_status" style="font-size: 1px; font-weight: bold;"></span>
                        </center>
                    </div>
     <div class="clear">
            <div class="divHead">
                <span class="divHeading">Update Instance</span>
            </div>
            <div class="clear">
                <div class="divBorder">
        <div class="clear">
            <div class="editor-label FloatLeft" style="width: 40%;">
                <span class="ValidationSpan">*</span> User Name
            </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(m => m.UserName) %>
            </div>
        </div>
        <div class="clear">
            <div class="editor-label FloatLeft" style="width: 40%;">
                <span class="ValidationSpan">*</span> Email
            </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(m => m.Email) %>
            </div>
        </div>
        <div class="clear">
            <div class="editor-label FloatLeft" style="width: 40%;">
                <span class="ValidationSpan">*</span> Password
            </div>
            <div class="editor-field">
                <%: Html.PasswordFor(m => m.Password) %>
            </div>
        </div>
        <div class="clear">
            <div class="editor-label FloatLeft" style="width: 40%;">
                <span class="ValidationSpan">*</span> Confirm Password
            </div>
            <div class="editor-field">
                <%: Html.PasswordFor(m => m.ConfirmPassword) %>
            </div>
        </div>
        <div class="clear">
            <div class="editor-label FloatLeft" style="width: 40%;">
                <span class="ValidationSpan">*</span> Instance Name
            </div>
            <div class="editor-field">
                <%= Html.DropDownListFor(m => m.Instance, Model.Instances, "Select Instance")%>
            </div>
        </div>
        <div id="divButtons" class="clear" style="margin-top: 10px;">
            <center>
                <input type="button" value="Update" class="rg_button" onclick="RegisterAdmin();return false;" />
                <input type="button" value="Clear" class="rg_button" onclick="RegisterAdminClear();return false;" />
            </center>
        </div>
        </div>
        </div>
        </div>
    </div>
    <script type="text/javascript">
        // start tracking actovity  
        EnableTimeout(); 
    </script>
</body>
</html>
