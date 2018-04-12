<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Master.Master" AutoEventWireup="true" CodeBehind="forgot.aspx.cs" Inherits="Cryptfolio.Views.WebForm11" %>
<asp:Content ID="Content1" ContentPlaceHolderID="Style" runat="server">

    <link type="text/css" href="../Public/Resources/CSS/vuetify.min.css" rel="stylesheet" />
    <style>
        .forgot-content{
            min-height: 70vh;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Body" runat="server">
    <div id="app" class="forgot-content">
        <v-container >
            <v-layout align-center justify-center column wrap>
                <v-flex xs12 class="text-xs-center">
                    <h4>Forgot your password?</h4>
                    <p>Please enter the email address registered on your account.</p>
                </v-flex>
                <v-flex xs12 v-if="isSuccess == false" style="width:30%;" class="mt-5">
                <transition name="fade" appear>
                    <v-alert color="error" icon="warning" v-model="isError">
                        No email exists
                    </v-alert>
                </transition>
                <v-form v-model="valid" ref="form" onkeypress="return event.keyCode != 13;" enctype="multipart/form-data">
           
                                <v-text-field
                                        label="Email"
                                        v-model="email"
                                        :rules="emailRules"
                                        name="email"
                                        @focus ="isError = false"
                                        required
                                ></v-text-field>
                <div class="text-xs-center"><v-btn round @click="sendEmail" :class="{ green: valid, red: !valid }">Reset</v-btn><v-btn round @click="clear">Clear</v-btn></div>
            
                <transition name="fade" appear v-if="isProcess">
                    <v-card-text><v-progress-circular indeterminate color="primary"></v-progress-circular> Please wait while we process your request </v-card-text>
                </transition>
                </v-form>
                </v-flex>
                <v-flex xs12 v-else>
                    <v-alert color="success" icon="check_circle" value="true">
                        An email consisting your password has been sent to your email address.
                    </v-alert>
                    <div class="text-xs-center mt-3"><a href="/password/reset">Still haven't got it? Press here to try again</a></div>
                </v-flex>
            
            </v-layout>
        </v-container>
    </div>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Script" runat="server">
    <script>
        var vm = new Vue({
            el: '#app',
            props: {
                accept: {
                    type: String,
                    default: "image/*"
                },
                disabled: {
                    type: Boolean,
                    default: false
                },
                value: {
                    type: [Array, String]
                }
            },
            data: {
                //vue-model for v-form checking
                valid: false,
                //vue-model for displaying successful view
                isSuccess: false,
                //vue-model for displaying alert box
                isError: false,
                //vue-model for loading progress
                isProcess: false,
                //vue-model for email input box
                email: '',
                //vue-model to bind with :rules attribute in input box
                emailRules: [
                    (v) => !!v || 'E-mail is required',
                    (v) => /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(v) || 'E-mail must be valid'
                ]
        },
        methods: {
            //Bind with the clear button
            clear () {
                this.valid=false
                this.$refs.form.reset()
            },
            //Bind with Reset button, send axios post request to server
            sendEmail: function(e){
                e.preventDefault();
                if (this.$refs.form.validate()) {
                    this.isProcess = true
                    setTimeout(function(){
                        vm.isProcess = false
                        //Send Ajax
                        var bodyAjax = {
                            type: "forgot_password",
                            email: email
                        };
                        //AJAX Request
                        $.ajax({
                            type: "POST",
                            url: "forgot.aspx",
                            data: bodyAjax,
                            success: function (data) {
                                console.log(data);
                                if (data == 1) {
                                    vm.isError = true;
                                } else {
                                    vm.isSuccess = true;
                                }
                            },
                            error: function (data) {
                                console.log(data);
                            }
                        });
                    },2000)
                    
                }
                
            }
            
        }
        })
    </script>

</asp:Content>
