<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
    .ui-state-default .ui-icon-trash {
    background: url("../images/info.png");
    background-position: 0 0;

}
        </style>
    <script type="text/javascript">
        $(document).ready(function () {
            LoadUsers();
        });
        function Create() {
            $("#divUserMaster").hide();
            $("#CreateUser").hide();
            $("#backToList").show();
            $("#divCreateUser").show();
            GetContentByActionAndController('AddEditUser', 'User', 'Add/Edit User', '#divCreateUser');
        }
        function UpdateUser(id) {
            $("#divUserMaster").hide();
            $("#CreateUser").hide();
            $("#backToList").show();
            $("#divCreateUser").show();
            GetContentByActionAndControllerForEdit('EditUser', 'User', 'Add/Edit User', id, '#divCreateUser');
        }
        function LoadUsers() {
            var gridDataUrl;
            gridDataUrl = '/User/JsonUserCollection';
            jQuery("#list").jqGrid({
                url: gridDataUrl,
                datatype: "json",
                mtype: 'POST',
                colNames: ['Id', 'Name', 'Address', 'City', 'State', 'PinCode', 'Mobile', 'RoleName', 'Active'],
                colModel: [
                  { name: 'Id', index: 'Id', align: 'left', hidedlg: true, hidden: true, editable: false, viewable: false, formoptions: { elmsuffix: '   ', rowpos: 1, colpos: 2 } },
                  { name: 'Name', index: 'Name', align: 'left', hidden: false, editable: false, viewable: false, formoptions: { elmsuffix: '   ', rowpos: 1, colpos: 3 } },
                  { name: 'Address', index: 'Address', align: 'left', hidden: false, editable: false, viewable: false, formoptions: { elmsuffix: '   ', rowpos: 1, colpos: 4 } },
                { name: 'City', index: 'City', align: 'left',  hidden: false, editable: false, viewable: false, formoptions: { elmsuffix: '   ', rowpos: 1, colpos: 5 } },
                { name: 'State', index: 'State', align: 'left',  hidden: false, editable: false, viewable: false, formoptions: { elmsuffix: '   ', rowpos: 1, colpos: 6 } },
                { name: 'PinCode', index: 'PinCode', align: 'left',  hidden: false, editable: false, viewable: false, formoptions: { elmsuffix: '   ', rowpos: 1, colpos: 7 } },
                { name: 'Mobile', index: 'Mobile', align: 'left',  hidden: false, editable: false, viewable: false, formoptions: { elmsuffix: '   ', rowpos: 1, colpos: 8 } },
                { name: 'RoleName', index: 'RoleName', align: 'left',  hidden: false, editable: false, viewable: false, formoptions: { elmsuffix: '   ', rowpos: 1, colpos: 9 } },
                { name: 'Active', index: 'Active', align: 'left', hidden: false, editable: false, viewable: false, formoptions: { elmsuffix: '   ', rowpos: 1, colpos: 10 } },
                ],
                rownumbers: true,
                rowNum: 10,
                rowList: [10, 20, 30],
                height: 'auto',
                autowidth: true,
                pager: jQuery('#pager'),
                sortname: 'Name',
                viewrecords: true,
                sortorder: "asc",
                caption: "Users",
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

                hidegrid: true //To show/hide the button in the caption bar to hide/show the grid.
            }).navGrid('#pager', { search: false, view: false, edit: false, add: false, del: true, searchtext: "" },
       {
           closeOnEscape: true, url: "/Administration/EditJsonSiteLogs", closeAfterEdit: false, width: 350, checkOnSubmit: false, topinfo: "Transaction Successful..", bottominfo: "Fields marked with(*) are required.", beforeShowForm: function (formid) { $("#tr_ID", formid).hide(); $("#FrmTinfo").css("display", "none"); }, afterSubmit: // Function for show msg after submit the form in edit
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
       {
           closeOnEscape: true, url: "/Administration/AddJsonSiteLogs", closeAfterAdd: false, width: 350, topinfo: "Transaction Successful..", bottominfo: "Fields marked with(*) are required.", beforeShowForm: function (formid) { $("#tr_ID", formid).hide(); $("#FrmTinfo").css("display", "none"); }, afterSubmit: // Function for show msg after submit the form in Add
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
       {
           url: "/User/DelUser",
           beforeShowForm: function ($form) {
               $("td.delmsg", $form[0]).html("Do you want to activate/deactivate the selected user?");
               $("td.DelButton a#dData").html("Yes <span class='ui-icon ui-icon-scissors'></span>");
               $("td.DelButton a#eData").html("No <span class='ui-icon ui-icon-cancel'></span>");
               
           },
           width:350,
           onclickSubmit: function (params) {
               var ajaxData = {};
               var list = $("#list");
               var selectedRow = list.getGridParam("selrow");
               rowData = list.getRowData(selectedRow);
               ajaxData = { id: rowData.Id };
               return ajaxData;
           },
           afterComplete: function (response) {
               var resp = $.parseJSON(response.responseText);
               ClearMsg();
               if (resp.success)
                   Success(resp.message);
               else
                   Failure(resp.message);
               var recs = parseInt($("#list").getGridParam("records"), 10);
               if (recs == 0) {
                   $("#gridWrapper").hide();
                   EmptyGrid("#EmptyGridWrapper");
                   $("#EmptyGridWrapper").show();
               } else {
                   $('#gridWrapper').show();
                   $("#EmptyGridWrapper").hide();
               }
           }



       }, // delete options
       { closeOnEscape: true, multipleSearch: true, closeAfterSearch: true }, // search options
       { closeOnEscape: true, width: 350 } // view options
    );
       jQuery("#list").jqGrid('navButtonAdd', '#pager', {
           caption: "Show/Hide",
           buttonicon: "ui-icon-newwin",
           title: "Show/Hide Columns",
           onClickButton: function () {
               jQuery("#list").setColumns({ ShrinkToFit: true, colnameview: false, recreateForm: true, afterSubmitForm: function (id) { setTimeout("imagePreview()", 2000); } });
               return false;
           }
       });
            $.extend($.jgrid.search, { Find: 'Search' });
            $.extend($.jgrid.navGrid, { delicon: 'ui-icon-customtrash' });
            //$("#list").jqGrid("navGrid", "#pager", { delicon: "ui-icon-customtrash" });

        }
    </script>
</head>
<body>
    <div class="clear">
        
        <div style="float: left;">
            <input type="button" id="CreateUser" class="rg_button_red upper" title="Click to Create User"
                value="Create User" onclick="Create()" />
        </div>
      
        <div id="divbackToSearch" style="float: right;">
            <input type="button" class="rg_button_red upper" style="display:none;" id="backToList" title="Back" value="Back To User List"
                onclick="Back()" />
        </div>
    </div>
    <div id="divUserMaster">
        
        <div id="gridWrapper" style="width: 100%;">
           
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
    <div id="divCreateUser">
    </div>
</body>
</html>
