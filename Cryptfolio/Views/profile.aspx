<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Master.Master" AutoEventWireup="true" CodeBehind="profile.aspx.cs" Inherits="Cryptfolio.Views.WebForm12" %>
<asp:Content ID="Content1" ContentPlaceHolderID="Style" runat="server">
    <style>
        .edit-profile{
            min-height: 70vh;
            text-align:center;
        }
        .edit-profile-textbox{
            margin-top: 15vh;
        }
        .error-message{
            color:red;
            font-family:'Roboto';
            font-size:12px;
        }
        .button-submit {
            margin-top: 30px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Body" runat="server">
    <div class="edit-profile">
        <div class="edit-profile-textbox">
            <div class="mdl-typography--display-2 mdl-typography--text-center" style="font-family: 'Dancing Script', cursive;">Account Settings</div>
            <div id="app">
                <v-alert type="error" :value="alert" class="mr-5 ml-5">
                    Failed to update profile. 
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
              
                    <asp:Button class="button-submit mdl-button mdl-js-button mdl-button--raised mdl-js-ripple-effect mdl-button--colored" ID="Submit" runat="server" Text="Update" OnClientClick="submitForm()//" UseSubmitBehavior="False" />

            </form>
        </div>
        
        
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Script" runat="server">
    <script>
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
                    type: "profile_edit",
                    username: username,
                    email: email,
                    password: password
                };
                //AJAX Request
                $.ajaxSetup({
                    headers: { "type_request": "POST_REQUEST" }
                });

                $.ajax({
                    type: "POST",
                    url: "profile.aspx",
                    data: bodyAjax,
                    success: function (data) {

                        if (data == 1) {
                            window.location.href = "index.aspx";
                        } else {
                            vm.alert = true;
                        }
                        //console.log(request_status);
                    },
                    error: function (data) {
                        console.log(data);
                        vm.alert = true;
                    }
                });
            }

        }
    </script>
</asp:Content>
