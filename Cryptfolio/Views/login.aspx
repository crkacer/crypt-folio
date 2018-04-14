<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Master.Master" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="Cryptfolio.Views.WebForm2" %>


<asp:Content ID="Content1" ContentPlaceHolderID="Style" runat="server">
    
    <link type="text/css" rel="stylesheet" href="../Public/Resources/CSS/vuetify.min.css" />
    <style>
        .login-screen{
            min-height:70vh;
        }
        .login-textbox{
            margin-top:20vh;
        }
        .login-instruction{
            border-left: 2px solid #CBDBD7;
            
        }

        @media (max-width: 479px){
            .login-instruction{
                border-left: none;
            }
        }
        .error-message{
            color:red;
            font-family:'Roboto';
            font-size:12px;
            margin-left:12vw;
        }
        .button-submit{
            margin-top:30px;

            margin-left:10.5vw;
        }
      
        .instruction-section{
            margin-top:9vh;
            margin-left:5vw;
            margin-right:2vw;
        }
    </style>
</asp:Content>



<asp:Content ID="Content2" ContentPlaceHolderID="Body" runat="server">
    <div class="login-screen mdl-grid">
        <div class="login-textbox mdl-cell mdl-cell--5-col-desktop">
            
            <div class="mdl-typography--display-2 mdl-typography--text-center">Welcome back</div>
            <div class="mdl-typography--headline mdl-typography--text-center">Please enter your email and password to login</div>
                <div id="app">
                    <v-alert type="error" :value="alert" class="mr-5 ml-5">
                        Failed to Login. Please check your credentials
                    </v-alert>
                </div>
                
                <form ref="form" action="#" runat="server" >
                    <div class="mdl-typography--text-center">
                        <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
                            <asp:TextBox class="mdl-textfield__input" ID="emailInput" runat="server"></asp:TextBox>
                            <label class="mdl-textfield__label" for="emailInput">Email*</label> 
                        </div>
                    </div>
                    <div class="error-message mdl-typography--font-bold">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="The email is required" Display="Dynamic" ControlToValidate="emailInput">
                        </asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ErrorMessage="Email has to be in a correct format" ControlToValidate="emailInput" Display="Dynamic" ViewStateMode="Inherit" ValidationExpression="[^\d]\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
                    </div>
                    <div class="mdl-typography--text-center">
                        <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
                             <asp:TextBox class="mdl-textfield__input" ID="Password" runat="server" TextMode="Password"></asp:TextBox>
                             <label class="mdl-textfield__label" for="Password">Password*</label> 
                        </div>
                    </div>
                    <div class="error-message mdl-typography--font-bold">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="The password is required" Display="Dynamic" ControlToValidate="Password">
                        </asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ErrorMessage="Password has to be in a correct format" ControlToValidate="Password" Display="Dynamic" ViewStateMode="Inherit" ValidationExpression="^[^\d]((?=.*\d)(?=.*[a-z])(?=.*[!\*]).{8,16})"></asp:RegularExpressionValidator>
                    </div>
              
                    <asp:Button class="button-submit mdl-button mdl-js-button mdl-button--raised mdl-js-ripple-effect mdl-button--colored" ID="Submit" runat="server" Text="Log In" OnClientClick="submitForm()//" UseSubmitBehavior="False" />
                    <asp:Button class="button-submit mdl-button mdl-js-button mdl-button--raised mdl-js-ripple-effect mdl-button--colored" ID="Clear" runat="server" Text="Clear" OnClientClick="this.form.reset();return false;" />

                </form>
         
            
        </div>
        <div class="login-instruction mdl-cell mdl-cell--7-col-desktop">
            <div class="instruction-section">
                <div class="mdl-typography--title mdl-typography--font-bold">
                    Login Instructions
                </div>
                <div class="mdl-typography--font-medium">
                    Email starts with a letter and follows this format and includes a number <b>(example@example.com)</b> and passwords must <b>start with a 
                    letter</b>, have <b>at least one of these characters (! *)</b>, <b>at least one digit</b>, and must be <b>within 8-16 characters.</b>
                    When done typing, click Log in to sign in. Otherwise, click Clear to reset again.
                </div>
            </div>
            <div class="instruction-section">
                <div class="mdl-typography--title mdl-typography--font-bold">
                    Forgot your password?
                </div>
                <div class="mdl-typography--font-medium">
                    Fear not, just click on this <a href="./forgot.aspx" title="forgot password link" style="text-decoration:none;">link</a> to reset
                </div>
            </div>
            <div class="instruction-section">
                <div class="mdl-typography--title mdl-typography--font-bold">
                    Haven't Register yet?
                </div>
                <div class="mdl-typography--font-medium">
                   <a href="./register.aspx" title="Register Link" style="text-decoration:none;">Register now</a> with us for more access to our application.
                </div>
            </div>
            <div class="instruction-section">
                <div class="mdl-typography--title mdl-typography--font-bold">
                    Security purpose
                </div>
                <div class="mdl-typography--font-medium">
                    For security reason, please log out and exit your web browser when you are done accessing services that require authentication.
                </div>
            </div>
        </div>
    </div>

</asp:Content>





<asp:Content ID="Content3" ContentPlaceHolderID="Script" runat="server">
    <script type="text/javascript">
        var vm = new Vue({
            el: '#app',
            data: {
                alert: false
            },
            watch: {
                alert: function (val) {
                    setTimeout(function () {
                        if (val == true) {
                            vm.alert = false;
                        }
                    }, 2500);
                }
            }
        });
        function submitForm() {

            var email = document.getElementById('<%=emailInput.ClientID%>').value;
            var password = document.getElementById('<%=Password.ClientID%>').value;
            if (Page_IsValid && email != "" && password != "") {
               
                var bodyAjax = {
                    type: "post_login",
                    email: email,
                    password: password
                };

                $.ajax({
                    type: "POST",
                    url: "login.aspx",
                    data: bodyAjax,
                    success: function (data) {
                        console.log(data);
                        if (data == "1") {
                            window.location.href = "login-confirmation.aspx";
                        } else {
                            alert("Username or password is incorrect");
                        }
                    },
                    error: function (data) {
                        console.log(data);
                    }
                });
            }
            
        }
        //AJAX Request
        
    </script>
</asp:Content>
