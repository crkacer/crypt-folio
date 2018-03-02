<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Master.Master" AutoEventWireup="true" CodeBehind="login-confirmation.aspx.cs" Inherits="Cryptfolio.Views.WebForm7" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Style" runat="server">

    <style>
        .confirmation-link a{
            color: #5584BD;
            text-decoration:none;
        }
        .confirmation-link a:hover{
            color: #000859;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="Body" runat="server">
    <div class="confirmation-section mdl-typography--text-center">
        <div class="mdl-typography--display-3"><span class="confirmation-title">Congratulations! You have successfully logged in!</span></div>
        <div class="mdl-typography--title"><span class="confirmation-link"><a href="./index.aspx" title="Back To Main Page">Yay! Take me back to main page!</a></span></div>
    </div>
</asp:Content>


<asp:Content ID="Content3" ContentPlaceHolderID="Script" runat="server">
</asp:Content>
