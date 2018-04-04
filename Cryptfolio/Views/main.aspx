<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Master.Master" AutoEventWireup="true" CodeBehind="main.aspx.cs" Inherits="Cryptfolio.Views.WebForm4" %>
<asp:Content ID="Content1" ContentPlaceHolderID="Style" runat="server">
    <link href="../Public/Resources/CSS/main-style.css" type="text/css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Body" runat="server">
  
        <div class="main-content" id="app">
           <div class="main-inside-content">
               <div class="mdl-typography--text-center" style="margin-bottom: 10vh;">
                    <div class="mdl-typography--display-3" style="color:midnightblue; margin-bottom: 5vh;">Cryptfolio</div>
                    <div class="mdl-layout__title">
                        <div class="mdl-typography--title">
                            <b style="color:darkblue;">Cryptfolio</b> facilitates this much needed control over <br /> the management of your cryptocurrencies as a short as well as long term investment.
                        </div>
                    </div>
                </div>
                <div  class="mdl-tabs mdl-js-tabs main-table">
                    <div class="mdl-tabs__tab-bar tabs-bar">
                        <a href="#coins" class="mdl-tabs__tab is-active">Coin</a>
                        <a href="#news" class="mdl-tabs__tab" id="newsTab">News</a>
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
                                    <th class="mdl-data-table__cell--non-numeric mdl-col">7d Chart (US)</th>
                                    <th>Change 24H</th>
                                </tr>
                            </thead>
                            <tbody>

                            </tbody>
                
                        </table>
                    
                    </div>
                    <div class="mdl-tabs__panel news-table" id="news">
                        <div class="news-tab" v-for="(article, i) in articles" :key="i" >
                            <div class="article-card-event" >
                                <img :src=article.urlToImage class="article-card-image" />
                                <div class="mdl-card__title mdl-card--expand" style="text-align:left;">
                                    <h6 style="color:coral;">{{article.author}} &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <span style="font-weight:400; color: gray;">{{getLastUpdated(new Date(), new Date(article.publishedAt))}}</span></h6>
                                    <a style="font-size: 14px; font-weight:700; text-decoration:none; color:black; display:block;" :href=article.url target="_blank">{{article.title}}</a>
                                    <p style="font-size:12px;">{{getRefinedDescriptions(article.description)}}</p>
                                </div>
                                
                            </div>
                        </div>                            
                    </div>
                </div>
           </div>
           
            
        </div>
        
    

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Script" runat="server">
    

    <script type="text/javascript">

        var all_coins_current = <%=Data_COINS_Current%>;
        var all_news = <%=DATA_NEWS_JSON%>;
        var articles = [];
        JSON.parse(all_news)['articles'].some(function (e,i) {
            articles.push(e);
            return i === 4;
        });
        
        console.log(articles);

        var all_coins_historical = (<%=Data_COINS_Historical%>);


        var Data_Graph = {};
        for (var e in all_coins_historical) {

            var p = [];
            JSON.parse(all_coins_historical[e])['Data'].forEach(function (el) {
                p[p.length] = [el['time'], el['close']];
            });
            Data_Graph[e] = p;
        }

        var div = new Array(20);
        var chartData = new Array(20);
        var tableData = [];
        Object.keys(Data_Graph).forEach(function (e, i) {
            tableData.push(addData(e, i));
        });

        //Draw the Graph
        $(document).ready(function () {
            var table = $('#crypto-table').DataTable({
                responsive: true,
                "data": tableData,
                "iDisplayLength": 5,
                "columns": [
                    { "data": "number" },
                    { "data": "coin" },
                    { "data": "price" },
                    { "data": "totalVol24H" },
                    { "data": "marketcap" },
                    {
                        "data": "chart",
                        "render": function (data, type, row, meta) {
                            if (type === 'display' || type === 'filter') {
                                return $('<div>')
                                    .attr('id', data + "-chart")
                                    .text('Error')
                                    .css({"height":"5vh","width":"15vw"})
                                    .wrap('<div></div>')
                                    .parent()
                                    .html();
                                
                            }

                            return data;
                            
                        }
                                
                    },
                    { "data": "change24H" }
                ],
                language: {
                    search: "Search",
                    searchPlaceholder: "User Search",
                    
                    "sLengthMenu": ' Choice: ' + '<select>' +
                    '<option value="5">5 COINS PER PAGE</option>' +
                    '<option value="10">10 COINS PER PAGE</option>'+
                    '</select>',
                    "sLoadingRecords": "Please wait - loading..."
                }

            });
            for (var i = 0; i < 5; i++) {
                drawGraph(tableData[i].chart);
            }
            $('#crypto-table').on('draw.dt', function () {
                var info = table.rows({ page: 'current' }).data();
                for (var i = 0; i < info.length; i++) {
                    
                    drawGraph(info[i].chart);
                }
            });
            
        });

        //Vue.js
        var vm = new Vue({
            el: '#app',
            data: {
                articles : articles
            },
            methods: {
                getLastUpdated: function (date1, date2) {
                    var diff = (date2 - date1) / 1000;
                    var diff = Math.abs(Math.floor(diff));
                    var days = Math.floor(diff / (24 * 60 * 60));
                    var leftSec = diff - days * 24 * 60 * 60;
                    var hrs = Math.floor(leftSec / (60 * 60));
                    var leftSec = leftSec - hrs * 60 * 60;
                    var min = Math.floor(leftSec / (60));
                    var leftSec = leftSec - min * 60;
                    
                    return (days != 0 ? days.toString() + " day(s) ago" :
                        (hrs != 0 ? hrs.toString() + " hour(s) ago" :
                            (min != 0 ? min.toString() + " minute(s) ago" :
                                (leftSec != 0 ? leftSec.toString() + " second(s) ago" : "Just now")
                            )
                        )
                    )
                },
                getRefinedDescriptions: function (str) {

                    return str.length > 500 ? str.replace(/[?]/g,".").substring(0, 300) + "..." : str.replace(/[?]/g,".");
                }

            }

        });

        //Draw Graph
        function drawGraph(currVal) {
            
            var data = Data_Graph[currVal];
            var id = currVal + "-chart";
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
        }
        function addData(currVal, index) {

            var foo = {};
            foo.number = index + 1;
            foo.coin = currVal;
            foo.price = all_coins_current[currVal].USD.toString();
            foo.totalVol24H = "$ 1 B";
            foo.marketcap = "$ 180.22 B";
            div[index] = currVal;

            foo.chart = div[index];
            foo.change24H = "6 %";

            return foo;
        }
        
    </script>

</asp:Content>
