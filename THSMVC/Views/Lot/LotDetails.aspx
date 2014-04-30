<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<THSMVC.Models.LotDetailsModel>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>CreateUser</title>
    <script type="text/javascript">
        $(document).ready(function () {

            HideStoneRelatedFields();

            $("#ProductId").change(function () {
                var productId = $('#ProductId').val();
                if (productId == '' || productId == null || productId == undefined) {

                } else {
                    CheckIsStonedAndGetStonesList(productId);
                }
            });
        });

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

        function CheckIsStonedAndGetStonesList(prdctId) {
            debugger;
            $.ajax({
                type: "POST",
                url: "Lot/CheckIsStonedOrNot",
                data: { productId: prdctId },
                dataType: "json",
                beforeSend: function () {
                    $('#ddlStone option[value!=""]').remove();
                },
                success: function (Result) {
                    debugger;
                    if (Result.success) {
                        ShowStoneRelatedFields();

                        $.each(Result.stoneList, function (key, value) {
                            $("#ddlStone").append($("<option></option>").val
                               (value.StoneId).html(value.StoneName));
                        });
                    }
                },
                error: function (Result) {
                    debugger;
                    alert("Error");
                }
            });
        }

        function PrintBarcode() {
            var lotId = $("#hdnLotId").val();
            
            var productId = $('#ProductId').val();
            var WeightOrMRP = $('#txtWeightOrMrp').val();
            var stoneId = $('#ddlStone').val();
            var noOfStones = $('#txtNoOfStones').val();
            var stoneWeight = $('#txtStoneWeight').val();
            var stonePrice = $('#txtStonePrice').val();
            var notes = $('#txtNotes').val();
            var errorMsg = '';
            if (productId == '' || productId == null || productId == undefined) {
                errorMsg = errorMsg + 'Please select Product <br/>';
            }
            if (WeightOrMRP == '' || WeightOrMRP == null || WeightOrMRP == undefined) {
                errorMsg = errorMsg + 'Please enter Weight <br/>';
            }

            if ($('#tdStoneDdl').is(':visible')) {
               if (stoneId == '' || stoneId == null || stoneId == undefined || stoneId == 0) {
                errorMsg = errorMsg + 'Please select Stone <br/>';
                }
                if (stoneWeight == '' || stoneWeight == null || stoneWeight == undefined) {
                    errorMsg = errorMsg + 'Please enter Stone Weight <br/>';
                }
                if (noOfStones == '' || noOfStones == null || noOfStones == undefined) {
                    errorMsg = errorMsg + 'Please enter no of stones <br/>';
                }
                if (stonePrice == '' || stonePrice == null || stonePrice == undefined) {
                    errorMsg = errorMsg + 'Please enter Stone Price. <br/>';
                }
            }

           var datToSend = {    productId:productId, 
                                lotId: lotId, 
                               stoneId : stoneId, 
                               Weight: WeightOrMRP, 
                               stoneWeight:stoneWeight, 
                               stonePrice: stonePrice, 
                               noOfStones : noOfStones, 
                               notes:notes };
         
           if (errorMsg == '' || errorMsg == null || errorMsg == undefined) {

                $.ajax({
                    type: "POST",
                    url: "Lot/PrintBarcode",
                    data:  datToSend ,
                    dataType: "json",
                    beforeSend: function () {
                        //$('#ddlStone option[value!=""]').remove();
                    },
                    success: function (Result) {
                        debugger;
                        if (Result.success) {
                            $.each(Result.stoneList, function (key, value) {
                                var newRow = $("<tr><td>"+value.ProductName+"</td><td>"+value.Edit+"</td> <td> "+value.Delete+"</td></tr>");
                                $("#tblCompletedBarcodes").append(newRow);
                            });
                        }else
                        {
                            Failure('Erro occured while generating Barcode and printing Barcode.');
                        }
                    },
                    error: function (Result) {
                        debugger;
                        alert("Error");
                    }
                });


            } else {
                Failure(errorMsg);
                return;
            }
        }

        function EditLot(barcodeId){
            alert(barcodeId);
        }

        function DeleteLot(barcodeId){
            alert(barcodeId);
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
                       <table>
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
            <div class="ContentdivHead" onclick="toggleContentDivHead(this,'#divAssignedLotList');">
                <span class="divHeading">Print Barcode</span>
            </div>
            <div class="clear">
                <div class="ContentdivBorder" id="divAssignedLotList">
                    <div class="clear">
                       <table>
                        <tr>
                            <th>Select Product</th>
                            <th>Weight/MRP</th>
                            <th id="thStoneDdl">Select Stone</th>
                            <th id="thNoOfStones">No Of Stones</th>
                            <th id="thStoneWeight">Stone Weight</th>
                            <th id="thStonePrice">Price</th>
                            <th >Notes</th>
                            <th></th>
                        </tr>
                        <tr>
                            <td>
                                <%=  Html.DropDownListFor(model => model.ProductId, Model.ProductList.Select(x => new SelectListItem { Text = x.ProductName.ToString(), Value = x.Id.ToString() }),"Select Product")%>
                            </td>
                            <td>
                                <input style="width:80px;" type="text" id="txtWeightOrMrp" />
                            </td>
                            <td id="tdStoneDdl">
                                <select id="ddlStone">
                                    <option>Select Stone</option>
                                </select>
                            </td>
                            <td id="tdNoOfStones">
                                <input style="width:80px;" type="text" id="txtNoOfStones" />
                            </td>
                            <td id="tdStoneWeight">
                                <input style="width:80px;" type="text" id="txtStoneWeight" />
                            </td>
                            <td id="tdStonePrice">
                                <input style="width:80px;" type="text" id="txtStonePrice" />
                            </td>
                            <td>
                                <textarea id="txtNotes"></textarea>
                            </td>
                            <td>
                                <input type="button" class="rg_button_red" id="btnPrintBarcode" onclick="PrintBarcode();" value="Print" />
                            </td>
                        </tr>
                       </table>

                    </div>
                </div>
            </div>
        </div>

         <div class="clear">
            <div class="ContentdivHead" onclick="toggleContentDivHead(this,'#divLotInfo');">
                <span class="divHeading">Completed Barcodes</span>
            </div>
            <div class="clear">
                <div class="ContentdivBorder" id="div1">
                    <div class="clear">
                        <table id="tblCompletedBarcodes">
                            <tr>
                                <th>
                                    Product Name
                                </th>
                                <th>
                                    Edit
                                </th>
                                <th>Delete</th>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
