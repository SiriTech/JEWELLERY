<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<THSMVC.Models.UserParentInfoModel>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>UserParentInfo</title>
    <script type="text/javascript">
        function BackToParentInfo() {
            GetContentByActionAndController('UserParentInfoGrid', 'Admin', 'Create User', '.TabContent');
        }
        function CopySingleAddr(obj) {
            ClearMsg();
            if (obj.checked) {
                if ($.trim($("#SingleCommAddress").val()) != "") {
                    $("#SinglePermAddress").val($("#SingleCommAddress").val());
                    $("#SinglePermAddress").attr("disabled", "disabled");
                }
                else {
                    obj.checked = false;
                    Failure("No information in Communication Address.");
                }
            }
            else {
                if ($.trim($("#SingleCommAddress").val()) != "") {
                    $("#SinglePermAddress").val("");
                    $("#SinglePermAddress").attr("disabled", "");
                }
            }
        }

        function CopyDetailAddr(obj) {
            ClearMsg();
            if (obj.checked) {
                var chk = true;
                if ($.trim($("#CommLine1").val()) != "") {
                    chk = false;
                    $("#PermLine1").val($("#CommLine1").val());
                    $("#PermLine1").attr("disabled", "disabled");
                }
                if ($.trim($("#CommLine2").val()) != "") {
                    chk = false;
                    $("#PermLine2").val($("#CommLine2").val());
                    $("#PermLine2").attr("disabled", "disabled");
                }
                if ($.trim($("#CommCountry").val()) != "") {
                    chk = false;
                    $("#PermCountry").val($("#CommCountry").val());
                    $("#PermCountry").attr("disabled", "disabled");
                    $.ajax({
                        type: "POST",
                        url: "/Admin/StatesListByCountry",
                        data: "CountryId=" + $("#CommCountry").val(),
                        async: false,
                        dataType: "json",
                        beforeSend: function () {
                            $.blockUI();   //this is great plugin - 'blockUI'
                        },
                        success: function (states) {
                            $("#PermState").find('option').remove();
                            $State = $("#PermState");
                            $.each(states, function (i, state) {
                                if (i == 0) { $State.append('<option value="">Select State</option>'); }
                                $State.append('<option value="' + state.Value + '">' + state.Text + '</option>');
                            });
                            $.unblockUI();
                        },
                        error: function (XMLHttpRequest, textStatus, errorThrown) {
                            $.unblockUI();
                            var errMsg = "<P>Error Loading: " + XMLHttpRequest.responseText + "<br/>";
                            $("#status").html(errMsg).show("slow");
                        }
                    });

                }
                if ($.trim($("#CommState").val()) != "") {
                    chk = false;
                    $("#PermState").val($("#CommState").val());
                    $("#PermState").attr("disabled", "disabled");
                    $.ajax({
                        type: "POST",
                        url: "/Admin/CitiesListByState",
                        data: "StateId=" + $("#CommState").val(),
                        async: false,
                        dataType: "json",
                        beforeSend: function () {
                            $.blockUI();   //this is great plugin - 'blockUI'
                        },
                        success: function (cities) {
                            $("#PermCity").find('option').remove();
                            $City = $("#PermCity");
                            $.each(cities, function (i, city) {
                                if (i == 0) { $City.append('<option value="">Select City</option>'); }
                                $City.append('<option value="' + city.Value + '">' + city.Text + '</option>');
                            });
                            $.unblockUI();
                        },
                        error: function (XMLHttpRequest, textStatus, errorThrown) {
                            $.unblockUI();
                            var errMsg = "<P>Error Loading: " + XMLHttpRequest.responseText + "<br/>";
                            $("#status").html(errMsg).show("slow");
                        }
                    });
                }
                if ($.trim($("#CommCity").val()) != "") {
                    chk = false;
                    $("#PermCity").val($("#CommCity").val());
                    $("#PermCity").attr("disabled", "disabled");
                    var Sector = '<%=Model.setParentAddressSector %>';
                    if (Sector == "True") {
                        $.ajax({
                            type: "POST",
                            url: "/Admin/SectorsListByCity",
                            data: "CityId=" + $("#CommCity").val(),
                            async: false,
                            dataType: "json",
                            beforeSend: function () {
                                $.blockUI();   //this is great plugin - 'blockUI'
                            },
                            success: function (cities) {
                                $("#PermSector").find('option').remove();
                                $City = $("#PermSector");
                                $.each(cities, function (i, city) {
                                    if (i == 0) { $City.append('<option value="">Select Sector</option>'); }
                                    $City.append('<option value="' + city.Value + '">' + city.Text + '</option>');
                                });
                                $.unblockUI();
                            },
                            error: function (XMLHttpRequest, textStatus, errorThrown) {
                                $.unblockUI();
                                var errMsg = "<P>Error Loading: " + XMLHttpRequest.responseText + "<br/>";
                                $("#status").html(errMsg).show("slow");
                            }
                        });
                    }
                }
                var Sector = '<%=Model.setParentAddressSector %>';
                if (Sector == "True") {
                    if ($.trim($("#CommSector").val()) != "") {
                        chk = false;
                        $("#PermSector").val($("#CommSector").val());
                        $("#PermSector").attr("disabled", "disabled");
                    }
                }
                if ($.trim($("#CommPIN").val()) != "") {
                    chk = false;
                    $("#PermPIN").val($("#CommPIN").val());
                    $("#PermPIN").attr("disabled", "disabled");
                }
                if (chk) {
                    obj.checked = false;
                    Failure("No information in Communication Address.");
                }
                else {
                    $('#divCommAddress input[type=text],input[type=password],textarea').each(function () {
                        $(this).attr("disabled", "disabled");

                    });
                    var Sector = '<%=Model.setParentAddressSector %>';
                    if (Sector == "True") {
                        $("#PermSector").val($("#CommSector").val());
                        $("#PermSector").attr("disabled", "disabled");
                    }
                    $("#CommCity").attr("disabled", "disabled");
                    $("#CommState").attr("disabled", "disabled");
                    $("#CommCountry").attr("disabled", "disabled");

                    $("#PermCountry").attr("disabled", "disabled");
                    $("#PermState").attr("disabled", "disabled");
                    $("#PermCity").attr("disabled", "disabled");
                    var Sector = '<%=Model.setParentAddressSector %>';
                    if (Sector == "True") {
                        $("#PermSector").attr("disabled", "disabled");
                    }
                    $('#divPermanentAddress input[type=text],input[type=password],textarea').each(function () {
                        $(this).attr("disabled", "disabled");

                    });
                }
            }
            else {
                $('#divPermanentAddress input[type=text],input[type=password],textarea').each(function () {
                    $(this).removeAttr("disabled");
                    $(this).val("");

                });

                $('#divPermanentAddress input[type=checkbox]').each(function () {
                    $(this).attr("checked", false);

                });
                $("#PermCountry").val("");
                $("#PermState").val("");
                $("#PermCity").val("");
                $("#PermCountry").removeAttr("disabled");
                $("#PermState").removeAttr("disabled");
                $("#PermCity").removeAttr("disabled");
                var Sector = '<%=Model.setParentAddressSector %>';
                if (Sector == "True") {
                    $("#PermSector").val("");
                    $("#PermSector").removeAttr("disabled");
                }
                $('#divCommAddress input[type=text],input[type=password],textarea').each(function () {
                    $(this).removeAttr("disabled");

                });
                var Sector = '<%=Model.setParentAddressSector %>';
                if (Sector == "True") {
                    $("#PermSector").val("");
                    $("#PermSector").removeAttr("disabled");
                }

                $("#CommCity").removeAttr("disabled");
                $("#CommState").removeAttr("disabled");
                $("#CommCountry").removeAttr("disabled");
            }
        }
        function submitUserParentInfo() {
            ClearMsg();
            $("#statusDiv").css("display", "none");
            var msg;
            msg = "";
            if ($("#UserParentInfo select[id=RelationId]").val() == "") {
                msg = "Relation Required <br/>";
            }
            if ($("#UserParentInfo input[id=FirstName]").val() == "") {
                msg = msg + " First Name Required <br/>";
            }
            if ($("#spnLastNameRequired").text() == "*") {
                if ($("#UserParentInfo input[id=LastName]").val() == "") {
                    msg = msg + " Last Name Required <br/>";
                }
            }
            if (msg != "") {
                Failure(msg);
                return false;
            }
                $.ajax({
                    type: "POST",
                    traditional: true,
                    url: "/Admin/UserParentInfo",
                    data: {
                        FirstName: $("#UserParentInfo input[id=FirstName]").val(),
                        LastName: $("#UserParentInfo input[id=LastName]").val(),
                        RelationId: $("#UserParentInfo select[id=RelationId]").val(),
                        PhotoName: $("#hdnPhotoName").val(),
                        PhotoSize: $("#hdnPhotoSize").val(),
                        OccupationId: $("#UserParentInfo select[id=OccupationId]").val(),
                        Qualification: $("#UserParentInfo input[id=Qualification]").val(),
                        CompanyName: $("#UserParentInfo input[id=CompanyName]").val(),
                        strDOB: $("#UserParentInfo input[id=strDOB]").val(),
                        SingleCommAddress: $("#UserPersonalInfo textarea[id=SingleCommAddress]").val(),
                        SinglePermAddress: $("#UserParentInfo textarea[id=SinglePermAddress]").val(),
                        SingleOfficeParentAddress: $("#UserParentInfo textarea[id=SingleOfficeParentAddress]").val(),
                        ChkSingleAddr: $("#UserParentInfo input[id=ChkSingleAddr]").val(),
                        CommLine1: $("#UserParentInfo input[id=CommLine1]").val(),
                        CommLine2: $("#UserParentInfo input[id=CommLine2]").val(),
                        CommCountry: $("#UserParentInfo select[id=CommCountry]").val(),
                        CommState: $("#UserParentInfo select[id=CommState]").val(),
                        CommCity: $("#UserParentInfo select[id=CommCity]").val(),
                        CommSector: $("#UserParentInfo select[id=CommSector]").val(),
                        CommPIN: $("#UserParentInfo input[id=CommPIN]").val(),
                        PermLine1: $("#UserParentInfo input[id=PermLine1]").val(),
                        PermLine2: $("#UserParentInfo input[id=PermLine2]").val(),
                        PermCountry: $("#UserParentInfo select[id=PermCountry]").val(),
                        PermState: $("#UserParentInfo select[id=PermState]").val(),
                        PermCity: $("#UserParentInfo select[id=PermCity]").val(),
                        PermSector: $("#UserParentInfo select[id=PermSector]").val(),
                        PermPIN: $("#UserGeneralInfo input[id=PermPIN]").val(),
                        OfficeParentLine1: $("#UserParentInfo input[id=OfficeParentLine1]").val(),
                        OfficeParentLine2: $("#UserParentInfo input[id=OfficeParentLine2]").val(),
                        OfficeCountry: $("#UserParentInfo select[id=OfficeCountry]").val(),
                        OfficeState: $("#UserParentInfo select[id=OfficeState]").val(),
                        OfficeCity: $("#UserParentInfo select[id=OfficeCity]").val(),
                        OfficeSector: $("#UserParentInfo select[id=OfficeSector]").val(),
                        OfficeParentPIN: $("#UserParentInfo input[id=OfficeParentPIN]").val(),
                        MobilePhone: $("#UserParentInfo input[id=MobilePhone]").val(),
                        HomePhone: $("#UserParentInfo input[id=HomePhone]").val(),
                        WorkPhone: $("#UserParentInfo input[id=WorkPhone]").val(),
                        WorkPhoneExtn: $("#UserParentInfo input[id=WorkPhoneExtn]").val(),
                        Fax: $("#UserParentInfo input[id=Fax]").val(),
                        ParentId: $("#hdnParentID").val()
                    },
                    dataType: "json",
                    beforeSend: function () {
                        $.blockUI();   //this is great plugin - 'blockUI'
                    },
                    success: function (result) {
                        if (result.success) {
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
                        <img alt="Photo" src="../../images/<%= Html.Encode(Model.InstanceId) %>/<%= Html.Encode(Model.PhotoName) %>"
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
    <div  class="clear">
    <% if (Model.EnableBackButton)
       { %>
    <div style="float: right;">
        <input type="button" id="backToParentInfo" class="rg_button_red" title="Back to parent Info." onclick="BackToParentInfo();"
            value="Back to Parent Info." />
    </div>
    <%} %>
    </div>
    <div class="clear">
        <div id="UserParentInfo">
            <div class="clear">
                <div class="ContentdivHead" onclick="toggleContentDivHead(this,'#divUserParentInfo');">
                    <span class="divHeading">Parent Information</span>
                </div>
                <div class="clear">
                    <div class="ContentdivBorder" id="divUserParentInfo">
                        <div class="clear">
                            <%-- <div class="FloatLeft" style="width: 80%;">--%>
                            <div class="clear">
                                <div class="FloatLeft" style="width: 50%;">
                                    <div class="clear">
                                        <div class="editor-label FloatLeft" style="width: 40%;">
                                           <span class="ValidationSpan">*</span> Relation
                                        </div>
                                        <div class="editor-field" style="text-align: left;">
                                            <%= Html.DropDownListFor(m => m.RelationId, Model.Relations, "Select Relation", new { title = "Select Relation" })%>
                                        </div>
                                    </div>
                                </div>
                                <div style="float: left; width: 50%;">
                                    <div class="clear">
                                        <div class="editor-label FloatLeft" style="width: 40%;">
                                           <span class="ValidationSpan">*</span> First Name
                                        </div>
                                        <div class="editor-field" style="text-align: left;">
                                            <%= Html.TextBoxFor(m => m.FirstName, new { maxlength = 100, title = "Type in Parent first name" })%>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="clear">
                                <div class="FloatLeft" style="width: 50%;">
                                    <div class="clear">
                                        <div class="editor-label FloatLeft" style="width: 40%;">
                                         <% if (Convert.ToBoolean(Model.setLastNameRequired))
                                               { %>
                                            <span id="spnLastNameRequired" class="ValidationSpan">*</span>
                                            <%} %>
                                            Last Name
                                        </div>
                                        <div class="editor-field" style="text-align: left;">
                                            <%= Html.TextBoxFor(m => m.LastName, new { maxlength = 50, title = "Type in Parent last name" })%>
                                        </div>
                                    </div>
                                </div>
                                <div style="float: left; width: 50%;">
                                    <div class="clear">
                                        <div class="editor-label FloatLeft" style="width: 40%;">
                                            Occupation
                                        </div>
                                        <div class="editor-field" style="text-align: left;">
                                            <%= Html.DropDownListFor(m => m.OccupationId, Model.Occupations, "Select Occupation", new { title = "Select Occupation" })%>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="clear">
                                <div class="FloatLeft" style="width: 50%;">
                                    <div class="clear">
                                        <div class="editor-label FloatLeft" style="width: 40%;">
                                            Qualification
                                        </div>
                                        <div class="editor-field" style="text-align: left;">
                                            <%= Html.TextBoxFor(m => m.Qualification, new { title = "Type in Parent Qualification" })%>
                                        </div>
                                    </div>
                                </div>
                                <div style="float: left; width: 50%;">
                                    <div class="clear">
                                        <div class="editor-label FloatLeft" style="width: 40%;">
                                            Company Name
                                        </div>
                                        <div class="editor-field" style="text-align: left;">
                                            <%= Html.TextBoxFor(m => m.CompanyName, new { title = "Type in Parent Company Name" })%>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <% if (Convert.ToBoolean(Model.setParentEmail))
                               { %>
                            <div class="clear">
                                <div class="FloatLeft" style="width: 50%;">
                                    <div class="clear">
                                        <div class="editor-label FloatLeft" style="width: 40%;">
                                            Email Address
                                        </div>
                                        <div class="editor-field" style="text-align: left;">
                                            <%= Html.TextBoxFor(m => m.Email, new { maxlength = 100, autocomplete = "off",title="Type in your Email Address" })%>
                                        </div>
                                    </div>
                                </div>
                                <div style="float: left; width: 50%;">
                                    <div class="clear">
                                        <div class="editor-label FloatLeft" style="width: 40%;">
                                            Alternate Email Address
                                        </div>
                                        <div class="editor-field" style="text-align: left;">
                                            <%= Html.TextBoxFor(m => m.AlternateEmail, new { maxlength = 100, autocomplete = "off", title = "Type in your alternate Email Address" })%>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <%} %>
                            <div class="clear">
                                <div class="FloatLeft" style="width: 50%;">
                                    <div class="clear">
                                        <div class="editor-label FloatLeft" style="width: 40%;">
                                            Date of Birth
                                        </div>
                                        <div class="editor-field" style="text-align: left;">
                                            <%= Html.TextBoxFor(m => m.strDOB, new { maxlength = 100, autocomplete = "off", @class = "CalendarBox", title = "Select Date of birth from calendar" })%>
                                        </div>
                                    </div>
                                </div>
                                <div style="float: left; width: 50%;">
                                    <div class="clear">
                                        <div class="editor-label FloatLeft" style="width: 40%;">
                                            Photo
                                        </div>
                                        <div class="editor-field" id="divPhotoPreviewSmall" style="text-align: left; vertical-align: middle;">
                                            <% if (Model.PhotoName == null)
                                               { %>
                                            <a id="A2" href="#" onclick="ShowPhotoFunc();" title="Click to upload photo">Upload
                                                Photo</a>
                                            <%}
                                               else
                                               { %>
                                            <img alt="Photo" src="../../images/<%= Html.Encode(Model.InstanceId) %>/<%= Html.Encode(Model.PhotoName) %>"
                                                height="30px" width="25px" style="border: 1px solid #C0C0C0" />
                                            <a id="A1" href="#" onclick="ShowPhotoFunc();" title="Click to Edit the photo">Edit</a>
                                            <%} %>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="clear">
                <div style="width: 50%; float: left;">
                    <div class="ContentdivHead" onclick="toggleContentDivHead(this,'#divCommParentAddress');">
                        <span class="divHeading">Communication Address</span>
                    </div>
                    <div class="clear">
                        <div class="ContentdivBorder" id="divCommParentAddress">
                            <div class="clear">
                                <% if (Model.setParentAddress == "Simple")
                                   { %>
                                <div class="clear">
                                    <div class="editor-label FloatLeft" style="height: 20px;">
                                    </div>
                                </div>
                                <div class="clear">
                                    <div class="editor-label FloatLeft" style="width: 40%;">
                                        Address
                                    </div>
                                    <div class="editor-field" style="text-align: left;">
                                        <%= Html.TextAreaFor(m => m.SingleCommParentAddress, new { maxlength = 2000, autocomplete = "off",title="Type in parent detailed Address" })%>
                                    </div>
                                </div>
                                <%}
                                   else
                                   {%>
                                <div class="clear">
                                    <div class="editor-label FloatLeft" style="height: 20px;">
                                    </div>
                                </div>
                                <div class="clear">
                                    <div class="editor-label FloatLeft" style="width: 40%;">
                                        Line1
                                    </div>
                                    <div class="editor-field" style="text-align: left;">
                                        <%= Html.TextBoxFor(m => m.CommParentLine1, new { maxlength = 500, autocomplete = "off", title = "Type in Communication Address line 1" })%>
                                    </div>
                                </div>
                                <div class="clear">
                                    <div class="editor-label FloatLeft" style="width: 40%;">
                                        Line2
                                    </div>
                                    <div class="editor-field" style="text-align: left;">
                                        <%= Html.TextBoxFor(m => m.CommParentLine2, new { maxlength = 500, autocomplete = "off", title = "Type in Communication Address line 2" })%>
                                    </div>
                                </div>
                                <div class="clear">
                                    <div class="editor-label FloatLeft" style="width: 40%;">
                                        Country
                                    </div>
                                    <div class="editor-field" style="text-align: left;">
                                        <%= Html.DropDownListFor(m => m.CommCountry, Model.CommParentCountries, "Select Country", new { onChange = "CommCountryChange();return false;",title="Select Country" })%>
                                    </div>
                                </div>
                                <div class="clear">
                                    <div class="editor-label FloatLeft" style="width: 40%;">
                                        State
                                    </div>
                                    <div class="editor-field" style="text-align: left;">
                                        <%= Html.DropDownListFor(m => m.CommState, Model.CommParentStates, "Select State", new { onChange = "CommStateChange();return false;",title="Select State" })%>
                                    </div>
                                </div>
                                <div class="clear">
                                    <div class="editor-label FloatLeft" style="width: 40%;">
                                        City
                                    </div>
                                    <div class="editor-field" style="text-align: left;">
                                        <%= Html.DropDownListFor(m => m.CommCity, Model.CommParentCities, "Select City", new { onChange = "CommCityChange();return false;",title="Select City" })%>
                                    </div>
                                </div>
                                <% if (Convert.ToBoolean(Model.setParentAddressSector))
                                   { %>
                                <div class="clear">
                                    <div class="editor-label FloatLeft" style="width: 40%;">
                                        Sector
                                    </div>
                                    <div class="editor-field" style="text-align: left;">
                                        <%= Html.DropDownListFor(m => m.CommSector, Model.CommParentSectors, "Select Sector", new { title="Select Sector" })%>
                                    </div>
                                </div>
                                <%}
                                   } %>
                                <div class="clear">
                                    <div class="editor-label FloatLeft" style="width: 40%;">
                                        PIN
                                    </div>
                                    <div class="editor-field" style="text-align: left;">
                                        <%= Html.TextBoxFor(m => m.CommParentPIN, new { maxlength = 20, autocomplete = "off",title="Type in PIN Code" })%>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div style="float: right; width: 50%;">
                    <div class="ContentdivHead" onclick="toggleContentDivHead(this,'#divPermanentParentAddress');">
                        <span class="divHeading">Permanent Address</span>
                    </div>
                    <div class="clear">
                        <div class="ContentdivBorder" id="divPermanentParentAddress">
                            <div class="clear">
                                <div class="ContentdivBorder" id="div1">
                                    <div class="clear">
                                        <% if (Model.setParentAddress == "Simple")
                                           { %>
                                        <div class="clear">
                                            <div style="height: 20px; text-align: center;">
                                                <input type="checkbox" title="Check to Copy Communication Address" id="ChkSingleAddr"
                                                    onclick="CopySingleAddr(this);" />
                                                Same as Communication Address
                                            </div>
                                        </div>
                                        <div class="clear">
                                            <div class="editor-label FloatLeft" style="width: 40%;">
                                                Address
                                            </div>
                                            <div class="editor-field" style="text-align: left;">
                                                <%= Html.TextAreaFor(m => m.SinglePermParentAddress, new { maxlength = 2000, autocomplete = "off",title="Type in Permanent Address" })%>
                                            </div>
                                        </div>
                                        <%}
                                           else
                                           {%>
                                        <div class="clear">
                                            <div style="height: 20px; text-align: center;">
                                                <input type="checkbox" title="Check to Copy Communication Address" onclick="CopyDetailAddr(this);" />
                                                Same as Communication Address
                                            </div>
                                        </div>
                                        <div class="clear">
                                            <div class="editor-label FloatLeft" style="width: 40%;">
                                                Line1
                                            </div>
                                            <div class="editor-field" style="text-align: left;">
                                                <%= Html.TextBoxFor(m => m.PermParentLine1, new { maxlength = 500, autocomplete = "off",title="Type in your Permanent address line 1" })%>
                                            </div>
                                        </div>
                                        <div class="clear">
                                            <div class="editor-label FloatLeft" style="width: 40%;">
                                                Line2
                                            </div>
                                            <div class="editor-field" style="text-align: left;">
                                                <%= Html.TextBoxFor(m => m.PermParentLine2, new { maxlength = 500, autocomplete = "off", title = "Type in your Permanent address line 2" })%>
                                            </div>
                                        </div>
                                        <div class="clear">
                                            <div class="editor-label FloatLeft" style="width: 40%;">
                                                Country
                                            </div>
                                            <div class="editor-field" style="text-align: left;">
                                                <%= Html.DropDownListFor(m => m.PermCountry, Model.PermParentCountries, "Select Country", new { onChange = "PermCountryChange();return false;",title="Select Country" })%>
                                            </div>
                                        </div>
                                        <div class="clear">
                                            <div class="editor-label FloatLeft" style="width: 40%;">
                                                State
                                            </div>
                                            <div class="editor-field" style="text-align: left;">
                                                <%= Html.DropDownListFor(m => m.PermState, Model.PermParentStates, "Select State", new { onChange = "PermStateChange();return false;",title="Select State" })%>
                                            </div>
                                        </div>
                                        <div class="clear">
                                            <div class="editor-label FloatLeft" style="width: 40%;">
                                                City
                                            </div>
                                            <div class="editor-field" style="text-align: left;">
                                                <%= Html.DropDownListFor(m => m.PermCity, Model.PermParentCities, "Select City", new { onChange = "PermCityChange();return false;",title="Select City" })%>
                                            </div>
                                        </div>
                                        <% if (Convert.ToBoolean(Model.setParentAddressSector))
                                           { %>
                                        <div class="clear">
                                            <div class="editor-label FloatLeft" style="width: 40%;">
                                                Sector
                                            </div>
                                            <div class="editor-field" style="text-align: left;">
                                                <%= Html.DropDownListFor(m => m.PermSector, Model.PermParentSectors, "Select Sector", new { title="Select Sector" })%>
                                            </div>
                                        </div>
                                        <%}
                                           }%>
                                        <div class="clear">
                                            <div class="editor-label FloatLeft" style="width: 40%;">
                                                PIN
                                            </div>
                                            <div class="editor-field" style="text-align: left;">
                                                <%= Html.TextBoxFor(m => m.PermParentPIN, new { maxlength = 20, autocomplete = "off",title="Type in PIN Code" })%>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="clear">
                <div class="ContentdivHead" onclick="toggleContentDivHead(this,'#divOfficeParentAddress');">
                    <span class="divHeading">Office Address</span>
                </div>
                <div class="clear">
                    <div class="ContentdivBorder" id="divOfficeParentAddress">
                        <div class="clear">
                            <% if (Model.setParentAddress == "Simple")
                               { %>
                            <div class="clear">
                                <div class="editor-label FloatLeft" style="height: 20px;">
                                </div>
                            </div>
                            <div class="clear">
                                <div class="editor-label FloatLeft" style="width: 40%;">
                                    Address
                                </div>
                                <div class="editor-field" style="text-align: left;">
                                    <%= Html.TextAreaFor(m => m.SingleOfficeParentAddress, new { maxlength = 2000, autocomplete = "off",title="Type in parent detailed office Address" })%>
                                </div>
                            </div>
                            <%}
                               else
                               {%>
                            <div class="clear">
                                <div class="editor-label FloatLeft" style="width: 40%;">
                                    Line1
                                </div>
                                <div class="editor-field" style="text-align: left;">
                                    <%= Html.TextBoxFor(m => m.OfficeParentLine1, new { maxlength = 500, autocomplete = "off", title = "Type in Office Address line 1" })%>
                                </div>
                            </div>
                            <div class="clear">
                                <div class="editor-label FloatLeft" style="width: 40%;">
                                    Line2
                                </div>
                                <div class="editor-field" style="text-align: left;">
                                    <%= Html.TextBoxFor(m => m.OfficeParentLine2, new { maxlength = 500, autocomplete = "off", title = "Type in Office Address line 2" })%>
                                </div>
                            </div>
                            <div class="clear">
                                <div class="editor-label FloatLeft" style="width: 40%;">
                                    Country
                                </div>
                                <div class="editor-field" style="text-align: left;">
                                    <%= Html.DropDownListFor(m => m.OfficeCountry, Model.OfficeParentCountries, "Select Country", new { onChange = "CommCountryChange();return false;", title = "Select Country" })%>
                                </div>
                            </div>
                            <div class="clear">
                                <div class="editor-label FloatLeft" style="width: 40%;">
                                    State
                                </div>
                                <div class="editor-field" style="text-align: left;">
                                    <%= Html.DropDownListFor(m => m.OfficeState, Model.OfficeParentStates, "Select State", new { onChange = "CommStateChange();return false;", title = "Select State" })%>
                                </div>
                            </div>
                            <div class="clear">
                                <div class="editor-label FloatLeft" style="width: 40%;">
                                    City
                                </div>
                                <div class="editor-field" style="text-align: left;">
                                    <%= Html.DropDownListFor(m => m.OfficeCity, Model.OfficeParentCities, "Select City", new { onChange = "CommCityChange();return false;", title = "Select City" })%>
                                </div>
                            </div>
                            <% if (Convert.ToBoolean(Model.setParentAddressSector))
                               { %>
                            <div class="clear">
                                <div class="editor-label FloatLeft" style="width: 40%;">
                                    Sector
                                </div>
                                <div class="editor-field" style="text-align: left;">
                                    <%= Html.DropDownListFor(m => m.OfficeSector, Model.OfficeParentSectors, "Select Sector", new { title = "Select Sector" })%>
                                </div>
                            </div>
                            <%}
                                   } %>
                            <div class="clear">
                                <div class="editor-label FloatLeft" style="width: 40%;">
                                    PIN
                                </div>
                                <div class="editor-field" style="text-align: left;">
                                    <%= Html.TextBoxFor(m => m.OfficeParentPIN, new { maxlength = 20, autocomplete = "off", title = "Type in PIN Code" })%>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="clear">
                <div class="ContentdivHead" onclick="toggleContentDivHead(this,'#divParentContactInfo');">
                    <span class="divHeading">Contact Information</span>
                </div>
                <div class="clear">
                    <div class="ContentdivBorder" id="divParentContactInfo">
                        <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                                Mobile Phone
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.MobilePhone, new { maxlength = 20, autocomplete = "off", title = "Type in parent Mobile Phone" })%>
                            </div>
                        </div>
                        <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                                Home Phone
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.HomePhone, new { maxlength = 20, autocomplete = "off", title = "Type in parent Home Phone" })%>
                            </div>
                        </div>
                        <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                                Work Phone
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.WorkPhone, new { maxlength = 20, autocomplete = "off", title = "Type in parent Work Phone" })%>
                            </div>
                        </div>
                        <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                                Work Phone Extension
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.WorkPhoneExtn, new { maxlength = 10, autocomplete = "off", title = "Type in parent Work Phone Extension" })%>
                            </div>
                        </div>
                        <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                                Fax
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.Fax, new { maxlength = 50, autocomplete = "off", title = "Type in parent Fax Number" })%>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
              <div id="divButtons" class="clear" style="margin-top: 10px; margin-bottom: 20px;">
                <center>
                    <input type="button" value="OK, Save" class="rg_button_red" onclick="submitUserParentInfo();return false;" />
                    <input type="button" value="Clear" class="rg_button" onclick="clearForm();return false;" />
                    <%= Html.HiddenFor(m => m.InstanceId, new { id = "hdnInstanceID"})%>
                    <%= Html.HiddenFor(m => m.ParentId, new { id = "hdnParentID"})%>
                </center>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        EnableTimeout();
        function ClosePopup() {
            $.modal.close({ persist: true });
        }
        function ShowPhotoFunc() {
            $("#basic-modal-content").modal({ persist: true, minHeight: 300 });
        }

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
        function clearForm() {
            $('#UserParentInfo input[type=text],input[type=password],select').each(function () {
                $(this).val("");

                if ($(this).is("select") & $(this)[0].size > 1) {
                    $(this)[0].options.length = 0;
                }
            });

            $('#UserParentInfo input[type=radio]').each(function () {
                $(this).attr("checked", false);
            });
        }
        $("#UserParentInfo input[id=FirstName]").ForceAlphaNumericsOnly();
        $("#UserParentInfo input[id=LastName]").ForceAlphaNumericsOnly();
        $(document).ready(function () {
            //$("[title]").tooltip({ position: "bottom left" });
            $("#photo").makeAsyncUploader({
                upload_url: "/Admin/AsyncUpload?InstanceID=" + $("#hdnInstanceID").val(),
                flash_url: '/Scripts/swfupload.swf',
                button_image_url: '/Images/UploadButton_2.jpg',
                disableDuringUpload: 'INPUT[type="button"]',
                file_size_limit: "1 MB",
                file_types: "*.jpg;*.gif;*.png;*.jpeg;*.bmp;"
            });
            var Update = '<%=Model.Calendar %>';
            if (Update == "Advanced") {
                $('#UserParentInfo input[id=strDOB]').scroller({ theme: "android-ics light" });
            }
            else {
                $('#UserParentInfo input[id=strDOB]').datepicker({
                    changeMonth: true,
                    changeYear: true,
                    showButtonPanel: true
                });
            }
        });
    </script>
</body>
</html>
