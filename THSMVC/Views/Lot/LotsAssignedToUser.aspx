<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<THSMVC.Models.LotAssignModel>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>CreateUser</title>
    <script type="text/javascript">
        $(document).ready(function () {
           GetAssingedLotsToUser()
        });

       
        function GetAssingedLotsToUser() {
            jQuery("#AssignedLotlist").jqGrid({
                url: '/Lot/JsonAssignedLotsToUserCollection',
                datatype: "json",
                mtype: 'POST',
                colNames: ['Id', 'LotName', 'Assigned To', 'Status', 'Action'],
                colModel: [
                     { name: 'Id', index: 'Id', width: 100, align: 'left', editable: false, viewable: false, hidden: true, formoptions: { elmsuffix: '(*)', rowpos: 1, colpos: 1} },
                { name: 'LotName', index: 'LotName', width: 100, align: 'left', editable: true, viewable: true, hidden: false, formoptions: { elmsuffix: '(*)', rowpos: 1, colpos: 2} },
                { name: 'UserName', index: 'UserName', width: 100, align: 'left', editable: true, formoptions: { elmsuffix: '(*)', rowpos: 2, colpos: 2} },
                { name: 'Status', index: 'Status', width: 100, align: 'left', editable: true, edittype: 'text', editrules: { required: true }, formoptions: { elmsuffix: '(*)', rowpos: 3, colpos: 2} },
                { name: 'AcceptLink', index: 'AcceptLink', width: 100, align: 'center', editable: true, edittype: 'text', editrules: { required: true }, formoptions: { elmsuffix: '(*)', rowpos: 3, colpos: 2} }
                ],
                rownumbers: true,
                rowNum: 10,
                rowList: [10, 20, 30],
                height: 'auto',
                autowidth: true,
                pager: jQuery('#AssignedLotpager'),
                sortname: 'LotName',
                viewrecords: true,
                sortorder: "asc",
                caption: "Assinged Lots",
                gridComplete: function () {
                    var recs = parseInt($("#AssignedLotlist").getGridParam("records"), 10);
                    if (recs == 0) {
                        $("#gridWrapper").hide();
                        EmptyGrid("#EmptyGridWrapper");
                        $("#EmptyGridWrapper").show();
                    } else {
                        $('#gridWrapper').show();
                        $("#EmptyGridWrapper").hide();
                    }
                },

                hidegrid: true //To show/hide the button in the caption bar to hide/show the grid.
            }).navGrid('#AssignedLotpager', { search: false, view: false, edit: false, add: false, del: true, searchtext: "" },
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
           url: "/Lot/DelLotAssignment", onclickSubmit: function (params) {
               var ajaxData = {};
               var list = $("#AssignedLotlist");
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
               var recs = parseInt($("#AssignedLotlist").getGridParam("records"), 10);
               if (recs == 0) {
                   $("#gridWrapper").hide();
                   EmptyGrid("#EmptyGridWrapper");
                   $("#EmptyGridWrapper").show();
               } else {
                   $('#gridWrapper').show();
                   $("#EmptyGridWrapper").hide();
               }

               $.ajax({
                   type: "POST",
                   contentType: "application/json; charset=utf-8",
                   url: "Lot/LotDropdown",
                   data: {},
                   dataType: "json",
                   beforeSend: function () {
                       $('#LotId option[value!=""]').remove();
                   },
                   success: function (Result) {
                       $.each(Result.result, function (key, value) {

                           $("#LotId").append($("<option></option>").val
                               (value.LotId).html(value.LotName));
                       });
                   },
                   error: function (Result) {
                       alert("Error");
                   }
               });
           }



       }, // delete options
           {closeOnEscape: true, multipleSearch: true, closeAfterSearch: true }, // search options
           {closeOnEscape: true, width: 350} // view options
        );
            $.extend($.jgrid.search, { Find: 'Search' });

            jQuery("#AssignedLotlist").jqGrid('navButtonAdd', '#AssignedLotpager', {
                caption: "Show/Hide",
                buttonicon: "ui-icon-newwin",
                title: "Show/Hide Columns",
                onClickButton: function () {
                    jQuery("#AssignedLotlist").setColumns({ ShrinkToFit: true, colnameview: false, recreateForm: true, afterSubmitForm: function (id) { setTimeout("imagePreview()", 2000); } });
                    return false;
                }
            });
        }

        function AcceptLot(lotId) {
            $.ajax({
                type: "POST",
                traditional: true,
                url: "/Lot/AcceptLot",
                data: {
                    lotId: lotId
                },
                dataType: "json",
                beforeSend: function () {
                    $.blockUI();   //this is great plugin - 'blockUI'
                },
                success: function (result) {
                    if (result.success) {
                        RefreshGrid();
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

        function RefreshGrid() {
            //debugger;
            jQuery('#AssignedLotlist').jqGrid('setGridParam', { search: false, url: '/Lot/JsonAssignedLotsToUserCollection' }).trigger("reloadGrid");
        }

        function GotoLotDetails(lotId) {
            $.ajax({
                type: "GET",
                traditional: true,
                url: "/Lot/GetLotDetails",
                data: {
                    lotId: lotId
                },
                dataType: "html",
                beforeSend: function () {
                    $.blockUI();   //this is great plugin - 'blockUI'
                },
                success: function (result) {
                    $("#Content").html(result);
                    $("#hdnLotId").val(lotId);
                    $.unblockUI();
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    $.unblockUI();
                    Error(XMLHttpRequest, textStatus, errorThrown);
                }
            });
        }
    </script>
</head>
<body>
    <div id="divCreateLot" style="clear: both; width: 100%; display: block;">
        
        <div class="clear">
            <div class="ContentdivHead" onclick="toggleContentDivHead(this,'#divAssignedToUserLotList');">
                <span class="divHeading">Assinged Lots</span>
            </div>
            <div class="clear">
                <div class="ContentdivBorder" id="divAssignedToUserLotList">
                    <div class="clear">
                        <div id="gridWrapper" style="width: 100%;">

                            <div>
                                <table id="AssignedLotlist" class="scroll" cellpadding="0" cellspacing="0">
                                </table>
                                <div id="AssignedLotpager" class="scroll" style="text-align: center;">
                                </div>
                            </div>
                        </div>
                        <div id="EmptyGridWrapper">
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
