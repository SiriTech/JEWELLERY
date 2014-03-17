<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<THSMVC.Models.UserPersonalInfoModel>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>UserPersonalInfo</title>
    <script type="text/javascript">
        function clearForm() {
            ClearMsg();
            $('#UserPersonalInfo input[type=text],input[type=password],select,textarea').each(function () {
                $(this).val("");

                if ($(this).is("select") & $(this)[0].size > 1) {
                    $(this)[0].options.length = 0;
                }
            });

            $('#UserPersonalInfo input[type=radio]').each(function () {
                $(this).attr("checked", false);
            });
            $('#UserPersonalInfo input[type=checkbox]').each(function () {
                $(this).attr("checked", false);
            });
        }
        function submitUserPersonalInfo() {
            ClearMsg();
            var chk = true;
            $('#UserPersonalInfo input[type=text],textarea').each(function () {
                if ($.trim($(this).val()) != "") {
                    chk = false;
                }
            });
            $('#UserPersonalInfo select').each(function () {
                var id = $(this).attr("id");
                if ($("#" + id + " option:selected").val() != "") {
                    chk = false;
                }
            });
            if (!chk) {
                $.ajax({
                    type: "POST",
                    traditional: true,
                    url: "/Admin/UserPersonalInfo",
                    data: {
                        Religion: $("#UserPersonalInfo select[id=Religion]").val(),
                        Category: $("#UserPersonalInfo select[id=Category]").val(),
                        MotherTongue: $("#UserPersonalInfo select[id=MotherTongue]").val(),
                        strDOB: $("#UserPersonalInfo input[id=strDOB]").val(),
                        Email: $("#UserPersonalInfo input[id=Email]").val(),
                        AlternateEmail: $("#UserPersonalInfo input[id=AlternateEmail]").val(),
                        SingleCommAddress: $("#UserPersonalInfo textarea[id=SingleCommAddress]").val(),
                        SinglePermAddress: $("#UserPersonalInfo textarea[id=SinglePermAddress]").val(),
                        ChkSingleAddr: $("#UserPersonalInfo input[id=ChkSingleAddr]").val(),
                        CommLine1: $("#UserPersonalInfo input[id=CommLine1]").val(),
                        CommLine2: $("#UserPersonalInfo input[id=CommLine2]").val(),
                        CommCountry: $("#UserPersonalInfo select[id=CommCountry]").val(),
                        CommState: $("#UserPersonalInfo select[id=CommState]").val(),
                        CommCity: $("#UserPersonalInfo select[id=CommCity]").val(),
                        CommSector: $("#UserPersonalInfo select[id=CommSector]").val(),
                        CommPIN: $("#UserPersonalInfo input[id=CommPIN]").val(),
                        PermLine1: $("#UserPersonalInfo input[id=PermLine1]").val(),
                        PermLine2: $("#UserPersonalInfo input[id=PermLine2]").val(),
                        PermCountry: $("#UserPersonalInfo select[id=PermCountry]").val(),
                        PermState: $("#UserPersonalInfo select[id=PermState]").val(),
                        PermCity: $("#UserPersonalInfo select[id=PermCity]").val(),
                        PermSector: $("#UserPersonalInfo select[id=PermSector]").val(),
                        PermPIN: $("#UserPersonalInfo input[id=PermPIN]").val()
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
            else {
                Failure("No information found to save.");
            }
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
                    var Sector = '<%=Model.setAddressSector %>';
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
                var Sector = '<%=Model.setAddressSector %>';
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
                    var Sector = '<%=Model.setAddressSector %>';
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
                    var Sector = '<%=Model.setAddressSector %>';
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
                var Sector = '<%=Model.setAddressSector %>';
                if (Sector == "True") {
                    $("#PermSector").val("");
                    $("#PermSector").removeAttr("disabled");
                }
                $('#divCommAddress input[type=text],input[type=password],textarea').each(function () {
                    $(this).removeAttr("disabled");

                });
                var Sector = '<%=Model.setAddressSector %>';
                if (Sector == "True") {
                    $("#PermSector").val("");
                    $("#PermSector").removeAttr("disabled");
                }
               
                $("#CommCity").removeAttr("disabled");
                $("#CommState").removeAttr("disabled");
                $("#CommCountry").removeAttr("disabled");
            }
        }
        
    </script>
</head>
<body>
    <div class="clear">
        <div id="UserPersonalInfo">
            <div class="clear">
                <div class="ContentdivHead" onclick="toggleContentDivHead(this,'#divUserPersonalInfo');">
                    <span class="divHeading">Personal Information</span>
                </div>
                <div class="clear">
                    <div class="ContentdivBorder" id="divUserPersonalInfo">
                        <div class="clear">
                            <%-- <div class="FloatLeft" style="width: 80%;">--%>
                            <div class="clear">
                                <div class="FloatLeft" style="width: 50%;">
                                    <div class="clear">
                                        <div class="editor-label FloatLeft" style="width: 40%;">
                                            Religion
                                        </div>
                                        <div class="editor-field" style="text-align: left;">
                                            <%= Html.DropDownListFor(m => m.Religion, Model.Religions, "Select Religion", new { title="Select Religion" })%>
                                        </div>
                                    </div>
                                </div>
                                <div style="float: left; width: 50%;">
                                    <div class="clear">
                                        <div class="editor-label FloatLeft" style="width: 40%;">
                                            Category
                                        </div>
                                        <div class="editor-field" style="text-align: left;">
                                            <%= Html.DropDownListFor(m => m.Category, Model.Categories, "Select Category", new { title = "Select Category" })%>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="clear">
                                <div class="FloatLeft" style="width: 50%;">
                                    <div class="clear">
                                        <div class="editor-label FloatLeft" style="width: 40%;">
                                            Mother Tongue
                                        </div>
                                        <div class="editor-field" style="text-align: left;">
                                            <%= Html.DropDownListFor(m => m.MotherTongue, Model.MotherTongues, "Select Mother Tongue", new { title = "Select Mother Tongue" })%>
                                        </div>
                                    </div>
                                </div>
                                <div style="float: left; width: 50%;">
                                    <div class="clear">
                                        <div class="editor-label FloatLeft" style="width: 40%;">
                                            Date of birth
                                        </div>
                                        <div class="editor-field" style="text-align: left;">
                                            <%= Html.TextBoxFor(m => m.strDOB, new { maxlength = 10, autocomplete = "off", @class = "CalendarBox",title="Select Date of birth from calendar" })%>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <% if (Convert.ToBoolean(Model.setEmail))
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
                        </div>
                    </div>
                </div>
            </div>
            <div class="clear">
                <div style="width: 50%; float: left;">
                    <div class="ContentdivHead" onclick="toggleContentDivHead(this,'#divCommAddress');">
                        <span class="divHeading">Communication Address</span>
                    </div>
                    <div class="clear">
                        <div class="ContentdivBorder" id="divCommAddress">
                            <div class="clear">
                                <% if (Model.setAddress == "Simple")
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
                                        <%= Html.TextAreaFor(m => m.SingleCommAddress, new { maxlength = 2000, autocomplete = "off",title="Type in your detailed Address" })%>
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
                                        <%= Html.TextBoxFor(m => m.CommLine1, new { maxlength = 500, autocomplete = "off", title = "Type in your Communication Address line 1" })%>
                                    </div>
                                </div>
                                <div class="clear">
                                    <div class="editor-label FloatLeft" style="width: 40%;">
                                        Line2
                                    </div>
                                    <div class="editor-field" style="text-align: left;">
                                        <%= Html.TextBoxFor(m => m.CommLine2, new { maxlength = 500, autocomplete = "off", title = "Type in your Communication Address line 2" })%>
                                    </div>
                                </div>
                                <div class="clear">
                                    <div class="editor-label FloatLeft" style="width: 40%;">
                                        Country
                                    </div>
                                    <div class="editor-field" style="text-align: left;">
                                        <%= Html.DropDownListFor(m => m.CommCountry, Model.CommCountries, "Select Country", new { onChange = "CommCountryChange();return false;",title="Select Country" })%>
                                    </div>
                                </div>
                                <div class="clear">
                                    <div class="editor-label FloatLeft" style="width: 40%;">
                                        State
                                    </div>
                                    <div class="editor-field" style="text-align: left;">
                                        <%= Html.DropDownListFor(m => m.CommState, Model.CommStates, "Select State", new { onChange = "CommStateChange();return false;",title="Select State" })%>
                                    </div>
                                </div>
                                <div class="clear">
                                    <div class="editor-label FloatLeft" style="width: 40%;">
                                        City
                                    </div>
                                    <div class="editor-field" style="text-align: left;">
                                        <%= Html.DropDownListFor(m => m.CommCity, Model.CommCities, "Select City", new { onChange = "CommCityChange();return false;",title="Select City" })%>
                                    </div>
                                </div>
                                <% if (Convert.ToBoolean(Model.setAddressSector))
                                   { %>
                                <div class="clear">
                                    <div class="editor-label FloatLeft" style="width: 40%;">
                                        Sector
                                    </div>
                                    <div class="editor-field" style="text-align: left;">
                                        <%= Html.DropDownListFor(m => m.CommSector, Model.CommSectors, "Select Sector", new { title="Select Sector" })%>
                                    </div>
                                </div>
                                <%}
                                   } %>
                                <div class="clear">
                                    <div class="editor-label FloatLeft" style="width: 40%;">
                                        PIN
                                    </div>
                                    <div class="editor-field" style="text-align: left;">
                                        <%= Html.TextBoxFor(m => m.CommPIN, new { maxlength = 20, autocomplete = "off",title="Type in your PIN Code" })%>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div style="float: right; width: 50%;">
                    <div class="ContentdivHead" onclick="toggleContentDivHead(this,'#divPermanentAddress');">
                        <span class="divHeading">Permanent Address</span>
                    </div>
                    <div class="clear">
                        <div class="ContentdivBorder" id="divPermanentAddress">
                            <div class="clear">
                                <div class="ContentdivBorder" id="div1">
                                    <div class="clear">
                                        <% if (Model.setAddress == "Simple")
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
                                                <%= Html.TextAreaFor(m => m.SinglePermAddress, new { maxlength = 2000, autocomplete = "off",title="Type in your Permanent Address" })%>
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
                                                <%= Html.TextBoxFor(m => m.PermLine1, new { maxlength = 500, autocomplete = "off",title="Type in your Permanent address line 1" })%>
                                            </div>
                                        </div>
                                        <div class="clear">
                                            <div class="editor-label FloatLeft" style="width: 40%;">
                                                Line2
                                            </div>
                                            <div class="editor-field" style="text-align: left;">
                                                <%= Html.TextBoxFor(m => m.PermLine2, new { maxlength = 500, autocomplete = "off", title = "Type in your Permanent address line 2" })%>
                                            </div>
                                        </div>
                                        <div class="clear">
                                            <div class="editor-label FloatLeft" style="width: 40%;">
                                                Country
                                            </div>
                                            <div class="editor-field" style="text-align: left;">
                                                <%= Html.DropDownListFor(m => m.PermCountry, Model.PermCountries, "Select Country", new { onChange = "PermCountryChange();return false;",title="Select Country" })%>
                                            </div>
                                        </div>
                                        <div class="clear">
                                            <div class="editor-label FloatLeft" style="width: 40%;">
                                                State
                                            </div>
                                            <div class="editor-field" style="text-align: left;">
                                                <%= Html.DropDownListFor(m => m.PermState, Model.PermStates, "Select State", new { onChange = "PermStateChange();return false;",title="Select State" })%>
                                            </div>
                                        </div>
                                        <div class="clear">
                                            <div class="editor-label FloatLeft" style="width: 40%;">
                                                City
                                            </div>
                                            <div class="editor-field" style="text-align: left;">
                                                <%= Html.DropDownListFor(m => m.PermCity, Model.PermCities, "Select City", new { onChange = "PermCityChange();return false;",title="Select City" })%>
                                            </div>
                                        </div>
                                        <% if (Convert.ToBoolean(Model.setAddressSector))
                                           { %>
                                        <div class="clear">
                                            <div class="editor-label FloatLeft" style="width: 40%;">
                                                Sector
                                            </div>
                                            <div class="editor-field" style="text-align: left;">
                                                <%= Html.DropDownListFor(m => m.PermSector, Model.PermSectors, "Select Sector", new { title="Select Sector" })%>
                                            </div>
                                        </div>
                                        <%}
                                           }%>
                                        <div class="clear">
                                            <div class="editor-label FloatLeft" style="width: 40%;">
                                                PIN
                                            </div>
                                            <div class="editor-field" style="text-align: left;">
                                                <%= Html.TextBoxFor(m => m.PermPIN, new { maxlength = 20, autocomplete = "off",title="Type in your PIN Code" })%>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div id="divButtons" class="clear" style="margin-top: 10px; margin-bottom: 20px;">
                <center>
                    <input type="button" value="OK, Save" title="Save" class="rg_button_red" onclick="submitUserPersonalInfo();return false;" />
                    <input type="button" value="Clear" class="rg_button" title="Clear" onclick="clearForm();return false;" />
                </center>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        // start tracking actovity  
        EnableTimeout();
        $(document).ready(function () {
            var Update = '<%=Model.Calendar %>';
            if (Update == "Advanced") {
                $('#UserPersonalInfo input[id=strDOB]').scroller({ theme: "android-ics light" });
            }
            else {

                $("#UserPersonalInfo input[id=strDOB]").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    showButtonPanel: true
                });
            }
            $("[title]").tooltip({ position: "bottom left" });
        });
    </script>
</body>
</html>
