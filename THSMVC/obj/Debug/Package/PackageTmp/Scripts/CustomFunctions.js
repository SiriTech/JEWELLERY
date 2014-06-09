
function getElement(id) {
    return document.getElementById(id);
}
function checkEmail(Id) {
    if (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(getElement(Id).value)) {
        return (true)
    }
    return false;
}
function EmptyGrid(element) {
    $(element).html("<div class='clear' style='border:1px solid red;background-color:#faebeb;color:#1a8ca3;font-weight:bold;font-family: Lucida Calligraphy;'><div style='float:left;text-align:right;width:40%;'><img src='../../images/No_idea.png' width='40px' height='40px' /></div><div style='float:right;text-align:left;vertical-align:middle;width:60%;line-height:3.5em;'> No Information Found to view.</div></div>");

} function ChooseColorPopUp(obj) {
    $("#obj_ref").text(obj);
    $("#basic-modal-content").modal({ minHeight: 300 });
    GetContentByActionAndController('BBColor', 'OnlineTest', 'Manage Test', '#basic-modal-content');
}
function ChooseYTPopUp(obj) {
    $("#obj_ref").text(obj);
    $("#basic-modal-content").modal({ minHeight: 500, close: false });
    GetContentByActionAndController('BBYouTube', 'OnlineTest', 'Manage Test', '#basic-modal-content');
}
var fixGridHeight = function (grid) {
    var gviewNode = grid[0].parentNode.parentNode.parentNode;
    //var gview = grid.parent().parent().parent(); 
    //var bdiv = jQuery("#gview_" + grid[0].id + " .ui-jqgrid-bdiv"); 
    var bdiv = jQuery(".ui-jqgrid-bdiv", gviewNode);
    if (bdiv.length) {
        var delta = bdiv[0].scrollHeight - bdiv[0].clientHeight;
        var height = grid.height();
        if (delta !== 0 && height && (height - delta > 0)) {
            grid.setGridHeight(height - delta);
        }
    }
};

function fixGridWidth(grid) {
    if (grid[0] != undefined) {
        var gviewScrollWidth = grid[0].parentNode.parentNode.parentNode.scrollWidth;
        var mainWidth = jQuery('#Content').width();
        var gridScrollWidth = grid[0].scrollWidth;
        var htable = jQuery('table.ui-jqgrid-htable', grid[0].parentNode.parentNode.parentNode);
        var scrollWidth = gridScrollWidth;
        if (htable.length > 0) {
            var hdivScrollWidth = htable[0].scrollWidth;
            if ((gridScrollWidth < hdivScrollWidth))
                scrollWidth = hdivScrollWidth; // max (gridScrollWidth, hdivScrollWidth) 
        }
        if (gviewScrollWidth != scrollWidth || scrollWidth > mainWidth) {

            var newGridWidth = (scrollWidth <= mainWidth) ? scrollWidth : mainWidth;  // min (scrollWidth, mainWidth) 
            // if the grid has no data, gridScrollWidth can be less then hdiv[0].scrollWidth
            if (newGridWidth != gviewScrollWidth) {
                grid.jqGrid("setGridWidth", newGridWidth);
            }

        }
        else {
            grid.jqGrid("setGridWidth", mainWidth);
        }
        grid.jqGrid("setGridWidth", mainWidth);
    }
};
var fixGridSize = function (grid) {
    fixGridWidth(grid);

};

function getParameterByName(name) { var match = RegExp('[?&]' + name + '=([^&]*)').exec(window.location.search); return match && decodeURIComponent(match[1].replace(/\+/g, ' ')); }
function MenuHide(span, id) {
    if (document.getElementById(id).style.display == 'block') {
        document.getElementById(id).style.display = 'none'; span.className = 'MenuOpenSpan';
    }
    else {
        document.getElementById(id).style.display = 'block'; span.className = 'MenuCloseSpan';
    }
}
function ClearMsg() {
    //    $("#fixedtop2").html("");
    //    $("#center250b").css("display", "none");
    $.noty.close()


}
function toggleContentDivHead(obj, contentdiv) {
    if ($(obj)[0].className == "ContentdivHeadOver") {
        $(obj)[0].className = "ContentdivHead";
        $(contentdiv).slideDown();
    }
    else {
        $(obj)[0].className = "ContentdivHeadOver";
        $(contentdiv).slideUp();
    }
}
function toggleContentDivHeadMenu(obj, contentdiv) {
    if ($(obj)[0].className == "ContentdivHeadOverMenu") {
        $(obj)[0].className = "ContentdivHeadMenu";
        $(contentdiv).slideDown();
    }
    else {
        $(obj)[0].className = "ContentdivHeadOverMenu";
        $(contentdiv).slideUp();
    }
}
function Success(result) {
    //    $("#center250b").css({ 'display': 'block' });
    //    $("#fixedtop2").css({ 'color': 'green' });
    //    $("#fixedtop2").html(result + "<a id='closeMsg' onclick='ClearMsg();' href='#' style='margin-right:15px;float:right;color:gray;text-decoration:none;'>X</a>"); // show status message with animation
    // window.scroll(0, 0);
    noty({ text: result, type: "success" });
}
function Failure(result) {
    //    $("#center250b").css({ 'display': 'block' });
    //    $("#fixedtop2").css({ 'color': 'red' });
    //    $("#fixedtop2").html(result + "<a id='closeMsg' onclick='ClearMsg();' href='#' style='margin-right:15px;float:right;color:gray;text-decoration:none;'>X</a>"); // show status message with animation
    //window.scroll(0, 0);
    noty({ text: result, type: "error" });
}
function Error(req, status, error) {
    //    $("#center250b").css({ 'display': 'block' });
    //    $("#fixedtop2").css({ 'background-color': 'white', 'color': 'green' });
    //    $("#fixedtop2").html("Sorry! Please try again later" + "<a id='closeMsg' onclick='ClearMsg();' href='#' style='margin-right:15px;float:right;color:gray;text-decoration:none;'>X</a>"); // show status message with animation
    // window.scroll(0, 0);
    $.ajax({
        type: "POST",
        url: "/Shared/ErrorLog",
        dataType: "json",
        traditional: true,
        data: {
            ErrorHead: "<head>" + $(req.responseText)[0].outerHTML + "</head>",
            ErrorBody: "<body>" + $(req.responseText)[1].outerHTML,
            ErrorBody1: $(req.responseText)[2].outerHTML,
            ErrorScript: $(req.responseText)[7].outerHTML + "</body>"
        },
        beforeSend: function () {
            //$.blockUI();   //this is great plugin - 'blockUI'
        },
        success: function (response) {

           // $.unblockUI();
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            //$.unblockUI();

        }
    });
    noty({ text: "Sorry! Please try again later", type: "error" });
}
function Validation(result) {
    noty({ text: result, type: "error" });
}
function Information(result) {
    noty({ text: result, type: "information", force: true });
}

function PopulateMenuWithContent(obj, Action, Controller, Id) {
    ClearMsg();
    $("#Content").empty();
    $.ajax({
        type: "POST",
        url: "/Shared/LeftMenu?MenuId=" + Id,
        dataType: "html",
        beforeSend: function () {
            $.blockUI();   //this is great plugin - 'blockUI'
        },
        success: function (response) {
            $(".menuChange")[0].className = "";
            $.ajax({
                type: "POST",
                url: "/Shared/JsonView?MenuId=" + Id,
                dataType: "html",
                beforeSend: function () {
                    $.blockUI();   //this is great plugin - 'blockUI'
                },
                success: function (response) {
                    $("#Content").html(response);
                    //                    var div = getElement("Content");
                    //                    var x = div.getElementsByTagName("script");
                    //                    debugger;
                    //                    for (var i = 0; i < x.length; i++) {
                    //                        eval(x[i].text);
                    //                    }
                    getElement(obj.id).className = 'menuChange';
                    document.title = obj.id;
                    $("#Content :input[type='text']:enabled:first").focus();
                    $.unblockUI();
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    $.unblockUI();

                }
            });
            $("#LeftMenuContainer").html(response);

        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            $.unblockUI();
            Error(XMLHttpRequest, text, errorThrown);

        }
    });

}
function LoadFirstContent(Id, Name) {
    ClearMsg();
    $("#Content").empty();
    if (Id != "") {
        $.ajax({
            type: "POST",
            url: "/Shared/JsonView?MenuId=" + Id,
            dataType: "html",
            beforeSend: function () {
                $.blockUI();   //this is great plugin - 'blockUI'
            },
            success: function (response) {
                $("#Content").html(response);
                //                var div = getElement("Content");
                //                var x = div.getElementsByTagName("script");
                //                for (var i = 0; i < x.length; i++) {
                //                    eval(x[i].text);
                //                }
                document.title = Name;
                // $("#Content :input[type='text']:enabled:first").focus();
                $("#Content :input[type='text']:enabled:first").focus();
                $.unblockUI();
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                $.unblockUI();
                Error(XMLHttpRequest, textStatus, errorThrown);

            }
        });
    }
}

function LoadContentByActionAndController(Action, Controller, Viewtitle) {
    ClearMsg();
    $("#Content").empty();
    $.ajax({
        type: "POST",
        url: "/Shared/JsonViewByActionAndController",
        data: "Action=" + Action + "&Controller=" + Controller,
        dataType: "html",
        beforeSend: function () {
            $.blockUI();   //this is great plugin - 'blockUI'
        },
        success: function (response) {
            $("#Content").html(response);
            document.title = Viewtitle;
            //            var div = getElement("Content");
            //            debugger;
            //            var x = div.getElementsByTagName("script");
            //            for (var i = 0; i < x.length; i++) {
            //                eval(x[i].text);
            //            }
            $("#Content :input[type='text']:enabled:first").focus();
            $.unblockUI();
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            $.unblockUI();
            Error(XMLHttpRequest, text, errorThrown);

        }
    });
}
function GetContentByActionAndController(Action, Controller, Viewtitle, contentHolder) {
    ClearMsg();
    $(contentHolder).empty();
    $(contentHolder).html("<img alt='indicator' src='../../images/indicator.gif' /><b>Loading...</b>");
    $.ajax({
        type: "POST",
        url: "/Shared/JsonViewByActionAndController",
        data: "Action=" + Action + "&Controller=" + Controller,
        dataType: "html",
        beforeSend: function () {
            $.blockUI();   //this is great plugin - 'blockUI'
        },
        success: function (response) {
            $(contentHolder).html(response);
            document.title = Viewtitle;
            $("#Content :input[type='text']:enabled:first").focus();
            $.unblockUI();
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            $.unblockUI();

            Error(XMLHttpRequest, textStatus, errorThrown);

        }
    });
}
function LoadContentByActionAndControllerForEdit(Action, Controller, Viewtitle, Id) {
    ClearMsg();
    $("#Content").empty();
    $.ajax({
        type: "POST",
        url: "/Shared/JsonViewByActionAndControllerForEdit",
        data: "Action=" + Action + "&Controller=" + Controller + "&Id=" + Id,
        dataType: "html",
        beforeSend: function () {
            $.blockUI();   //this is great plugin - 'blockUI'
        },
        success: function (response) {
            $("#Content").html(response);
            document.title = Viewtitle;
            //            var div = getElement("Content");
            //            debugger;
            //            var x = div.getElementsByTagName("script");
            //            for (var i = 0; i < x.length; i++) {
            //                eval(x[i].text);
            //            }
            //$("#Content :input[type='text']:enabled:first").focus();
            $.unblockUI();
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            $.unblockUI();
            Error(XMLHttpRequest, textStatus, errorThrown);

        }
    });
}
function LoadContentByActionAndControllerForEditMultipleParams(Action, Controller, Viewtitle, Id, Id1) {
    ClearMsg();
    $("#Content").empty();
    $.ajax({
        type: "POST",
        url: "/Shared/JsonViewByActionAndControllerForEditMultipleParams",
        data: "Action=" + Action + "&Controller=" + Controller + "&Id=" + Id + "&Id1=" + Id1,
        dataType: "html",
        beforeSend: function () {
            $.blockUI();   //this is great plugin - 'blockUI'
        },
        success: function (response) {
            $("#Content").html(response);
            document.title = Viewtitle;
            //            var div = getElement("Content");
            //            debugger;
            //            var x = div.getElementsByTagName("script");
            //            for (var i = 0; i < x.length; i++) {
            //                eval(x[i].text);
            //            }
            //$("#Content :input[type='text']:enabled:first").focus();
            $.unblockUI();
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            $.unblockUI();
            Error(XMLHttpRequest, textStatus, errorThrown);

        }
    });
}
function LoadContentByActionAndControllerForEditMultipleParamsWithMenuId(Action, Controller, Viewtitle, Id, Id1, MenuId) {
    ClearMsg();
    $("#Content").empty();
    $.ajax({
        type: "POST",
        url: "/Shared/JsonViewByActionAndControllerForEditMultipleParamsWithMenuId",
        data: "Action=" + Action + "&Controller=" + Controller + "&Id=" + Id + "&Id1=" + Id1 + "&MenuId=" + MenuId,
        dataType: "html",
        beforeSend: function () {
            $.blockUI();   //this is great plugin - 'blockUI'
        },
        success: function (response) {
            $("#Content").html(response);
            document.title = Viewtitle;
            //            var div = getElement("Content");
            //            debugger;
            //            var x = div.getElementsByTagName("script");
            //            for (var i = 0; i < x.length; i++) {
            //                eval(x[i].text);
            //            }
            //$("#Content :input[type='text']:enabled:first").focus();
            $.unblockUI();
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            $.unblockUI();
            Error(XMLHttpRequest, textStatus, errorThrown);

        }
    });
}
function LoadContentByActionAndControllerForEditWithMenuId(Action, Controller, Viewtitle, Id, MenuId) {
    ClearMsg();
    $("#Content").empty();
    $.ajax({
        type: "POST",
        url: "/Shared/JsonViewByActionAndControllerForEditWithMenuId",
        data: "Action=" + Action + "&Controller=" + Controller + "&Id=" + Id + "&MenuId=" + MenuId,
        dataType: "html",
        beforeSend: function () {
            $.blockUI();   //this is great plugin - 'blockUI'
        },
        success: function (response) {
            $("#Content").html(response);
            document.title = Viewtitle;
            //            var div = getElement("Content");
            //            debugger;
            //            var x = div.getElementsByTagName("script");
            //            for (var i = 0; i < x.length; i++) {
            //                eval(x[i].text);
            //            }
            $("#Content :input[type='text']:enabled:first").focus();
            $.unblockUI();
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            $.unblockUI();
            Error(XMLHttpRequest, textStatus, errorThrown);

        }
    });
}
function GetContentByActionAndControllerForEdit(Action, Controller, Viewtitle, Id, contentHolder) {
    ClearMsg();
    $(contentHolder).empty();
    $.ajax({
        type: "POST",
        url: "/Shared/JsonViewByActionAndControllerForEdit",
        data: "Action=" + Action + "&Controller=" + Controller + "&Id=" + Id,
        dataType: "html",
        beforeSend: function () {
            $.blockUI();   //this is great plugin - 'blockUI'
        },
        success: function (response) {
            $(contentHolder).html(response);
            document.title = Viewtitle;
            //            var div = getElement("Content");
            //            debugger;
            //            var x = div.getElementsByTagName("script");
            //            for (var i = 0; i < x.length; i++) {
            //                eval(x[i].text);
            //            }
            //$("#Content :input[type='text']:enabled:first").focus();
            $.unblockUI();
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            $.unblockUI();
            Error(XMLHttpRequest, textStatus, errorThrown);

        }
    });
}
function GetContentByActionAndControllerForEditMenuId(Action, Controller, Viewtitle, Id, contentHolder,MenuId) {
    ClearMsg();
    $(contentHolder).empty();
    $.ajax({
        type: "POST",
        url: "/Shared/JsonViewByActionAndControllerForEditWithMenuId",
        data: "Action=" + Action + "&Controller=" + Controller + "&Id=" + Id + "&MenuId=" + MenuId,
        dataType: "html",
        beforeSend: function () {
            $.blockUI();   //this is great plugin - 'blockUI'
        },
        success: function (response) {
            $(contentHolder).html(response);
            document.title = Viewtitle;
            //            var div = getElement("Content");
            //            debugger;
            //            var x = div.getElementsByTagName("script");
            //            for (var i = 0; i < x.length; i++) {
            //                eval(x[i].text);
            //            }
            //$("#Content :input[type='text']:enabled:first").focus();
            $.unblockUI();
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            $.unblockUI();
            Error(XMLHttpRequest, textStatus, errorThrown);

        }
    });
}
function clearForm() {
    ClearMsg();
    $('input[type=text],input[type=password],select').each(function () {
        $(this).val("");

        if ($(this).is("select") & $(this)[0].size > 1) {
            $(this)[0].options.length = 0;
        }
    });

    $('input[type=radio]').each(function () {
        $(this).attr("checked", false);
    });
}
function ChangePwdClear() {
    $("#ChangePwd input[type='password'] ").attr("value", "");
    ClearMsg();
}
function submitChangePwd() {
    ClearMsg();
    $("#statusDiv").css("display", "none");
    var OldPwd = document.getElementById('OldPassword');
    var NewPwd = document.getElementById('NewPassword');
    var ConfirmNewPwd = document.getElementById('ConfirmPassword');
    var msg;
    msg = ""
    if (getElement('OldPassword').value == "") {
        msg = "Old Password Required <br/>";
    }
    if (getElement('NewPassword').value == "") {
        msg = msg + " New Password Required <br/>";
    }
    else {
        if (getElement('NewPassword').value.length < 5) {
            msg = msg + " New Password must be atleast '5' characters long <br/>";
        }
    }
    if (getElement('ConfirmPassword').value == "") {
        msg = msg + " Confirm Password Required <br/>";
    }
    if (getElement('NewPassword').value != getElement('ConfirmPassword').value) {
        msg = msg + " New Password and Confirm password must be same ";
    }
    if (msg != "") {
        //        msg = "<center>" + msg + "</center>"
        //        $("#validationDiv").css("display", "block");
        //        document.getElementById('validationDiv').innerHTML = msg;
        //        $("#validationDiv").fadeTo(7000, 1).hide(1000);
        Failure(msg);
        return false;
    }
    $.ajax(
            {
                type: "POST",
                url: "/Shared/ChangePassword",
                data: "OldPwd=" + getElement('OldPassword').value + "&NewPwd=" + getElement('NewPassword').value,
                beforeSend: function () {
                    $.blockUI();
                },
                complete: function () {
                    $.unblockUI();
                },
                success: function (result) {
                    if (result.success) {
                        //PopulateMenuWithContent('Home', 'Welcome', 'Admin', '12');

                        Success(result.message);
                        $('#Home').click();
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
function LoadCitiesByState(StateId) {
    ClearMsg();
    $.ajax({
        type: "POST",
        url: "/Admin/CitiesListByState",
        data: "StateId=" + StateId,
        dataType: "json",
        beforeSend: function () {
            $.blockUI();   //this is great plugin - 'blockUI'
        },
        success: function (cities) {
            $("#City").find('option').remove();
            $City = $("#City");
            $.each(cities, function (i, city) {
                if (i == 0) { $City.append('<option value="">Select City</option>'); }
                $City.append('<option value="' + city.Value + '">' + city.Text + '</option>');
            });
            $.unblockUI();
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            $.unblockUI();
            Error(XMLHttpRequest, textStatus, errorThrown);
        }
    });
}
function LoadSectorsByCity(CityId) {
    ClearMsg();
    $.ajax({
        type: "POST",
        url: "/Admin/SectorsListByCity",
        data: "CityId=" + CityId,
        dataType: "json",
        beforeSend: function () {
            $.blockUI();   //this is great plugin - 'blockUI'
        },
        success: function (cities) {
            $("#Sector").find('option').remove();
            $City = $("#Sector");
            $.each(cities, function (i, city) {
                if (i == 0) { $City.append('<option value="">Select Sector</option>'); }
                $City.append('<option value="' + city.Value + '">' + city.Text + '</option>');
            });
            $.unblockUI();
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            $.unblockUI();
            var errMsg = "<P>Error Loading: " + XMLHttpRequest.responseText + "<br/>";
            Failure(errMsg);
        }
    });
}
function LoadStatesByCountry(countryId) {
    ClearMsg();
    $.ajax({
        type: "POST",
        url: "/Admin/StatesListByCountry",
        data: "CountryId=" + countryId,
        dataType: "json",
        beforeSend: function () {
            $.blockUI();   //this is great plugin - 'blockUI'
        },
        success: function (states) {
            $("#State").find('option').remove();
            $State = $("#State");
            $.each(states, function (i, state) {
                if (i == 0) { $State.append('<option value="">Select State</option>'); }
                $State.append('<option value="' + state.Value + '">' + state.Text + '</option>');
            });
            $.unblockUI();
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            $.unblockUI();
            var errMsg = "<P>Error Loading: " + XMLHttpRequest.responseText + "<br/>";
            Failure(errMsg);
        }
    });
}
function LoadCommStatesByCommCountry(countryId) {
    ClearMsg();
    $.ajax({
        type: "POST",
        url: "/Admin/StatesListByCountry",
        data: "CountryId=" + countryId,
        dataType: "json",
        beforeSend: function () {
            $.blockUI();   //this is great plugin - 'blockUI'
        },
        success: function (states) {
            $("#CommState").find('option').remove();
            $State = $("#CommState");
            $.each(states, function (i, state) {
                if (i == 0) { $State.append('<option value="">Select State</option>'); }
                $State.append('<option value="' + state.Value + '">' + state.Text + '</option>');
            });
            $.unblockUI();
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            $.unblockUI();
            var errMsg = "<P>Error Loading: " + XMLHttpRequest.responseText + "<br/>";
            Failure(errMsg);
        }
    });
}
function LoadCommCitiesByCommState(StateId) {
    ClearMsg();
    $.ajax({
        type: "POST",
        url: "/Admin/CitiesListByState",
        data: "StateId=" + StateId,
        dataType: "json",
        beforeSend: function () {
            $.blockUI();   //this is great plugin - 'blockUI'
        },
        success: function (cities) {
            $("#CommCity").find('option').remove();
            $City = $("#CommCity");
            $.each(cities, function (i, city) {
                if (i == 0) { $City.append('<option value="">Select City</option>'); }
                $City.append('<option value="' + city.Value + '">' + city.Text + '</option>');
            });
            $.unblockUI();
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            $.unblockUI();
            var errMsg = "<P>Error Loading: " + XMLHttpRequest.responseText + "<br/>";
            Failure(errMsg);
        }
    });
}
function LoadCommSectorsByCommCity(CityId) {
    ClearMsg();
    $.ajax({
        type: "POST",
        url: "/Admin/SectorsListByCity",
        data: "CityId=" + CityId,
        dataType: "json",
        beforeSend: function () {
            $.blockUI();   //this is great plugin - 'blockUI'
        },
        success: function (cities) {
            $("#CommSector").find('option').remove();
            $City = $("#CommSector");
            $.each(cities, function (i, city) {
                if (i == 0) { $City.append('<option value="">Select Sector</option>'); }
                $City.append('<option value="' + city.Value + '">' + city.Text + '</option>');
            });
            $.unblockUI();
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            $.unblockUI();
            var errMsg = "<P>Error Loading: " + XMLHttpRequest.responseText + "<br/>";
            Failure(errMsg);
        }
    });
}
function LoadPermStatesByPermCountry(countryId) {
    ClearMsg();
    $.ajax({
        type: "POST",
        url: "/Admin/StatesListByCountry",
        data: "CountryId=" + countryId,
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
            Failure(errMsg);
        }
    });
}
function LoadPermCitiesByPermState(StateId) {
    ClearMsg();
    $.ajax({
        type: "POST",
        url: "/Admin/CitiesListByState",
        data: "StateId=" + StateId,
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
            Failure(errMsg);
        }
    });
}
function LoadPermSectorsByPermCity(CityId) {
    ClearMsg();
    $.ajax({
        type: "POST",
        url: "/Admin/SectorsListByCity",
        data: "CityId=" + CityId,
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
            Failure(errMsg);
        }
    });
}
function LoadCountries() {
    ClearMsg();
    $.ajax({
        type: "POST",
        url: "/Admin/CountriesList",
        dataType: "json",
        beforeSend: function () {
            $.blockUI();   //this is great plugin - 'blockUI'
        },
        success: function (countries) {
            $("#Country").find('option').remove();
            $Country = $("#Country");
            $.each(countries, function (i, country) {
                if (i == 0) { $Country.append('<option value="">Select Country</option>'); }
                $Country.append('<option value="' + country.Value + '">' + country.Text + '</option>');
            });
            $.unblockUI();
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            $.unblockUI();
            var errMsg = "<P>Error Loading: " + XMLHttpRequest.responseText + "<br/>";
            Failure(errMsg);
        }
    });
}
function LoadStates() {
    ClearMsg();
    $.ajax({
        type: "POST",
        url: "/Admin/StatesList",
        dataType: "json",
        beforeSend: function () {
            $.blockUI();   //this is great plugin - 'blockUI'
        },
        success: function (states) {
            $("#State").find('option').remove();
            $State = $("#State");
            $.each(states, function (i, state) {
                if (i == 0) { $State.append('<option value="">Select State</option>'); }
                $State.append('<option value="' + state.Value + '">' + state.Text + '</option>');
            });
            $.unblockUI();
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            $.unblockUI();
            var errMsg = "<P>Error Loading: " + XMLHttpRequest.responseText + "<br/>";
            Failure(errMsg);
        }
    });
}
function LoadCities() {
    ClearMsg();
    $.ajax({
        type: "POST",
        url: "/Admin/CitiesList",
        dataType: "json",
        beforeSend: function () {
            $.blockUI();   //this is great plugin - 'blockUI'
        },
        success: function (cities) {
            $("#City").find('option').remove();
            $City = $("#City");
            $.each(cities, function (i, city) {
                if (i == 0) { $City.append('<option value="">Select City</option>'); }
                $City.append('<option value="' + city.Value + '">' + city.Text + '</option>');
            });
            $.unblockUI();
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            $.unblockUI();
            var errMsg = "<P>Error Loading: " + XMLHttpRequest.responseText + "<br/>";
            Failure(errMsg);
        }
    });
}
function LoadSectors() {
    ClearMsg();
    $.ajax({
        type: "POST",
        url: "/Admin/SectorList",
        dataType: "json",
        beforeSend: function () {
            $.blockUI();   //this is great plugin - 'blockUI'
        },
        success: function (cities) {
            $("#Sector").find('option').remove();
            $City = $("#Sector");
            $.each(cities, function (i, city) {
                if (i == 0) { $City.append('<option value="">Select Sector</option>'); }
                $City.append('<option value="' + city.Value + '">' + city.Text + '</option>');
            });
            $.unblockUI();
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            $.unblockUI();
            var errMsg = "<P>Error Loading: " + XMLHttpRequest.responseText + "<br/>";
            Failure(errMsg);
        }
    });
}
function LoadInstances() {
    ClearMsg();
    $.ajax({
        type: "POST",
        url: "/Admin/InstanceList",
        dataType: "json",
        beforeSend: function () {
            $.blockUI();   //this is great plugin - 'blockUI'
        },
        success: function (cities) {
            $("#ParentInstance").find('option').remove();
            $City = $("#ParentInstance");
            $.each(cities, function (i, city) {
                if (i == 0) { $City.append('<option value="">Select Instance</option>'); }
                $City.append('<option value="' + city.Value + '">' + city.Text + '</option>');
            });
            $.unblockUI();
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            $.unblockUI();
            var errMsg = "<P>Error Loading: " + XMLHttpRequest.responseText + "<br/>";
            Failure(errMsg);
        }
    });
}
function LoadScriptJS(src) {
    ClearMsg();
    var script = document.createElement("script");
    script.type = "text/javascript";
    document.getElementsByTagName("head")[0].appendChild(script);
    script.src = "../../Scripts/AppScripts/" + src;
}

function CountryChange() {
    ClearMsg();
    var value = $.trim($("#Country").val());
    if (value == "") {
        $("#State").find('option').remove();
        $("#City").find('option').remove();
        $("#Sector").find('option').remove();
    }
    else
        LoadStatesByCountry(value);
}
function StateChange() {
    ClearMsg();
    var value = $.trim($("#State").val());
    if (value == "") {
        $("#City").find('option').remove();
        $("#Sector").find('option').remove();
    }
    else
        LoadCitiesByState(value);
}
function CityChange() {
    ClearMsg();
    var value = $.trim($("#City").val());
    if (value == "")
        $("#Sector").find('option').remove();
    else
        LoadSectorsByCity(value);
}
function CommCountryChange() {
    ClearMsg();
    var value = $.trim($("#CommCountry").val());
    if (value == "") {
        $("#CommState").find('option').remove();
        $("#CommCity").find('option').remove();
        $("#CommSector").find('option').remove();
    }
    else
        LoadCommStatesByCommCountry(value);
}
function CommStateChange() {
    ClearMsg();
    var value = $.trim($("#CommState").val());
    if (value == "") {
        $("#CommCity").find('option').remove();
        $("#CommSector").find('option').remove();
    }
    else
        LoadCommCitiesByCommState(value);
}
function CommCityChange() {
    ClearMsg();
    var value = $.trim($("#CommCity").val());
    if (value == "")
        $("#CommSector").find('option').remove();
    else
        LoadCommSectorsByCommCity(value);
}
function PermCountryChange() {
    ClearMsg();
    var value = $.trim($("#PermCountry").val());
    if (value == "") {
        $("#PermState").find('option').remove();
        $("#PermCity").find('option').remove();
        $("#PermSector").find('option').remove();
    }
    else
        LoadPermStatesByPermCountry(value);
}
function PermStateChange() {
    ClearMsg();
    var value = $.trim($("#PermState").val());
    if (value == "") {
        $("#PermCity").find('option').remove();
        $("#PermSector").find('option').remove();
    }
    else
        LoadPermCitiesByPermState(value);
}
function PermCityChange() {
    ClearMsg();
    var value = $.trim($("#PermCity").val());
    if (value == "")
        $("#PermSector").find('option').remove();
    else
        LoadPermSectorsByPermCity(value);
}
function ClassChange() {
    ClearMsg();
    $("#searchSection").css("display", "block");
    var value = $.trim($("#Class").val());
    if (value == "")
        $("#Section").find('option').remove();
    else
        LoadSectionsByClass(value);
}

function LoadSectionsByClass(classId) {
    ClearMsg();
    $.ajax({
        type: "POST",
        url: "/Admin/SectionsListByClass",
        data: "ClassId=" + classId,
        dataType: "json",
        beforeSend: function () {
            $.blockUI();   //this is great plugin - 'blockUI'
        },
        success: function (sections) {
            $("#Section").find('option').remove();
            $Section = $("#Section");
            $.each(sections, function (i, section) {
                if (i == 0) { $Section.append('<option value="">Select Section</option>'); }
                $Section.append('<option value="' + section.Value + '">' + section.Text + '</option>');
            });
            $.unblockUI();
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            $.unblockUI();
            var errMsg = "<P>Error Loading: " + XMLHttpRequest.responseText + "<br/>";
            Failure(errMsg);
        }
    });
}

function OthersCreate(hdnElement, value, Optional, selectelement, beforeOptional, beforeOptionalName) {
    ClearMsg();
    if ($.trim($(value).val()) != "Other") {
        $.ajax(
            {
                type: "POST",
                url: "/Shared/AddJsonOthers",
                data: "hdnValue=" + $(hdnElement).val() + "&Value=" + $(value).val() + "&Optional=" + $($(Optional).val()).val(),
                beforeSend: function () {
                    //popup('popUpOther');
                    $.blockUI();
                },
                complete: function () {
                    $.unblockUI();
                },
                success: function (result) {
                    if (result.success) {
                        $($(selectelement).val() + " option:eq(" + result.count + ")").before('<option value="' + result.Id + '">' + $(value).val() + '</option>');
                        $($(selectelement).val()).val(result.Id);
                        if ($(beforeOptional).val() != "") {
                            $($(beforeOptional).val()).append('<option value="$">Select ' + $(beforeOptionalName).val() + '</option>');
                            $($(beforeOptional).val()).append('<option value="$">Other</option>');
                        }
                        $.modal.close();
                        Success(result.message);

                    }
                    else {
                        $($(selectelement).val()).val("");
                        Failure(result.message);
                    }
                },
                error: function (req, status, error) {
                    Error(req, status, error);
                }
            });
    }
    else {
        $($(selectelement).val()).val("");
        Failure("Rule Violation - System don't allow 'Other'");
        //popup('popUpOther');
        $("#popUpOther").modal({ persist: true });
    }
}

function CancelOther(selectElement) {
    //popup('popUpOther');
    $.modal.close();
    $($(selectElement).val()).val("");
}