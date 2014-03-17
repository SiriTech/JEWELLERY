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
