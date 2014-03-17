<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<THSMVC.Models.CreateUserModel>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>CreateUser</title>
    <script type="text/javascript">
        $(document).ready(function () {
            var Update = '<%=Model.selection %>';
            if (Update == "Parent") {
                $("#toc li").attr("class", "");
                $("#toc li[id=liParent]").attr("class", "current");
            }
            $("#toc li").click(function (e) {
                if ($(this).attr("id") == "liGeneral") {
                    $("#toc li").attr("class", "");
                    $(this).attr("class", "current");
                    GetContentByActionAndController('UserGeneralInfo', 'Admin', 'Create User', '.TabContent');
                }
                if ($(this).attr("id") == "liPersonal") {
                    $("#toc li").attr("class", "");
                    $.ajax({
                        type: "POST",
                        url: "/Admin/ChkSession",
                        data: {},
                        async: false,
                        dataType: "json",
                        beforeSend: function () {
                            $.blockUI();   //this is great plugin - 'blockUI'
                        },
                        success: function (result) {
                            if (result.success) {
                                $("#toc li[id=liPersonal]").attr("class", "current");
                                GetContentByActionAndController('UserPersonalInfo', 'Admin', 'Create User', '.TabContent');
                            }
                            else {
                                $("#toc li[id=liGeneral]").attr("class", "current");
                                ClearMsg();
                                Information("Please fill User General Info.");
                            }
                            $.unblockUI();
                        },
                        error: function (XMLHttpRequest, textStatus, errorThrown) {
                            $.unblockUI();
                            Error(XMLHttpRequest, textStatus, errorThrown);
                        }
                    });

                }
                if ($(this).attr("id") == "liParent") {
                    $("#toc li").attr("class", "");
                    $.ajax({
                        type: "POST",
                        traditional: true,
                        url: "/Admin/ChkSession",
                        data: {},
                        dataType: "json",
                        beforeSend: function () {
                            $.blockUI();   //this is great plugin - 'blockUI'
                        },
                        success: function (result) {

                            if (result.success) {
                                $("#toc li[id=liParent]").attr("class", "current");
                                GetContentByActionAndController('UserParentInfo', 'Admin', 'Create User', '.TabContent');
                            }
                            else {
                                ClearMsg();
                                $("#toc li[id=liGeneral]").attr("class", "current");
                                Information("Please fill User General Info.");
                            }
                            $.unblockUI();
                        },
                        error: function (XMLHttpRequest, textStatus, errorThrown) {
                            $.unblockUI();
                            Error(XMLHttpRequest, textStatus, errorThrown);
                        }
                    });
                }
            });
        });
    </script>
</head>
<body>

    <div style="clear: both; width: 100%; display: block;">
        <ol id="toc">
            <li id="liGeneral" class="current"><a href="#"><span>General Info.</span></a></li>
            <li id="liPersonal"><a href="#"><span>Personal Info.</span></a></li>
            <li id="liParent"><a href="#"><span>Parent Info.</span></a></li>
        </ol>
    </div>
</body>
</html>
