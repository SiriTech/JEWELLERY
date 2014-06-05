<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>CreateUser</title>
    <!-- CSS goes in the document HEAD or added to your external stylesheet -->

    <script type="text/javascript">
        $(document).ready(function () {
            
            
        });

        
    </script>
</head>
<body>
    <div id="divBankDetails" style="clear: both; width: 100%; display: block;">
        <div class="clear">
            <div class="ContentdivHead" onclick="toggleContentDivHead(this,'#divLotInfo');">
                <span class="divHeading">Lot Details</span>
            </div>
            <div class="clear">
                <div class="ContentdivBorder" id="divLotInfo">
                    <div class="clear">
                       <h1>Bank Details</h1>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
