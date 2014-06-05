<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>CreateUser</title>
    <!-- CSS goes in the document HEAD or added to your external stylesheet -->

    <script type="text/javascript">
        $(document).ready(function () {
            
            
        });


        function LoadEmployees() {
            var gridDataUrl;
            gridDataUrl = '/Product/JsonProductCollection';
            jQuery("#list").jqGrid({
                url: gridDataUrl,
                datatype: "json",
                mtype: 'POST',
                colNames: ['Id', 'Product Name'],
                colModel: [
                  { name: 'Id', index: 'Id', align: 'left', hidedlg: true, hidden: true, editable: false, viewable: false, formoptions: { elmsuffix: '   ', rowpos: 1, colpos: 2} },
                  { name: 'ProductName', index: 'ProductName', align: 'left', hidedlg: true, hidden: false, editable: false, viewable: false, formoptions: { elmsuffix: '   ', rowpos: 1, colpos: 3} }
                ],
                rownumbers: true,
                rowNum: 10,
                rowList: [10, 20, 30],
                height: 'auto',
                autowidth: true,
                pager: jQuery('#pager'),
                sortname: 'ProductName',
                viewrecords: true,
                sortorder: "asc",
                caption: "Products",
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
       url: "/Product/DelProduct",
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
       {closeOnEscape: true, multipleSearch: true, closeAfterSearch: true }, // search options
       {closeOnEscape: true, width: 350} // view options
    );
            $.extend($.jgrid.search, { Find: 'Search' });

        }

        function CreateEmp() {
            $("#divProductMaster").hide();
            $("#CreateProduct").hide();
            $("#backToList").show();
            $("#divCreateProduct").show();
            GetContentByActionAndController('AddEditProduct', 'Product', 'Add/Edit Product', '#divCreateProduct');
        }

        function BackToList() {
            alert('back');
        }

    </script>
</head>
<body>
    <div id="divBankDetails" style="clear: both; width: 100%; display: block;">

        <div class="clear">
            <div style="float: left;">
                <input type="button" id="CreateEmployee" class="rg_button_red upper" title="Click to Create Employee"
                    value="Create Employee" onclick="CreateEmp()" />
            </div>
            <div id="divbackToSearch" style="float: right;">
                <input type="button" class="rg_button_red upper" style="display: none;" id="backToList"
                    title="Back" value="Back To Employee List" onclick="BackToList()" />
            </div>
        </div>

        <div class="clear">
            <div class="ContentdivHead" onclick="toggleContentDivHead(this,'#divLotInfo');">
                <span class="divHeading">Employee Details</span>
            </div>
            <div class="clear">
                <div class="ContentdivBorder" id="divLotInfo">
                    <div class="clear">
                       <h1>Employee Details</h1>
                    </div>
                </div>
            </div>
        </div>

         <div id="divCreateEmployee">
        </div>

    </div>
</body>
</html>
