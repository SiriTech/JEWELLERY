<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<THSMVC.Models.UserGeneralInfoModel>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>UserGeneralInfo</title>
    <script type="text/javascript">
        function ClosePopup() {
            $.modal.close({ persist: true });
        }
        function ShowPhotoFunc() {
            $("#basic-modal-content").modal({ persist: true, minHeight : 300 });
        }
        function submitUserGeneralInfo() {
            ClearMsg();
            $("#statusDiv").css("display", "none");
            var msg;
            msg = ""
            if ($("#UserGeneralInfo select[id=Role]").val() == "") {
                msg = "Role Required <br/>";
            }
            if ($("#UserGeneralInfo select[id=Batch]").val() == "") {
                msg = msg + " Session Required <br/>";
            }
            if ($("#UserGeneralInfo input[id=FirstName]").val() == "") {
                msg = msg + " First Name Required <br/>";
            }
            if ($("#spnLastNameRequired").text() == "*") {
                if ($("#UserGeneralInfo input[id=LastName]").val() == "") {
                    msg = msg + " Last Name Required <br/>";
                }
            }
            if ($("#UserGeneralInfo input[id=DisplayName]").val() == "") {
                msg = msg + " DisplayName Required <br/>";
            }
            else {

                $.ajax({
                    type: "POST",
                    url: "/Admin/ChkDuplicateDisplayName",
                    data: "Name=" + $("#UserGeneralInfo input[id=DisplayName]").val(),
                    dataType: "json",
                    async: false,
                    beforeSend: function () {
                        // $.blockUI();   //this is great plugin - 'blockUI'
                    },
                    success: function (result) {

                        if (result.success) {
                            ClearMsg();
                            //Success(result.message);
                        }
                        else {
                            msg = msg + " Display Name already Exists. <br/>";
                        }
                        // $.unblockUI();
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        //$.unblockUI();
                        var errMsg = "<P>Error Loading: " + XMLHttpRequest.responseText + "<br/>";
                        $("#status").html(errMsg).show("slow");
                    }
                });
            }
            if ($("#UserGeneralInfo select[id=Gender]").val() == "") {
                msg = msg + " Gender Required <br/>";
            }
            if ($("#spnDateofJoiningRequired").text() == "*") {
                if ($("#UserGeneralInfo input[id=strDateOfJoining]").val() == "") {
                    msg = msg + " Date Of Joining Required <br/>";
                }
            }
            if ($("#spnAdmissionDtRequired").text() == "*") {
                if ($("#UserGeneralInfo input[id=strAdmissionDate]").val() == "") {
                    msg = msg + " Admission Date Required <br/>";
                }
            }
            if ($("#spnAdmissionNoRequired").text() == "*") {
                if ($("#UserGeneralInfo input[id=AdmissionNo]").val() == "") {
                    msg = msg + " Admission No. Required <br/>";
                }
            }
            if ($("#UserGeneralInfo select[id=Class]").val() == "") {
                msg = msg + " Class Required <br/>";
            }
            if ($("#spnSectionRequiredFld").is(':hidden')) { } else {
                if ($("#UserGeneralInfo select[id=Section]").val() == "") {
                    msg = msg + " Section Required <br/>";
                }
            }
            if ($("#UserGeneralInfo input[id=UserName]").val() == "") {
                msg = msg + " User Name Required <br/>";
            }
            else {
                $.ajax({
                    type: "POST",
                    url: "/Admin/ChkDuplicateUserName",
                    data: "Name=" + $("#UserGeneralInfo input[id=UserName]").val(),
                    dataType: "json",
                    async: false,
                    beforeSend: function () {
                        // $.blockUI();   //this is great plugin - 'blockUI'
                    },
                    success: function (result) {
                        if (result.success) {
                            ClearMsg();
                            //Success(result.message);
                        }
                        else {
                            msg = msg + " User Name already Exists. <br/>";
                        }
                        // $.unblockUI();
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        $.unblockUI();
                        Error(XMLHttpRequest, textStatus, errorThrown);
                    }
                });
            }
            if ($("#UserGeneralInfo input[id=Password]").val() == "") {
                msg = msg + " Password Required <br/>";
            }
            else {
                if ($("#UserGeneralInfo input[id=Password]").val().length < 5) {
                    msg = msg + " Password must be atleast '5' characters long <br/>";
                }
            }
            if ($("#UserGeneralInfo input[id=ConfirmPassword]").val() == "") {
                msg = msg + " Confirm Password Required <br/>";
            }
            if ($("#UserGeneralInfo input[id=Password]").val() != $("#UserGeneralInfo input[id=ConfirmPassword]").val()) {
                msg = msg + " New Password and Confirm password must be same ";
            }

            if (msg != "") {
                //                msg = "<center>" + msg + "</center>"
                //                $("#validationDiv").css("display", "block");
                //                document.getElementById('validationDiv').innerHTML = msg;
                //                $("#validationDiv").fadeTo(7000, 1).hide(1000);
                //                window.scroll(0, 0);
                //                return false;
                Failure(msg);
                return false;
            }

            var Disabilityarr = [];
            $("#Disability option").each(function (i) {
                if ($(this).attr('selected')) {
                    if ($(this).val() != "") {
                        Disabilityarr.push($(this).val());
                    }
                }
            });
            var FoodOfferingarr = [];
            $("#FoodOffering option").each(function (j) {
                if ($(this).attr('selected')) {
                    if ($(this).val() != "") {
                        FoodOfferingarr.push($(this).val());
                    }
                }
            });
            var DietaryNeedsarr = [];
            $("#DietaryNeed option").each(function (k) {
                if ($(this).attr('selected')) {
                    if ($(this).val() != "") {
                        DietaryNeedsarr.push($(this).val());
                    }
                }
            });
            $.ajax({
                type: "POST",
                traditional: true,
                url: "/Admin/UserGeneralInfo",
                data: {
                    UserName: $("#UserGeneralInfo input[id=UserName]").val(),
                    Password: $("#UserGeneralInfo input[id=Password]").val(),
                    Role: $("#UserGeneralInfo select[id=Role]").val(),
                    RoleName: $("#UserGeneralInfo select[id=Role]").find(":selected").text(),
                    FirstName: $("#UserGeneralInfo input[id=FirstName]").val(),
                    LastName: $("#UserGeneralInfo input[id=LastName]").val(),
                    DisplayName: $("#UserGeneralInfo input[id=DisplayName]").val(),
                    Gender: $("#UserGeneralInfo select[id=Gender]").val(),
                    Designation: $("#UserGeneralInfo select[id=Designation]").val(),
                    Qualification: $("#UserGeneralInfo input[id=Qualification]").val(),
                    EmployeeId: $("#UserGeneralInfo input[id=EmployeeId]").val(),
                    AdmissionNo: $("#UserGeneralInfo input[id=AdmissionNo]").val(),
                    strAdmissionDate: $("#UserGeneralInfo input[id=strAdmissionDate]").val(),
                    Batch: $("#UserGeneralInfo select[id=Batch]").val(),
                    RollNo: $("#UserGeneralInfo input[id=RollNo]").val(),
                    strDateOfJoining: $("#UserGeneralInfo input[id=strDateOfJoining]").val(),
                    BloodGroup: $("#UserGeneralInfo select[id=BloodGroup]").val(),
                    Transport: $("#UserGeneralInfo select[id=Transport]").val(),
                    Referrel: $("#UserGeneralInfo select[id=Referrel]").val(),
                    FeeCategory: $("#UserGeneralInfo select[id=FeeCategory]").val(),
                    Class: $("#UserGeneralInfo select[id=Class]").val(),
                    Section: $("#UserGeneralInfo select[id=Section]").val(),
                    Sibling: $("#UserGeneralInfo select[id=Sibling]").val(),
                    IdentificationMarks: $("#UserGeneralInfo textarea[id=IdentificationMarks]").val(),
                    PhotoName: $("#hdnPhotoName").val(),
                    PhotoSize: $("#hdnPhotoSize").val(),
                    ArrFoodOffering: FoodOfferingarr,
                    ArrDietaryNeed: DietaryNeedsarr,
                    ArrDisability: Disabilityarr
                },
                dataType: "json",
                beforeSend: function () {
                    $.blockUI();   //this is great plugin - 'blockUI'
                },
                success: function (result) {
                    if (result.success) {

                        $("#toc li").attr("class", "");
                        $("#toc li[id=liPersonal]").attr("class", "current");
                        GetContentByActionAndController('UserPersonalInfo', 'Admin', 'Create User', '.TabContent');
                        Success(result.message);
                    }
                    else {
                        Failure(result.message);
                    }
                    $.unblockUI();
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    $.unblockUI();
                    Error(XMLHttpRequest, textStatus, errorThrown);
                }
            });
        }
        function clearForm() {
            $('#UserGeneralInfo input[type=text],input[type=password],select').each(function () {
                $(this).val("");

                if ($(this).is("select") & $(this)[0].size > 1) {
                    $(this)[0].options.length = 0;
                }
            });

            $('#UserGeneralInfo input[type=radio]').each(function () {
                $(this).attr("checked", false);
            });
        }
        num = 1;
        function RoleChange(element) {
                var value = $(element).find(":selected").text();
                var val = $(element).find(":selected").val();
                if (val != "" && val != "$") {
                    if (value != "Student") {
                        $("#divDesgQualification").css("display", "block");
                        $("#spnSiblingsInSameSchool").text("Children studying in same school");
                        $("#spnSiblingDetails").text("Children details");
                        $("#spnEmpIdRollNo").text("Employee Id");
                        $("#spnSectionRequiredFld").hide();
                        $("#divAdmNoAdmDate").css("display", "none");
                    }
                    else {
                        $("#divDesgQualification").css("display", "none");
                        $("#spnSiblingsInSameSchool").text("Siblings in same school");
                        $("#spnSiblingDetails").text("Sibling details");
                        $("#spnEmpIdRollNo").text("Roll No.");
                        $("#spnSectionRequiredFld").show();
                        $("#divAdmNoAdmDate").css("display", "block");
                    }
                }
                return;
        }
        function DisplayNameChange(obj) {
            $.ajax({
                type: "POST",
                url: "/Admin/ChkDuplicateDisplayName",
                data: "Name=" + $(obj).val(),
                dataType: "json",
                beforeSend: function () {
                    // $.blockUI();   //this is great plugin - 'blockUI'
                },
                success: function (result) {
                    if (result.success) {
                        ClearMsg();
                        //Success(result.message);
                    }
                    else {
                        ClearMsg();
                        Failure(result.message);
                    }
                    // $.unblockUI();
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    //$.unblockUI();
                    var errMsg = "<P>Error Loading: " + XMLHttpRequest.responseText + "<br/>";
                    $("#status").html(errMsg).show("slow");
                }
            });
        }
        function UserNameChange(obj) {
            $.ajax({
                type: "POST",
                url: "/Admin/ChkDuplicateUserName",
                data: "Name=" + $(obj).val(),
                dataType: "json",
                beforeSend: function () {
                    // $.blockUI();   //this is great plugin - 'blockUI'
                },
                success: function (result) {
                    if (result.success) {
                        ClearMsg();
                        //Success(result.message);
                    }
                    else {
                        ClearMsg();
                        Failure(result.message);
                    }
                    // $.unblockUI();
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    $.unblockUI();
                    Error(XMLHttpRequest, textStatus, errorThrown);
                }
            });
        }
        function ContentClassChange(element) {

            var value = $.trim($("#UserGeneralInfo select[id=Class]").val());
            if (value == "$") {
                $("#UserGeneralInfo select[id=Section]").find('option').remove();
                $("#spnpopupOtherHeader").text("Class");
                $("#spnLeft").text("Enter value for Other");
                $("#btnpopupOtherSave").attr("value", "OK");
                $("#btnpopupOtherCancel").attr("value", "Cancel");
                $("#hdnVal").val("Class");
                $("#hdnBeforeOptional").val("#UserGeneralInfo select[id=Section]");
                $("#hdnBeforeOptionalName").val("Section");
                $("#hdnSelectElement").val("#UserGeneralInfo select[id=Class]");
                ClearMsg();
                $("#popUpOther input[type=text]").val("");
                //popup("popUpOther");
                $("#popUpOther").modal();
                $("#popUpOther input[type=text]").focus();
            }
            if (value == "") {
                $("#UserGeneralInfo select[id=Section]").find('option').remove();
            }
            if (value != "" && value != "$") {
                $("#UserGeneralInfo select[id=Section]").find('option').remove();
                ContentLoadSectionsByClass(value);
            }

        }
        function ContentSectionChange(element) {
            var value = $.trim($("#UserGeneralInfo select[id=Section]").val());
            if (value == "$") {
                $("#spnpopupOtherHeader").text("Section");
                $("#spnLeft").text("Enter value for Other");
                $("#btnpopupOtherSave").attr("value", "OK");
                $("#btnpopupOtherCancel").attr("value", "Cancel");
                $("#hdnVal").val("Class,Section");
                $("#hdnOptional").val("#UserGeneralInfo select[id=Class]");
                $("#hdnBeforeOptional").val("");
                $("#hdnBeforeOptionalName").val("");
                $("#hdnSelectElement").val("#UserGeneralInfo select[id=Section]");
                ClearMsg();
                $("#popUpOther input[type=text]").val("");
                //popup("popUpOther");
                $("#popUpOther").modal();
                $("#popUpOther input[type=text]").focus();
            }
        }
        function ContentLoadSectionsByClass(classId) {
            $.ajax({
                type: "POST",
                url: "/Admin/SectionsListByClass",
                data: "ClassId=" + classId,
                dataType: "json",
                beforeSend: function () {
                    $.blockUI();   //this is great plugin - 'blockUI'
                },
                success: function (sections) {
                    $Section = $("#UserGeneralInfo select[id=Section]");
                    $Section.append('<option value="">Select Section</option>');
                    $.each(sections, function (i, section) {
                        $Section.append('<option value="' + section.Value + '">' + section.Text + '</option>');

                    });
                    $Section.append('<option value="$">Other</option>');
                    $.unblockUI();
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    $.unblockUI();
                    var errMsg = "<P>Error Loading: " + XMLHttpRequest.responseText + "<br/>";
                    Error(errMsg);
                }
            });
        }
    </script>
</head>
<body>
    <div id="basic-modal-content">
        <div class="popupHead">
            <span>Select Photo to upload</span>
        </div>
        <input type="hidden" id="hdnPhotoName" /><input type="hidden" id="hdnPhotoSize" />
        <div class="clear">
            <div>
                <div class="clear">
                    <div style="text-align: center;" id="divPhotoPreview">
                        <% if (Model.PhotoName == null)
                           { %>
                        <img alt="Photo" src="../../images/default_student_photo.gif" height="140px" width="120px"
                            style="border: 3px solid #C0C0C0" />
                        <%}
                           else
                           { %>
                        <img alt="Photo" src="../../StudentPhotos/<%= Html.Encode(Model.InstanceId) %>/<%= Html.Encode(Model.PhotoName) %>"
                            height="140px" width="120px" style="border: 3px solid #C0C0C0" />
                        <%} %>
                    </div>
                </div>
                <div class="clear" id="divPhotoUploadBtns" style="margin: 10px;">
                    <center>
                        <% if (Model.PhotoName == null)
                           { %>
                        <input type="file" id="photo" name="photo" />
                        <%}
                           else
                           { %>
                        <input type="button" value="Remove Photo" class="rg_button_red" onclick="RemovePhoto();" />
                        <%} %>
                        <%--&nbsp;
                        <input type="button" value="Close" class="rg_button" onclick="ClosePopup()" />--%>
                    </center>
                </div>
            </div>
        </div>
    </div>
    <div id="popUpSibling" style="display: none;">
        <div style="background-color: White;">
            <div id="divpopupSiblingMsg">
                <center>
                    <span id="spnpopupSiblingMsg" style="font-weight: bold; color: Red;"></span>
                </center>
            </div>
            <div class="divHead">
                <span class="divHeading">Select Siblings</span>
            </div>
            <div class="clear">
                <div class="popupdivBorder">
                    <div class="clear">
                        <div class="editor-label FloatLeft" style="width: 30%;">
                            <span class="ValidationSpan">*</span> <span id="spnLeft"></span>
                        </div>
                        <div class="editor-field" style="text-align: left;">
                            <input type="text" id="otherText" />
                        </div>
                    </div>
                    <div class="clear" style="margin: 10px;">
                        <center>
                            <input type="button" value="OK" id="btnpopupOtherSave" class="rg_button_red" onclick="Create()" />
                            &nbsp;
                            <input type="button" value="Cancel" id="btnpopupOtherCancel" class="rg_button" onclick="popup('popUpOther')" />
                        </center>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="clear">
        <div id="UserGeneralInfo">
            <div class="clear">
                <div class="ContentdivHead" onclick="toggleContentDivHead(this,'#divUserBasicInfo');">
                    <span class="divHeading">Basic Information</span>
                </div>
                <div class="clear">
                    <div class="ContentdivBorder" id="divUserBasicInfo">
                        <div class="clear">
                            <%-- <div class="FloatLeft" style="width: 80%;">--%>
                            <div class="clear">
                                <div class="FloatLeft" style="width: 50%;">
                                    <div class="clear">
                                        <div class="editor-label FloatLeft" style="width: 40%;">
                                            <span class="ValidationSpan">*</span> Role
                                        </div>
                                        <div class="editor-field" style="text-align: left;">
                                            <%= Html.DropDownListFor(m => m.Role, Model.Roles, "Select Role", new { onChange = "RoleChange(this);return false;",title="Select Role from the list" })%>
                                        </div>
                                    </div>
                                </div>
                                <div style="float: left; width: 50%;">
                                    <div class="clear">
                                        <div class="editor-label FloatLeft" style="width: 40%;">
                                            <span class="ValidationSpan">*</span> Session
                                        </div>
                                        <div class="editor-field" style="text-align: left;">
                                            <%= Html.DropDownListFor(m => m.Batch, Model.Batches, "Select Session", new { title="Select the appropriate session" })%>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="clear">
                                <div class="FloatLeft" style="width: 50%;">
                                    <div class="clear">
                                        <div class="editor-label FloatLeft" style="width: 40%;">
                                            <span class="ValidationSpan">*</span> First Name
                                        </div>
                                        <div class="editor-field" style="text-align: left;">
                                            <%= Html.TextBoxFor(m => m.FirstName, new { maxlength = 100, autocomplete = "off", onblur = "DisplayNameChange(this);return false;",title="Type in your First Name" })%>
                                        </div>
                                    </div>
                                </div>
                                <div style="float: left; width: 50%;">
                                    <div class="clear">
                                        <div class="editor-label FloatLeft" style="width: 40%;">
                                            <% if (Convert.ToBoolean(Model.setLastNameRequired))
                                               { %>
                                            <span id="spnLastNameRequired" class="ValidationSpan">*</span>
                                            <%} %>
                                            Last Name
                                        </div>
                                        <div class="editor-field" style="text-align: left;">
                                            <%= Html.TextBoxFor(m => m.LastName, new { maxlength = 50, autocomplete = "off",title="Not mandatory" })%>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="clear">
                                <div class="FloatLeft" style="width: 50%;">
                                    <div class="clear">
                                        <div class="editor-label FloatLeft" style="width: 40%;">
                                            <span class="ValidationSpan">*</span> Display Name
                                        </div>
                                        <div class="editor-field" style="text-align: left;">
                                            <%= Html.TextBoxFor(m => m.DisplayName, new { maxlength = 150, autocomplete = "off", onblur = "DisplayNameChange(this);return false;",title="Type in a unique Display Name" })%>
                                        </div>
                                    </div>
                                </div>
                                <div style="float: left; width: 50%;">
                                    <div class="clear">
                                        <div class="editor-label FloatLeft" style="width: 40%;">
                                            <span class="ValidationSpan">*</span> Gender
                                        </div>
                                        <div class="editor-field" style="text-align: left;">
                                            <%= Html.DropDownListFor(m => m.Gender, Model.Genders, "Select Gender", new { title="Select appropriate Gender" })%>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="clear" id="divDesgQualification" style="display: none;">
                                <div class="FloatLeft" style="width: 50%;">
                                    <div class="clear">
                                        <div class="editor-label FloatLeft" style="width: 40%;">
                                            <span class="ValidationSpan">*</span> Designation
                                        </div>
                                        <div class="editor-field" style="text-align: left;">
                                            <%= Html.DropDownListFor(m => m.Designation, Model.Designations, "Select Designation", new { title="Select appropriate Designation" })%>
                                        </div>
                                    </div>
                                </div>
                                <div style="float: left; width: 50%;">
                                    <div class="clear">
                                        <div class="editor-label FloatLeft" style="width: 40%;">
                                            Qualification
                                        </div>
                                        <div class="editor-field" style="text-align: left;">
                                            <%= Html.TextBoxFor(m => m.Qualification, new { maxlength = 100, autocomplete = "off", title="Type in your Qualification" })%>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="clear">
                                <div class="FloatLeft" style="width: 50%;">
                                    <div class="clear">
                                        <div class="editor-label FloatLeft" style="width: 40%;">
                                            <span id="spnEmpIdRollNo">Employee Id</span>
                                        </div>
                                        <div class="editor-field" style="text-align: left;">
                                            <%= Html.TextBoxFor(m => m.EmployeeId, new { maxlength = 50, autocomplete = "off",title="Type in your Employee Id" })%>
                                        </div>
                                    </div>
                                </div>
                                <div style="float: left; width: 50%;">
                                    <div class="clear">
                                        <div class="editor-label FloatLeft" style="width: 40%;">
                                            <% if (Convert.ToBoolean(Model.setDateofJoiningRequired))
                                               { %>
                                            <span id="spnDateofJoiningRequired" class="ValidationSpan">*</span>
                                            <%} %>
                                            Date of joining
                                        </div>
                                        <div class="editor-field" style="text-align: left;">
                                            <%= Html.TextBoxFor(m => m.strDateOfJoining, new { maxlength = 10, autocomplete = "off", @class = "CalendarBox",title="Select date from Calendar" })%>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="clear" id="divAdmNoAdmDate" style="display: none;">
                                <div class="FloatLeft" style="width: 50%;">
                                    <div class="clear">
                                        <div class="editor-label FloatLeft" style="width: 40%;">
                                            <% if (Convert.ToBoolean(Model.setAdmissionDtRequired))
                                               { %>
                                            <span id="spnAdmissionDtRequired" class="ValidationSpan">*</span>
                                            <%} %>
                                            Admission Date
                                        </div>
                                        <div class="editor-field" style="text-align: left;">
                                            <%= Html.TextBoxFor(m => m.strAdmissionDate, new { maxlength = 10, autocomplete = "off", @class = "CalendarBox",title="Select Admission Date from Calendar" })%>
                                        </div>
                                    </div>
                                </div>
                                <div style="float: left; width: 50%;">
                                    <div class="clear">
                                        <div class="editor-label FloatLeft" style="width: 40%;">
                                            <% if (Convert.ToBoolean(Model.setAdmissionNoRequired))
                                               { %>
                                            <span id="spnAdmissionNoRequired" class="ValidationSpan">*</span>
                                            <%} %>
                                            Admission No.
                                        </div>
                                        <div class="editor-field" style="text-align: left;">
                                            <%= Html.TextBoxFor(m => m.AdmissionNo, new { maxlength = 50, autocomplete = "off",title="Type in your Admission Number" })%>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="clear">
                                <div class="FloatLeft" style="width: 50%;">
                                    <div class="clear">
                                        <div class="editor-label FloatLeft" style="width: 40%;">
                                            <span class="ValidationSpan">*</span> Class
                                        </div>
                                        <div class="editor-field" style="text-align: left;">
                                            <%= Html.DropDownListFor(m => m.Class, Model.Classes, "Select Class", new { onChange = "ContentClassChange(this);return false;",title="Select Class from list. Add new class by selecting 'Other'" })%>
                                        </div>
                                    </div>
                                </div>
                                <div style="float: left; width: 50%;">
                                    <div class="clear">
                                        <div class="editor-label FloatLeft" style="width: 40%;">
                                            <span id="spnSectionRequiredFld" class="ValidationSpan">*</span> Section
                                        </div>
                                        <div class="editor-field" style="text-align: left;">
                                            <%= Html.DropDownListFor(m => m.Section, Model.Sections, "Select Section", new { onChange = "ContentSectionChange(this);return false;",title="Select Section from list. Add new section by selecting 'Other'" })%>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="clear">
                                <div class="FloatLeft" style="width: 50%;">
                                    <div class="clear">
                                        <div class="editor-label FloatLeft" style="width: 40%;">
                                            Photo
                                        </div>
                                        <div class="editor-field" id="divPhotoPreviewSmall" style="text-align: left; vertical-align: middle;">
                                            <% if (Model.PhotoName == null)
                                               { %>
                                            <a id="A2" href="#" onclick="ShowPhotoFunc();" title="Click to upload photo">Upload Photo</a>
                                            <%}
                                               else
                                               { %>
                                            <img alt="Photo" src="../../StudentPhotos/<%= Html.Encode(Model.InstanceId) %>/<%= Html.Encode(Model.PhotoName) %>"
                                                height="30px" width="25px" style="border: 1px solid #C0C0C0" />
                                            <a id="A1" href="#" onclick="ShowPhotoFunc();" title="Click to Edit the photo">Edit</a>
                                            <%} %>
                                        </div>
                                    </div>
                                </div>
                                <div style="float: left; width: 50%;">
                                    <div class="clear">
                                        <div class="editor-label FloatLeft" style="width: 40%;">
                                        </div>
                                        <div class="editor-field" style="text-align: left;">
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <%--  </div>
                            <div style="float: right; width: 19%; text-align: center;">
                                <div class="clear">
                                    <img alt="Photo" src="../../images/001.jpg" height="140px" width="120px" style="border: 3px solid #C0C0C0" /></div>
                            </div>--%>
                        </div>
                    </div>
                </div>
            </div>
            <div class="clear">
                <div class="ContentdivHead" onclick="toggleContentDivHead(this,'#divUserGeneralInfo');">
                    <span class="divHeading">General Information</span>
                </div>
                <div class="clear">
                    <div class="ContentdivBorder" id="divUserGeneralInfo">
                        <div class="clear">
                            <%--<div class="FloatLeft" style="width: 80%;">--%>
                            <div class="clear">
                                <div class="FloatLeft" style="width: 50%;">
                                    <div class="clear">
                                        <div class="editor-label FloatLeft" style="width: 40%;">
                                            Blood Group
                                        </div>
                                        <div class="editor-field" style="text-align: left;">
                                            <%= Html.DropDownListFor(m => m.BloodGroup, Model.BloodGroups, "Select Blood Group", new { title="Select Blood Group " })%>
                                        </div>
                                    </div>
                                </div>
                                <div style="float: left; width: 50%;">
                                    <div class="clear">
                                        <div class="editor-label FloatLeft" style="width: 40%;">
                                            Transport
                                        </div>
                                        <div class="editor-field" style="text-align: left;">
                                            <%= Html.DropDownListFor(m => m.Transport, Model.Transports, "Select Transport", new { title="Select Transport" })%>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="clear">
                                <div class="FloatLeft" style="width: 50%;">
                                    <div class="clear">
                                        <div class="editor-label FloatLeft" style="width: 40%;">
                                            Referral
                                        </div>
                                        <div class="editor-field" style="text-align: left;">
                                            <%= Html.DropDownListFor(m => m.Referrel, Model.Referrels, "Select Referral", new { title = "Select Referral" })%>
                                        </div>
                                    </div>
                                </div>
                                <div style="float: left; width: 50%;">
                                    <div class="clear">
                                        <div class="editor-label FloatLeft" style="width: 40%;">
                                            Fee Category
                                        </div>
                                        <div class="editor-field" style="text-align: left;">
                                            <%= Html.DropDownListFor(m => m.FeeCategory, Model.FeeCategories, "Select Fee Category", new{ title="Select Fee Category" })%>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="clear">
                                <% if (Model.setFoodOffering == "Single")
                                   { %>
                                <div class="FloatLeft" style="width: 50%;">
                                    <div class="clear">
                                        <div class="editor-label FloatLeft" style="width: 40%;">
                                            Food Offering
                                        </div>
                                        <div class="editor-field" style="text-align: left;">
                                            <%= Html.DropDownListFor(m => m.singleFoodOffering, Model.singleFoodOfferings, "Select Food Offering", new { id = "FoodOffering",title="Select Food Offering" })%>
                                        </div>
                                    </div>
                                </div>
                                <%}
                                   else if (Model.setFoodOffering == "Multiple")
                                   {%>
                                <div class="FloatLeft" style="width: 50%;">
                                    <div class="clear">
                                        <div class="editor-label FloatLeft" style="width: 40%;">
                                            Food Offering
                                        </div>
                                        <div class="editor-field" style="text-align: left;">
                                            <%= Html.ListBoxFor(m => m.FoodOffering, Model.FoodOfferings, new { title = "Select Multiple By holding the 'Ctrl' Key" })%>
                                        </div>
                                    </div>
                                </div>
                                <%}
                                   else
                                   { %>
                                <div class="FloatLeft" style="width: 50%;">
                                    <div class="clear">
                                        <div class="editor-label FloatLeft" style="width: 40%;">
                                            Food Offering
                                        </div>
                                        <div class="editor-field" style="text-align: left;">
                                            <%= Html.ListBoxFor(m => m.FoodOffering, Model.FoodOfferings, new { title = "Select Multiple By holding the 'Ctrl' Key" })%>
                                        </div>
                                    </div>
                                </div>
                                <%} %>
                                <% if (Model.setDietaryNeed == "Single")
                                   { %>
                                <div style="float: left; width: 50%;">
                                    <div class="clear">
                                        <div class="editor-label FloatLeft" style="width: 40%;">
                                            Dietary Needs
                                        </div>
                                        <div class="editor-field" style="text-align: left;">
                                            <%= Html.DropDownListFor(m => m.singleDietaryNeed, Model.singleDietaryNeeds, "Select Dietary Need", new { id = "DietaryNeed",title="Select Dietary Needs" })%>
                                        </div>
                                    </div>
                                </div>
                                <%}
                                   else if (Model.setDietaryNeed == "Multiple")
                                   {%>
                                <div style="float: left; width: 50%;">
                                    <div class="clear">
                                        <div class="editor-label FloatLeft" style="width: 40%;">
                                            Dietary Needs
                                        </div>
                                        <div class="editor-field" style="text-align: left;">
                                            <%= Html.ListBoxFor(m => m.DietaryNeed, Model.DietaryNeeds, new { title = "Select Multiple By holding the 'Ctrl' Key" })%>
                                        </div>
                                    </div>
                                </div>
                                <%}
                                   else
                                   { %>
                                <div style="float: left; width: 50%;">
                                    <div class="clear">
                                        <div class="editor-label FloatLeft" style="width: 40%;">
                                            Dietary Needs
                                        </div>
                                        <div class="editor-field" style="text-align: left;">
                                            <%= Html.ListBoxFor(m => m.DietaryNeed, Model.DietaryNeeds, new { title = "Select Multiple By holding the 'Ctrl' Key" })%>
                                        </div>
                                    </div>
                                </div>
                                <%} %>
                            </div>
                            <div class="clear">
                                <% if (Model.setDisability == "Single")
                                   { %>
                                <div class="FloatLeft" style="width: 50%;">
                                    <div class="clear">
                                        <div class="editor-label FloatLeft" style="width: 40%;">
                                            Disability
                                        </div>
                                        <div class="editor-field" style="text-align: left;">
                                            <%= Html.DropDownListFor(m => m.singleDisability, Model.singleDisabilities, "Select Disability", new { id = "Disability",title="Select Disability" })%>
                                        </div>
                                    </div>
                                </div>
                                <%}
                                   else if (Model.setDisability == "Multiple")
                                   {%>
                                <div class="FloatLeft" style="width: 50%;">
                                    <div class="clear">
                                        <div class="editor-label FloatLeft" style="width: 40%;">
                                            Disability
                                        </div>
                                        <div class="editor-field" style="text-align: left;">
                                            <%= Html.ListBoxFor(m => m.Disability, Model.Disabilities, new { title = "Select Multiple By holding the 'Ctrl' Key" })%>
                                        </div>
                                    </div>
                                </div>
                                <%}
                                   else
                                   { %>
                                <div class="FloatLeft" style="width: 50%;">
                                    <div class="clear">
                                        <div class="editor-label FloatLeft" style="width: 40%;">
                                            Disability
                                        </div>
                                        <div class="editor-field" style="text-align: left;">
                                            <%= Html.ListBoxFor(m => m.Disability, Model.Disabilities, new { title="Select Multiple By holding the 'Ctrl' Key" })%>
                                        </div>
                                    </div>
                                </div>
                                <%} %>
                                <div style="float: left; width: 50%;">
                                    <div class="clear">
                                        <div class="editor-label FloatLeft" style="width: 40%;">
                                            <span id="spnSiblingsInSameSchool">Siblings in same school</span>
                                        </div>
                                        <div class="editor-field" style="text-align: left;">
                                            <%= Html.DropDownListFor(m => m.Sibling, Model.Siblings, "Select", new { title="Select 'Yes' if Siblings in same school" })%>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="clear">
                                <div class="FloatLeft" style="width: 50%;">
                                    <div class="clear">
                                        <div class="editor-label FloatLeft" style="width: 40%;">
                                            Identification Marks
                                        </div>
                                        <div class="editor-field" style="text-align: left;">
                                            <%= Html.TextAreaFor(m => m.IdentificationMarks, new {maxlength = 10, autocomplete = "off",title="Type in your identification marks" })%>
                                            <span id="spnIdentificatonCnt"></span>
                                        </div>
                                    </div>
                                </div>
                                <div style="float: left; width: 50%;">
                                    <div class="clear">
                                        <div class="editor-label FloatLeft" style="width: 40%;">
                                            <span id="spnSiblingDetails">Sibling Details</span>
                                        </div>
                                        <div class="editor-field" style="text-align: left; float: left;">
                                            <div class="clear">
                                                <div style="border: 1px solid lightgray; width: 210px; height: 35px; overflow: auto;">
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <%--  </div>
                            <div style="float: right; width: 19%; text-align: center;">
                            </div>--%>
                        </div>
                    </div>
                </div>
            </div>
            <div class="clear">
                <div class="ContentdivHead" onclick="toggleContentDivHead(this,'#divUserAccountInfo');">
                    <span class="divHeading">Account Information</span>
                </div>
                <div class="clear">
                    <div class="ContentdivBorder" id="divUserAccountInfo">
                        <div class="clear">
                            <%-- <div class="FloatLeft" style="width: 80%;">--%>
                            <div class="clear">
                                <div class="FloatLeft" style="width: 50%;">
                                    <div class="clear">
                                        <div class="editor-label FloatLeft" style="width: 40%;">
                                            <span class="ValidationSpan">*</span> User Name
                                        </div>
                                        <div class="editor-field" style="text-align: left;">
                                            <%= Html.TextBoxFor(m => m.UserName, new { maxlength = 10, autocomplete = "off", onblur = "UserNameChange(this);return false;",title="Type in your User Name" })%>
                                        </div>
                                    </div>
                                </div>
                                <div style="float: left; width: 50%;">
                                    <div class="clear">
                                        <div class="editor-label FloatLeft" style="width: 40%;">
                                            <span class="ValidationSpan">*</span> Password
                                        </div>
                                        <div class="editor-field" style="text-align: left;">
                                            <%= Html.PasswordFor(m => m.Password, new { value=Model.Password, maxlength = 10, autocomplete = "off",title="Make it hard to guess" })%>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="clear">
                                <div class="FloatLeft" style="width: 50%;">
                                    <div class="clear">
                                        <div class="editor-label FloatLeft" style="width: 40%;">
                                            <span class="ValidationSpan">*</span> Confirm Password
                                        </div>
                                        <div class="editor-field" style="text-align: left;">
                                            <%= Html.PasswordFor(m => m.Password, new { value = Model.Password, maxlength = 10, autocomplete = "off", Id = "ConfirmPassword", title = "Same as Password" })%>
                                        </div>
                                    </div>
                                </div>
                                <div style="float: left; width: 50%;">
                                    <div class="clear">
                                        <div class="editor-label FloatLeft" style="width: 40%;">
                                            Change Password on login
                                        </div>
                                        <div class="editor-field" style="text-align: left;">
                                            <input type="checkbox" checked="checked" disabled="disabled" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <%--  </div>
                            <div style="float: right; width: 19%; text-align: center;">
                            </div>--%>
                        </div>
                    </div>
                </div>
            </div>
            <div id="divButtons" class="clear" style="margin-top: 10px; margin-bottom: 20px;">
                <center>
                    <input type="button" value="OK, Create" class="rg_button_red" onclick="submitUserGeneralInfo();return false;" />
                    <input type="button" value="Clear" class="rg_button" onclick="clearForm();return false;" />
                    <%= Html.HiddenFor(m => m.InstanceId, new { id = "hdnInstanceID"})%>
                </center>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        // start tracking actovity  
        EnableTimeout();
        function LoadPhotoPreview(name, size) {
            var InstanceId = '<%=Model.InstanceId %>';
            $("#divPhotoPreview").html("<img alt='Photo' src='../../StudentPhotos/" + InstanceId + "/" + name + "' height='140px' width='120px' style='border: 3px solid #C0C0C0' />");
            $("#divPhotoPreviewSmall").html("<img alt='Photo' src='../../StudentPhotos/" + InstanceId + "/" + name + "' height='30px' width='25px' style='border: 3px solid #C0C0C0' /><a id='A1' href='#' onclick='ShowPhotoFunc();'>Edit</a>");
            $("#hdnPhotoName").val(name);
            $("#hdnPhotoSize").val(size);

        }
        function RemovePhoto() {
            $("#divPhotoPreview").html(" <img alt='Photo' src='../../images/default_student_photo.gif' height='140px' width='120px' style='border: 3px solid #C0C0C0' />");
            $("#divPhotoPreviewSmall").html(" <a id='A2' href='#' onclick='ShowPhotoFunc();'>Upload Photo</a>");
            $("#hdnPhotoName").val("");
            $("#hdnPhotoSize").val(0);
            $("#divPhotoUploadBtns").empty();
            $("#divPhotoUploadBtns").html("<center><input type='file' id='photo' name='photo' /></center>");
            $("#photo").makeAsyncUploader({

                upload_url: "/Admin/AsyncUpload?InstanceID=" + $("#hdnInstanceID").val(),
                flash_url: '/Scripts/swfupload.swf',
                button_image_url: '/Images/UploadButton_2.jpg',
                disableDuringUpload: 'INPUT[type="button"]',
                file_size_limit: "1 MB",
                file_types: "*.jpg;*.gif;*.png;*.jpeg;*.bmp;"

            });

        }
        function popupClose() {
            popup('popUpDiv');
        }
        $("#UserGeneralInfo input[id=FirstName]").keyup(function () { $("#UserGeneralInfo input[id=DisplayName]").val($(this).val()); });
        $("#UserGeneralInfo input[id=FirstName]").ForceAlphaNumericsOnly();
        $("#UserGeneralInfo input[id=LastName]").ForceAlphaNumericsOnly();
        $("#UserGeneralInfo input[id=DisplayName]").ForceAlphaNumericsOnly();
        // $("#UserGeneralInfo input[id=Qualification]").ForceAlphabetsOnly();
        $("#UserGeneralInfo input[id=EmployeeId]").ForceAlphaNumericsOnly();
        $("#UserGeneralInfo input[id=AdmissionNo]").ForceAlphaNumericsOnly();
        $("#UserGeneralInfo input[id=UserName]").ForceAlphaNumericsOnly();
        $(document).ready(function () {
            var Update = '<%=Model.Calendar %>';
            if (Update == "Advanced") {
                $('#UserGeneralInfo input[id=strAdmissionDate]').scroller({ theme: "android-ics light" });
                $('#UserGeneralInfo input[id=strDateOfJoining]').scroller({ theme: "android-ics light" });
            }
            else {
                $('#UserGeneralInfo input[id=strAdmissionDate]').datepicker({
                    changeMonth: true,
                    changeYear: true,
                    showButtonPanel: true
                });
                $("#UserGeneralInfo input[id=strDateOfJoining]").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    showButtonPanel: true
                });
            }

        });
        $(document).ready(function () {

            $('textarea[maxlength]').keyup(function () {
                //get the limit from maxlength attribute  
                var limit = parseInt($(this).attr('maxlength'));
                //get the current text inside the textarea  
                var text = $(this).val();
                //count the number of characters in the text  
                var chars = text.length;

                //check if there are more characters then allowed  
                if (chars > limit) {
                    //and if there are use substr to get the text before the limit  
                    var new_text = text.substr(0, limit);
                    ClearMsg();
                    noty({ text: "Character length Exceeded.", type: "information", layout: "topCenter", theme: "noty_theme_twitter" });
                    //and change the current text with the new text  
                    $(this).val(new_text);
                }
            });
            var value = $("#UserGeneralInfo select[id=Role]").find(":selected").text();
            var val = $("#UserGeneralInfo select[id=Role]").find(":selected").val();
            if (val != "" && val != "$") {
                if (value != "Student") {
                    $("#divDesgQualification").css("display", "block");
                    $("#spnSiblingsInSameSchool").text("Children studying in same school");
                    $("#spnSiblingDetails").text("Children details");
                    $("#spnEmpIdRollNo").text("Employee Id");
                    $("#spnSectionRequiredFld").hide();
                    $("#divAdmNoAdmDate").css("display", "none");
                }
                else {
                    $("#divDesgQualification").css("display", "none");
                    $("#spnSiblingsInSameSchool").text("Siblings in same school");
                    $("#spnSiblingDetails").text("Sibling details");
                    $("#spnEmpIdRollNo").text("Roll No.");
                    $("#spnSectionRequiredFld").show();
                    $("#divAdmNoAdmDate").css("display", "block");
                }
            }
//            $("#UserGeneralInfo input[type=text],input[type=password],textarea,select").tooltip({

//                // place tooltip on the bottomleft edge
//                position: "bottom left",

//                // a little tweaking of the position
//                offset: [-2, 10],

//                // use the built-in fadeIn/fadeOut effect
//                effect: "fade",

//                // custom opacity setting
//                opacity: 1

            //            });
            $("[title]").tooltip({ position: "bottom left" });
            $("#photo").makeAsyncUploader({

                upload_url: "/Admin/AsyncUpload?InstanceID=" + $("#hdnInstanceID").val(),
                flash_url: '/Scripts/swfupload.swf',
                button_image_url: '/Images/UploadButton_2.jpg',
                disableDuringUpload: 'INPUT[type="button"]',
                file_size_limit: "1 MB",
                file_types: "*.jpg;*.gif;*.png;*.jpeg;*.bmp;"

            });

            $(function () {
                $.Others("#UserGeneralInfo select[id=Role]", "popUpOther", {
                    popupHeader: "Role",
                    popupHidden: "Role",
                    popupOptional: "",
                    popupHiddenElement: "#hdnVal",
                    popupOptionalElement: "#hdnOptional",
                    labelText: "Enter value for Role",
                    HeaderElement: "#spnpopupOtherHeader",
                    labelElement: "#spnLeft",
                    saveButtonText: "OK",
                    cancelButtonText: "Cancel",
                    saveButtonElement: "#btnpopupOtherSave",
                    cancelButtonElement: "#btnpopupOtherCancel"
                })
            });
            $(function () {
                $.Others("#UserGeneralInfo select[id=Designation]", "popUpOther", {
                    popupHeader: "Designation",
                    popupHidden: "Designation",
                    popupOptional: "",
                    popupHiddenElement: "#hdnVal",
                    popupOptionalElement: "#hdnOptional",
                    labelText: "Enter value for Designation",
                    HeaderElement: "#spnpopupOtherHeader",
                    labelElement: "#spnLeft",
                    saveButtonText: "OK",
                    cancelButtonText: "Cancel",
                    saveButtonElement: "#btnpopupOtherSave",
                    cancelButtonElement: "#btnpopupOtherCancel"
                })
            });
            $(function () {
                $.OnlyOthers("#UserGeneralInfo select[id=Class]", "popUpOther")
            });
            $(function () {
                $.Others("#UserGeneralInfo select[id=Gender]", "popUpOther", {
                    popupHeader: "Gender",
                    popupHidden: "Gender",
                    popupOptional: "",
                    popupHiddenElement: "#hdnVal",
                    popupOptionalElement: "#hdnOptional",
                    labelText: "Enter value for Gender",
                    HeaderElement: "#spnpopupOtherHeader",
                    labelElement: "#spnLeft",
                    saveButtonText: "OK",
                    cancelButtonText: "Cancel",
                    saveButtonElement: "#btnpopupOtherSave",
                    cancelButtonElement: "#btnpopupOtherCancel"
                })
            });


        });
        
    </script>
</body>
</html>
