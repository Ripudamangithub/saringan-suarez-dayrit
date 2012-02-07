﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Basic.Master" Inherits="System.Web.Mvc.ViewPage<Omnipresence.Mvc2.Models.EventCommentViewModel>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Index
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>
        <%: Model.Title %></h2><p>, by <%:Html.ActionLink(Model.CreatorUsername, "Profile","Profile", new {id = Model.CreatorUsername}, null)%></p>
    <div id="map<%: Model.EventId %>" data-lat="<%:Model.Latitude %>" data-lng="<%:Model.Longitude %>"
        style="background-position: center; width: 100%; height: 200px;">
    </div>
    <script type="text/javascript">
        function realInitialize() {
            setMap("map<%:Model.EventId %>");
        }
    </script>
    <div>
        <p>
            <%: Model.Description %></p>
    </div>
    <div>
        <p>
            From
            <%: String.Format("{0:D}", Model.StartTime) %>
            to
            <%:String.Format("{0:D}", Model.EndTime) %></p>
    </div>
    <div>
        <p>
            Rating:
            <%: Model.Rating %></p>
    </div>
    <% if (Model.CreatedByUser)
       { %><%: Html.ActionLink("Edit", "Edit", new { id = Model.EventId })%><%}
       else
       {
           %><%:Html.ActionLink("Vote up", "VoteUp", new { id = Model.EventId }) %><%:Html.ActionLink("Vote down", "VoteDown", new { id = Model.EventId }) %><%
                                                                                                                                                                 } %>
    <%: Html.ActionLink("Share", "Share", new { id = Model.EventId })%>
    <h2>
        Media</h2>
    <% foreach (String s in Model.MediaFileNameList)
       {%>
    <img src="<%= Url.Content("~/Uploads/Images/" + s) %>" alt="image" />
    <%} %>
    <%: Html.ActionLink("Upload media", "UploadMedia", new { id = Model.EventId }) %>
    <h2>
        Comments</h2>
    <% foreach (Omnipresence.Mvc2.Models.CommentViewModel cm in Model.CommentList)
       {
    %>
    <p>
        <%= cm.CommenterName %>
        said:
        <%= cm.CommentText %>
        (<%=cm.TimeString %>)
        <% if (cm.UserIsAuthor)
           { %>[<a href="/Comment/Delete/<%=cm.CommentId %>">x</a>]<%} %></p>
    <%} %>
    <% if (!User.Identity.Name.Equals(""))
       {
           using (Html.BeginForm())
           { %>
    <%: Html.ValidationSummary(true)%>
    <%: Html.TextAreaFor(model => model.NewComment)%>
    <input type="submit" value="Comment" />
    <%}
       } %>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
