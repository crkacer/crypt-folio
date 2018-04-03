<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Master.Master" AutoEventWireup="true" CodeBehind="portfolio.aspx.cs" Inherits="Cryptfolio.Views.WebForm9" %>
<asp:Content ID="Content1" ContentPlaceHolderID="Style" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Body" runat="server">
    <a id="test" href="#">TEST</a>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Script" runat="server">
    <script type="text/javascript">
        var coin_data = <%=JSON_COIN_data%>;
        console.log(coin_data[0]);

        $("#test").on("click", function () {
            console.log(1);
            var bodyAjax = {
                type: "add_coin",
                coin: "BTC",
                amount: 10,
                date: "2017-13-05"
            };

            $.ajax({
                type: "POST",
                url: "portfolio.aspx",
                data: bodyAjax,
                success: function (data) {
                    console.log(data);
                },
                error: function (data) {
                    console.log(data);
                }
            });
        });

    </script>
</asp:Content>