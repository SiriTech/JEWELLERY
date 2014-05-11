<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<THSMVC.Models.LotCloseModel>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>CreateUser</title>
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
            PlainRows('tblLotDetailsAssign');
            PlainRows('tblLotDetailsCompl');
            //PendingRows('tblPending');
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

        function PlainRows(id) {
            if (document.getElementsByTagName) {

                var table = document.getElementById(id);
                var rows = table.getElementsByTagName("tr");

                for (i = 0; i < rows.length; i++) {
                    rows[i].className = "oddrowcolor";
                }
            }
        }

        function PendingRows(id) {
            if (document.getElementsByTagName) {

                var table = document.getElementById(id);
                var rows = table.getElementsByTagName("tr");

                for (i = 0; i < rows.length; i++) {
                    rows[i].className = "oddrowcolor";
                }
            }
        }

        window.onload = function () {
            altRows('tblLotDetails');
        }

        function CloseLot() {
            var lotId = $("#HdnCloseLotId").val();
            //alert(lotId);
            $("#dialog-close-confirm").dialog({
                resizable: false,
                width: 400,
                modal: true,
                buttons: {
                    Submit: function () {

                        $.ajax({
                            type: "POST",
                            url: "Lot/CloseLotSubmit",
                            data: { lotId: lotId },
                            dataType: "json",
                            beforeSend: function () {
                                //$('#ddlStone option[value!=""]').remove();
                            },
                            success: function (Result) {
                                if (Result.success) {
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
        }

        
    </script>
</head>
<body>
    <div id="divCreateLot" style="clear: both; width: 100%; display: block;">
        <div class="clear">
            <div class="ContentdivHead" onclick="toggleContentDivHead(this,'#divCloseLot');">
                <span class="divHeading">Close Lot</span>
            </div>
            <div class="clear">
                <div class="ContentdivBorder" id="divCloseLot">
                    
                    <div class="clear">
                       <table class="altrowstable MyTable" id="tblLotDetails">
                        <tr>
                            <th>LotName</th>
                            <th>Product Group</th>
                        </tr>
                        <tr>
                            <td style="width:50%;text-align:center">
                                <%= this.Model.LotName %>
                                <%= Html.Hidden("hdnLotId", this.Model.LotId) %>
                            </td>
                            <td style="width:50%; text-align:center">
                                <%= this.Model.ProductGroupName %>
                            </td>
                        </tr>
                       </table>
                    </div>

                    <table width="100%">
                        <tr>
                            <td colspan="2" style="padding:10px;">
                            
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: center; font-weight: bold; font-size: 14px; color: maroon;">
                                Details at the Time of Lot Assigning 
                            </td>
                            <td style="text-align: center; font-weight: bold; font-size: 14px; color: maroon;">
                                Details at the Time of Lot Closing 
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" style="padding:2px;">
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <table width="50%" class="altrowstable MyTable" id="tblLotDetailsAssign">
                                    
                                     <tr>
                                        <td>
                                            Weight
                                        </td>
                                        
                                        <td>
                                            <%= this.Model.Weight.ToString() %> grms
                                        </td>
                                    </tr>

                                     <tr>
                                        <td>
                                            MRP
                                        </td>
                                        
                                        <td>
                                          Rs.   <%= this.Model.MRP.ToString() %>
                                        </td>
                                    </tr>

                                     <tr>
                                        <td>
                                            No Of Peices
                                        </td>
                                        
                                        <td>
                                            <%= this.Model.NoOfPcs.ToString() %>
                                        </td>
                                    </tr>

                                    

                                     <tr>
                                        <td>
                                            Difference Allowed
                                        </td>
                                       
                                        <td>
                                            <%= this.Model.DiffAllowed.ToString() %> grms
                                        </td>
                                    </tr>
                                </table>
                            </td>

                            <td>
                                <table width="50%" class="altrowstable MyTable" id="tblLotDetailsCompl">
                                    
                                    <tr>
                                        <td>
                                            Weight Completed
                                        </td>
                                        
                                        <td>
                                            <%= this.Model.WeightCompleted.ToString() %> grms
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>
                                            MRP Completed
                                        </td>
                                        
                                        <td>
                                           Rs.  <%= this.Model.MRPCompleted.ToString() %>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>
                                            No Of Peices completed
                                        </td>
                                       
                                        <td>
                                            <%= this.Model.NoOfPcsCompleted.ToString() %>
                                        </td>
                                    </tr>

                                    
                                    <tr>
                                        <td>
                                            Actual Difference
                                        </td>
                                        
                                        <td>
                                            <%= this.Model.DiffAllowedActual.ToString() %> grms
                                        </td>
                                    </tr>
                                   

                                </table>
                            </td>
                        </tr>
                    </table>
                    <div style="text-align:center">
                       <table class="" id="tblPending" width="100%" style="padding:20px">
                                        <tr>
                                            <td style="width: 50%; text-align: right; font-weight: bold; font-size: 14px; color: #FF0000;">
                                                No Of peices pending
                                            </td>
                                            <td>:</td>
                                            <td style="width: 50%; text-align: left;font-weight: bold; font-size: 14px; color: maroon;">
                                                <%= this.Model.NoOfPcsPending.ToString() %>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 50%; text-align: right; font-weight: bold; font-size: 14px; color: #FF0000">
                                                Weight pending
                                            </td>
                                            <td>:</td>
                                            <td style="width: 50%; text-align: left;font-weight: bold; font-size: 14px; color: maroon;">
                                                <%= this.Model.WeightPending.ToString() %> grms
                                            </td>
                                        </tr>
                                    </table>
                    </div>
                    
                    <div class="clear">
                    <% if(this.Model.LotStatisID == 4)
                        {%>
                        <div id="divButtons" class="clear" style="margin-top: 10px; margin-bottom: 20px;">
                            <center>
                                <input type="button" value="OK, Close Lot" class="rg_button_red" onclick="CloseLot(); return false;" />
                            </center>
                        </div>
                        <%} %>
                    </div>
                </div>
            </div>
        </div>
        
        <div id="dialog-close-confirm" title="Close Lot?" style="display:none">
        <p>
            <span class="ui-icon ui-icon-alert" style="float: left; margin: 0 7px 20px 0;"></span>
            Are you sure you want to Close the Lot anyway ?
         </p>
    </div>

    </div>
</body>
</html>
