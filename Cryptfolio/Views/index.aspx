<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Master.Master" AutoEventWireup="true" CodeBehind="index.aspx.cs" Inherits="Cryptfolio.Views.WebForm1" %>


<asp:Content ID="Content1" ContentPlaceHolderID="Style" runat="server">
    <style>
        .blockchain-logo{
            text-align:center;
            
        }
        html, body{
            padding:0;
            margin:0;
        }
    </style>
</asp:Content>



<asp:Content ID="Content2" ContentPlaceHolderID="Body" runat="server">
    <header class="portfolio-header">
        <div class="portfolio-logo-row">
            <span class="mdl-layout__title">
                <div class="portfolio-logo"></div>
                <button onclick="window.location.href='./home.html'" class="mdl-button mdl-js-button mdl-button--raised mdl-button--accent mdl-js-ripple-effect">Main Page</button>
            </span>
        </div>
    </header>
    <div class="mdl-grid" style="padding:0; margin:0;">
        <div class="mdl-cell mdl-cell--6-col" style="min-height:400px;">
            <div class="mdl-layout__title">
                <div class="mdl-typography--display-3 mdl-animation--default" style="text-align:center; color:midnightblue;">Getting Started</div>
            </div>
                <div class="mdl-typography--title" style="padding:10px 10px; margin: 45px 20px;">
                    Cryptfolio Project was established to manage cryptocurrency investments. Click the below button to explore our website functionalities
                </div>
                <div style="text-align:center;">
                    <button onclick="window.location.href='./home.html'" class="mdl-button mdl-js-button mdl-button--raised mdl-button--accent mdl-js-ripple-effect">Take me there!</button>
                </div>
            
            
        </div>
        <div class="mdl-cell mdl-cell--6-col" style="min-height:400px; padding:0;margin:0;">
            <div class="blockchain-logo" style="margin:50px 50px;">
                <img src="../Public/Resources/Images/blockchain.jpg" alt="blockchain" style="height: 200px; width:200px;"/>
            </div>
        </div>
    </div>
    <div class="portfolio-more-section">
        <div class="mdl-grid mdl-color--accent">
            <div class="mdl-cell mdl-cell--6-col" style="min-height:300px;">
                <div class="mdl-layout__title">
                    <img src="../Public/Resources/Images/signin.png" alt="signin" style="height: 200px; width:200px;"/>
                </div>
            </div>
            <div class="mdl-cell mdl-cell--6-col" style="min-height:300px;">
                <div class="mdl-layout__title">
                    <div class="mdl-typography--display-3" style="color:midnightblue; margin-bottom:50px;" >Already a member?</div>
                    <button onclick="window.location.href='./signin.html'" class="mdl-button mdl-js-button mdl-button--raised mdl-button--accent mdl-js-ripple-effect">Sign me in</button>
                </div>
            </div>
        
            
        </div>
    </div>
</asp:Content>



<asp:Content ID="Content3" ContentPlaceHolderID="Script" runat="server">
</asp:Content>
