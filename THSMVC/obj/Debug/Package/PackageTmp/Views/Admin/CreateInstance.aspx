<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>CreateInstance</title>
   <script type="text/javascript">
       function CreateInstanceClear() {
           $("#CreateInstance input[type='text'] ").attr("value", "");
           $("#CreateInstance select").find('option:first').attr('selected', 'selected');
           ClearMsg();
       }
       $(function () {
           LoadCountries();
           LoadStates();
           LoadCities();
           LoadSectors();
           LoadInstances();
       });
       function CreateInstance() {
           $("#statusDiv").css("display", "none");

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

           if (getElement('LicenseFrom').value == "") {
               msg = msg + " License From Required <br/>";
           }
           if (getElement('LicenseTo').value == "") {
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
                url: "/Admin/CreateInstance",
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
                        "&From=" + getElement('LicenseFrom').value +
                        "&To=" + getElement('LicenseTo').value,
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
    <div id="CreateInstance">
    <div id="validationDiv" style="margin-top: 10px; font-weight: bold; color: Red;">
                    </div>
                    <div id="statusDiv" style="margin-top: 10px;">
                        <center>
                            <span id="_status" style="font-size: 1px; font-weight: bold;"></span>
                        </center>
                    </div>
        <div class="clear">
            <div class="divHead">
                <span class="divHeading">Create Instance</span>
            </div>
            <div class="clear">
                <div class="divBorder">
                    <div class="clear">
                        <div class="editor-label FloatLeft" style="width: 40%;">
                            <span class="ValidationSpan">*</span> Instance Name
                        </div>
                        <div class="editor-field">
                            <input type="text" id="InstanceName" />
                        </div>
                    </div>
                    <div class="clear">
                        <div class="editor-label FloatLeft" style="width: 40%;">
                            Parent Instance
                        </div>
                        <div class="editor-field">
                            <select id="ParentInstance" name="ParentInstance">
                            </select>
                        </div>
                    </div>
                    <div class="clear">
                        <div class="editor-label FloatLeft" style="width: 40%;">
                            <span class="ValidationSpan">*</span> Country
                        </div>
                        <div class="editor-field">
                            <select id="Country" name="Country" onchange="CountryChange();return false;">
                            </select>
                        </div>
                    </div>
                    <div class="clear">
                        <div class="editor-label FloatLeft" style="width: 40%;">
                            <span class="ValidationSpan">*</span> State
                        </div>
                        <div class="editor-field">
                            <select id="State" name="State" onchange="StateChange();return false;">
                            </select>
                        </div>
                    </div>
                    <div class="clear">
                        <div class="editor-label FloatLeft" style="width: 40%;">
                            City
                        </div>
                        <div class="editor-field">
                             <select id="City" name="City" onchange="CityChange();return false;">
                                        </select>
                        </div>
                    </div>
                    <div class="clear">
                        <div class="editor-label FloatLeft" style="width: 40%;">
                            Sector
                        </div>
                        <div class="editor-field">
                            <select id="Sector" name="Sector">
                            </select>
                        </div>
                    </div>
                    <div class="clear">
                        <div class="editor-label FloatLeft" style="width: 40%;">
                            Location
                        </div>
                        <div class="editor-field">
                            <input type="text" id="Location" />
                        </div>
                    </div>
                    <div class="clear">
                        <div class="editor-label FloatLeft" style="width: 40%;">
                            PIN
                        </div>
                        <div class="editor-field">
                            <input type="text" id="PIN" />
                        </div>
                    </div>
                    <div class="clear">
                        <div class="editor-label FloatLeft" style="width: 40%;">
                            Phone
                        </div>
                        <div class="editor-field">
                            <input type="text" id="Phone" />
                        </div>
                    </div>
                    <div class="clear">
                        <div class="editor-label FloatLeft" style="width: 40%;">
                            Mobile
                        </div>
                        <div class="editor-field">
                            <input type="text" id="Mobile" />
                        </div>
                    </div>
                    <div class="clear">
                        <div class="editor-label FloatLeft" style="width: 40%;">
                           <span class="ValidationSpan">*</span> License From
                        </div>
                        <div class="editor-field">
                            <input type="text" id="LicenseFrom" />
                        </div>
                    </div>
                    <div class="clear">
                        <div class="editor-label FloatLeft" style="width: 40%;">
                            <span class="ValidationSpan">*</span> License To
                        </div>
                        <div class="editor-field">
                            <input type="text" id="LicenseTo" />
                        </div>
                    </div>
                    <div id="divButtons" class="clear" style="margin-top: 10px;">
                        <center>
                            <input type="button" value="Create" class="rg_button_red" onclick="CreateInstance();return false;" />
                            <input type="button" class="rg_button"  value="Clear" onclick="CreateInstanceClear();return false;" />
                        </center>
                    </div>
                </div>
            </div>
        </div>
    </div>
   <script defer="defer" type="text/javascript">
       $(document).ready(function () {
           $("#LicenseFrom").datepicker();
           $("#LicenseTo").datepicker();
       });
       //eval(LoadScriptJS("CreateInstance.js"));
   </script>
   <script type="text/javascript">
       // start tracking actovity  
       EnableTimeout(); 
    </script>
</body>
</html>
