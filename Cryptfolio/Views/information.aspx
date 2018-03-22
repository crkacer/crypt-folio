 <%@ Page Title="" Language="C#" MasterPageFile="~/Views/Master.Master" AutoEventWireup="true" CodeBehind="information.aspx.cs" Inherits="Cryptfolio.Views.WebForm6" %>
<asp:Content ID="Content1" ContentPlaceHolderID="Style" runat="server">
    <link rel="stylesheet" href="../Public/Resources/CSS/information-style.css" type="text/css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Body" runat="server">
    <div class="why-cryptfolio mdl-typography--text-center">
        <div class="mdl-typography--display-3"><span class="why-cryptfolio-title">Why Cryptfolio?</span></div>
    </div>
    <div class="the-idea">
        <div class="mdl-grid">
            <div class="mdl-cell mdl-cell--8-col">
                <div class="mdl-typography--display-3"><span class="the-idea-title">The Idea</span></div>
                <div class="mdl-typography--title"><span class="the-idea-content">Cryptfolio raises from the need for a friendly, up to date application which manages your investments regarding crypto currencies. With many different crypto applications in the market, Cryptfolio stands out from the test when it comes to simplicity, user friendliness and professionalism. </span></div>
            </div>
            <div class="the-idea-image mdl-cell mdl-cell-4-col mdl-cell--hide-phone mdl-cell--hide-tablet">
                <img src="../Public/Resources/Images/the-idea-image.png" alt="The idea image" style="height:500px; width: 538px;"/>
            </div>
        </div>
    </div>
    <div class="the-future">
        <div class="mdl-grid">
            <div class="mdl-cell mdl-cell--4-col mdl-cell--hide-phone mdl-cell--hide-tablet">
                <img src="../Public/Resources/Images/the-future-image.png" alt="The future image" style="height:500px; width: 538px;"/>
            </div>
            <div class="mdl-cell mdl-cell--8-col">
                <div class="mdl-typography--display-3 text-future"><span class="the-future-title">The Future</span></div>
                <div class="mdl-typography--title"><span class="the-future-content">Cryptfolio has started with the most popular crypto currencies relevant to investors in the market place. However, the application will seek to grow in order to provide further services such as: automated API integration for popular exchanges, ability to bulk import trades from unpopular exchanges as well as the ability to import balances and transactions from wallets. </span></div>
            </div>
        </div>
    </div>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Script" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            sr.reveal('.the-idea-title', { duration: 1000, container: '.mdl-layout__content', viewFactor: 0.5, scale: 0.5 });
            sr.reveal('.the-idea-content', { duration: 1000, container: '.mdl-layout__content', viewFactor: 1, scale: 0.5 });
            sr.reveal('.the-future-title', { duration: 1000, container: '.mdl-layout__content', viewFactor: 0.5, scale: 0.5 });
            sr.reveal('.the-future-content', { duration: 1000, container: '.mdl-layout__content', viewFactor: 1, scale: 0.5 });
        });
    </script>
</asp:Content>
