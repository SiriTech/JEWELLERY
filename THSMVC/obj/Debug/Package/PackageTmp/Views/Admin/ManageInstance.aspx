<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>ManageInstance</title>
</head>
<body>
 <div style="float: left;">
        <a href="#" onclick="LoadContentByActionAndController('CreateInstance','Admin','Create Instance');" id="lnkUsers">Create Instance</a>
    </div>
  <div id="ManageInstance">
            <div class="clear">
                <div class="divHead">
                    <span class="divHeading">Search Instance</span> 
                </div>
                <div class="clear">
                    <div class="divBorder">
                        <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                              Instance Name
                            </div>
                            <div class="editor-field">
                                <input type="text" id="InstanceName" />
                            </div>
                        </div>
                        <div id="divButtons" class="clear" style="margin-top: 10px;">
                            <center>
                                <input type="button" value="Search" onclick="ManageInstanceSearch();return false;" />
                                <input type="button" value="Clear" onclick="ManageInstanceClear();return false;" />
                            </center>
                        </div>
                    </div>
                </div>
            </div>
        </div>
     <table id="list" class="scroll" cellpadding="0" cellspacing="0">
        </table>
        <div id="pager" class="scroll" style="text-align: center;">
        </div>
        <script defer="defer" type="text/javascript">
            
            var gridimgpath = '/Scripts/jqgrid/themes/redmond/images';
            var gridDataUrl = '/Admin/JsonInstaneCollection';

            jQuery("#list").jqGrid({
                url: gridDataUrl,
                datatype: "json",
                mtype: 'POST',
                colNames: ['ID', 'Instance Name', 'Country', 'State', 'City', 'License From', 'License To'],
                colModel: [
              { name: 'Id', index: 'Id', align: 'left', hidden: true, editable: true, viewable: false, formoptions: { elmsuffix: '   ', rowpos: 1, colpos: 2} },
              { name: 'InstanceName', index: 'InstanceName', width: 100, align: 'left', editable: true, formoptions: { elmsuffix: '(*)', rowpos: 2, colpos: 2} },
              { name: 'Country', index: 'Country', width: 100, align: 'left', editable: true, edittype: 'text', editrules: { required: true }, formoptions: { elmsuffix: '(*)', rowpos: 3, colpos: 2} },
              { name: 'State', index: 'State', width: 100, align: 'left', editable: true, formoptions: { elmsuffix: '    ', rowpos: 4, colpos: 2} },
              { name: 'City', index: 'City', width: 100, align: 'left', editable: true, formoptions: { elmsuffix: '    ', rowpos: 5, colpos: 2} },
               { name: 'From', index: 'From', width: 100, align: 'left', editable: true, formoptions: { elmsuffix: '    ', rowpos: 6, colpos: 2} },
                { name: 'To', index: 'To', width: 100, align: 'left', editable: true, formoptions: { elmsuffix: '    ', rowpos: 7, colpos: 2}}],
                rowNum: 10,
                rowList: [10, 20, 30],
                imgpath: gridimgpath,
                height: 'auto',
                autowidth: true,
                pager: jQuery('#pager'),
                sortname: 'Id',
                sortorder: "desc",
                caption: "Instance Details",
                forceFit: true,
                hidegrid: true //To show/hide the button in the caption bar to hide/show the grid.
            }).navGrid('#pager', { search: true, view: true, edit: false, add: false, del: false, searchtext: "" },
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
            $.extend($.jgrid.search, { Find: 'Search' })

        </script>
       <script type="text/javascript">
           // start tracking actovity  
           EnableTimeout(); 
    </script>
</body>
</html>
