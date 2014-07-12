<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<THSMVC.Models.UserModel>" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript">
        $(document).ready(function () { $("#Name").focus(); });
        function Back() {
            ClearMsg();
            $("#divUserMaster").show();
            $("#CreateUser").show();
            $("#backToList").hide();
            $("#divCreateUser").hide();
            $("#list").trigger("reloadGrid");
        }
        function submitUser() {
            ClearMsg();
            var msg = '';
            if ($("#Name").val() == '') {
                msg = 'Please enter Name<br/>';
            }
//            if ($("#Username").val() == '') {
//                msg += 'Please enter Username<br/>';
//            }
//            if ($("#Password").val() == '') {
//                msg += 'Please enter Password<br/>';
//            }
            if ($("#RoleId").val() == '') {
                msg += 'Please select Role<br/>';
            }
            
            if (msg != "") {
                Failure(msg);
                return;
            }
            $.ajax({
                type: "POST",
                url: "/User/SubmitUser",
                data: {
                    Id: $("#hdnID").val(),
                    Name: $("#Name").val(),
                    Address: $("#Address").val(),
                    City: $("#City").val(),
                    State: $("#State").val(),
                    PinCode: $("#PinCode").val(),
                    Mobile: $("#Mobile").val(),
                    Phone: $("#Phone").val(),
                    Email: $("#Email").val(),
                    Username: $("#Username").val(),
                    Password: $("#Password").val(),
                    RoleId: $("#RoleId").val(),

                    Mobile2: $("#Mobile2").val(),
                    Mobile3: $("#Mobile3").val(),
                    Mobile4: $("#Mobile4").val(),
                    Email1: $("#Email1").val(),
                    Email2: $("#Email2").val(),
                    EducationQualiication: $("#EducationQualiication").val(),
                    Designation: $("#Designation").val(),
                    TempAddress: $("#TempAddress").val(),
                    TempCity: $("#TempCity").val(),
                    TempState: $("#TempState").val(),
                    TempPin: $("#TempPin").val(),
                    FatherPhone: $("#FatherPhone").val(),
                    MotherPhone: $("#MotherPhone").val(),
                    AdharNo: $("#AdharNo").val(),
                    PANNo: $("#PANNo").val()
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
        <div id="AddEditUser">
            <div class="clear">
                <div class="ContentdivHead" onclick="toggleContentDivHead(this,'#divAddEditUser');">
                    <span class="divHeading">User</span>
                </div>
                <div class="clear">
                    <div class="ContentdivBorder" id="divAddEditUser">
                        <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                                <span class="ValidationSpan">*</span> Name
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.Name, new { maxlength = 100, autocomplete = "off", title="Type in Name" })%>
                            </div>
                        </div>
                        <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                                Address
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.Address, new { maxlength = 100, autocomplete = "off", title="Type in Address" })%>
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
                                Pin Code
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.PinCode, new { maxlength = 100, autocomplete = "off", title="Type in Pin Code" })%>
                            </div>
                        </div>
                        <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                               Mobile
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.Mobile, new { maxlength = 100, autocomplete = "off", title="Type in Mobile" })%>
                            </div>
                        </div>

                        <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                               Mobile 2
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.Mobile2, new { maxlength = 100, autocomplete = "off", title="Type in Mobile" })%>
                            </div>
                        </div>

                        <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                               Mobile 3
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.Mobile3, new { maxlength = 100, autocomplete = "off", title="Type in Mobile" })%>
                            </div>
                        </div>

                        <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                               Mobile 4
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.Mobile4, new { maxlength = 100, autocomplete = "off", title="Type in Mobile" })%>
                            </div>
                        </div>

                         <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                               Phone
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.Phone, new { maxlength = 100, autocomplete = "off", title="Type in Phone" })%>
                            </div>
                        </div>
                         <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                               Email
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.Email, new { maxlength = 100, autocomplete = "off", title="Type in Email" })%>
                            </div>
                        </div>

                        <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                               Email 2
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.Email1, new { maxlength = 100, autocomplete = "off", title="Type in Mobile" })%>
                            </div>
                        </div>

                        <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                               Email 3
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.Email2, new { maxlength = 100, autocomplete = "off", title="Type in Mobile" })%>
                            </div>
                        </div>

                        <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                               EducationQualiication
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.EducationQualiication, new { maxlength = 100, autocomplete = "off", title="Type in Mobile" })%>
                            </div>
                        </div>

                        <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                               Designation
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.Designation, new { maxlength = 100, autocomplete = "off", title="Type in Mobile" })%>
                            </div>
                        </div>

                        <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                               Temp Address
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.TempAddress, new { maxlength = 100, autocomplete = "off", title="Type in Address" })%>
                            </div>
                        </div>
                       
                         <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                               Temp City
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.TempCity, new { maxlength = 100, autocomplete = "off", title="Type in City" })%>
                            </div>
                        </div>
                       
                         <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                               Temp State
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.TempState, new { maxlength = 100, autocomplete = "off", title="Type in State" })%>
                            </div>
                        </div>
                       
                         <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                               Temp Pin
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.TempPin, new { maxlength = 7, autocomplete = "off", title="Type in Pin" })%>
                            </div>
                        </div>
                        
                         <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                               Father Contact Number
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.FatherPhone, new { maxlength = 15, autocomplete = "off", title="Type in Father Mobile Number" })%>
                            </div>
                        </div>
                        
                         <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                               Mother Contact Number
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.MotherPhone, new { maxlength = 15, autocomplete = "off", title="Type in Mother contact number" })%>
                            </div>
                        </div>
                        
                         <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                               Adhar Numner
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.AdharNo, new { maxlength = 50, autocomplete = "off", title="Type in Adhar Number" })%>
                            </div>
                        </div>
                        
                         <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                               PAN Number
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.PANNo, new { maxlength = 30, autocomplete = "off", title="Type in PAN Number" })%>
                            </div>
                        </div>

                         <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                                Username
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.Username, new { maxlength = 100, autocomplete = "off", title="Type in Username" })%>
                            </div>
                        </div>
                         <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                                Password
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.Password, new { maxlength = 100, autocomplete = "off", title="Type in Password" })%>
                            </div>
                        </div>
                         <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                               <span class="ValidationSpan">*</span> Role
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.DropDownListFor(m => m.RoleId, Model.Roles, "Select Role", new { title="Select Role from the list" })%>
                            </div>
                        </div>
                        <div id="divButtons" class="clear" style="margin-top: 10px; margin-bottom: 20px;">
                            <center>
                                <input type="button" value="<%= Model.BtnText %>" class="rg_button_red" onclick="submitUser(); return false;" />
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
