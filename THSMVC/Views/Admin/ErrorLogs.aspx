<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>ErrorLogs</title>
</head>
<body>
    <div style="width:100%;">
     <table id="list" class="scroll" cellpadding="0" cellspacing="0">
                </table>
                <div id="pager" class="scroll" style="text-align: center;">
                </div>
                <script defer="defer" type="text/javascript">

                    var gridimgpath = '/Scripts/jqgrid/themes/redmond/images';
                    var gridDataUrl = '/Admin/JsonErrorLogsCollection';



                    jQuery("#list").jqGrid({
                        url: gridDataUrl,
                        datatype: "json",
                        mtype: 'POST',
                        colNames: ['TimeStamp', 'Level', 'Message', 'Exception', 'User ID'],
                        colModel: [
              { name: 'Date', index: 'Date', width: 100, align: 'left', editable: true, searchoptions: { sopt: ['eq', 'ne']} },
              { name: 'Level', index: 'Level', width: 100, align: 'left', editable: true, searchoptions: { sopt: ['eq', 'ne', 'cn']} },
              { name: 'Message', index: 'Message', width: 100, align: 'left', editable: true, searchoptions: { sopt: ['eq', 'ne', 'cn']} },
              { name: 'Exception', index: 'Exception', width: 230, align: 'left', editable: true, searchoptions: { sopt: ['eq', 'ne', 'cn']} },
              { name: 'UserID', index: 'UserID', width: 100, align: 'left', editable: true, searchoptions: { sopt: ['eq', 'ne', 'cn']}}],
                        rowNum: 5,
                        rowList: [5, 10],
                        imgpath: gridimgpath,
                        height: 'auto',
                        autowidth: true,
                        pager: jQuery('#pager'),
                        sortname: 'Date',
                        viewrecords: true,
                        sortorder: "desc",
                        caption: "Error Logs Details",
                        forceFit: true,
                        hidegrid: true //To show/hide the button in the caption bar to hide/show the grid.
                    }).navGrid('#pager', { search: true, view: true, edit: false, add: false, del: false, searchtext: "" },
   {}, // default settings for edit
   {}, // default settings for add
   {}, // delete options
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
