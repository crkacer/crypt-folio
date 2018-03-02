<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Master.Master" AutoEventWireup="true" CodeBehind="feedback.aspx.cs" Inherits="Cryptfolio.Views.WebForm3" %>



<asp:Content ID="Content1" ContentPlaceHolderID="Style" runat="server">
    <link rel="stylesheet" href="../Public/Resources/CSS/feedback-style.css" type="text/css" />

</asp:Content>




<asp:Content ID="Content2" ContentPlaceHolderID="Body" runat="server">
    <div class="feedback-header mdl-typography--text-center">
        <div class="mdl-typography--display-3"><span class="feedback-title">Give us your feedback</span></div>
        <div class="mdl-typography--headline"><span class="feedback-subtitle">Thank you for taking your time to write for us. We really appreciate it.</span></div>
    </div>
    <div class="feedback-form-section">
        <form action="./feedback-confirmation.aspx" runat="server">
            <div class="feedback-form">
                <div class="input-form">
                    <div class="mdl-typography--text-center">
                        <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
                            <asp:TextBox class="mdl-textfield__input" ID="name" runat="server" ></asp:TextBox>
                            <label class="mdl-textfield__label" for="name">Name*</label> 
                        </div>
                    </div>
                
                    <div class="mdl-typography--text-center error-message mdl-typography--font-bold">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="Name is required" Display="Dynamic" ControlToValidate="name">
                        </asp:RequiredFieldValidator>
                    </div>
                    <div class="mdl-typography--text-center">
                        <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
                            <asp:TextBox class="mdl-textfield__input" ID="emailInput" runat="server" ></asp:TextBox>
                            <label class="mdl-textfield__label" for="emailInput">Email*</label> 
                        </div>
                    </div>
                    <div class="mdl-typography--text-center error-message mdl-typography--font-bold">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="The email is required" Display="Dynamic" ControlToValidate="emailInput">
                        </asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ErrorMessage="Email has to be in a correct format" ControlToValidate="emailInput" Display="Dynamic" ViewStateMode="Inherit" ValidationExpression="[^\d]\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
                    </div>
                    <div class="mdl-typography--text-center">
                        <div class=" mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
                            <asp:TextBox class="mdl-textfield__input" ID="comment" runat="server" Columns="20" Rows="10" TextMode="MultiLine"></asp:TextBox>
                            <label class="mdl-textfield__label" for="comment">Comment*</label> 
                        </div>
                    </div>
                
                    <div class="mdl-typography--text-center error-message mdl-typography--font-bold">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="Comment is required" Display="Dynamic" ControlToValidate="comment">
                        </asp:RequiredFieldValidator>
                    </div>
                </div>
                <%--<div class="button-list">
                    <asp:RadioButtonList ID="RequestType" runat="server" BorderStyle="None" CellPadding="0" CellSpacing="0" Height="100px" RepeatDirection="Horizontal">
                        <asp:ListItem Text="Support" Value="support" Selected="True"></asp:ListItem>
                        <asp:ListItem Text="Bug Report" Value="bug"></asp:ListItem>
                        <asp:ListItem Text="Feedback" Value="feedback"></asp:ListItem>
                    </asp:RadioButtonList>
                </div>--%>
                <div class="button-list">
                    <span class="mdl-typography--title">Request Type: </span>
                    &nbsp;
                    <label class="mdl-radio mdl-js-radio mdl-js-ripple-effect" for="option-1">
                      <input type="radio" id="option-1" class="mdl-radio__button" name="options" value="1" checked>
                      <span class="mdl-radio__label">Support</span>
                    </label>
                    &nbsp;
                    <label class="mdl-radio mdl-js-radio mdl-js-ripple-effect" for="option-2">
                      <input type="radio" id="option-2" class="mdl-radio__button" name="options" value="2">
                      <span class="mdl-radio__label">Bug Report</span>
                    </label>
                    &nbsp;
                    <label class="mdl-radio mdl-js-radio mdl-js-ripple-effect" for="option-3">
                      <input type="radio" id="option-3" class="mdl-radio__button" name="options" value="3">
                      <span class="mdl-radio__label">Improvement Feedback</span>
                    </label>
                </div>
                
                  <asp:Button class="button-submit mdl-button mdl-js-button mdl-button--raised mdl-js-ripple-effect mdl-button--colored"  ID="Submit" runat="server" Text="Send" OnClick="Submit_Click" />
                  <asp:Button class="button-clear mdl-button mdl-js-button mdl-button--raised mdl-js-ripple-effect mdl-button--colored" ID="Clear" runat="server" Text="Clear" OnClientClick="this.form.reset();return false;" />

            </div>
        </form>
    </div>
</asp:Content>





<asp:Content ID="Content3" ContentPlaceHolderID="Script" runat="server">
</asp:Content>
