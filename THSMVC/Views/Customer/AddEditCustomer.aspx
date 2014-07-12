<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<THSMVC.Models.CustomerModel>" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="../../Scripts/jquery-asyncUpload-0.1.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $(".upload").makeAsyncUploader({
                upload_url: "/Admin/AsyncUpload?InstanceID=" + $("#hdnInstanceID").val(),
                flash_url: '/Scripts/swfupload.swf',
                button_image_url: '/Images/UploadButton_2.jpg',
                disableDuringUpload: 'INPUT[type="button"]',
                file_size_limit: "1 MB",
                file_types: "*"
            });
        });

        function LoadPhotoPreview(name, size, id) {
            var docName = name.split("$$")[0];
            var docGuidName=name.split("$$")[1];
            var InstanceId = '<%=Model.InstanceId %>';
            $("#div" + id + "Preview").html("<a target='_blank' href='CustomerDocs/" + $("#hdnInstanceID").val() + "/" + docGuidName + "'>" + docName + "</a>&nbsp;<a href='javascript:void(0);' onclick='Removedoc(\""+id+"\");'>X</a>");
            $("#hdn"+id+"Name").val(name);
        }
        function Removedoc(id) {
            $("#div" + id + "Preview").html("<input type='file' id='" + id + "' class='upload' />");
            $("#hdn" + id + "Name").val('');
            $(".upload").makeAsyncUploader({
                upload_url: "/Admin/AsyncUpload?InstanceID=" + $("#hdnInstanceID").val(),
                flash_url: '/Scripts/swfupload.swf',
                button_image_url: '/Images/UploadButton_2.jpg',
                disableDuringUpload: 'INPUT[type="button"]',
                file_size_limit: "1 MB",
                file_types: "*"
            });
        }
        function Back() {
            ClearMsg();
            $("#divCustomerMaster").show();
            $("#CreateCustomer").show();
            $("#backToList").hide();
            $("#divCreateCustomer").hide();
            $("#list").trigger("reloadGrid");
        }

        function submitCustomer() {
            debugger;
            ClearMsg();
            var msg = '';
            if ($("#Name").val() == '') {
                msg = 'Please enter Customer Name<br/>';
            }
            if (msg != "") {
                Failure(msg);
                return;
            }
            $.ajax({
                type: "POST",
                url: "/Customer/SubmitCustomer",
                data: {
                    Id: $("#hdnID").val(),
                    Name: $("#Name").val(),
                    CustometNumber: $("#CustometNumber").val(),
                    Address: $("#Address").val(),
                    City: $("#City").val(),
                    State: $("#State").val(),
                    Pin: $("#Pin").val(),
                    Mobile: $('#Mobile').val(),
                    PhoneNumber: $("#PhoneNumber").val(),
                    EmailAddress: $("#EmailAddress").val(),
                    File1:$("#hdnfile1Name").val(),
                    File2:$("#hdnfile2Name").val(),
                    File3:$("#hdnfile3Name").val()
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
        <div id="AddEditProduct">
            <div class="clear">
                <div class="ContentdivHead" onclick="toggleContentDivHead(this,'#divAddEditProduct');">
                    <span class="divHeading">Customer</span>
                </div>
                <div class="clear">
                    
                    <div class="ContentdivBorder" id="divAddEditProduct">
                    <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                               <span class="ValidationSpan">*</span> Customer Name
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.Name, new { maxlength = 100, autocomplete = "off", title="Type in Customer Name" })%>
                            </div>
                        </div>
                         <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                                Address
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.Address, new { maxlength = 100, autocomplete = "off", title="Type in Customer Address" })%>
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
                                 Pin
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.Pin, new { maxlength = 6, autocomplete = "off", title="Type in Pin Number" })%>
                            </div>
                        </div>
                         <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                                Mobile Number
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.Mobile, new { maxlength = 12, autocomplete = "off", title="Type in Mobile Number" })%>
                            </div>
                        </div>
                        <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                                Phone Number
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.PhoneNumber, new { maxlength = 15, autocomplete = "off", title="Type in Phone Number" })%>
                            </div>
                        </div>
                        <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                                E-Mail Address
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.TextBoxFor(m => m.EmailAddress, new { maxlength = 50, autocomplete = "off", title="Type in E-Mail Address" })%>
                            </div>
                        </div>
                        <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                                File1
                                <input type="hidden" id="hdnfile1Name" />
                            </div>
                            <div class="editor-field" style="text-align: left;" id="divfile1Preview">
                            <% if(Model.Isfile1Exists){ %>
                            <a href="CustomerDocs/<%= Model.InstanceId %>/<%= Model.File1Guid %>" target="_blank"><%= Model.File1 %></a>&nbsp;<a href="javascript:void(0);" onclick="Removedoc('file1');">X</a>
                            <%}else{ %>
                                <input type="file" id="file1" name="file1" class="upload" />
                                <%} %>
                            </div>
                        </div>
                        <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                                File2
                                <input type="hidden" id="hdnfile2Name" />
                            </div>
                            <div class="editor-field" style="text-align: left;" id="divfile2Preview">
                            <% if(Model.Isfile2Exists){ %>
                            <a href="CustomerDocs/<%= Model.InstanceId %>/<%= Model.File2Guid %>" target="_blank"><%= Model.File2 %></a>&nbsp;<a href="javascript:void(0);" onclick="Removedoc('file2');">X</a>
                            <%}else{ %>
                                <input type="file" id="file2" name="file2" class="upload" />
                                <%} %>
                            </div>
                        </div>
                        <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                                File3
                                <input type="hidden" id="hdnfile3Name" />
                            </div>
                            <div class="editor-field" style="text-align: left;" id="divfile3Preview">
                            <% if(Model.Isfile3Exists){ %>
                            <a href="CustomerDocs/<%= Model.InstanceId %>/<%= Model.File3Guid %>" target="_blank"><%= Model.File3 %></a>&nbsp;<a href="javascript:void(0);" onclick="Removedoc('file3');">X</a>
                            <%}else{ %>
                                <input type="file" id="file3" name="file3" class="upload" />
                                <%} %>
                            </div>
                        </div>
                        <div id="divButtons" class="clear" style="margin-top: 10px; margin-bottom: 20px;">
                            <center>
                                <input type="button" value="<%= Model.BtnText %>" class="rg_button_red" onclick="submitCustomer(); return false;" />
                                <input type="button" value="Clear" class="rg_button" onclick="clearForm(); return false;" />
                                <%= Html.HiddenFor(m => m.Id, new { id = "hdnID"})%>
                            </center>
                            <input type="hidden" id="hdnInstanceID" value="<%= Model.InstanceId %>" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
