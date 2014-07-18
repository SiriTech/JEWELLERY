<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>CreateUser</title>
    <!-- CSS goes in the document HEAD or added to your external stylesheet -->
    <script type="text/javascript">
        $(document).ready(function () {
            LoadCustomers();

        });

        function UpdateCustomer(id) {
            $("#divCustomerMaster").hide();
            $("#CreateCustomer").hide();
            $("#backToList").show();
            $("#divCreateCustomer").show();
            //GetContentByActionAndController('AddEditCustomer', 'Customer', 'Add/Edit Customer', '#divCreateCustomer');
            GetContentByActionAndControllerForEdit('EditCustomer', 'Customer', 'Add/Edit Customer', id, '#divCreateCustomer');
        }

        function LoadCustomers() {
            var gridDataUrl;
            gridDataUrl = '/Customer/JsonCustomerCollection';
            jQuery("#list").jqGrid({
                url: gridDataUrl,
                datatype: "json",
                mtype: 'POST',
                colNames: ['Id', 'Customer Name', 'Customer Number', 'Address', 'City', 'State', 'Mobile', 'PhoneNumber', 'EmailAddress'],
                colModel: [
                  { name: 'Id', index: 'Id', align: 'left', hidedlg: true, hidden: true, editable: false, viewable: false, formoptions: { elmsuffix: '   ', rowpos: 1, colpos: 2} },
                  { name: 'Customer Name', index: 'Name', align: 'left', hidden: false, editable: false, viewable: false, formoptions: { elmsuffix: '   ', rowpos: 1, colpos: 3} },
                  { name: 'Customer Number', index: 'CustometNumber', align: 'left', hidden: false, editable: false, viewable: false, formoptions: { elmsuffix: '   ', rowpos: 1, colpos: 3} },
                  { name: 'Address', index: 'Address', align: 'left', hidden: false, editable: false, viewable: false, formoptions: { elmsuffix: '   ', rowpos: 1, colpos: 3} },
                  { name: 'City', index: 'City', align: 'left', hidden: false, editable: false, viewable: false, formoptions: { elmsuffix: '   ', rowpos: 1, colpos: 3} },
                  { name: 'State', index: 'State', align: 'left', hidden: false, editable: false, viewable: false, formoptions: { elmsuffix: '   ', rowpos: 1, colpos: 3} },
                  { name: 'MobileNumber1', index: 'MobileNumber1', align: 'left', hidden: false, editable: false, viewable: false, formoptions: { elmsuffix: '   ', rowpos: 1, colpos: 3 } },
                  { name: 'PhoneNumber', index: 'PhoneNumber', align: 'left', hidden: false, editable: false, viewable: false, formoptions: { elmsuffix: '   ', rowpos: 1, colpos: 3} },
                  { name: 'EmailAddress', index: 'EmailAddress', align: 'left', hidden: false, editable: false, viewable: false, formoptions: { elmsuffix: '   ', rowpos: 1, colpos: 3} }
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
                caption: "Customers",
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
       url: "/Customer/DelCustomer",
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

            jQuery("#list").jqGrid('navButtonAdd', '#pager', {
                caption: "Show/Hide",
                buttonicon: "ui-icon-newwin",
                title: "Show/Hide Columns",
                onClickButton: function () {
                    jQuery("#list").setColumns({ ShrinkToFit: true, colnameview: false, recreateForm: true, afterSubmitForm: function (id) { setTimeout("imagePreview()", 2000); } });
                    return false;
                }
            });


        }

        function CreateCust() {
            $("#divCustomerMaster").hide();
            $("#CreateCustomer").hide();
            $("#backToList").show();
            $("#divCreateCustomer").show();
            GetContentByActionAndController('AddEditCustomer', 'Customer', 'Add/Edit Customer', '#divCreateCustomer');
        }

        function BackToList() {
            ClearMsg();
            $("#divCustomerMaster").show();
            $("#CreateCustomer").show();
            $("#backToList").hide();
            $("#divCreateCustomer").hide();
            $("#list").trigger("reloadGrid");
        }

    </script>
</head>
<body>
    <div id="divCustDetails" style="clear: both; width: 100%; display: block;">
        <div class="clear">
            <div style="float: left;">
                <input type="button" id="CreateCustomer" class="rg_button_red upper" title="Click to Create Customer"
                    value="Create Customer" onclick="CreateCust()" />
            </div>
            <div id="divbackToSearch" style="float: right;">
                <input type="button" class="rg_button_red upper" style="display: none;" id="backToList"
                    title="Back" value="Back To Customer List" onclick="BackToList()" />
            </div>
        </div>
        <div class="clear">
            <div class="ContentdivBorder" id="divLotInfo">
                <div id="divCustomerMaster">
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
            </div>
        </div>
        <div id="divCreateCustomer">
        </div>
    </div>
</body>
</html>
