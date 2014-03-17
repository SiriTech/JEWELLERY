<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<THSMVC.Models.MainMenuModel>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Welcome
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="DataContent" runat="server">

    <h2>Empty</h2>
    <script type="text/javascript">
        var Name = '<%=Model.Menu %>';
        var Id = '<%=Model.MenuId %>';
        if (Id != "") {
            document.title = Name;
            document.getElementById(Name).className = 'menuChange';
            LoadFirstContent(Id, Name);
        }
    </script>
</asp:Content>
