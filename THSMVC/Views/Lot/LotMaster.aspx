<%--<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<LotMasterModel>" %>--%>
<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<THSMVC.Models.LotMasterModel>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Lot Master</title>
   <style type="text/css">
    .blo
        {
            display: inline-block;
            width: auto;
        }
        .non
        {
            display: none;
        }
   </style>
    <script src="../../Scripts/ImagePreview.js" type="text/javascript"></script>
    <script type="text/javascript">
       
        function Create() {
            ClearMsg();
            $("#ManageUsers").slideUp();
            $("#divbackToSearch").show();
            $("#CreateUser").hide();
            $("#UserTabs").show();
            GetContentByActionAndController('CreateLot', 'Lot', 'Create Lot', '#UserTabs');
            $("#backToList").show();
        }

        function CreateLot_Submit() {

            var url = '';
            var error = '';
            var LId = $("#hdnLotID").val();
            var LName = $("#LotName").val();
            var PGId = $("#ProductGroupId").val();
            var Weight =  $("#Weight").val();
            var Qty = $("#Qty").val();
            var DId = $("#DealerId").val();
            var IsMRP = $("#IsMRP").val();
            var MRP = $("#MRP").val();
            var DiffAllowed = $("#DiffAllowed").val();
            if (LName == null || LName == '' || LName == undefined) {
                error = error + "Lot name is missing. <br />";
            }
            if (PGId == null || PGId == '' || PGId == undefined || PGId == '0') {
                error = error + "Product Group is missing. <br />";
            }
            if (Qty == null || Qty == '' || Qty == undefined || Qty =="0") {
                error = error + "Quantity is missing. <br />";
            }
            if ((Weight == null || Weight == '' || Weight == undefined || Weight =="0") && ( MRP == null || MRP == '' || MRP == undefined || MRP == "0")) {
                error = error + "Weight/MRP is missing.";
            }

            if (error.trim().length > 1) {
                Failure(error);
            }else {
                if ($("#hdnLotID").val() == '' || $("#hdnLotID").val() == null || $("#hdnLotID").val() == "0") {
                    url = "/Lot/CreateLot";
                } else {
                    url = "/Lot/UpdateLot";
                }

                $.ajax({
                    type: "POST",
                    traditional: true,
                    url: url,
                    data: {
                        LotId: LId,
                        LotName: LName,
                        ProductGroupId: PGId,
                        Weight: Weight,
                        Qty: Qty,
                        DealerId: DId,
                        IsMRP: IsMRP,
                        MRP: MRP,
                        DiffAllowed: DiffAllowed
                    },
                    dataType: "json",
                    beforeSend: function () {
                        $.blockUI();   //this is great plugin - 'blockUI'
                    },
                    success: function (result) {
                        if (result.success) {
                            Success(result.msg);
                            clearForm();
                        }
                        else {
                            Failure(result.msg);
                        }
                        $.unblockUI();
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        $.unblockUI();
                        Error(XMLHttpRequest, textStatus, errorThrown);
                    }
                });
            }

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
                $("#backToList").hide();
                $("#CreateUser").show();
                jQuery('#list').jqGrid('setGridParam', { url: gridDataUrl }).trigger("reloadGrid");
            }

        }

       
       
    </script>
</head>
<body>
    <div class="clear">
        
        <div style="float: left;">
            <input type="button" id="CreateUser" class="rg_button_red upper" title="Click to Create Lot"
                value="Create a Lot" onclick="Create()" />
        </div>
      
        <div id="divbackToSearch" style="float: right;">
            <input type="button" class="rg_button_red upper" style="display:none;" id="backToList" title="Back" value="Back To Lot List"
                onclick="toggleSearch()" />
        </div>
    </div>
    <div id="ManageUsers">
        
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
    <div id="UserTabs">
    </div>
    
    <script type="text/javascript">

        var gridDataUrl;
        var Update = '<%=Model.Update %>';
        if (Update == "True") {
            gridDataUrl = '/Lot/JsonLotCollection';
        }
        else {
            gridDataUrl = '/Lot/JsonLotCollection';
        }
        jQuery("#list").jqGrid({
            url: gridDataUrl,
            datatype: "json",
            mtype: 'POST',
            colNames: ['LotId', 'LotName', 'ProductGroupId', 'Qty', 'Weight', 'DealerId'],
            colModel: [
              { name: 'LotId', index: 'LotId', align: 'left', hidedlg: true, hidden: false, editable: true, viewable: false, formoptions: { elmsuffix: '   ', rowpos: 1, colpos: 2} },
               { name: 'LotName', index: 'LotName', width: 100, align: 'left', editable: true, viewable: true, hidden: false, formoptions: { elmsuffix: '(*)', rowpos: 2, colpos: 2} },
              { name: 'ProductGroupId', index: 'ProductGroupId', width: 100, align: 'left', editable: true, formoptions: { elmsuffix: '(*)', rowpos: 4, colpos: 2} },
              { name: 'Qty', index: 'Qty', width: 100, align: 'left', editable: true, edittype: 'text', editrules: { required: true }, formoptions: { elmsuffix: '(*)', rowpos: 5, colpos: 2} },
              { name: 'Weight', index: 'Weight', width: 100, align: 'left', editable: true, formoptions: { elmsuffix: '    ', rowpos: 6, colpos: 2} },
              { name: 'DealerId', index: 'DealerId', width: 100, align: 'left', editable: true, formoptions: { elmsuffix: '    ', rowpos: 7, colpos: 2} }
            ],
            rownumbers: true,
            rowNum: 10,
            rowList: [10, 20, 30],
            height: 'auto',
            autowidth: true,
            pager: jQuery('#pager'),
            sortname: 'LotId',
            viewrecords: true,
            sortorder: "asc",
            caption: "Lot Details",
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

        function UpdateLot(lotId) {
            ClearMsg();
            $("#ManageUsers").slideUp();
            $("#divbackToSearch").show();
            $("#backToList").show();
            $("#CreateUser")[0].className = "rg_button upper";
            $("#UserTabs").show();
            $(".TabContent").show();

           // GetContentByActionAndController('CreateUser', 'Admin', 'Create User', '#UserTabs');
            GetContentByActionAndControllerForEdit("EditLot", "Lot", "Update Lot", lotId, '#UserTabs');
        }
    </script>
</body>
</html>
