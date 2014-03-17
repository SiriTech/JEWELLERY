<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<THSMVC.Models.ManageUsersModel>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>ManageUsers</title>
    <link href="../../Content/GmailStyle.css" rel="stylesheet" type="text/css" />
    <script src="../../Scripts/ImagePreview.js" type="text/javascript"></script>
    <script type="text/javascript">
        function Excel() {
            ClearMsg();
            $(".Googlemenu ul li ul").attr("class", "disBlock");
            $(".Googlemenu ul li ul li").attr("class", "disBlock");
            $(".Googlemenu ul li ul li a").attr("class", "disBlock");
            Information("Exporting is in progress...");
            var FirstName = "";
            if (getElement('FirstName').value != "") {
                FirstName = getElement('FirstName').value;
            }
            var Role = "";
            if (getElement('Role').selectedIndex != 0) {
                Role = getElement('Role').options[getElement('Role').selectedIndex].value;
            }
            var LastName = "";
            if (getElement('LastName').value != "") {
                LastName = getElement('LastName').value;
            }
            var DisplayName = "";
            if (getElement('DisplayName').value != "") {
                DisplayName = getElement('DisplayName').value;
            }
            var UserName = "";
            if (getElement('UserName').value != "") {
                UserName = getElement('UserName').value;
            }

            var Gender = "";
            if (getElement('Gender').selectedIndex != 0) {
                Gender = getElement('Gender').options[getElement('Gender').selectedIndex].value;
            }
            var Class = "";
            if (getElement('Class').selectedIndex != 0) {
                Class = getElement('Class').options[getElement('Class').selectedIndex].value;
            }
            var Section = "";
            if (getElement('Section').selectedIndex != 0) {
                Section = getElement('Section').options[getElement('Section').selectedIndex].value;
            }
            $.ajax(
            {
                type: "POST",
                url: "/Admin/GenerateExcel",
                traditional: true,
                data: {
                    FirstName: FirstName,
                    RoleId: Role,
                    LastName: LastName,
                    DisplayNameSearch: DisplayName,
                    UserName: UserName,
                    GenderName: Gender,
                    ClassName: Class,
                    SectionName: Section
                },
                success: function (result) {
                    window.location.href = "/Admin/GenerateExcel";
                    ClearMsg();
                    //                    if (result.success) {
                    //                        $("body").append("<iframe src='" + result.message + "' style='display: none;' ></iframe>");
                    //                    }
                    //                    else {
                    //                        Failure("Export failed. Please try again later.");
                    //                    }
                },
                error: function (req, status, error) {
                    Failure("Sorry, Please try again later.");
                }
            });
        }
        function Word() {
            ClearMsg();
            $(".Googlemenu ul li ul").attr("class", "disBlock");
            $(".Googlemenu ul li ul li").attr("class", "disBlock");
            $(".Googlemenu ul li ul li a").attr("class", "disBlock");
            Information("Exporting is in progress...");
            var FirstName = "";
            if (getElement('FirstName').value != "") {
                FirstName = getElement('FirstName').value;
            }
            var Role = "";
            if (getElement('Role').selectedIndex != 0) {
                Role = getElement('Role').options[getElement('Role').selectedIndex].value;
            }
            var LastName = "";
            if (getElement('LastName').value != "") {
                LastName = getElement('LastName').value;
            }
            var DisplayName = "";
            if (getElement('DisplayName').value != "") {
                DisplayName = getElement('DisplayName').value;
            }
            var UserName = "";
            if (getElement('UserName').value != "") {
                UserName = getElement('UserName').value;
            }

            var Gender = "";
            if (getElement('Gender').selectedIndex != 0) {
                Gender = getElement('Gender').options[getElement('Gender').selectedIndex].value;
            }
            var Class = "";
            if (getElement('Class').selectedIndex != 0) {
                Class = getElement('Class').options[getElement('Class').selectedIndex].value;
            }
            var Section = "";
            if (getElement('Section').selectedIndex != 0) {
                Section = getElement('Section').options[getElement('Section').selectedIndex].value;
            }
            $.ajax(
            {
                type: "POST",
                url: "/Admin/GenerateWord",
                traditional: true,
                data: {
                    FirstName: FirstName,
                    RoleId: Role,
                    LastName: LastName,
                    DisplayNameSearch: DisplayName,
                    UserName: UserName,
                    GenderName: Gender,
                    ClassName: Class,
                    SectionName: Section
                },
                success: function (result) {
                    window.location.href = "/Admin/GenerateWord";
                    ClearMsg();
                    //                    if (result.success) {
                    //                        $("body").append("<iframe src='" + result.message + "' style='display: none;' ></iframe>");
                    //                    }
                    //                    else {
                    //                        Failure("Export failed. Please try again later.");
                    //                    }
                },
                error: function (req, status, error) {
                    Failure("Sorry, Please try again later.");
                }
            });
        }
        function PDF() {
            ClearMsg();
            $(".Googlemenu ul li ul").attr("class", "disBlock");
            $(".Googlemenu ul li ul li").attr("class", "disBlock");
            $(".Googlemenu ul li ul li a").attr("class", "disBlock");
            Information("Exporting is in progress...");
            var FirstName = "";
            if (getElement('FirstName').value != "") {
                FirstName = getElement('FirstName').value;
            }
            var Role = "";
            if (getElement('Role').selectedIndex != 0) {
                Role = getElement('Role').options[getElement('Role').selectedIndex].value;
            }
            var LastName = "";
            if (getElement('LastName').value != "") {
                LastName = getElement('LastName').value;
            }
            var DisplayName = "";
            if (getElement('DisplayName').value != "") {
                DisplayName = getElement('DisplayName').value;
            }
            var UserName = "";
            if (getElement('UserName').value != "") {
                UserName = getElement('UserName').value;
            }

            var Gender = "";
            if (getElement('Gender').selectedIndex != 0) {
                Gender = getElement('Gender').options[getElement('Gender').selectedIndex].value;
            }
            var Class = "";
            if (getElement('Class').selectedIndex != 0) {
                Class = getElement('Class').options[getElement('Class').selectedIndex].value;
            }
            var Section = "";
            if (getElement('Section').selectedIndex != 0) {
                Section = getElement('Section').options[getElement('Section').selectedIndex].value;
            }
            $.ajax(
            {
                type: "POST",
                url: "/Admin/GenerateWordforPDF",
                traditional: true,
                data: {
                    FirstName: FirstName,
                    RoleId: Role,
                    LastName: LastName,
                    DisplayNameSearch: DisplayName,
                    UserName: UserName,
                    GenderName: Gender,
                    ClassName: Class,
                    SectionName: Section
                },
                success: function (result) {
                    $.ajax(
                    {
                        type: "POST",
                        url: "/Admin/GeneratePDF",
                        data: {},
                        success: function (result) {
                            ClearMsg();
                            window.location.href = "/Admin/GeneratePDF";
                        },
                        error: function (req, status, error) {
                            Failure("Sorry, Please try again later.");
                        }
                    });
                },
                error: function (req, status, error) {
                    Failure("Sorry, Please try again later.");
                }
            });
        }
        function UpdateParent(userId) {
            ClearMsg();
            $("#ManageUsers").slideUp();
            $("#divbackToSearch").show();
            $("#CreateUser")[0].className = "rg_button upper";
            $("#UserTabs").show();
            $(".TabContent").show();
            $("#toc li").attr("class", "");
            $("#toc li[id=liParent]").attr("class", "current");
            GetContentByActionAndControllerForEdit('CreateUserParent', 'Admin', 'Create User', 'Parent', '#UserTabs');
            GetContentByActionAndControllerForEdit("UpdateParent", "Admin", "Update Parent", userId, '.TabContent');

        }
        $("#divbackToSearch").hide();
        $("#UserTabs").hide();
        $(".TabContent").hide();
        function CreateUser() {
            ClearMsg();
            $("#popUpDiv select").find('option:first').attr('selected', 'selected');
            $("#Popupmsg").text("");
            popup('popUpDiv');
        }
        function Create() {
            ClearMsg();
            $.ajax({
                type: "POST",
                url: "/Admin/ClearInternalUserSession",
                data: {},
                async: false,
                dataType: "json",
                beforeSend: function () {
                    $.blockUI();   //this is great plugin - 'blockUI'
                },
                success: function (result) {
                    $.unblockUI();
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    $.unblockUI();
                    var errMsg = "<P>Error Loading: " + XMLHttpRequest.responseText + "<br/>";
                    $("#status").html(errMsg).show("slow");
                }
            });
            $("#ManageUsers").slideUp();
            $("#divbackToSearch").show();
            $("#CreateUser")[0].className = "rg_button upper";
            $("#UserTabs").show();
            $(".TabContent").show();

            GetContentByActionAndController('CreateUser', 'Admin', 'Create User', '#UserTabs');
            GetContentByActionAndController('UserGeneralInfo', 'Admin', 'Create User', '.TabContent');
        }
        function UpdateUser(userId) {
            ClearMsg();
            $("#ManageUsers").slideUp();
            $("#divbackToSearch").show();
            $("#CreateUser")[0].className = "rg_button upper";
            $("#UserTabs").show();
            $(".TabContent").show();

            GetContentByActionAndController('CreateUser', 'Admin', 'Create User', '#UserTabs');
            GetContentByActionAndControllerForEdit("UpdateUser", "Admin", "Update User", userId, '.TabContent');
        }
        function toggleSearch() {
            ClearMsg();
            if ($("#ManageUsers").is(":visible")) {
                $("#ManageUsers").slideUp();
            }
            else {
                $("#ManageUsers").slideDown();
                $("#UserTabs").hide();
                $("#divbackToSearch").hide();
                $(".TabContent").hide();
                $("#CreateUser")[0].className = "rg_button_red upper";
                $.ajax({
                    type: "POST",
                    url: "/Admin/BackToSearch",
                    data: {},
                    async: false,
                    dataType: "json",
                    beforeSend: function () {
                        $.blockUI();   //this is great plugin - 'blockUI'
                    },
                    success: function (cities) {
                        $.unblockUI();
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        $.unblockUI();
                        var errMsg = "<P>Error Loading: " + XMLHttpRequest.responseText + "<br/>";
                        $("#status").html(errMsg).show("slow");
                    }
                });
                SearchUser();
            }

        }
       
    </script>
</head>
<body>
    <div class="clear">
        <% if (Model.Create)
           { %>
        <div style="float: left;">
            <input type="button" id="CreateUser" class="rg_button_red upper" title="Click to Create User"
                value="Create an User" onclick="Create()" />
        </div>
        <%} %>
        <div id="divbackToSearch" style="float: right;">
            <input type="button" class="rg_button_red upper" title="Back" value="Back To Search"
                onclick="toggleSearch()" />
        </div>
    </div>
    <div id="ManageUsers">
        <div class="clear">
            <div class="ContentdivHeadOver" onclick="toggleContentDivHead(this,'#divSearchUsers');">
                <span class="divHeading">Search Users</span>
            </div>
            <div class="clear">
                <div class="ContentdivBorder" id="divSearchUsers" style="display: none;">
                    <div class="clear">
                        <div class="FloatLeft" style="width: 50%;">
                            <div class="clear">
                                <div class="editor-label FloatLeft" style="width: 40%;">
                                    First Name
                                </div>
                                <div class="editor-field" style="text-align: left;">
                                    <%= Html.TextBoxFor(m => m.FirstName, new { maxlength = 100, autocomplete = "off",title="Type in First name to search" })%>
                                </div>
                            </div>
                        </div>
                        <div style="float: right; width: 50%;">
                            <div class="clear">
                                <div class="editor-label FloatLeft" style="width: 40%;">
                                    Last Name
                                </div>
                                <div class="editor-field">
                                    <%= Html.TextBoxFor(m => m.LastName, new { title="Type in last name to search" })%>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="clear">
                        <div class="FloatLeft" style="width: 50%;">
                            <div class="clear">
                                <div class="editor-label FloatLeft" style="width: 40%;">
                                    Display Name
                                </div>
                                <div class="editor-field" style="text-align: left;">
                                    <%= Html.TextBoxFor(m => m.DisplayName, new { title="Type in display name to search" })%>
                                </div>
                            </div>
                        </div>
                        <div style="float: right; width: 50%;">
                            <div class="clear">
                                <div class="editor-label FloatLeft" style="width: 40%;">
                                    User Name
                                </div>
                                <div class="editor-field">
                                    <%= Html.TextBoxFor(m => m.UserName, new { title="Type in user name to search" })%>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="clear">
                        <div class="FloatLeft" style="width: 50%;">
                            <div class="clear">
                                <div class="editor-label FloatLeft" style="width: 40%;">
                                    Role
                                </div>
                                <div class="editor-field" style="text-align: left;">
                                    <%= Html.DropDownListFor(m => m.Role, Model.Roles, "Select Role", new { title="Select Role" })%>
                                </div>
                            </div>
                        </div>
                        <div style="float: right; width: 50%;">
                            <div class="clear">
                                <div class="editor-label FloatLeft" style="width: 40%;">
                                    Gender
                                </div>
                                <div class="editor-field">
                                    <%= Html.DropDownListFor(m => m.Gender, Model.Genders, "Select Gender", new { title="Select Gender" })%>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="clear">
                        <div class="FloatLeft" style="width: 50%;">
                            <div class="clear">
                                <div class="editor-label FloatLeft" style="width: 40%;">
                                    Class
                                </div>
                                <div class="editor-field" style="text-align: left;">
                                    <%= Html.DropDownListFor(m => m.Class, Model.Classes, "Select Class", new { onChange = "ClassChange();return false;",title="Select Class" })%>
                                </div>
                            </div>
                        </div>
                        <div style="float: right; width: 50%; display: none;" id="searchSection">
                            <div class="clear">
                                <div class="editor-label FloatLeft" style="width: 40%;">
                                    Section
                                </div>
                                <div class="editor-field">
                                    <%= Html.DropDownListFor(m => m.Section, Model.Sections, "Select Section", new { title="Select Section" })%>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div id="divButtons" class="clear" style="margin-top: 10px;">
                        <center>
                            <input type="button" value="Search" class="rg_button" title="Search" onclick="SearchUser();return false;" />
                            <input type="button" value="Clear" class="rg_button" title="Clear" onclick="ManageInstanceClear();return false;" />
                        </center>
                    </div>
                </div>
            </div>
        </div>
        <div id="gridWrapper" style="width: 100%;">
            <div>
                <div class="Googlemenu">
                    <ul>
                        <li><a class="dropdown" href="#">Export<span class="arrow"></span></a>
                            <ul class="width-2">
                                <li><a href="#" onclick="Excel()">
                                    <img src="../../images/page_excel.png" alt="EXCEL" />
                                    Excel Format</a></li>
                                <li><a href="#" onclick="PDF()">
                                    <img src="../../images/pdf_document.png" alt="PDF" />
                                    PDF Format</a></li>
                                <li><a href="#" onclick="Word()">
                                    <img src="../../images/blue-document-word.png" alt="WORD" />
                                    Word Format</a></li>
                            </ul>
                        </li>
                    </ul>
                </div>
            </div>
            <div>
                <table id="list" class="scroll" cellpadding="0" cellspacing="0">
                </table>
                <div id="pager" class="scroll" style="text-align: center;">
                </div>
            </div>
        </div>
        <div id="EmptyGridWrapper">
        </div>
    </div>
    <div id="validationDiv" style="margin-top: 10px; font-weight: bold; color: Red;">
    </div>
    <div id="statusDiv" style="margin-top: 10px;">
        <center>
            <span id="_status" style="font-size: 1px; font-weight: bold;"></span>
        </center>
    </div>
    <div id="UserTabs">
    </div>
    <div class="TabContent">
    </div>
    <script type="text/javascript">

        var gridDataUrl;
        var Update = '<%=Model.Update %>';
        if (Update == "True") {
            gridDataUrl = '/Admin/JsonManageUsersEditCollection';
        }
        else {
            gridDataUrl = '/Admin/JsonManageUsersCollection';
        }
        jQuery("#list").jqGrid({
            url: gridDataUrl,
            datatype: "json",
            mtype: 'POST',
            colNames: ['UserId', 'First Name', 'Last Name', 'Display Name', 'Gender', 'Role', 'Class', 'Section', 'Photo'],
            colModel: [
              { name: 'UserId', index: 'UserId', align: 'left', hidedlg: true, hidden: true, editable: true, viewable: false, formoptions: { elmsuffix: '   ', rowpos: 1, colpos: 2} },
               { name: 'FirstName', index: 'FirstName', width: 100, align: 'left', editable: true, viewable: true, hidden: true, formoptions: { elmsuffix: '(*)', rowpos: 2, colpos: 2} },
              { name: 'LastName', index: 'LastName', width: 100, align: 'left', editable: true, viewable: true, hidden: true, edittype: 'text', editrules: { required: true }, formoptions: { elmsuffix: '(*)', rowpos: 3, colpos: 2} },
              { name: 'DisplayName', index: 'DisplayName', width: 100, align: 'left', editable: true, formoptions: { elmsuffix: '(*)', rowpos: 4, colpos: 2} },
              { name: 'GenderName', index: 'GenderName', width: 100, align: 'left', editable: true, edittype: 'text', editrules: { required: true }, formoptions: { elmsuffix: '(*)', rowpos: 5, colpos: 2} },
              { name: 'RoleName', index: 'RoleName', width: 100, align: 'left', editable: true, formoptions: { elmsuffix: '    ', rowpos: 6, colpos: 2} },
              { name: 'ClassName', index: 'ClassName', width: 100, align: 'left', editable: true, formoptions: { elmsuffix: '    ', rowpos: 7, colpos: 2} },
               { name: 'SectionName', index: 'SectionName', width: 100, align: 'left', editable: true, formoptions: { elmsuffix: '    ', rowpos: 8, colpos: 2} },
               { name: 'Photo', index: 'Photo', width: 100, align: 'left', hidden: true, viewable: true, editable: true, formoptions: { elmsuffix: '    ', rowpos: 9, colpos: 2}}],
            rowNum: 10,
            rowList: [10, 20, 30],
            height: 'auto',
            autowidth: true,
            pager: jQuery('#pager'),
            sortname: 'DisplayName',
            viewrecords: true,
            sortorder: "asc",
            caption: "User Details",
            gridComplete: function () {
                var recs = parseInt($("#list").getGridParam("records"), 10);
                if (recs == 0) {
                    $("#gridWrapper").hide();
                    EmptyGrid("#EmptyGridWrapper");
                } else {
                    $('#gridWrapper').show();
                    $("#EmptyGridWrapper").hide();
                }
            },
            subGrid: true,
            subGridRowExpanded: function (subgrid_id, row_id) {
                // we pass two parameters
                // subgrid_id is a id of the div tag created whitin a table data
                // the id of this elemenet is a combination of the "sg_" + id of the row
                // the row_id is the id of the row
                // If we wan to pass additinal parameters to the url we can use
                // a method getRowData(row_id) - which returns associative array in type name-value
                // here we can easy construct the flowing
                var subgrid_table_id, pager_id;
                subgrid_table_id = subgrid_id + "_t";
                pager_id = "p_" + subgrid_table_id;
                var list = $("#list");
                rowData = list.getRowData(row_id);
                $("#" + subgrid_id).html("<table id='" + subgrid_table_id + "' class='scroll'></table><div id='" + pager_id + "' class='scroll'></div>");
                jQuery("#" + subgrid_table_id).jqGrid({
                    url: "/Admin/JsonParentsCollectionByUserId?id=" + rowData.UserId,
                    datatype: "json",
                    colNames: ['UserId', 'First Name', 'Relation'],
            colModel: [
              { name: 'UserId', index: 'UserId', align: 'left', hidden: true, editable: true, viewable: false, formoptions: { elmsuffix: '   ', rowpos: 1, colpos: 2} },
              { name: 'FirstName', index: 'Name', width: 100, align: 'left', editable: true, formoptions: { elmsuffix: '(*)', rowpos: 2, colpos: 2} },
              { name: 'LastName', index: 'LastName', width: 100, align: 'left', editable: true, edittype: 'text', editrules: { required: true }, formoptions: { elmsuffix: '(*)', rowpos: 3, colpos: 2}}],
                    rowNum: 10,
                    pager: pager_id,
                    sortname: 'FirstName',
                    sortorder: "asc",
                    rowList: [10, 20, 30],
                    height: 'auto',
                    autowidth: true,
                    caption: "Parent Details",
                });
                jQuery("#" + subgrid_table_id).jqGrid('navGrid', "#" + pager_id, { search: false, edit: false, add: false, del: false })
            },
            forceFit: true,
            hidegrid: true //To show/hide the button in the caption bar to hide/show the grid.
        }).navGrid('#pager', { search: false, view: true, edit: false, add: false, del: false, searchtext: "" },
   { closeOnEscape: true, url: "/Administration/EditJsonSiteLogs", closeAfterEdit: false, width: 350, checkOnSubmit: false, topinfo: "Transaction Successful..", bottominfo: "Fields marked with(*) are required.", beforeShowForm: function (formid) { $("#tr_ID", formid).hide(); $("#FrmTinfo").css("display", "none"); }, afterSubmit: // Function for show msg after submit the form in edit
        function (response, postdata) {
            var json = response.responseText; //in my case response text form server is "{sc:true,msg:''}"
            if (json) {
                $("#FrmTinfo").css("display", "block");
                $("#FrmTinfo").css("font-weight", "bold");
                $("#FrmTinfo").css("text-align", "center");
                $("#FrmTinfo").css("color", "green");
            }
            return [true, "successful"];
        }
   }, // default settings for edit
   {closeOnEscape: true, url: "/Administration/AddJsonSiteLogs", closeAfterAdd: false, width: 350, topinfo: "Transaction Successful..", bottominfo: "Fields marked with(*) are required.", beforeShowForm: function (formid) { $("#tr_ID", formid).hide(); $("#FrmTinfo").css("display", "none"); }, afterSubmit: // Function for show msg after submit the form in Add
        function (response, postdata) {
            var json = response.responseText; //in my case response text form server is "{sc:true,msg:''}"
            if (json) {
                $("#FrmTinfo").css("display", "block");
                $("#FrmTinfo").css("font-weight", "bold");
                $("#FrmTinfo").css("text-align", "center");
                $("#FrmTinfo").css("color", "green");
            }
            return [true, "successful"];
        }


}, // default settings for add
   {url: "/Administration/DelJsonSiteLogs", onclickSubmit: function (params) {
       var ajaxData = {};
       var list = $("#list");
       var selectedRow = list.getGridParam("selrow");
       rowData = list.getRowData(selectedRow);
       ajaxData = { id: rowData.ID };
       return ajaxData;
   }



}, // delete options
   {closeOnEscape: true, multipleSearch: true, closeAfterSearch: true }, // search options
   {closeOnEscape: true, width: 350} // view options
);
        $.extend($.jgrid.search, { Find: 'Search' });

        jQuery("#list").jqGrid('navButtonAdd', '#pager', {
            caption: "Show/Hide",
            buttonicon: "ui-icon-newwin",
            title: "Show/Hide Columns",
            onClickButton: function () {
                jQuery("#list").setColumns({ ShrinkToFit: true, colnameview: false, recreateForm: true,afterSubmitForm: function(id){setTimeout("imagePreview()", 2000);} });
                return false;
            }
        });

        function SearchUser() {

            var FirstName = "";
            if (getElement('FirstName').value != "") {
                FirstName = getElement('FirstName').value;
            }
            var Role = "";
            if (getElement('Role').selectedIndex != 0) {
                Role = getElement('Role').options[getElement('Role').selectedIndex].value;
            }
            var LastName = "";
            if (getElement('LastName').value != "") {
                LastName = getElement('LastName').value;
            }
            var DisplayName = "";
            if (getElement('DisplayName').value != "") {
                DisplayName = getElement('DisplayName').value;
            }
            var UserName = "";
            if (getElement('UserName').value != "") {
                UserName = getElement('UserName').value;
            }

            var Gender = "";
            if (getElement('Gender').selectedIndex != 0) {
                Gender = getElement('Gender').options[getElement('Gender').selectedIndex].value;
            }
            var Class = "";
            if (getElement('Class').selectedIndex != 0) {
                Class = getElement('Class').options[getElement('Class').selectedIndex].value;
            }
            var Section = "";
            if (getElement('Section').selectedIndex != 0) {
                Section = getElement('Section').options[getElement('Section').selectedIndex].value;
            }
            // Get the values entered for serch and pass to grid to reload with the new search data.
            var newGridDataUrl = gridDataUrl + '?FirstName=' + FirstName + '&LastName=' + LastName + '&DisplayName=' + DisplayName + '&UserName=' + UserName + '&Gender=' + Gender + '&Class=' + Class + '&Section=' + Section;

            // Set the parameters in the grid data source
            jQuery('#list').jqGrid('setGridParam', { url: newGridDataUrl }).trigger("reloadGrid");
        }

    </script>
    <script type="text/javascript">
        // start tracking actovity  
        EnableTimeout(); 
    </script>
    <script type="text/javascript">
        $(document).ready(function () {
            $(function () {
                $.Others("#seltest", "popUpOther", {
                    popupHeader: "Test",
                    labelText: "Enter value for Test",
                    HeaderElement: "#spnpopupOtherHeader",
                    labelElement: "#spnLeft",
                    saveButtonText: "OK",
                    cancelButtonText: "Cancel",
                    saveButtonElement: "#btnpopupOtherSave",
                    cancelButtonElement: "#btnpopupOtherCancel"
                })

                setTimeout("imagePreview()", 2000);

            });
            $("[title]").tooltip({ position: "bottom left" });
           
        });
        
    </script>
</body>
</html>
