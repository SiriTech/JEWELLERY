<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<IEnumerable<THSMVC.Models.ShowTestModel>>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>ShowTests</title>
    <style type="text/css">
        #clsTestNames
        {
            font-weight: bold;
            margin-bottom: 10px;
            color: #fff;
            font-size: 18px;
        }
        #clsTestNames a
        {
            color: Orange;
        }
        .dotted
        {
            color: white;
            clear: both;
            float: none;
            height: 1px;
            margin: 5px 0 10px 0;
            padding: 0;
            border-bottom: 1px dotted #D2D2D2;
        }
    </style>
    <script type="text/javascript">
        function manageTest(id) {
            $.modal.close();
            LoadContentByActionAndControllerForEdit("ManageTest", "OnlineTest", "Manage Test", id);
        }
    </script>
</head>
<body>
    <div class="popupHead">
        <span>This question used in the following tests</span>
    </div>
    <div class="clear">
        <p>
            <b>Question : </b><%=Model.ToList()[0].Question %></p>
        <div class="dotted">
        </div>
        <%foreach (var p in Model)
          { %>
        <div id="clsTestNames">
            <p>
                <a href="#" onclick='manageTest("<%=p.TestId %>");'>
                    <%= p.TestName %></a>
            </p>
        </div>
        <%} %>
    </div>
</body>
</html>
