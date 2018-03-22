<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Master.Master" AutoEventWireup="true" CodeBehind="aboutus.aspx.cs" Inherits="Cryptfolio.Views.WebForm5" %>
<asp:Content ID="Content1" ContentPlaceHolderID="Style" runat="server">
    <link rel="stylesheet" href="../Public/Resources/CSS/aboutus-style.css" type="text/css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Body" runat="server">
    <div class="aboutus-content">
        <div class="book">
            <div id="flipbook">
                <div id="front-page" class="hard"></div>
                <div id="front-page2" class="hard"></div>
                <div></div>
	            <div></div>
	            <div></div>
	            <div></div>
	            <div></div>
	            <div></div>
	            <div></div>
	            <div></div>
                <div></div>
                <div></div>
                <div id="back-page2" class="hard"></div>
                <div id="back-page3" class="hard"></div>
            </div>
        </div>
        <div class="info-section back">
        
            <div id="scene2" data-friction-x="0.1"
	            data-friction-y="0.1"
	            data-scalar-x="25"
	            data-scalar-y="15">
            
                <div class="back" data-depth="0.00"><div class="history-section-background"></div></div>
                <div class="back" data-depth="0.60"><div class="black"></div></div>
                <div class="back" data-depth="0.60"><div class="wave paint depth-30"></div></div>
                <div class="back" data-depth="0.60"><div class="wave plain depth-40"></div></div>
                <div class="back" data-depth="0.60"><div class="wave paint depth-50"></div></div>
                <div class="back" data-depth="0.60"><div class="wave plain depth-60"></div></div>
                <div class="back" data-depth="0.60"><div class="wave paint depth-80"></div></div>
                <div class="back" data-depth="0.60"><div class="wave plain depth-100"></div></div>
            
            </div>
        </div>
    </div>
    
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Script" runat="server">
    <script type="text/javascript" src="../Public/Resources/JS/zoom.min.js"></script>
    <script type="text/javascript" src="../Public/Resources/JS/scissor.min.js"></script>
    <script type="text/javascript" src="../Public/Resources/JS/hash.js"></script>
    <script type="text/javascript" src="../Public/Resources/JS/turn.min.js"></script>

    <script type="text/javascript">
        //URIs

        Hash.on('^page\/([0-9]*)$', {
            yep: function (path, parts) {
                var page = parts[1];

                if (page !== undefined) {
                    if ($('#flipbook').turn('is'))
                        $('#flipbook').turn('page', page);
                }

            },
            nop: function (path) {

                if ($('#flipbook').turn('is'))
                    $('#flipbook').turn('page', 1);
            }
        });
        //Initialize book
        $("#flipbook").turn({
            autoCenter: true,
            elevation: 50,
            acceleration: true,
            gradients: true,
            duration: 500,
            page: 1
        });
        var scene2 = document.getElementById('scene2');
        var parallaxInstance = new Parallax(scene2, {
            relativeInput: true
        });
    </script>

</asp:Content>
