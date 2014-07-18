<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript">
        $(document).ready(function () {
            LoadProducts(true,true,false,false,false,false,true);
            
        });
        function Create() {
            $("#divProductMaster").hide();
            $("#CreateProduct").hide();
            $("#backToList").show();
            $("#divCreateProduct").show();
            GetContentByActionAndController('AddEditProduct', 'Product', 'Add/Edit Product', '#divCreateProduct');
        }
        function UpdateProduct(id) {
            $("#divProductMaster").hide();
            $("#CreateProduct").hide();
            $("#backToList").show();
            $("#divCreateProduct").show();
            GetContentByActionAndControllerForEdit('EditProduct', 'Product', 'Add/Edit Product', id, '#divCreateProduct');
        }
        function LoadProducts(col_ProductName, col_ShortForm, col_ValueAddedByPerc, col_ValueAddedFixed, col_MakingChargesPerGram, col_MakingChargesFixed, col_IsStoneStr) {
            var gridDataUrl;
            gridDataUrl = '/Product/JsonProductCollection';
            jQuery("#list").jqGrid({
                url: gridDataUrl,
                datatype: "json",
                mtype: 'POST',
                colNames: ['Id', 'Product Name', 'ShortForm', 'ValueAddedByPerc', 'ValueAddedFixed', 'MakingChargesPerGram', 'MakingChargesFixed', 'IsStone'],
                colModel: [
                  { name: 'Id', index: 'Id', align: 'left', hidedlg: true, hidden: true, editable: false, viewable: false },
                  { name: 'ProductName', index: 'ProductName', align: 'left', hidden: !col_ProductName, editable: false, viewable: false },
                  { name: 'ShortForm', index: 'ShortForm',hidden:!col_ShortForm, editable: false, viewable: false },
                  { name: 'ValueAddedByPerc', index: 'ValueAddedByPerc', hidden: !col_ValueAddedByPerc, editable: false, viewable: false },
                  { name: 'ValueAddedFixed', index: 'ValueAddedFixed', hidden: !col_ValueAddedFixed, editable: false, viewable: false },
                  { name: 'MakingChargesPerGram', index: 'MakingChargesPerGram', hidden: !col_MakingChargesPerGram, editable: false, viewable: false },
                  { name: 'MakingChargesFixed', index: 'MakingChargesFixed', hidden: !col_MakingChargesFixed, editable: false, viewable: false },
                  { name: 'IsStoneStr', index: 'IsStoneStr', align: 'center',hidden:!col_IsStoneStr, editable: false, viewable: false}
                ],
                rownumbers: true,
                rowNum: 10,
                rowList: [10, 20, 30],
                height: 'auto',
                autowidth: true,
                gridview: true,
                pager: jQuery('#pager'),
                sortname: 'ProductName',
                viewrecords: false,
            	shrinkToFit:true,
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
            }).navGrid('#pager', { search: false, view: false, edit: false, add: false, del: false, searchtext: "" },
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
       { closeOnEscape: true, multipleSearch: true, closeAfterSearch: true }, // search options
       { closeOnEscape: true } // view options
    );
       jQuery("#list").jqGrid('navButtonAdd', '#pager', {
           caption: "Show/Hide",
           buttonicon: "ui-icon-newwin",
           title: "Show/Hide Columns",
           onClickButton: function () {
           	jQuery("#list").setColumns({
           		ShrinkToFit: true, colnameview: false, recreateForm: true, afterSubmitForm: function (id) {
           			var col_ProductName = false;
           			var col_ShortForm = false;
           			var col_ValueAddedByPerc = false;
           			var col_ValueAddedFixed = false;
           			var col_MakingChargesPerGram = false;
           			var col_MakingChargesFixed = false;
           			var col_IsStoneStr = false;
           			$('#' + id[0].id+" table").find('input[type="checkbox"]:checked').each(function () {
           				//this is the current checkbox
           				if (this.id == "col_ProductName")
           					col_ProductName = true;
           				if (this.id == "col_ShortForm")
           					col_ShortForm = true;
           				if (this.id == "col_ValueAddedByPerc")
           					col_ValueAddedByPerc = true;
           				if (this.id == "col_ValueAddedFixed")
           					col_ValueAddedFixed = true;
           				if (this.id == "col_MakingChargesPerGram")
           					col_MakingChargesPerGram = true;
           				if (this.id == "col_MakingChargesFixed")
           					col_MakingChargesFixed = true;
           				if (this.id == "col_IsStoneStr")
           					col_IsStoneStr = true;

           			});
           			$('#list').jqGrid('GridUnload');
           			LoadProducts(col_ProductName, col_ShortForm, col_ValueAddedByPerc, col_ValueAddedFixed, col_MakingChargesPerGram, col_MakingChargesFixed, col_IsStoneStr);
           		}
           	});
               return false;
           }
       });
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
            <input type="button" id="CreateProduct" class="rg_button_red upper" title="Click to Create Product"
                value="Create Product" onclick="Create()" />
        </div>
      
        <div id="divbackToSearch" style="float: right;">
            <input type="button" class="rg_button_red upper" style="display:none;" id="backToList" title="Back" value="Back To Product List"
                onclick="Back()" />
        </div>
    </div>
    <div id="divProductMaster">
        
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
    <div id="divCreateProduct">
    </div>
</body>
</html>
