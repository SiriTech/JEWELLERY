<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>TimeoutExpired</title>
</head>
<body>
    <div>
     <a id="Expired" href="/Shared/SessionExpire">Log Off</a>
    </div>
    <script type="text/javascript">
        //window.location.href = "../Home/Index";
        setTimeout("document.getElementById('Expired').click();", 100);  
        //$("#LogOff").click();
    </script>
</body>
</html>
