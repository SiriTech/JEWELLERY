<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>UnAuthorized</title>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#cont").animate({ width: "100%" }, { duration: 10000 });
        }); 
    </script>
    
</head>
<body>
    <div id="cont" style="width:10px;font-size:18px;height:25px;color:Red;">
    You are not authorized to access this page. Please contact your Administrator.
    </div>
</body>
</html>
