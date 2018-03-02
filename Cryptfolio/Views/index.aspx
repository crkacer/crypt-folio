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
        .sr .history-title .member-login {visibility:hidden;}
        
    </style>
</asp:Content>



<asp:Content ID="Content2" ContentPlaceHolderID="Body" runat="server">
    
    <div class="particle-wrapper">
        <div id="particles-js" style="height:45vh;">
            <div class="portfolio-logo animated fadeIn">
                <img src="../Public/Resources/Images/logo.png" />
            </div>
        </div>
        
    </div>
    <div class="getting-started">
        <div class="mdl-grid">
            <div class="mdl-cell mdl-cell--6-col">
                <div class="mdl-layout__title">
                    <div class="getting-started-title">
                        <div class="gettingStarted-effect mdl-typography--display-2" ></div>
                        <div class="css-typing mdl-typography--title" >
                        </div>
                        <div>
                        <button onclick="window.location.href='./home.html'" class="mdl-button mdl-js-button mdl-button--raised mdl-button--colored mdl-js-ripple-effect">Take me there!</button>
                        </div>
                    </div>
                   
                 </div>
            
            </div>
            <div class="mdl-cell mdl-cell--6-col-desktop mdl-cell--hide-phone mdl-cell--hide-tablet">
                <div class="blockchain-logo">
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
    </div>
    
    <div class="crypto-history-section">
        <div class="mdl-grid ">
            <div class="mdl-cell mdl-cell--6-col">
                <div id="coin">
                  <div class="side-a">
                  </div>
                  <div class="side-b">
                  </div>
                </div>
            </div>
            <div class="mdl-cell mdl-cell--6-col">
                <div class="history-effect">
                    <div class="history-container mdl-layout__title">
                        <div class="history-title mdl-typography--headline mdl-typography--text-justify">
                            Cryptocurrencies are fast moving and constantly fluctuating on a regular basis. They are emerging and fast moving currencies that require time, knowledge, and information for appropriate management. <b style="color:darkblue;">Cryptfolio</b> facilitates this much needed control over the management of your cryptocurrencies as a short as well as long term investment.
                        </div>
                        <button onclick="window.location.href='./information.aspx'" class="mdl-button mdl-js-button mdl-button--raised mdl-button--colored mdl-js-ripple-effect">I want to hear more</button>
                    </div>
                </div>
                
                
                
            </div>
        </div>
    </div>
    <div class="history-section">
        <div id="history-section-content" class="back">
            <div>
                <div class="mdl-typography--display-3 history-section-title mdl-typography--text-center">
                    Our History
                </div>
                <div class="mdl-typography--title history-section-info">
                    Created in 2018, <b style="color:midnightblue;">Crytfolio</b> focuses on creating value by  providing a Crypto  currency portfolio service in order to satisfy the investing needs of our customers. We strive  to make the future better for our customers, and our  communities by becoming Canada's  most efficient and  innovative Crypto currency manager. 
                </div>
                <div class="explore-button">
                    <button onclick="window.location.href='./aboutus.aspx'" class="mdl-button mdl-js-button mdl-button--raised mdl-button--colored mdl-js-ripple-effect">Explore</button>
                </div>
            </div>
        </div>
        
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
    <div class="portfolio-login-section">
        <div class="mdl-grid" >
            <div class="mdl-cell mdl-cell--6-col mdl-typography--text-center">
                <div class="member-login">
                    <div class="mdl-layout__title ">
                        <div class=" mdl-typography--display-3 " style="color:midnightblue; margin-bottom:50px;" >Already a member?</div>
                        <button onclick="window.location.href='./login.aspx'" class="mdl-button mdl-js-button mdl-button--raised mdl-button--colored mdl-js-ripple-effect">Sign me in</button>
                   </div>
                </div>
           </div>
            <div class="mdl-cell mdl-cell--6-col mdl-cell--hide-phone mdl-cell--hide-tablet">
                <div class="member-login-logo">
                </div>
                
            </div>
        
            
        </div>
    </div>
    <div id="team-section" >
        <div class="team-section-content ">
                <div class="mdl-grid ">
                    <div class="mdl-cell mdl-cell--6-col">

                    </div>
                    <div class="mdl-cell mdl-cell--6-col" id="teamImg">
                        <div class="team-title" >
                            <div class ="mdl-layout__title" >
                                <div class="mdl-typography--display-3 meet-our-team" style="color:midnightblue;">Meet our team</div>
                            </div>
                            <div class="duc-face">
                                <img src="../Public/Resources/Images/Duc.png" style="width:128px; height:128px;" id="duc-face"/>
                                
                            </div>
                            <div class="allan-face">
                                <img src="../Public/Resources/Images/Allan.png" style="width:128px; height:128px;" id="allan-face"/>
                                
                                 <img src="../Public/Resources/Images/Huy.png" style="width:128px; height:128px;" id="huy-face"/>
                                <span class="huy-face">
                                </span>
                            </div>
                            
                        </div>
                    
                    </div>
                </div>
            </div>
        <div id="scene">
            
            <div data-depth="0.00"><div class="parallax-5"></div></div>
            <div data-depth="0.00"><div class="parallax-4"></div></div>
            <div data-depth="0.00"><div class="parallax-3"></div></div>
            <div data-depth="0.00"><div class="parallax-2"></div></div>
            <div data-depth="0.00"><div class="parallax-1"></div></div>
            
            
            <div data-depth="0.55" class="mdl-cell--hide-phone mdl-cell--hide-tablet"><div class="parallax-6"></div></div>
            <div data-depth="1.00" class="mdl-cell--hide-phone mdl-cell--hide-tablet"><div class="parallax-7"></div></div>
            
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
        var flipResult = 1;
        setInterval(function () {
            
            $('#coin').removeClass();
            if (flipResult == 1) {
                $('#coin').addClass('heads');
                flipResult = 0;
            }
            else {
                $('#coin').addClass('tails');
                flipResult = 1;
            }
        }, 3000);
        $(document).ready(function () {
            sr.reveal('.history-effect', { duration: 500, container: '.mdl-layout__content', viewFactor: 0.4, scale: 0.5 });
            sr.reveal('.member-login', { duration: 500, container: '.mdl-layout__content', viewFactor: 0.5, rotate: { x: 0, y: 0, z: 50 } });
            sr.reveal('.member-login-logo', { duration: 500, container: '.mdl-layout__content', viewFactor: 0.5, rotate: { x: 50, y: 0, z: 0 } });
            sr.reveal('#huy-face', { duration: 1000, container: '.mdl-layout__content', viewFactor: 0.5 });
            sr.reveal('#allan-face', { duration: 1000, container: '.mdl-layout__content', viewFactor: 0.5 });
            sr.reveal('.duc-face', { duration: 1000, container: '.mdl-layout__content', viewFactor: 0.5 });
            sr.reveal('.history-section-info', { duration: 1000, container: '.mdl-layout__content', viewFactor: 0.5 });
            sr.reveal('.explore-button', { duration: 1000, container: '.mdl-layout__content', viewFactor: 0.5 });
            $("#teamImg").on("click", function () {
                window.location.href = './aboutus.aspx#page/6';
            });
        });
        var scene = document.getElementById('scene');
        var parallaxInstance = new Parallax(scene, {
            relativeInput: true
        });

        var scene2 = document.getElementById('scene2');
        var parallaxInstance = new Parallax(scene2, {
            relativeInput: true
        });
               </script>
    <script src="../Public/Resources/JS/particles.js">
        
    </script>
    <script src="../Public/Resources/JS/app.js">

    </script>
</asp:Content>
