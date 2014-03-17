<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<THSMVC.Models.CreateInstanceModel>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>UpdateInstance</title>
    <script type="text/javascript">
        function UpdateInstanceClear() {
            $("#UpdateInstance input[type='text'] ").attr("value", "");
            $("#UpdateInstance select").find('option:first').attr('selected', 'selected');
            ClearMsg();
        }

        function UpdateInstance() {
            $("#statusDiv").css("display", "none");
            var Id = getElement("Id").value;
            var msg;
            msg = "";
            if (getElement('InstanceName').value == "") {
                msg = "Instance Name Required <br/>";
            }
            if (getElement('Country').selectedIndex == 0) {
                msg = msg + " Select Country <br/>";
            }
            if (getElement('State').selectedIndex == 0) {
                msg = msg + " Select State <br/>";
            }

            if (getElement('LicenseFromString').value == "") {
                msg = msg + " License From Required <br/>";
            }
            if (getElement('LicenseToString').value == "") {
                msg = msg + " License To Required <br/>";
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
                url: "/Admin/UpdateInstance",
                data: "InstanceName=" + getElement('InstanceName').value +
                        "&ParentInstance=" + getElement('ParentInstance').options[getElement('ParentInstance').selectedIndex].value +
                        "&Country=" + getElement('Country').options[getElement('Country').selectedIndex].value +
                        "&State=" + getElement('State').options[getElement('State').selectedIndex].value +
                        "&City=" + getElement('City').options[getElement('City').selectedIndex].value +
                        "&Sector=" + getElement('Sector').options[getElement('Sector').selectedIndex].value +
                        "&Location=" + getElement('Location').value +
                        "&PIN=" + getElement('PIN').value +
                        "&Phone=" + getElement('Phone').value +
                        "&Mobile=" + getElement('Mobile').value +
                        "&From=" + getElement('LicenseFromString').value +
                        "&To=" + getElement('LicenseToString').value +
                        "&Id=" + Id,
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


        function GetDetails() {
            var Id = getElement("hdnInstanceId").value;
            $.ajax(
            {
                type: "POST",
                url: "/Admin/GetInstanceById",
                data: "Id=" + Id,
                beforeSend: function () {
                    $.blockUI();

                },
                complete: function () {
                    $.unblockUI();
                },
                success: function (Instance) {
                    getElement("InstanceName").value = Instance[0].Name;
                    $("#ParentInstance").val(Instance[0].ParentInstance);
                    $("#Country").val(Instance[0].Country);
                    $("#State").val(Instance[0].State);
                    $("#City").val(Instance[0].City);
                    $("#Sector").val(Instance[0].Sector);
                    if (Instance[0].Location != null)
                        getElement("Location").value = Instance[0].Location;
                    if (Instance[0].PIN != null)
                        getElement("PIN").value = Instance[0].PIN;
                    if (Instance[0].Phone != null)
                        getElement("Phone").value = Instance[0].Phone;
                    if (Instance[0].Mobile != null)
                        getElement("Mobile").value = Instance[0].Mobile;
                    var start = (Instance[0].LicenseStartDate).replace("/Date(", "");
                    var stDate = (start).replace(")/", "");
                    var dt = parseInt(stDate, 10);
                    date = new Date(dt);
                    fStart = date.getMonth() + 1 + '/' + date.getDate() + '/' + date.getFullYear();
                    getElement("LicenseFrom").value = fStart;
                    var end = (Instance[0].LicenseEndDate).replace("/Date(", "");
                    var stDate1 = (end).replace(")/", "");
                    var dt1 = parseInt(stDate1, 10);
                    date = new Date(dt1);
                    fEnd = date.getMonth() + 1 + '/' + date.getDate() + '/' + date.getFullYear();

                    getElement("LicenseTo").value = fEnd;

                },
                error: function (req, status, error) {
                    $("#_status").slideDown(250).text("Oops! Please try again later."); // show status message with animation
                    $("#_status").animate({ fontSize: "1em" }, { duration: 500 }).animate({ color: "red" }, { duration: 1000 });
                    window.scroll(0, 0);
                }
            });
        }
        
    </script>
</head>
<body>
   <div id="UpdateInstance">
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
                            <span class="ValidationSpan">*</span> Instance Name
                        </div>
                        <div class="editor-field">
                             <%= Html.TextBoxFor(m => m.InstanceName)%>
                                        <%: Html.HiddenFor(m => m.Id)%>
                        </div>
                    </div>
                    <div class="clear">
                        <div class="editor-label FloatLeft" style="width: 40%;">
                            Parent Instance
                        </div>
                        <div class="editor-field">
                            <%= Html.DropDownListFor(m => m.ParentInstance, Model.Instances, "Select Instance")%>
                        </div>
                    </div>
                    <div class="clear">
                        <div class="editor-label FloatLeft" style="width: 40%;">
                            <span class="ValidationSpan">*</span> Country
                        </div>
                        <div class="editor-field">
                            <%= Html.DropDownListFor(m => m.Country, Model.Countries, "Select Country", new { onChange = "CountryChange();return false;" })%>
                        </div>
                    </div>
                    <div class="clear">
                        <div class="editor-label FloatLeft" style="width: 40%;">
                            <span class="ValidationSpan">*</span> State
                        </div>
                        <div class="editor-field">
                            <%= Html.DropDownListFor(m => m.State, Model.States, "Select State", new { onChange = "StateChange();return false;" })%>
                        </div>
                    </div>
                    <div class="clear">
                        <div class="editor-label FloatLeft" style="width: 40%;">
                            City
                        </div>
                        <div class="editor-field">
                            <%= Html.DropDownListFor(m => m.City, Model.Cities, "Select City", new { onChange = "CityChange();return false;" })%>
                        </div>
                    </div>
                    <div class="clear">
                        <div class="editor-label FloatLeft" style="width: 40%;">
                            Sector
                        </div>
                        <div class="editor-field">
                           <%= Html.DropDownListFor(m => m.Sector, Model.Sectors, "Select Sector")%>
                        </div>
                    </div>
                    <div class="clear">
                        <div class="editor-label FloatLeft" style="width: 40%;">
                            Location
                        </div>
                        <div class="editor-field">
                            <%= Html.TextBoxFor(m => m.Location)%>
                        </div>
                    </div>
                    <div class="clear">
                        <div class="editor-label FloatLeft" style="width: 40%;">
                            PIN
                        </div>
                        <div class="editor-field">
                            <%= Html.TextBoxFor(m => m.PIN)%>
                        </div>
                    </div>
                    <div class="clear">
                        <div class="editor-label FloatLeft" style="width: 40%;">
                            Phone
                        </div>
                        <div class="editor-field">
                            <%= Html.TextBoxFor(m => m.Phone)%>
                        </div>
                    </div>
                    <div class="clear">
                        <div class="editor-label FloatLeft" style="width: 40%;">
                            Mobile
                        </div>
                        <div class="editor-field">
                            <%= Html.TextBoxFor(m => m.Mobile)%>
                        </div>
                    </div>
                    <div class="clear">
                        <div class="editor-label FloatLeft" style="width: 40%;">
                           <span class="ValidationSpan">*</span> License From
                        </div>
                        <div class="editor-field">
                             <%= Html.TextBoxFor(m => m.LicenseFromString)%>
                        </div>
                    </div>
                    <div class="clear">
                        <div class="editor-label FloatLeft" style="width: 40%;">
                            <span class="ValidationSpan">*</span> License To
                        </div>
                        <div class="editor-field">
                            <%= Html.TextBoxFor(m => m.LicenseToString)%>
                        </div>
                    </div>
                    <div id="divButtons" class="clear" style="margin-top: 10px;">
                        <center>
                            <input type="button" value="Update" onclick="UpdateInstance();return false;" />
                            <input type="button" value="Clear" onclick="UpdateInstanceClear();return false;" />
                        </center>
                    </div>
                </div>
            </div>
        </div>
    </div>
   <script defer="defer" type="text/javascript">
       $(document).ready(function () {
           $("#LicenseFromString").datepicker();
           $("#LicenseToString").datepicker();
       });
//       eval(LoadScriptJS("UpdateInstance.js"));
   </script>
   <script type="text/javascript">
       // start tracking actovity  
       EnableTimeout(); 
    </script>
</body>
</html>
