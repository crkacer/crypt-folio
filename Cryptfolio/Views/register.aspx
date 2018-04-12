<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Master.Master" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="Cryptfolio.Views.WebForm2" %>


<asp:Content ID="Content1" ContentPlaceHolderID="Style" runat="server">
    
    <link type="text/css" rel="stylesheet" href="../Public/Resources/CSS/vuetify.min.css" />
    <style>
        .register-screen{
            min-height:70vh;
        }
        .register-textbox{
            margin-top:20vh;
        }
        .register-instruction{
            border-left: 2px solid #CBDBD7;
            
        }

        @media (max-width: 479px){
            .register-instruction{
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
    <div class="register-screen mdl-grid">
        <div class="register-textbox mdl-cell mdl-cell--5-col-desktop">
            
            <div class="mdl-typography--display-2 mdl-typography--text-center">Welcome</div>
            <div class="mdl-typography--headline mdl-typography--text-center">Create an account.</div>
                <div id="app">
                    <v-alert type="error" :value="alert" class="mr-5 ml-5">
                        Failed to Register. Email is already taken
                    </v-alert>
                </div>
                
                <form ref="form" action="#" runat="server" >
                    <div class="mdl-typography--text-center">
                        <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
                            <asp:TextBox class="mdl-textfield__input" ID="usernameInput" runat="server"></asp:TextBox>
                            <label class="mdl-textfield__label" for="usernameInput">Username*</label> 
                        </div>
                    </div>
                    <div class="error-message mdl-typography--font-bold">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="Username is required" Display="Dynamic" ControlToValidate="usernameInput">
                        </asp:RequiredFieldValidator>
                    </div>
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
              
                    <asp:Button class="button-submit mdl-button mdl-js-button mdl-button--raised mdl-js-ripple-effect mdl-button--colored" ID="Submit" runat="server" Text="Register" OnClientClick="submitForm()//" UseSubmitBehavior="False" />
                    <asp:Button class="button-submit mdl-button mdl-js-button mdl-button--raised mdl-js-ripple-effect mdl-button--colored" ID="Clear" runat="server" Text="Clear" OnClientClick="this.form.reset();return false;" />

                </form>
         
            
        </div>
        <div class="register-instruction mdl-cell mdl-cell--7-col-desktop">
            <div class="instruction-section">
                <div class="mdl-typography--title mdl-typography--font-bold">
                    Registration Instructions
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
                    Already has an account?
                </div>
                <div class="mdl-typography--font-medium">
                   <a href="./login.aspx" title="Login Link" style="text-decoration:none;">Log In</a> to access more functionality.
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
            var username = document.getElementById('<%=usernameInput.ClientID%>').value;
            var email = document.getElementById('<%=emailInput.ClientID%>').value;
            var password = document.getElementById('<%=Password.ClientID%>').value;
            if (Page_IsValid && email != "" && password != "" && username != "") {
               
                var bodyAjax = {
                    type: "post_register",
                    username: username,
                    email: email,
                    password: password
                };
                 //AJAX Request
                $.ajax({
                    type: "POST",
                    url: "register.aspx",
                    data: bodyAjax,
                    success: function (data) {
                        console.log(data);
                        if (data == -1) {
                            vm.alert = true;
                        } else {
                            window.location.href = "./index.aspx";
                        }
                    },
                    error: function (data) {
                        console.log(data);
                    }
                });
            }
            
        }
       
        
    </script>
</asp:Content>
