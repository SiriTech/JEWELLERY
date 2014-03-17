<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<THSMVC.Models.CategoryModel>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>ManageCategory</title>
    <link href="../../Content/GmailStyle.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .blo
        {
            display: inline-block;
            width: auto;
        }
        .non
        {
            display: none;
        }
    </style>
    <script src="../../Scripts/fixFloat.js" type="text/javascript"></script>
    <script src="../../Scripts/jQuery.tmpl.min.js" type="text/javascript"></script>
    <script type="text/javascript">

        function page(val, pSize, CatName) {
            var $delay = 0;
            var $footer = $('#footer');
            var $prevLink = $('#prevlnk');
            var $nextLink = $('#nextlnk');
            $.ajaxSetup({ cache: false, async: false });
            $.getJSON("/OnlineTest/CategoryList?page=" + val + "&pageSize=" + pSize + "&CatName=" + CatName, function (data) {
                var from = (data.pager.PageNumber * data.pager.PageSize) - data.pager.PageSize;
                var to = from + data.pager.PageSize;
                var total = data.pager.TotalItemCount;
                if (total == 0) {
                    from = 0;
                    to = 0;
                    $("#from").text(from);
                    $("#to").text(to);
                }
                else {
                    $("#from").text(from = 0 ? 1 : from + 1);
                    if (total < data.pager.PageSize)
                        $("#to").text(total);
                    else
                        $("#to").text(to);
                }
                $("#total").text(data.pager.TotalItemCount);
                var markup = "<tr id='tr${Id}'><td class='chk'><input type='checkbox' id='${Id}' class='chkbox' onclick='chkSel();' /></td><td class='gm'><a href='#' title='Click to edit' onclick='editCategory(${Id});'>${CategoryName}</a></td></tr>";
                var Update = '<%=Model.Update %>';
                if (Update != "True") {
                   markup = "<tr id='tr${Id}'><td class='chk'><input type='checkbox' id='${Id}' class='chkbox' onclick='chkSel();' /></td><td class='gm'>${CategoryName}</td></tr>";
                }
                
                // Compile the markup as a named template
                $.template("movieTemplate", markup);
                $("#namesList").empty();
                $.tmpl("movieTemplate", data.names).appendTo("#namesList");

                // update "More" link to point to the next page
                var nextPage = data.pager.PageNumber + 1;
                var prevPage = data.pager.PageNumber - 1;
                if (data.pager.IsFirstPage) {

                    $prevLink.click(function (e) { e.preventDefault(); });
                    $prevLink.removeClass("previous");
                    $prevLink.addClass("previousdisabled");
                }
                else {
                    $prevLink.removeClass("previousdisabled");
                    $prevLink.addClass("previous");
                    $prevLink.unbind('click');
                    $prevLink.click(function () { page(prevPage, pSize, CatName); });

                }
                if (data.pager.IsLastPage) {
                    $nextLink.click(function (e) { e.preventDefault(); });
                    $nextLink.removeClass("next");
                    $nextLink.addClass("nextdisabled");
                }
                else {
                    $nextLink.removeClass("nextdisabled");
                    $nextLink.addClass("next");
                    $nextLink.unbind('click');
                    $nextLink.click(function () { page(nextPage, pSize, CatName); });
                }
                ClearMsg();
            }).error(function () {
                Error("Sorry, Please try again later.");
            });
            var offtop = $("div#toolbar_holder").offset().top;
            $('div#toolbar_holder').css("top", offtop);
            $('div#toolbar_holder').fixFloat();

        };
       
        function SearchCategory() {
            ClearMsg();
            var valu = $("#OnlineTestCategorySearch input[id=Category]").val();
            page(1, 20, valu);
        }
        function Clear() {
            ClearMsg();
            $("#OnlineTestCategorySearch input[id=Category]").val("");
        }
        function GetItems(pNo, pSize) {
            if ($(".Googlemenu ul li ul li a").attr("class") == "non")
                $(".Googlemenu ul li ul li a").attr("class", "blo");
            else
                $(".Googlemenu ul li ul li a").attr("class", "non");

            if ($(".Googlemenu ul li ul li").attr("class") == "non")
                $(".Googlemenu ul li ul li").attr("class", "blo");
            else
                $(".Googlemenu ul li ul li").attr("class", "non");
            page(pNo, pSize, '');
        }
        function cli() {
            if ($(".Googlemenu ul li ul li a").attr("class") == "non")
                $(".Googlemenu ul li ul li a").attr("class", "blo");
            else
                $(".Googlemenu ul li ul li a").attr("class", "non");

            if ($(".Googlemenu ul li ul li").attr("class") == "non")
                $(".Googlemenu ul li ul li").attr("class", "blo");
            else
                $(".Googlemenu ul li ul li").attr("class", "non");
        }
    </script>
</head>
<body>
    <div id="OnlineTestCategorySearch">
        <div class="clear">
            <div class="clear">
                <div class="ContentdivBorder" id="divSearchCategory">
                    <div class="clear">
                        <div class="editor-label FloatLeft" style="width: 40%; font-size: 16px;">
                            Search by Category Name
                        </div>
                        <div class="editor-field">
                            <input type="text" id="Category" maxlength="100" style="height: 25px;" />
                            <input type="button" class="g-button g-button-submit" id="Button2" value="Search"
                                style="margin-right: 5px;" onclick="SearchCategory();return false;" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="clear">
            <div class="Googlemenu" id="toolbar_holder">
                <ul>
                    <% if (Model.Create)
                       { %>
                    <li>
                        <input type="button" class="g-button g-button-red" id="Create" value="Create New"
                            style="margin-right: 5px;" /></li><%} %>
                    <li><a onclick="cli();" class="dropdown" href="#">Show<span class="arrow"></span></a>
                        <ul class="width-2">
                            <li><a href="#" onclick="GetItems(1,20);">20 Per Page</a></li>
                            <li onclick="GetItems(1,40);"><a href="#">40 Per Page</a></li>
                            <li><a href="#" onclick="GetItems(1,80);">80 Per Page</a></li>
                            <li><a href="#" onclick="GetItems(1,0);">All</a></li>
                        </ul>
                    </li>
                      <% if (Model.Delete)
                       { %>
                    <li><a class="deldisabled" id="dellnk" href="#">&nbsp;</a></li><%} %>
                    <li><a class="previous" id="prevlnk" href="#">&nbsp;</a></li>
                    <li><a class="num"><b><span id="from">1</span></b>–<b><span id="to">50</span></b> of
                        <b><span id="total">52</span></b></a></li>
                    <li><a class="next" id="nextlnk" href="#">&nbsp;</a></li>
                </ul>
            </div>
        </div>
        <div style="margin-top:35px;" class="clear">
        <input type="hidden" id="hdnNoofItems" />
            <table width="100%" class="gm">
            <thead><tr><th class="chk"><input type="checkbox" id="categorythChk" /></th><th class="gm">Category</th></tr><//thead>
            <tbody id="namesList"></tbody>
            </table>
        </div>
    </div>
    <script type="text/javascript">
        $(document).ready(function () {
            offtop();
            $("#Content").outerWidth()
            $("#toolbar_holder").css("width", $("#Content").outerWidth());
            $("#Create").click(function () { NewCategory(); });
            $("#categorythChk").click(function () {
                var chkd = this.checked;
                var checkBoxes = $(".chkbox");
                $.each(checkBoxes, function () {
                    $(this).attr('checked', chkd);
                });
                var $delLnk = $("#dellnk");
                if (chkd) {
                    $delLnk.removeClass("deldisabled");
                    $delLnk.addClass("del");
                }
                else {
                    $delLnk.removeClass("del");
                    $delLnk.addClass("deldisabled");
                }
            });
            $('#dellnk').click(function () {
                ClearMsg();
                var $delLnk = $("#dellnk");
                if ($delLnk.attr('class') == "deldisabled")
                    return false;
                if ($(".chkbox:checked").length > 0) {
                    var val = [];
                    $('.chkbox:checked').each(function (i) {
                        val.push(this.id);
                    });
                    $.ajax({
                        type: "POST",
                        traditional: true,
                        url: "/OnlineTest/DeleteCategories",
                        data: {
                            categoryIds: val
                        },
                        dataType: "json",
                        beforeSend: function () {
                            $.blockUI();   //this is great plugin - 'blockUI'
                        },
                        success: function (result) {
                            if (result.success) {
                                for (var i in val) {
                                    $("#tr" + val[i]).hide();
                                }
                                $("#testthChk").attr('checked', false);
                                $delLnk.removeClass("del");
                                $delLnk.addClass("deldisabled");
                                Success(result.message);
                            }
                            else {

                                Failure(result.message);
                            }
                            $.unblockUI();
                        },
                        error: function (XMLHttpRequest, textStatus, errorThrown) {
                            $.unblockUI();
                            Error(XMLHttpRequest, textStatus, errorThrown);
                        }
                    });
                }
                else
                    return false;
            });
            setTimeout("page(1,20,'')", 0);

        });
        function NewCategory() {
            LoadContentByActionAndController("Category", "OnlineTest", "Create Category");
        }
        function chkSel() {
            var $delLnk = $("#dellnk");
            if ($(".chkbox:checked").length > 0) {
                $delLnk.removeClass("deldisabled");
                $delLnk.addClass("del");
            }
            else {
                $delLnk.removeClass("del");
                $delLnk.addClass("deldisabled");
            }
            if ($(".chkbox").length == $(".chkbox:checked").length) {
                $("#categorythChk").attr("checked", "checked");
            } else {
                $("#categorythChk").removeAttr("checked");
            }
        }
        function offtop() {
            var offtop = $("div#toolbar_holder").offset().top;
            $('div#toolbar_holder').css("top", offtop);
            $('div#toolbar_holder').fixFloat();
        }
        function editCategory(id) {
            LoadContentByActionAndControllerForEdit("EditCategory", "OnlineTest", "Update Category", id);
        }
    </script>
</body>
</html>
