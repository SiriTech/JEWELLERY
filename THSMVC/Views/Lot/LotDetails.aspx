<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<THSMVC.Models.LotDetailsModel>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>CreateUser</title>
    <!-- CSS goes in the document HEAD or added to your external stylesheet -->
<style type="text/css">
table.altrowstable {
	font-family: verdana,arial,sans-serif;
	font-size:11px;
	color:Black;
	border-width: 1px;
	border-color: #a9c6c9;
	border-collapse: collapse;
	width:70%;
}
table.altrowstable th {
	border-width: 1px;
	padding: 8px;
	border-style: solid;
	border-color: #a9c6c9;
	color : Black !important;
}
table.altrowstable td {
	border-width: 1px;
	padding: 8px;
	border-style: solid;
	border-color: #a9c6c9;
	text-align:center;
}
.oddrowcolor{
	background-color:#d4e3e5;
}
.evenrowcolor{
	background-color:#b9c9fe;
}

table.printtable {
	font-family: verdana,arial,sans-serif;
	font-size:11px;
	color:#669;
	border-width: 1px;
	border-color: #a9c6c9;
	border-collapse: collapse;
}
table.printtable th {
	border-width: 1px;
	padding: 8px;
	border-style: solid;
	border-color: #a9c6c9;
	color : Black !important;
	background-color:#d4e3e5;
}
table.printtable td {
	padding: 8px;
	border-bottom-width : 1px;
	border-bottom-style: solid;
	border-bottom-color: #a9c6c9;
}

html, body {
    height: 100%;
  }
  .tableContainer-1 {
    height: 100%;
    width: 100%;
    display: table;
  }
  .tableContainer-2 {
    vertical-align: middle;
    display: table-cell;
    height: 100%;
  }
  .MyTable {
    margin: 0 auto;
  }
</style>
    <script type="text/javascript">
        $(document).ready(function () {
            altRows('tblLotDetails');
            HideStoneRelatedFields();
            GetCompletedLots();
            $("#ProductId").change(function () {
                var productId = $('#ProductId').val();
                if (productId == '' || productId == null || productId == undefined) {
                    HideStoneRelatedFields();
                } else {
                    CheckIsStonedAndGetStonesList(productId);
                }
            });

            $("#txtStoneWeight").blur(function(){
               GetCalculatedStonePrice();
           });

           $("#txtWeightOrMrp").keydown(function (event) {
               if (event.shiftKey == true) {
                   event.preventDefault();
               }

               if ((event.keyCode >= 48 && event.keyCode <= 57) || (event.keyCode >= 96 && event.keyCode <= 105) || event.keyCode == 8 || event.keyCode == 9 || event.keyCode == 37 || event.keyCode == 39 || event.keyCode == 46 || event.keyCode == 110) {
                   if (event.keyCode == 8 || event.keyCode == 46 || event.keyCode == 9) {
                   } else {
                       var arr = $(this).val().split('.');
                       if (arr.length <= 2) {
                           debugger;
                           if (arr[1].length > 2 || event.keyCode == 110) {
                               event.preventDefault();
                           }
                       }
                       if (arr.length > 2) {
                           event.preventDefault();
                       }
                   }
               } else {
                   event.preventDefault();
               }

               //                if ($(this).val().indexOf('.') !== -1 && event.keyCode == 190)
               //                    event.preventDefault();
           });
            
        });

        function altRows(id) {
            if (document.getElementsByTagName) {

                var table = document.getElementById(id);
                var rows = table.getElementsByTagName("tr");

                for (i = 0; i < rows.length; i++) {
                    if (i % 2 == 0) {
                        rows[i].className = "evenrowcolor";
                    } else {
                        rows[i].className = "oddrowcolor";
                    }
                }
            }
        }
        window.onload = function () {
            altRows('tblLotDetails');
        }

        function HideStoneRelatedFields() {
            $("#thStoneDdl").hide();
            $("#thNoOfStones").hide();
            $("#thStoneWeight").hide();
            $("#thStonePrice").hide();

            $("#tdStoneDdl").hide();
            $("#tdNoOfStones").hide();
            $("#tdStoneWeight").hide();
            $("#tdStonePrice").hide();
        }

        function ShowStoneRelatedFields() {
            $("#thStoneDdl").show();
            $("#thNoOfStones").show();
            $("#thStoneWeight").show();
            $("#thStonePrice").show();

            $("#tdStoneDdl").show();
            $("#tdNoOfStones").show();
            $("#tdStoneWeight").show();
            $("#tdStonePrice").show();
        }

        function SubmitLot() {

            $("#dialog-confirm").dialog({
                resizable: false,
                width:360,
                modal: true,
                buttons: {
                    Submit: function () {

                        $.ajax({
                            type: "POST",
                            url: "Lot/SubmitLot",
                            data: { lotId: $("#hdnLotId").val() },
                            dataType: "json",
                            beforeSend: function () {
                                //$('#ddlStone option[value!=""]').remove();
                            },
                            success: function (Result) {
                                if (Result.success) {
                                    //Todo: Redirect to List Page
                                    LoadFirstContent('166', 'Lots Assigned');
                                    Success(Result.message);
                                }
                                else {
                                    Failure(Result.message);
                                }
                            },
                            error: function (Result) {
                                alert("Error");
                            }
                        });
                        $(this).dialog("close");
                    },
                    Cancel: function () {
                        $(this).dialog("close");
                       // alert('Cancel');
                    }
                }
            });

//            alert($("#hdnLotId").val());


        }

        function GetAssignedAndCompletedCount() {
            $.ajax({
                type: "POST",
                url: "Lot/GetAssinedAndCompletedCount",
                data: { lotId : $("#hdnLotId").val()},
                dataType: "json",
                beforeSend: function () {
                    //$('#ddlStone option[value!=""]').remove();
                },
                success: function (Result) {
                    $("#lblAssignedCount").html(Result.AssCount);
                    $("#lblCompletedCount").html(Result.CompCount);
                    $("#lblPendingCount").html(Result.AssCount - Result.CompCount);

                    $("#lblAssWeight").html(Result.assWeight + ' grms');
                    $("#lblCmpWeight").html(Result.compWeight + ' grms');
                    $("#lblPenWeight").html((Result.assWeight - Result.compWeight) + ' grms');

                    $("#lblAssPrice").html('Rs. '+Result.assMRP);
                    $("#lblCmpPrice").html('Rs. ' + Result.compMRP);
                    $("#lblPenPrice").html('Rs. ' +( Result.assMRP - Result.compMRP));
                },
                error: function (Result) {
                    alert("Error");
                }
            });
        }

        function GetCalculatedStonePrice() {
            var lotId = $("#hdnLotId").val();
            var stoneId = $('#ddlStone').val();
            var stoneWeight = $('#txtStoneWeight').val();
            if (stoneWeight == '' || stoneWeight == null || stoneWeight == undefined) {
            }
            else {
                $.ajax({
                    type: "POST",
                    url: "Lot/GetCalculatedStonePrice",
                    data: { stoneId: stoneId, weight: stoneWeight },
                    dataType: "json",
                    beforeSend: function () {
                        //$('#ddlStone option[value!=""]').remove();
                    },
                    success: function (Result) {
                        $('#txtStonePrice').val(Result.data);
                    },
                    error: function (Result) {
                        alert("Error");
                    }
                });
            }
        }

        function CheckIsStonedAndGetStonesList(prdctId) {
            $.ajax({
                type: "POST",
                url: "Lot/CheckIsStonedOrNot",
                data: { productId: prdctId },
                dataType: "json",
                beforeSend: function () {
                    $('#ddlStone option[value!=""]').remove();
                },
                success: function (Result) {
                    if (Result.success) {
                        ShowStoneRelatedFields();

                        $.each(Result.stoneList, function (key, value) {
                            $("#ddlStone").append($("<option></option>").val
                               (value.StoneId).html(value.StoneName));
                        });
                    }
                    else {
                        HideStoneRelatedFields();
                    }
                },
                error: function (Result) {
                    alert("Error");
                }
            });
        }

        function ResetFields() {
            //$('#divAssignedLotList').find("input[type=text], input[type=select], textarea").val("");
//            $(':input').not(":button").val('');
//            $('input[type=checkbox]').attr('checked', false);
        }

        function PrintBarcode() {
            var lotId = $("#hdnLotId").val();
            
            var productId = $('#ProductId').val();
            var Weight = ''
            var MRP = '';
            if ($("#chkIsMRP").is(':checked')) {
                MRP = $('#txtWeightOrMrp').val();
                Weight = 0;
            }
            else {
                Weight = $('#txtWeightOrMrp').val();
                MRP = 0;
            }

            var stoneId = $('#ddlStone').val();
            var noOfStones = $('#txtNoOfStones').val();
            var stoneWeight = $('#txtStoneWeight').val();
            var stonePrice = $('#txtStonePrice').val();
            var notes = $('#txtNotes').val();
            var errorMsg = '';

            if (productId == '' || productId == null || productId == undefined) {
                errorMsg = errorMsg + 'Please select Product <br/>';
            }
            if (Weight == '' || Weight == null || Weight == undefined) 
            {
                if (MRP == '' || MRP == null || MRP == undefined) {
                    errorMsg = errorMsg + 'Please enter Weight/MRP <br/>';
                }
            }

            if ($('#tdStoneDdl').is(':visible')) {
                if (stoneId == '' || stoneId == null || stoneId == undefined || stoneId == 0) {
                    errorMsg = errorMsg + 'Please select Stone <br/>';
                }
                if (stoneWeight == '' || stoneWeight == null || stoneWeight == undefined) {
                    errorMsg = errorMsg + 'Please enter Stone Weight <br/>';
                }
                
                if (stonePrice == '' || stonePrice == null || stonePrice == undefined) {
                    errorMsg = errorMsg + 'Please enter Stone Price. <br/>';
                }
            }
            else {
                stoneId = 0; stoneWeight = 0; noOfStones = 0;stonePrice = 0;
            }

           var datToSend = {   productId:productId,
                               lotId: lotId, 
                               stoneId : stoneId == null ? 0 : stoneId,
                               Weight: Weight == null ? 0 : Weight,
                               mrp : MRP == null ?0 :MRP,
                               stoneWeight: stoneWeight == null ? 0 : stoneWeight,
                               stonePrice: stonePrice == null ? 0 : stonePrice,
                               noOfStones: noOfStones == null ? 0 : noOfStones, 
                               notes:notes };
         
           if (errorMsg == '' || errorMsg == null || errorMsg == undefined) {

               $.ajax({
                   type: "POST",
                   url: "Lot/PrintBarcode",
                   data: datToSend,
                   dataType: "json",
                   beforeSend: function () {
                       //$('#ddlStone option[value!=""]').remove();
                   },
                   success: function (Result) {

                       if (Result.success) {
                           $("#lblAssignedCount").html(Result.AssCount);
                           $("#lblCompletedCount").html(Result.CompCount);
                           $("#lblPendingCount").html(Result.AssCount - Result.CompCount);

                           $("#CompletedLotlist").trigger("reloadGrid");
                           ResetFields();
                           HideStoneRelatedFields();
                       } else {
                           Failure(Result.Message);
                       }
                   },
                   error: function (Result) {
                       alert("Error");
                   }
               });

            } else {
                Failure(errorMsg);
                return;
            }
        }

        function EditLot(barcodeId) {
            //alert(barcodeId);
            $.ajax({
                type: "POST",
                url: "Lot/EditBarcode",
                data: { id: barcodeId },
                dataType: "json",
                beforeSend: function () {
                    //$('#ddlStone option[value!=""]').remove();
                },
                success: function (Result) {
                    debugger;
                    if (Result.success) {
                        $("#ProductId").val(Result.prdId);
                        $('#chkIsMRP').prop('checked', Result.isMRP);
                        $("#txtWeightOrMrp").val(Result.weightOrMRP);
                        $("#txtNotes").val(Result.notes);
                    } else {
                        //Failure(Result.Message);
                    }
                },
                error: function (Result) {
                    debugger;
                    alert("Error");
                }
            });
        }

        function DeleteLot(barcodeId){
            //alert(barcodeId);
        }

        function GetCompletedLots() {
            debugger;

            GetAssignedAndCompletedCount();
            jQuery("#CompletedLotlist").jqGrid({
                url: '/Lot/JsonCompletedLotCollection?lotId=' + $("#hdnLotId").val(),
                datatype: "json",
                mtype: 'POST',
                colNames: ['Id', 'ProductName', 'Edit', 'Delete'],
                colModel: [
                     { name: 'Id', index: 'Id', width: 100, align: 'left', editable: false, viewable: false, hidden: true, formoptions: { elmsuffix: '(*)', rowpos: 1, colpos: 1} },
                { name: 'ProductName', index: 'ProductName', width: 100, align: 'center', editable: true, viewable: true, hidden: false, formoptions: { elmsuffix: '(*)', rowpos: 1, colpos: 2} },
                { name: 'Edit', index: 'Edit', width: 100, align: 'center', editable: true, hidden: true, formoptions: { elmsuffix: '(*)', rowpos: 2, colpos: 2} }
                , { name: 'Delete', index: 'Delete', width: 100, align: 'center', hidedlg: true, editable: true, hidden: true, edittype: 'text', editrules: { required: true }, formoptions: { elmsuffix: '(*)', rowpos: 3, colpos: 2} }
                ],
                rownumbers: true,
                rowNum: 10,
                rowList: [10, 20, 30],
                height: 'auto',
                autowidth: true,
                pager: jQuery('#CompletedLotpager'),
                sortname: 'ProductName',
                viewrecords: true,
                sortorder: "asc",
                caption: "Assinged Lots",
                gridComplete: function () {
                    var recs = parseInt($("#CompletedLotlist").getGridParam("records"), 10);
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
            }).navGrid('#CompletedLotpager', { search: false, view: false, edit: false, add: false, del: true, searchtext: "" },
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
           url: '/Lot/DeleteBarcode',
           onclickSubmit: function (params) {
               var ajaxData = {};
               var list = $("#CompletedLotlist");
               var selectedRow = list.getGridParam("selrow");
               rowData = list.getRowData(selectedRow);
               ajaxData = { id: rowData.Id };
               return ajaxData;
           },
           afterComplete: function (response) {
               var resp = $.parseJSON(response.responseText);
               ClearMsg();
               if (resp.success) {
                   $("#CompletedLotlist").trigger("reloadGrid");
                   GetAssignedAndCompletedCount();
                   Success(resp.message);
               }
               else
                   Failure(resp.message);
               var recs = parseInt($("#CompletedLotlist").getGridParam("records"), 10);
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

            jQuery("#CompletedLotlist").jqGrid('navButtonAdd', '#CompletedLotpager', {
                caption: "Show/Hide",
                buttonicon: "ui-icon-newwin",
                title: "Show/Hide Columns",
                onClickButton: function () {
                    jQuery("#CompletedLotlist").setColumns({ ShrinkToFit: true, colnameview: false, recreateForm: true, afterSubmitForm: function (id) { setTimeout("imagePreview()", 2000); } });
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
                <span class="divHeading">Lot Details</span>
            </div>
            <div class="clear">
                <div class="ContentdivBorder" id="divLotInfo">
                    <div class="clear">
                       <table class="altrowstable MyTable" id="tblLotDetails">
                        <tr>
                            <th>LotName</th>
                            <th>Weight OR MRP</th>
                            <th>No Of Pieces</th>
                            <th>Product Group</th>
                            <th>Is MRP</th>
                        </tr>
                        <tr>
                            <td>
                                <%= this.Model.LotName %>
                                <%= Html.Hidden("hdnLotId", this.Model.LotId) %>
                            </td>
                            <td>
                                <%= this.Model.Weight.ToString() %>
                            </td>
                            <td>
                                <%=this.Model.NoOfPcs.ToString() %>
                            </td>
                            <td>
                                <%= this.Model.ProductGroupName %>
                            </td>
                            <td>
                                <%= this.Model.IsMRP.ToString() %>
                            </td>

                        </tr>
                       </table>
                    </div>
                </div>
            </div>
        </div>
        <div class="clear">
            <div class="ContentdivHead" onclick="toggleContentDivHead(this,'#divPrintRow');">
                <span class="divHeading">Print Barcode</span>
            </div>
            <div class="clear">
                <div class="ContentdivBorder" id="divPrintRow">
                    <div class="clear">
                       <table class="printtable MyTable">
                        <tr>
                            <th>Select Product</th>
                            <th>Is MRP</th>
                            <th>Weight/MRP</th>
                            <th id="thStoneDdl">Select Stone</th>
                            <th id="thNoOfStones">No Of Stones</th>
                            <th id="thStoneWeight">Stone Weight</th>
                            <th id="thStonePrice">Price</th>
                            <th >Notes</th>
                            <th></th>
                        </tr>
                        <tr>
                            <td style="border-left-width : 1px;border-left-style: solid;border-left-color: #a9c6c9;">
                                <%=  Html.DropDownListFor(model => model.ProductId, Model.ProductList.Select(x => new SelectListItem { Text = x.ProductName.ToString(), Value = x.Id.ToString() }),"Select Product", new { Style="width:140px"})%>
                            </td>
                            <td>
                                <input style="width:40px;" type="checkbox" id="chkIsMRP" />
                            </td>
                            <td>
                                <input style="width:80px;" type="text" id="txtWeightOrMrp" />
                            </td>
                            <td id="tdStoneDdl">
                                <select id="ddlStone" style="width:120px">
                                    <option>Select Stone</option>
                                </select>
                            </td>
                            <td id="tdNoOfStones">
                                <input style="width:83px;" type="text" id="txtNoOfStones" />
                            </td>
                            <td id="tdStoneWeight">
                                <input style="width:85px;" type="text" id="txtStoneWeight" />
                            </td>
                            <td id="tdStonePrice">
                                <input style="width:80px;" type="text" id="txtStonePrice" />
                            </td>
                            <td>
                                <textarea id="txtNotes"></textarea>
                            </td>
                            <td style="border-right-width : 1px;border-right-style: solid;border-right-color: #a9c6c9;">
                                <input type="button" class="rg_button_red" id="btnPrintBarcode" onclick="PrintBarcode();" value="Print" />
                            </td>
                        </tr>
                       </table>

                    </div>
                </div>
            </div>
        </div>

         <div class="clear">
            <div class="ContentdivHead" onclick="toggleContentDivHead(this,'#divAssignedLotList');">
                <span class="divHeading">Completed Barcodes</span>
            </div>
            <div class="clear">
                <div class="ContentdivBorder" id="divAssignedLotList">
                    <div class="clear">
                        <%--<table id="tblCompletedBarcodes">
                            <tr>
                                <th>
                                    Product Name
                                </th>
                                <th>
                                    Edit
                                </th>
                                <th>Delete</th>
                            </tr>
                        </table>--%>

                         <div id="gridWrapper" style="width: 100%;">

                         <div class="tableContainer-1">
                         <div class="tableContainer-2">
                         <br />
                            <table class="printtable MyTable">
                                <tr>
                                    <th>
                                        Assigned Count
                                    </th>
                                    <th>
                                        <label id="lblAssignedCount"></label>
                                    </th>

                                    <th>
                                        Completed Count
                                    </th>
                                    <th>
                                        <label id="lblCompletedCount"></label>
                                    </th>

                                    <th>
                                        Pending Count
                                    </th>
                                    <th>
                                        <label id="lblPendingCount"></label>
                                    </th>
                                </tr>

                                <tr>
                                    <th>
                                        Assigned Weight
                                    </th>
                                    <th>
                                        <label id="lblAssWeight"></label>
                                    </th>

                                    <th>
                                        Completed Weight
                                    </th>
                                    <th>
                                        <label id="lblCmpWeight"></label>
                                    </th>

                                    <th>
                                        Pending Weight
                                    </th>
                                    <th>
                                        <label id="lblPenWeight"></label>
                                    </th>
                                </tr>

                                <tr>
                                    <th>
                                        Assigned Price
                                    </th>
                                    <th>
                                        <label id="lblAssPrice"></label>
                                    </th>

                                    <th>
                                        Completed Price
                                    </th>
                                    <th>
                                        <label id="lblCmpPrice"></label>
                                    </th>

                                    <th>
                                        Pending Price
                                    </th>
                                    <th>
                                        <label id="lblPenPrice"></label>
                                    </th>
                                </tr>
                                 
                            </table><br />
                            </div>
                            
                         </div>
                            <div>
                                <table id="CompletedLotlist" class="scroll" cellpadding="0" cellspacing="0">
                                </table>
                                <div id="CompletedLotpager" class="scroll" style="text-align: center;">
                                </div>
                            </div>
                        </div>
                        <div id="EmptyGridWrapper">
                        </div>

                    </div>
                </div>
            </div>
        </div>

        <div class="clear" style="text-align:center">
        <input type="button" class="rg_button_red" style="font-size:20px; border-radius:5px;" id="Button1" onclick="SubmitLot();" value="Submit Lot" />
        </div>
    </div>

    <div id="dialog-confirm" title="Submit Lot?" style="display:none">
        <p>
            <span class="ui-icon ui-icon-alert" style="float: left; margin: 0 7px 20px 0;"></span>
            Are you sure you want to submit the Lot ?
         </p>
    </div>

</body>
</html>
