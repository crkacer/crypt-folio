<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Master.Master" AutoEventWireup="true" CodeBehind="feedback-confirmation.aspx.cs" Inherits="Cryptfolio.Views.WebForm8" %>
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
        <div class="mdl-typography--display-3"><span class="confirmation-title">Thank you for taking your time to complete our feedback</span></div>
        <div class="mdl-typography--headline"><span class="confirmation-subtitle">Your feedback has been sent to our customer support team. We will review it and get back to you as soon as possible.</span></div>
        <div class="mdl-typography--title"><span class="confirmation-link"><a href="./index.aspx" title="Back to home page">Return to homepage</a></span></div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Script" runat="server">
</asp:Content>
