<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<IEnumerable<THSMVC.Models.Menu>>" %>
<ul id="dynamicmenu">
<% foreach(var p in Model)
   { %> 
    
   <li><a id="<%= Html.Encode(p.Name) %>" href="#" onclick="PopulateMenuWithContent(this,'<%= Html.Encode(p.Action) %>','<%= Html.Encode(p.Controller) %>','<%= Html.Encode(p.Id) %>');" >
      <%= Html.Encode(p.Name) %>  
       </a></li>
      
<% } %>
 </ul>
