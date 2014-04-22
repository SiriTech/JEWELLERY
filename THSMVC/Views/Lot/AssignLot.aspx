<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<THSMVC.Models.LotAssignModel>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>CreateUser</title>
    <script type="text/javascript">
        $(document).ready(function () {
            GetAssingedLots();
        });

        function LotAssign_Submit() {
            ClearMsg();
            var msg = "";
            if ($("#LotId").val() == '') {
                msg += "Please select Lot<br/>";
            }
            if ($("#userId").val() == '') {
                msg += "Please select User<br/>";
            }
            if (msg != '') {
                Failure(msg);
                return;
            }
            var LotId = $("#LotId").val();
            var UserId = $("#userId").val();
            var url = "/Lot/AssignLot";
            $.ajax({
                type: "POST",
                traditional: true,
                url: url,
                data: {
                    LotId: LotId,
                    UserId: UserId
                },
                dataType: "json",
                beforeSend: function () {
                    $.blockUI();   //this is great plugin - 'blockUI'
                },
                success: function (result) {
                    if (result.success) {
                        Success(result.msg);
                        clearForm();
                        $("#Lotlist").trigger("reloadGrid");
                        $("#LotId option[value='" + LotId + "']").remove();
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

        function clearForm() {
            ClearMsg();
            $("select#LotId").val('');
            $("select#userId").val('');
        }

        function GetAssingedLots() {
            jQuery("#Lotlist").jqGrid({
                url: '/Lot/JsonAssignedLotCollection',
                datatype: "json",
                mtype: 'POST',
                colNames: ['Id', 'LotName', 'Assigned To', 'Status'],
                colModel: [
                     { name: 'Id', index: 'Id', width: 100, align: 'left', editable: false, viewable: false, hidden: true, formoptions: { elmsuffix: '(*)', rowpos: 1, colpos: 1 } },
                { name: 'LotName', index: 'LotName', width: 100, align: 'left', editable: true, viewable: true, hidden: false, formoptions: { elmsuffix: '(*)', rowpos: 1, colpos: 2 } },
                { name: 'UserName', index: 'UserName', width: 100, align: 'left', editable: true, formoptions: { elmsuffix: '(*)', rowpos: 2, colpos: 2 } },
                { name: 'Status', index: 'Status', width: 100, align: 'left', editable: true, edittype: 'text', editrules: { required: true }, formoptions: { elmsuffix: '(*)', rowpos: 3, colpos: 2 } }
                ],
                rowNum: 10,
                rowList: [10, 20, 30],
                height: 'auto',
                autowidth: true,
                pager: jQuery('#Lotpager'),
                sortname: 'LotName',
                viewrecords: true,
                sortorder: "asc",
                caption: "Assinged Lots",
                gridComplete: function () {
                    var recs = parseInt($("#Lotlist").getGridParam("records"), 10);
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
            }).navGrid('#Lotpager', { search: false, view: false, edit: false, add: false, del: true, searchtext: "" },
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
                   var list = $("#Lotlist");
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
                   var recs = parseInt($("#Lotlist").getGridParam("records"), 10);
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
                           debugger;
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
           { closeOnEscape: true, multipleSearch: true, closeAfterSearch: true }, // search options
           { closeOnEscape: true, width: 350 } // view options
        );
            $.extend($.jgrid.search, { Find: 'Search' });

            jQuery("#Lotlist").jqGrid('navButtonAdd', '#Lotpager', {
                caption: "Show/Hide",
                buttonicon: "ui-icon-newwin",
                title: "Show/Hide Columns",
                onClickButton: function () {
                    jQuery("#Lotlist").setColumns({ ShrinkToFit: true, colnameview: false, recreateForm: true, afterSubmitForm: function (id) { setTimeout("imagePreview()", 2000); } });
                    return false;
                }
            });
        }


    </script>
</head>
<body>
    <div id="divCreateLot" style="clear: both; width: 100%; display: block;">
        <div class="clear">
            <div class="ContentdivHead" onclick="toggleContentDivHead(this,'#divLotInfo');">
                <span class="divHeading">Assign Lot</span>
            </div>
            <div class="clear">
                <div class="ContentdivBorder" id="divLotInfo">
                    <div class="clear">
                        <%-- <div class="FloatLeft" style="width: 80%;">--%>
                        <div class="clear">
                            <div class="clear">
                                <div class="editor-label FloatLeft" style="width: 40%;">
                                    <span class="ValidationSpan">*</span> Select Lot to Assign
                                </div>
                                <div class="editor-field" style="text-align: left;">
                                    <%-- <%= Html.TextBoxFor(m => m.ProductGroupId, new { maxlength = 10, autocomplete = "off", title="Type in Lot Name" })%>--%>
                                    <%=  Html.DropDownListFor(model => model.LotId, Model.LotList.Select(x => new SelectListItem { Text = x.LotName.ToString(), Value = x.LotId.ToString() }),"Select Lot")%>
                                </div>
                            </div>
                        </div>
                        <div class="clear">
                            <div class="clear">
                                <div class="editor-label FloatLeft" style="width: 40%;">
                                    <span class="ValidationSpan">*</span> Select User to Assign
                                </div>
                                <div class="editor-field" style="text-align: left;">
                                    <%--<%= Html.TextBoxFor(m => m.DealerId, new { maxlength = 10, autocomplete = "off", title="Type in Lot Name" })%>--%>
                                    <%=  Html.DropDownListFor(model => model.userId, Model.UserList.Select(x => new SelectListItem { Text = x.UserName.ToString(), Value = x.Id.ToString() }),"Select User")%>
                                </div>
                            </div>
                        </div>
                        <div class="clear">
                            <div id="divButtons" class="clear" style="margin-top: 10px; margin-bottom: 20px;">
                                <center>
                                    <input type="button" value="OK, Assign" class="rg_button_red" onclick="LotAssign_Submit(); return false;" />
                                </center>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="clear">
            <div class="ContentdivHead" onclick="toggleContentDivHead(this,'#divAssignedLotList');">
                <span class="divHeading">Assinged Lots</span>
            </div>
            <div class="clear">
                <div class="ContentdivBorder" id="divAssignedLotList">
                    <div class="clear">
                        <div id="gridWrapper" style="width: 100%;">

                            <div>
                                <table id="Lotlist" class="scroll" cellpadding="0" cellspacing="0">
                                </table>
                                <div id="Lotpager" class="scroll" style="text-align: center;">
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
