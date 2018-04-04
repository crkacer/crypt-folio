<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Master.Master" AutoEventWireup="true" CodeBehind="portfolio.aspx.cs" Inherits="Cryptfolio.Views.WebForm9" %>
<asp:Content ID="Content1" ContentPlaceHolderID="Style" runat="server">
    <link type="text/css" rel="stylesheet" href="../Public/Resources/CSS/portfolio-style.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Body" runat="server">
    <div class="wallet-content" id="app">
           <div class="wallet-inside-content">
               <div class="wallet-title">
                   <h2 style="margin:0; padding:10px;"><i class="material-icons" style="font-size:32px;top:2px;">account_balance_wallet</i>&nbsp;&nbsp;My Portfolio</h2>
               </div>
               <div class="wallet-option">
                   <button class="mdl-button mdl-js-button mdl-button--icon mdl-js-ripple-effect" >
                       <i class="material-icons">info_outline</i>
                   </button>
                   <button class="mdl-button mdl-js-button mdl-button--raised mdl-js-ripple-effect mdl-button--colored" style="margin:10px;">
                      <i class="material-icons">add</i>&nbsp;Coin
                   </button>
               </div>
               <div class="wallet-summary">
                   <div class="acquisition-cost mdl-card mdl-shadow--4dp">
                       <div class="mdl-card__title">
                           Acquisition Cost
                       </div>
                       <div class="mdl-card__supporting-text mdl-typography--text-left">
                           Acquisition cost here
                       </div>
                   </div>
                   <div class="profit-loss mdl-card mdl-shadow--4dp">
                       <div class="mdl-card__title ">
                           Profit/Loss
                       </div>
                       <div class="mdl-card__supporting-text mdl-typography--text-left">
                           Profit/Loss goes here
                       </div>
                   </div>
                   <div class="holdings mdl-card mdl-shadow--4dp">
                       <div class="mdl-card__title">
                           Holdings
                       </div>
                       <div class="mdl-card__supporting-text mdl-typography--text-left">
                           Holdings go here
                       </div>
                   </div>
                   <div class="day-profit-loss mdl-card mdl-shadow--4dp">
                       <div class="mdl-card__title">
                           24H Profit/Loss
                       </div>
                       <div class="mdl-card__supporting-text mdl-typography--text-left">
                           Profit/Loss goes here
                       </div>
                   </div>
               </div>
           </div>

    </div>
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