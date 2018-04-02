<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Master.Master" AutoEventWireup="true" CodeBehind="main.aspx.cs" Inherits="Cryptfolio.Views.WebForm4" %>
<asp:Content ID="Content1" ContentPlaceHolderID="Style" runat="server">
    <link href="../Public/Resources/CSS/main-style.css" type="text/css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Body" runat="server">
  
        <div class="main-content">
           <div class="main-inside-content">
               <div class="mdl-typography--text-center">
                    <div class="mdl-typography--display-3" style="color:midnightblue;">Cryptfolio</div>
                    <div class="mdl-layout__title">
                        <div class="mdl-typography--title">
                            Website description
                        </div>
                    </div>
                </div>
                <div  class="mdl-tabs mdl-js-tabs mdl-js-ripple-effect main-table">
                    <div class="mdl-tabs__tab-bar tabs-bar">
                        <a href="#coins" class="mdl-tabs__tab is-active">Coin</a>
                        <a href="#news" class="mdl-tabs__tab">News</a>
                    </div>
                    <div class="mdl-tabs__panel is-active coins-table" id="coins">

                        <table class="mdl-data-table mdl-js-data-table mdl-shadow--2dp" id="crypto-table" >
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th class="mdl-data-table__cell--non-numeric">Coin</th>
                                    <th class="mdl-data-table__cell--non-numeric">Price</th>
                                    <th class="mdl-data-table__cell--non-numeric">Total Vol. 24H</th>
                                    <th class="mdl-data-table__cell--non-numeric">Market Cap</th>
                                    <th class="mdl-data-table__cell--non-numeric">7d Chart (US)</th>
                                    <th>Change 24H</th>
                                </tr>
                            </thead>
                            <tbody>

                            </tbody>
                
                        </table>
                    
                    </div>
                    <div class="mdl-tabs__panel news-table" id="news">

                    </div>
                </div>
           </div>
           
            
        </div>
        
    

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Script" runat="server">
    <script type="text/javascript">

        var all_coins_current = <%=Data_COINS_Current%>;

        console.log(all_coins_current);
        var all_coins_historical = (<%=Data_COINS_Historical%>);

        //console.log(all_coins_historical);
        var Data_Graph = {};
        for (var e in all_coins_historical) {
            //console.log(e);
            //console.log(JSON.parse(all_coins_historical[e])['Data']);
            var p = [];
            JSON.parse(all_coins_historical[e])['Data'].forEach(function (el) {
                p[p.length] = [el['time'], el['close']];
            });
            Data_Graph[e] = p;
        }
        console.log(Data_Graph);
        var div = new Array(20);
        var chartData = new Array(20);
        Object.keys(Data_Graph).forEach(function (e, i) {
            addData(e, i);
        });

        function addData(currVal, index) {
            var data = Data_Graph[currVal];
            var table = document.getElementById('crypto-table');
            var row = table.insertRow(index+1);
            var number = row.insertCell(0);
            number.innerHTML = index+1;
            var coin = row.insertCell(1);
            coin.innerHTML = currVal;
            var price = row.insertCell(2);
            price.innerHTML = all_coins_current[currVal].USD.toString();
            var totalVol24H = row.insertCell(3);
            totalVol24H.innerHTML = "$ 1 B";
            var marketcap = row.insertCell(4);
            marketcap.innerHTML = "$ 180.22 B";
            chartData[index] = row.insertCell(5);
            div[index] = document.createElement('div');
            div[index].setAttribute('id', currVal + "-chart");
            div[index].setAttribute('class', 'mdl-data-table__cell--non-numeric');
            var id = currVal + "-chart";
            div[index].style.height = '5vh';
            div[index].style.width = '15vw';
            chartData[index].appendChild(div[index]);

            Highcharts.stockChart(id, {
                scrollbar: {
                    enabled: false
                },
                series: [{

                    data: data
                }],
                xAxis: {
                    visible: false
                },
                yAxis: {
                    visible: false
                },
                rangeSelector: {
                    enabled: false
                },
                navigation: {
                    buttonOptions: {
                        enabled: false
                    }
                },
                navigator: {
                    enabled: false
                },
                tooltip: {
                    enabled: false
                },
                credits: {
                    enabled: false
                }
            });


            var change24H = row.insertCell(6);
            change24H.innerHTML = "6 %";
        }
        
    </script>

</asp:Content>
