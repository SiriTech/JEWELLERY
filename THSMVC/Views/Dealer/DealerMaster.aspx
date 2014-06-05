<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <script type="text/javascript">
        $(document).ready(function () {
            LoadDealers();
        });
        function Create() {
            $("#divDealerMaster").hide();
            $("#CreateDealer").hide();
            $("#backToList").show();
            $("#divCreateDealer").show();
            GetContentByActionAndController('AddEditDealer', 'Dealer', 'Add/Edit Dealer', '#divCreateDealer');
        }
        function UpdateDealer(id) {
            $("#divDealerMaster").hide();
            $("#CreateDealer").hide();
            $("#backToList").show();
            $("#divCreateDealer").show();
            GetContentByActionAndControllerForEdit('EditDealer', 'Dealer', 'Add/Edit Dealer', id, '#divCreateDealer');
        }
        function LoadDealers() {
            var gridDataUrl;
            gridDataUrl = '/Dealer/JsonDealerCollection';
            jQuery("#list").jqGrid({
                url: gridDataUrl,
                datatype: "json",
                mtype: 'POST',
                colNames: ['Id', 'Company Name', 'Dealer Name'],
                colModel: [
                  { name: 'Id', index: 'Id', align: 'left', hidedlg: true, hidden: true, editable: false, viewable: false, formoptions: { elmsuffix: '   ', rowpos: 1, colpos: 2 } },
                  { name: 'CompanyName', index: 'CompanyName', align: 'left'},
                  { name: 'DealerName', index: 'DealerName', align: 'left' }
                ],
                rownumbers: true,
                rowNum: 10,
                rowList: [10, 20, 30],
                height: 'auto',
                autowidth: true,
                pager: jQuery('#pager'),
                sortname: 'DealerName',
                viewrecords: true,
                sortorder: "asc",
                caption: "Dealers",
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
           url: "/Dealer/DelDealer",
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
       //jQuery("#list").jqGrid('sortableRows');

       jQuery("#list").jqGrid(
    'sortableRows',
    { update: function (e, ui) {
        alert("The row with the id=" + ui.item[0].id +
            " is moved. New row index is " + ui.item[0].rowIndex);
    }
});

            $.extend($.jgrid.search, { Find: 'Search' });

        }
    </script>
</head>
<body>
    <div class="clear">

        <div style="float: left;">
            <input type="button" id="CreateDealer" class="rg_button_red upper" title="Click to Create Dealer"
                value="Create Dealer" onclick="Create()" />
        </div>

        <div id="divbackToSearch" style="float: right;">
            <input type="button" class="rg_button_red upper" style="display: none;" id="backToList" title="Back" value="Back To Dealer List"
                onclick="Back()" />
        </div>
    </div>
    <div id="divDealerMaster">

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
    <div id="validationDiv" style="margin-top: 10px; font-weight: bold; color: Red;">
    </div>
    <div id="statusDiv" style="margin-top: 10px;">
        <center>
            <span id="_status" style="font-size: 1px; font-weight: bold;"></span>
        </center>
    </div>
    <div id="divCreateDealer">
    </div>

    <script type="text/javascript">

        
        
    </script>
</body>
</html>
