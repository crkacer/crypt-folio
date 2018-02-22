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
    
    <div class="particle-wrapper">
        <div id="particles-js" style="height:45vh;">
            <div class="portfolio-logo">

            </div>
        </div>
        
    </div>

    <div class="mdl-grid" style="padding:0; margin:0;">
        <div class="mdl-cell mdl-cell--6-col" style="min-height:50vh; ">
            <div class="mdl-layout__title">
                <div class="gettingStarted-effect mdl-typography--display-3 mdl-animation--default" style="text-align:center; color:midnightblue; margin-top:5vh;"></div>
           
                <div class="css-typing mdl-typography--title" style="padding:10px 10px; margin: 5vw 5vh;">
                </div>
               
                <div style="text-align:center;">
                    <button onclick="window.location.href='./home.html'" class="mdl-button mdl-js-button mdl-button--raised mdl-button--accent mdl-js-ripple-effect">Take me there!</button>
                </div>
             </div>
            
        </div>
        <div class="mdl-cell mdl-cell--6-col" style="padding:0;margin:0;">
            <div class="blockchain-logo" style="margin:50px 50px;">
                <div class="orbit">
                  <div class="prot"></div>
                  <div class="elec sp1"></div>
                </div>
                <div class="orbit rot45"><div class="elec sp2"></div></div>
                <div class="orbit rot90"><div class="elec sp3"></div></div>
                <div class="orbit rot135"><div class="elec sp4"></div></div>
            </div>
        </div>
    </div>
    <div class="portfolio-more-section">
        <div class="mdl-grid mdl-color--amber">
            <div class="mdl-cell mdl-cell--6-col" style="min-height:40vh;">
                <div class="mdl-layout__title">

                </div>
            </div>
            <div class="mdl-cell mdl-cell--6-col" style="min-height:300px;">
                <div class="mdl-layout__title">
                    <div class="mdl-typography--display-3" style="color:midnightblue; margin-bottom:50px;" >Already a member?</div>
                    <button onclick="window.location.href='./login.aspx'" class="mdl-button mdl-js-button mdl-button--raised mdl-button--accent mdl-js-ripple-effect">Sign me in</button>
                </div>
            </div>
        
            
        </div>
    </div>
</asp:Content> 



<asp:Content ID="Content3" ContentPlaceHolderID="Script" runat="server">
    <script type="text/javascript">
        
        var intro = 'Cryptfolio Project was established to manage cryptocurrency investments. Click the below button to explore our website functionalities.';
        var gettingStarted = 'Getting Started'
        var spans = '<span>' + intro.split('').join('</span><span>') + '</span>';
        var gettingStartedSpan = '<span>' + gettingStarted.split('').join('</span><span>') + '</span>';
        $(spans).hide().appendTo('.css-typing').each(function (i) {
            $(this).delay(40 * i).css({
                display: 'inline',
                opacity: 0
            }).animate({
                opacity: 1
            }, 100);
        });
        $(gettingStartedSpan).hide().appendTo('.gettingStarted-effect').each(function (i) {
            $(this).delay(100 * i).css({
                display: 'inline',
                opacity: 0
            }).animate({
                opacity: 1
            }, 100);
        });

    </script>
    <script src="../Public/Resources/JS/particles.js">
        
    </script>
    <script src="../Public/Resources/JS/app.js">

    </script>
    
</asp:Content>
