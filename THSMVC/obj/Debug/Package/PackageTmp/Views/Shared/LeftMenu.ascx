<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<IEnumerable<THSMVC.App_Code.LeftMenu>>" %>
 <center style="margin-right: 1em; background-color: gray; color: white;cursor:pointer; margin-bottom: 5px;"  onclick="HideLeftMenu()">Hide Menu</center>
<div id="LeftMenu" style="width: 100%;">
    <div class="leftMenudiv">
        <div style="margin-right: 1em;">
            <%
                string GrpName = string.Empty;
                foreach (var p in Model)
                {
                    if (GrpName != p.GroupName)
                    {
                        if (GrpName != "")
                        { %>
                         </div>
                </div>
            </div>
                        <% }
                        GrpName = p.GroupName;  %>
            <div class="clear">
                <div class="divHead">
                    <span class="divHeading">
                        <%= Html.Encode(p.GroupName) %></span> <span class="MenuCloseSpan" onclick="MenuHide(this,'<%= Html.Encode(p.GroupName) %>')">
                        </span>
                </div>
                <div class="clear">
                    <div id="<%= Html.Encode(p.GroupName) %>" style="display: block;" class="divBorder">
                        <div>
                            <a id="A1" href="#" onclick="LoadFirstContent('<%= Html.Encode(p.MenuId) %>','<%= Html.Encode(p.MenuName) %>');">
                                <%= Html.Encode(p.MenuName) %></a>
                        </div>
                        <% 
                    }
                    else
                    { %>
                        <div>
                            <a id="A2" href="#" onclick="LoadFirstContent('<%= Html.Encode(p.MenuId) %>','<%= Html.Encode(p.MenuName) %>');">
                                <%= Html.Encode(p.MenuName) %></a>
                        </div>
                        <% 
        } %>
                   
            <% 
                } %>
                </div>
                </div>
            </div>
        </div>
    </div>
</div>
