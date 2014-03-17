<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>SiteLog</title>
</head>
<body>
    <div style="width:100%;">
     <table id="list" class="scroll" cellpadding="0" cellspacing="0">
                </table>
                <div id="pager" class="scroll" style="text-align: center;">
                </div>
                <script defer="defer" type="text/javascript">

                    var gridimgpath = '/Scripts/jqgrid/themes/redmond/images';
                    var gridDataUrl = '/Admin/JsonSiteLogsCollection';

                    jQuery("#list").jqGrid({
                        url: gridDataUrl,
                        datatype: "json",
                        mtype: 'POST',
                        colNames: ['ID', 'TimeStamp', 'Action', 'Controller', 'IP Address', 'URL', 'Host Address', 'User ID'],
                        colModel: [
              { name: 'ID', index: 'Id', align: 'left', hidden: true, editable: true, viewable: false, formoptions: { elmsuffix: '   ', rowpos: 1, colpos: 2 }, searchoptions: { sopt: ['eq', 'ne']} },
              { name: 'TimeStamp', index: 'TimeStamp', width: 100, align: 'left', editable: true, formoptions: { elmsuffix: '(*)', rowpos: 2, colpos: 2 }, searchoptions: { sopt: ['eq', 'ne']} },
              { name: 'Action', index: 'Action', width: 100, align: 'left', editable: true, edittype: 'text', editrules: { required: true, email: true }, formoptions: { elmsuffix: '(*)', rowpos: 3, colpos: 2 }, searchoptions: { sopt: ['eq', 'ne', 'cn']} },
              { name: 'Controller', index: 'Controller', width: 100, align: 'left', editable: true, formoptions: { elmsuffix: '    ', rowpos: 4, colpos: 2 }, searchoptions: { sopt: ['eq', 'ne', 'cn']} },
              { name: 'IPAddress', index: 'IPAddress', width: 100, align: 'left', editable: true, formoptions: { elmsuffix: '    ', rowpos: 5, colpos: 2 }, searchoptions: { sopt: ['eq', 'ne', 'cn']} },
              { name: 'URL', index: 'URL', hidden: true, align: 'left', editable: true, formoptions: { elmsuffix: '    ', rowpos: 6, colpos: 2 }, searchoptions: { sopt: ['eq', 'ne', 'cn']} },
              { name: 'HostAddress', index: 'HostAddress', hidden: true, align: 'left', editable: true, formoptions: { elmsuffix: '    ', rowpos: 7, colpos: 2 }, searchoptions: { sopt: ['eq', 'ne', 'cn']} },
              { name: 'UserID', index: 'UserID', width: 100, align: 'left', editable: true, formoptions: { elmsuffix: '    ', rowpos: 8, colpos: 2 }, searchoptions: { sopt: ['eq', 'ne', 'cn']}}],
                        rowNum: 10,
                        rowList: [10, 20, 30],
                        imgpath: gridimgpath,
                        height: 'auto',
                        autowidth: true,
                        pager: jQuery('#pager'),
                        sortname: 'Id',
                        viewrecords: true,
                        sortorder: "desc",
                        caption: "Site Logs Details",
                        forceFit: true,
                        hidegrid: true //To show/hide the button in the caption bar to hide/show the grid.
                    }).navGrid('#pager', { search: true, view: true, edit: true, add: true, del: true, searchtext: "" },
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
       //       var data = { oper: 'del', id: rowData.ID };
       //       $.post("/Home/DelJsonSiteLogs", ajaxData, function (ajaxData, textStatus, XMLHttpRequest) {
       //           $("#list").jqGrid().trigger("reloadGrid");
       //       });
       return ajaxData;
   }

}, // delete options
   {closeOnEscape: true, multipleSearch: true, closeAfterSearch: true }, // search options
   {closeOnEscape: true, width: 350} // view options
);
                    $.extend($.jgrid.search, { Find: 'Search' })






                    //        To enable Toolbar Serach uncomment this.
                    //        jQuery("#list").jqGrid('filterToolbar', { autosearch: true, searchOnEnter: false });



                    // add custom button to export the data to excel is added in jquery.jqgrid.min.js(3.6.3) version
                    //        jQuery("#list").jqGrid('navButtonAdd', '#pager', {
                    //            caption: "",
                    //            buttonicon: "ui-icon-save",
                    //            onClickButton: function () {
                    //                jQuery("#list").excelExport();
                    //            }
                    //        });



                    function setGridUrl() {
                        // Get the start and end dates entered
                        var newGridDataUrl = gridDataUrl + '?startDate=' + startDate.toJSONString() + '&endDate=' + endDate.toJSONString();

                        // Set the parameters in the grid data source
                        jQuery('#list').jqGrid('setGridParam', { url: newGridDataUrl }).trigger("reloadGrid");
                    }

                    //To set the properties to grid after window binding uncomment this.
                    //        $(window).bind('resize', function () {
                    //            $('#list').setGridWidth(800);
                    //            $('#list').setGridHeight('auto');
                    //        }).trigger('resize'); 



                    //        $(function () {
                    //            // Configure the date range picker
                    //            $('.daterangepicker').daterangepicker({
                    //                dateFormat: 'D M d, yy',
                    //                posX: 100,
                    //                posY: '16.8em',
                    //                onChange: function () {
                    //                    // Set the vars whenever the date range changes and then filter the results
                    //                    startDate = new Date($('#startDate').val());
                    //                    endDate = new Date($('#endDate').val());
                    //                    setGridUrl();
                    //                }
                    //            });

                    //            // Set the date range textbox values
                    //            $('#startDate').val(startDate.toDateString());
                    //            $('#endDate').val(endDate.toDateString());

                    //            // Set the grid json url to get the data to display
                    //            setGridUrl();
                    //        });
                </script>
    </div>
</body>
</html>
