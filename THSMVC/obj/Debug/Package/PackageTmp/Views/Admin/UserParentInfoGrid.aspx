<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<THSMVC.Models.UserParentInfoGridModel>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>UserParentInfoGrid</title>
    <script type="text/javascript">
        function MakeActiveParent(parentId) {
            ClearMsg();
            $.ajax({
                type: "POST",
                url: "/Admin/ActivateParent",
                data: "ParentId=" + parentId,
                dataType: "json",
                beforeSend: function () {
                    $.blockUI({ message: 'Activating...' });   //this is great plugin - 'blockUI'
                },
                success: function (result) {
                    if (result.success) {
                        $("#Parentlist").jqGrid().trigger("reloadGrid");
                        Success(result.message);
                    }
                    else
                        Failure(result.message);

                    $.unblockUI();
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    $.unblockUI();
                    Error(XMLHttpRequest, textStatus, errorThrown);
                }
            });
        }
        function ParentInfo() {
            GetContentByActionAndController('CreateParent', 'Admin', 'Create User', '.TabContent');
        }
        function primaryContactPopUp() {
            $("#basic-modal-content").modal();
        }
        function UpdateParent(userId) {
            ClearMsg();
            $("#ManageUsers").slideUp();
            $("#divbackToSearch").show();
            $("#CreateUser")[0].className = "rg_button upper";
            $("#UserTabs").show();
            $(".TabContent").show();
            $("#toc li").attr("class", "");
            $("#toc li[id=liParent]").attr("class", "current");
            //GetContentByActionAndController('CreateUser', 'Admin', 'Create User', '#UserTabs');
            GetContentByActionAndControllerForEdit("UpdateParent", "Admin", "Update Parent", userId, '.TabContent');
        }
    </script>
</head>
<body>
<div id="basic-modal-content">
        <div class="popupHead">
            <span>About Primary Contact</span>
        </div>
        <div class="clear">
            <div>
                <div class="clear">
                    <div style="font-size:16px;border:1px solid gray;padding:5px;">
                       Primary Contact will be used in every report, where we are displaying the parent name.<br />
                       e.g. : <b>Progress reports </b> - For parent name, The primary contact name will be used.
                    </div>
                </div>
            </div>
        </div>
    </div>
 <div  class="clear">
    <%--<% if (Model.EnableActiveButton)
       { %>
    <div style="float: left;">
        <input type="button" id="MakeActiveParent" class="rg_button_red" title="Click to activate one parent"
            value="Activate Parent" />
    </div>
    <%} %>--%>
    <div id="divAddParent" style="float: right;">
        <input type="button" class="rg_button_red upper" title="Click to add parent" value="Add Parent Info." onclick="ParentInfo()" />
    </div>
    </div>
    <div class="clear">
    <div id="parentgridWrapper" style="width: 100%;">
        <table id="Parentlist" class="scroll" cellpadding="0" cellspacing="0">
        </table>
        <div id="Parentpager" class="scroll" style="text-align: center;">
        </div>
    </div>
    <div id="parentEmptyGridWrapper">
    </div>
    </div>
    <script type="text/javascript">
        var gridimgpath = '/Scripts/jqgrid/themes/redmond/images';
        var ParentgridDataUrl= '/Admin/JsonParentsCollection';
        jQuery("#Parentlist").jqGrid({
            url: ParentgridDataUrl,
            datatype: "json",
            mtype: 'POST',
            colNames: ['UserId', 'First Name', 'Relation','Primary Contact'],
            colModel: [
              { name: 'UserId', index: 'UserId', align: 'left', hidden: true, editable: true, viewable: false, formoptions: { elmsuffix: '   ', rowpos: 1, colpos: 2} },
              { name: 'FirstName', index: 'Name', width: 100, align: 'left', editable: true, formoptions: { elmsuffix: '(*)', rowpos: 2, colpos: 2} },
              { name: 'LastName', index: 'LastName', width: 100, align: 'left', editable: true, edittype: 'text', formoptions: { elmsuffix: '(*)', rowpos: 3, colpos: 2} },
              { name: 'DisplayName', index: 'DisplayName', width: 100, align: 'left', editable: true, edittype: 'text', formoptions: { elmsuffix: '(*)', rowpos: 4, colpos: 2}}],
            rowNum: 10,
            rowList: [10, 20, 30],
            imgpath: gridimgpath,
            height: 'auto',
            autowidth: true,
            pager: jQuery('#Parentpager'),
            sortname: 'FirstName',
            viewrecords: true,
            sortorder: "asc",
            caption: "Parent Details",
            gridComplete: function () {
                var recs = parseInt($("#Parentlist").getGridParam("records"), 10);
                if (recs == 0) {
                    $("#parentgridWrapper").hide();
                    EmptyGrid("#parentEmptyGridWrapper");
                } else {
                    $('#parentgridWrapper').show();
                    $("#parentEmptyGridWrapper").hide();
                }
            },
            forceFit: true,
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



        

    </script>
    <script type="text/javascript">
        // start tracking actovity  
        EnableTimeout(); 
    </script>
</body>
</html>
