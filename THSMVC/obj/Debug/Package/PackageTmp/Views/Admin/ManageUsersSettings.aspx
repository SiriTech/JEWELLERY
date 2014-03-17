<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>ManageUsersSettings</title>
    <script type="text/javascript">
        function submitManageUsersSettings() {
            ClearMsg();
            var FoodOffering = $('input[name=FoodOfferingRadio]:checked').val();
            var DietaryNeed = $('input[name=DietaryNeedRadio]:checked').val();
            var Disability = $('input[name=DisabilityRadio]:checked').val();
            var LastName = $('input[name=LastNameRadio]:checked').val();
            var DateofJoining = $('input[name=DateofJoiningRadio]:checked').val();
            var AdmissionDate = $('input[name=AdmissionDateRadio]:checked').val();
            var AdmissionNum = $('input[name=AdmissionNumRadio]:checked').val();
            var Address = $('input[name=AddressRadio]:checked').val();
            var Email = $('input[name=EmailRadio]:checked').val();
            $.ajax(
            {
                type: "POST",
                url: "/Admin/ManageUSersSetting",
                data: "FoodOffering=" + FoodOffering + "&DietaryNeed=" + DietaryNeed + "&Disability=" + Disability + "&LastName=" + LastName + "&DateOfJoining=" + DateofJoining + "&AdmissionDt=" + AdmissionDate + "&AdmissionNo=" + AdmissionNum + "&Address=" + Address + "&Email=" + Email,
                beforeSend: function () {
                    $.blockUI();
                },
                complete: function () {
                    $.unblockUI();
                },
                success: function (result) {
                    if (result.success) {
                        //Success(result.message);
                        GetContentByActionAndController('UserGeneralInfo', 'Admin', 'Create User', '.TabContent');
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
    <div class="clear">
        <div class="ContentdivHead" onclick="toggleContentDivHead(this,'#divManageUsersSettings');">
            <span class="divHeading">First time settings (Please select multiple selection or single selection option for the following properties)</span>
        </div>
        <div class="clear">
            <div class="ContentdivBorder" id="divManageUsersSettings">
                <div class="clear">
                    <div class="editor-label FloatLeft" style="width: 40%;">
                        <span class="ValidationSpan">*</span> Food Offerings
                    </div>
                    <div class="editor-field">
                        <input type="radio" id="FoodOfferingYes" name="FoodOfferingRadio" value="Multiple" title="Multiple" />Multiple selection
                        &nbsp;
                        <input type="radio" id="FoodOfferingNo" name="FoodOfferingRadio" value="Single" checked="checked"
                            title="Single" />Single selection
                    </div>
                </div>
                <div class="clear">
                    <div class="editor-label FloatLeft" style="width: 40%;">
                        <span class="ValidationSpan">*</span> Dietary Needs
                    </div>
                    <div class="editor-field">
                        <input type="radio" id="DietaryNeedMultiple" name="DietaryNeedRadio" value="Multiple" title="Multiple" />Multiple selection
                        &nbsp;
                        <input type="radio" id="DietaryNeedSingle" name="DietaryNeedRadio" value="Single" checked="checked"
                            title="Single" />Single selection
                    </div>
                </div>
                <div class="clear">
                    <div class="editor-label FloatLeft" style="width: 40%;">
                        <span class="ValidationSpan">*</span> Disability
                    </div>
                    <div class="editor-field">
                        <input type="radio" id="DisabilityMultiple" name="DisabilityRadio" value="Multiple" title="Multiple" />Multiple selection
                        &nbsp;
                        <input type="radio" id="DisabilitySingle" name="DisabilityRadio" value="Single" checked="checked"
                            title="Single" />Single selection
                    </div>
                </div>
                  <div class="clear">
                    <div class="editor-label FloatLeft" style="width: 40%;">
                        <span class="ValidationSpan">*</span> Is Last Name Mandatory to fill?
                    </div>
                    <div class="editor-field">
                        <input type="radio" id="LastNameYes" name="LastNameRadio" value="Yes" title="Yes" />Yes
                        &nbsp;
                        <input type="radio" id="LastNameNo" name="LastNameRadio" value="No" checked="checked"
                            title="No" />No
                    </div>
                </div>
                 <div class="clear">
                    <div class="editor-label FloatLeft" style="width: 40%;">
                        <span class="ValidationSpan">*</span> Is Date of joining Mandatory to fill?
                    </div>
                    <div class="editor-field">
                        <input type="radio" id="DateofJoiningYes" name="DateofJoiningRadio" value="Yes" title="Yes" />Yes
                        &nbsp;
                        <input type="radio" id="DateofJoiningNo" name="DateofJoiningRadio" value="No" checked="checked"
                            title="No" />No
                    </div>
                </div>
                 <div class="clear">
                    <div class="editor-label FloatLeft" style="width: 40%;">
                        <span class="ValidationSpan">*</span> Is Admission Date Mandatory to fill?
                    </div>
                    <div class="editor-field">
                        <input type="radio" id="AdmissionDateYes" name="AdmissionDateRadio" value="Yes" title="Yes" />Yes
                        &nbsp;
                        <input type="radio" id="AdmissionDateNo" name="AdmissionDateRadio" value="No" checked="checked"
                            title="No" />No
                    </div>
                </div>
                 <div class="clear">
                    <div class="editor-label FloatLeft" style="width: 40%;">
                        <span class="ValidationSpan">*</span> Is Admission Number Mandatory to fill?
                    </div>
                    <div class="editor-field">
                        <input type="radio" id="AdmissionNumYes" name="AdmissionNumRadio" value="Yes" title="Yes" />Yes
                        &nbsp;
                        <input type="radio" id="AdmissionNumNo" name="AdmissionNumRadio" value="No" checked="checked"
                            title="No" />No
                    </div>
                </div>
                 <div class="clear">
                    <div class="editor-label FloatLeft" style="width: 40%;">
                        <span class="ValidationSpan">*</span> Address in 
                    </div>
                    <div class="editor-field">
                        <input type="radio" id="AddressMultiple" name="AddressRadio" value="Detail" checked="checked" title="Detail" />Detail
                        &nbsp;
                        <input type="radio" id="AddressSingle" name="AddressRadio" value="Simple" 
                            title="Simple" />Simple
                    </div>
                </div>
                 <div class="clear">
                    <div class="editor-label FloatLeft" style="width: 40%;">
                        <span class="ValidationSpan">*</span> Need Sector in Detailed Address? 
                    </div>
                    <div class="editor-field">
                       <input type="radio" id="SectorYes" name="AddressSectorRadio" value="Yes" title="Yes" checked="checked" />Yes
                        &nbsp;
                        <input type="radio" id="SectorNo" name="AddressSectorRadio" value="No" title="No" />No
                    </div>
                </div>
                 <div class="clear">
                    <div class="editor-label FloatLeft" style="width: 40%;">
                        <span class="ValidationSpan">*</span> Will you capture Email/Alternate Email?
                    </div>
                    <div class="editor-field">
                        <input type="radio" id="EmailYes" name="EmailRadio" value="Yes" title="Yes" />Yes
                        &nbsp;
                        <input type="radio" id="EmailNo" name="EmailRadio" value="No" checked="checked"
                            title="No" />No
                    </div>
                </div>
                <div id="divButtons" class="clear" style="margin-top: 10px;">
                    <center>
                        <input type="button" value="Save Settings" class="rg_button_red" onclick="submitManageUsersSettings();return false;" />
                    </center>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
