<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
     <div class="clear">
        
        <div style="float: left;">
            <input type="button" id="CreateProductGroup" class="rg_button_red upper" title="Click to Create Product Group"
                value="Create Product Group" onclick="Create()" />
        </div>
      
        <div id="divbackToSearch" style="float: right;">
            <input type="button" class="rg_button_red upper" style="display:none;" id="backToList" title="Back" value="Back To Product Group List"
                onclick="toggleSearch()" />
        </div>
    </div>
    <div id="divProductGroupMaster">
        
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
    <div id="divCreateProductGroup">
    </div>
    
    <script type="text/javascript">

        var gridDataUrl;
        gridDataUrl = '/ProductGroup/JsonProductGroupCollection';
        jQuery("#list").jqGrid({
            url: gridDataUrl,
            datatype: "json",
            mtype: 'POST',
            colNames: ['Id','Product Group'],
            colModel: [
              { name: 'Id', index: 'Id', align: 'left', hidedlg: true, hidden: true, editable: false, viewable: false, formoptions: { elmsuffix: '   ', rowpos: 1, colpos: 2} },
              { name: 'ProductGroup1', index: 'ProductGroup1', align: 'left', hidedlg: true, hidden: false, editable: false, viewable: false, formoptions: { elmsuffix: '   ', rowpos: 1, colpos: 3} }
            ],
            rowNum: 10,
            rowList: [10, 20, 30],
            height: 'auto',
            autowidth: true,
            pager: jQuery('#pager'),
            sortname: 'ProductGroup1',
            viewrecords: false,
            sortorder: "asc",
            caption: "Product Groups",
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
        }).navGrid('#pager', { search: false, view: false, edit: false, add: false, del: false, searchtext: "" },
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

        
    </script>
</body>
</html>
