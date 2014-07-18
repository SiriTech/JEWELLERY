<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<THSMVC.Models.DealerModel>" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
	<title></title>
	<link href="../../Scripts/ExcelPlugin/jquery.handsontable.full.css" rel="stylesheet"
		type="text/css" />
	<script src="../../Scripts/ExcelPlugin/jquery.handsontable.full.js" type="text/javascript"></script>
	<script type="text/javascript">
	    $(document).ready(function () {
	        $.ajax({
	            type: "POST",
	            url: "Dealer/DealerBankDetails",
	            data: { Id: $("#hdnID").val() },
	            dataType: "json",
	            async: false,
	            beforeSend: function () {
	                $.blockUI();   //this is great plugin - 'blockUI'
	            },
	            success: function (result) {
	                if (result.success) {
	                    data = result.data;
	                    ColHeaders = result.colheaders;
	                    hdata = result.hdata;
	                    hColHeaders = result.hcolheaders;
	                    var MaxCols = '6';
	                    debugger;
	                    $('#divDealerBankDetails').handsontable({
	                        data: data,
	                        minRows: 0,
	                        minCols: parseInt(MaxCols, 0),
	                        minSpareRows: 0,
	                        colHeaders: ColHeaders,
	                        autoWrapRow: true,
	                        contextMenu: false,
	                        fixedColumnsLeft: 1,
	                        width: $("#Content").innerWidth(),
	                        cells: function (row, col, prop) {
	                            var cellProperties = {};
	                            if (col === 0) {
	                                if ($("#hdnID").val() != 0) {
	                                    cellProperties.readOnly = true;
	                                    cellProperties.renderer = ReadOnlyRenderer;
	                                }
	                            }

	                            return cellProperties;
	                        }
	                    });
	                    var hot = $('#divDealerBankDetails').handsontable('getInstance');
	                    hot.updateSettings({
	                        colHeaders: hColHeaders,
	                        columns: hdata
	                    });
	                }
	                else {
	                    alert('error');
	                }
	                $.unblockUI();
	            },
	            error: function (XMLHttpRequest, textStatus, errorThrown) {
	                debugger;
	                Error(XMLHttpRequest, textStatus, errorThrown);
	            }
	        });
	    });
		function ReadOnlyRenderer(instance, td, row, col, prop, value, cellProperties) {
			Handsontable.TextCell.renderer.apply(this, arguments);
			$(td).css({
				background: '#BCDFF5', color: '#000'
			});
		};
		$(document).ready(function () {
			//	$("#DealerName").focus();
			$('#divDealerBankDetails').focus();

		});
		function Back() {
			ClearMsg();
			$("#divDealerMaster").show();
			$("#CreateDealer").show();
			$("#backToList").hide();
			$("#divCreateDealer").hide();
			$("#list").trigger("reloadGrid");
		}
		function submitDealer() {
			ClearMsg();
			var msg = '';
			if ($("#DealerName").val() == '') {
				msg = 'Please enter Dealer Name<br/>';
			}
			if ($("#CompanyName").val() == '') {
				msg += 'Please enter Company Name<br/>';
			}
			if (msg != "") {
				Failure(msg);
				return;
			}
			$.ajax({
				type: "POST",
				url: "/Dealer/SubmitDealer",
				data: {
					Id: $("#hdnID").val(),
					DealerName: $("#DealerName").val(),
					CompanyName: $("#CompanyName").val(),
					CompanyShortForm: $("#CompanyShortForm").val(),
					Address: $("#Address").val(),
					City: $("#City").val(),
					State: $("#State").val(),
					PinCode: $("#PinCode").val(),
					TinNo: $("#TinNo").val(),
					MobileNUmber1: $("#MobileNUmber1").val(),
					MobileNUmber2: $("#MobileNUmber2").val(),
					MobileNUmber3: $("#MobileNUmber3").val(),
					MobileNUmber4: $("#MobileNUmber4").val(),
					Email1: $("#Email1").val(),
					Email2: $("#Email2").val(),
					BankData: JSON.stringify($("#divDealerBankDetails").handsontable('getData'))
				},
				dataType: "json",
				beforeSend: function () {
					$.blockUI();
				},
				success: function (response) {
					if (response.success) {
						Success(response.message);
						setTimeout("Back();", 1000);
					}
					else
						Failure(response.message);
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
	<div class="clear">
		<div id="AddEditDealer">
			<div class="clear">
				<div class="ContentdivHead" onclick="toggleContentDivHead(this,'#divAddEditDealer');">
					<span class="divHeading">Dealer</span>
				</div>
				<div class="clear">
					<div class="ContentdivBorder" id="divAddEditDealer">
						<div class="clear">
							<div class="editor-label FloatLeft" style="width: 40%;">
								<span class="ValidationSpan">*</span> Dealer Name
							</div>
							<div class="editor-field" style="text-align: left;">
								<%= Html.TextBoxFor(m => m.DealerName, new { maxlength = 100, autocomplete = "off", title="Type in Dealer Name" })%>
							</div>
						</div>
						<div class="clear">
							<div class="editor-label FloatLeft" style="width: 40%;">
								<span class="ValidationSpan">*</span> Company Name
							</div>
							<div class="editor-field" style="text-align: left;">
								<%= Html.TextBoxFor(m => m.CompanyName, new { maxlength = 100, autocomplete = "off", title="Type in Company Name" })%>
							</div>
						</div>
						<div class="clear">
							<div class="editor-label FloatLeft" style="width: 40%;">
								Company Short Name
							</div>
							<div class="editor-field" style="text-align: left;">
								<%= Html.TextBoxFor(m => m.CompanyShortForm, new { maxlength = 100, autocomplete = "off", title="Type in Company Short Name" })%>
							</div>
						</div>
						<div class="clear">
							<div class="editor-label FloatLeft" style="width: 40%;">
								Address
							</div>
							<div class="editor-field" style="text-align: left;">
								<%= Html.TextBoxFor(m => m.Address, new { maxlength = 100, autocomplete = "off", title="Type in Address" })%>
							</div>
						</div>
						<div class="clear">
							<div class="editor-label FloatLeft" style="width: 40%;">
								City
							</div>
							<div class="editor-field" style="text-align: left;">
								<%= Html.TextBoxFor(m => m.City, new { maxlength = 100, autocomplete = "off", title="Type in City" })%>
							</div>
						</div>
						<div class="clear">
							<div class="editor-label FloatLeft" style="width: 40%;">
								State
							</div>
							<div class="editor-field" style="text-align: left;">
								<%= Html.TextBoxFor(m => m.State, new { maxlength = 100, autocomplete = "off", title="Type in State" })%>
							</div>
						</div>
						<div class="clear">
							<div class="editor-label FloatLeft" style="width: 40%;">
								PIN Code
							</div>
							<div class="editor-field" style="text-align: left;">
								<%= Html.TextBoxFor(m => m.PinCode, new { maxlength = 100, autocomplete = "off", title="Type in Pin Code" })%>
							</div>
						</div>
						<div class="clear">
							<div class="editor-label FloatLeft" style="width: 40%;">
								VAT or TIN number
							</div>
							<div class="editor-field" style="text-align: left;">
								<%= Html.TextBoxFor(m => m.TinNo, new { maxlength = 100, autocomplete = "off", title="Type in Company VAT or TIN no." })%>
							</div>
						</div>
						<div class="clear">
							<div class="editor-label FloatLeft" style="width: 40%;">
								Mobile Number1
							</div>
							<div class="editor-field" style="text-align: left;">
								<%= Html.TextBoxFor(m => m.MobileNUmber1, new { maxlength = 11, autocomplete = "off", title="Type in mobile no." })%>
							</div>
						</div>
						<div class="clear">
							<div class="editor-label FloatLeft" style="width: 40%;">
								Mobile Number2
							</div>
							<div class="editor-field" style="text-align: left;">
								<%= Html.TextBoxFor(m => m.MobileNUmber2, new { maxlength = 11, autocomplete = "off", title="Type in mobile no." })%>
							</div>
						</div>
						<div class="clear">
							<div class="editor-label FloatLeft" style="width: 40%;">
								Mobile Number3
							</div>
							<div class="editor-field" style="text-align: left;">
								<%= Html.TextBoxFor(m => m.MobileNUmber3, new { maxlength = 11, autocomplete = "off", title="Type in mobile no." })%>
							</div>
						</div>
						<div class="clear">
							<div class="editor-label FloatLeft" style="width: 40%;">
								Mobile Number4
							</div>
							<div class="editor-field" style="text-align: left;">
								<%= Html.TextBoxFor(m => m.MobileNUmber4, new { maxlength = 11, autocomplete = "off", title="Type in mobile no." })%>
							</div>
						</div>
						<div class="clear">
							<div class="editor-label FloatLeft" style="width: 40%;">
								Email Address1
							</div>
							<div class="editor-field" style="text-align: left;">
								<%= Html.TextBoxFor(m => m.Email1, new { maxlength = 100, autocomplete = "off", title="Type in Email Address." })%>
							</div>
						</div>
						<div class="clear">
							<div class="editor-label FloatLeft" style="width: 40%;">
								Email Address2
							</div>
							<div class="editor-field" style="text-align: left;">
								<%= Html.TextBoxFor(m => m.Email2, new { maxlength = 100, autocomplete = "off", title="Type in Email Address." })%>
							</div>
						</div>
						<div>
							<div id="divDealerBankDetails">
							</div>
						</div>
						<div id="divButtons" class="clear" style="margin-top: 10px; margin-bottom: 20px;">
							<center>
                                <input type="button" value="<%= Model.BtnText %>" class="rg_button_red" onclick="submitDealer(); return false;" />
                                <input type="button" value="Clear" class="rg_button" onclick="clearForm(); return false;" />
                                <%= Html.HiddenFor(m => m.Id, new { id = "hdnID"})%>
                            </center>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
