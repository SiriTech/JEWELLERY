function UpdateInstanceClear() {
    $("#UpdateInstance input[type='text'] ").attr("value", "");
    $("#UpdateInstance select").find('option:first').attr('selected', 'selected');
    ClearMsg();
}

function UpdateInstance() {
    $("#statusDiv").css("display", "none");
    var Id = getElement("hdnInstanceId").value;
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
                        "&From=" + getElement('LicenseFrom').value +
                        "&To=" + getElement('LicenseTo').value +
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
                    var dt = parseInt(stDate,10);
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
        