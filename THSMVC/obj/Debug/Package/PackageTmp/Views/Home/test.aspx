<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<IEnumerable<THSMVC.Models.print>>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>test</title>
    <style type="text/css">
        body
        {
            font-family: Calibri;
            font-size: 15px;
            color: #000000;
        }
        
        .bonafide
        {
            font-family: Times New Roman;
            font-size: 20px;
            font-weight: bold;
            color: #000000;
            text-align: center;
            text-decoration: underline;
        }
        .bonafidetxt
        {
            font-family: Calibri;
            font-size: 15px;
            font-style: normal;
            color: #000000;
            height: 26px;
            line-height: 26px;
        }
        .bonafidetxt2
        {
            font-family: Calibri;
            font-size: 15px;
            font-style: normal;
            color: #000000;
            height: 50px;
            line-height: 50px;
        }
        .dottedbonafidetxt
        {
            font-family: Calibri;
            font-size: 15px;
            font-style: normal;
            padding-left: 24px;
            padding-right: 24px;
            color: #000000;
            height: 26px;
            border-bottom: 1px Solid #000000;
        }
    </style>
</head>
<body>

   <%-- <% foreach (var p in Model)
       { %>
    <table width="800px" cellspacing="0" cellpadding="40" align="center" style="page-break-after:always;" >
        <tr>
            <td>
                <table width="100%" cellspacing="0" align="center">
                    <tr>
                        <td style="height: 200px;">
                        </td>
                    </tr>
                    <tr>
                        <td class="bonafide">
                            Certificate
                        </td>
                    </tr>
                    <tr>
                        <td style="height: 68px;">
                        </td>
                    </tr>
                    <tr>
                        <td class="bonafidetxt">
                            <table width="100%" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td>
                                        This is to certify that Mr. /Ms.
                                    </td>
                                    <td class="dottedbonafidetxt" width="220px">
                                        &nbsp; <b>
                                            <%= Html.Encode(p.Name) %></b>
                                    </td>
                                    <td>
                                        Hall Ticket No:
                                    </td>
                                    <td class="dottedbonafidetxt" width="80px">
                                        &nbsp;<%= Html.Encode(p.Hallticket) %>
                                    </td>
                                    <td>
                                        is a
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="bonafidetxt2">
                            student of Indur College of Engineering & Technology in fulfillment for the award
                            of <b>Bachelor of Technology</b> in <b>IT</b> affiliated to Jawaharlal Nehru Technological
                            University, Hyderabad has completed his project work at<br />
                            <b>ADS Softek Pvt Ltd.,</b>
                        </td>
                    </tr>
                    <tr>
                        <td style="height: 68px;">
                        </td>
                    </tr>
                    <tr>
                        <td class="bonafidetxt">
                            She/he has completed the project satisfactorily.
                        </td>
                    </tr>
                    <tr>
                        <td style="height: 68px;">
                        </td>
                    </tr>
                    <tr>
                        <td class="bonafidetxt">
                            <table width="100%" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td>
                                        <b>ADS Softek Pvt Ltd.,<br />
                                            (Project manager)</b>
                                    </td>
                                    <td align="right">
                                        <b>Date: 7th April 2012.</b>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
               
            </td>
        </tr>
    </table>
    <% } %>--%>
    
</body>
</html>
