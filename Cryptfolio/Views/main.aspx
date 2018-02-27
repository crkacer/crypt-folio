<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Master.Master" AutoEventWireup="true" CodeBehind="main.aspx.cs" Inherits="Cryptfolio.Views.WebForm4" %>
<asp:Content ID="Content1" ContentPlaceHolderID="Style" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Body" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Script" runat="server">
    <script type="text/javascript">
        var all_coins = <%=ALL_COINS%>;
        console.log(all_coins);
    </script>
</asp:Content>
