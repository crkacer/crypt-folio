<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Master.Master" AutoEventWireup="true" CodeBehind="main.aspx.cs" Inherits="Cryptfolio.Views.WebForm4" %>
<asp:Content ID="Content1" ContentPlaceHolderID="Style" runat="server">
    <link href="../Public/Resources/CSS/main-style.css" type="text/css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Body" runat="server">
  
        <div class="main-content">
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
        var all_news = <%=DATA_NEWS_JSON%>;
        var articles = [];
        JSON.parse(all_news)['articles'].forEach(function (e) {
            articles.push(e);
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

        $('#newsTab').one("click", function () {
           
            console.log(articles[0]);
            generateArticle(articles[0]);
        });
        //Generate Articles
        function generateArticle(article) {
            var lastUpdated = getLastUpdated(new Date(), new Date(article.publishedAt));
            var $news = $('#news');
            var $cardImg = $('<div class="article-card-image mdl-card mdl-shadow--2dp"></div >').css({'display': 'inline-block', 'width' : '100px', 'height' : '100px', 'background' : 'url(' + article.urlToImage + ') center/cover'});
            
            var $card = $('<div class="article-card-description mdl-card mdl-shadow--2dp"></div>').css({ 'display': 'inline-block'});
            var $titleDiv = $('<div class="mdl-card__title mdl-card--expand"></div>');
            var $news = $('<h6 class="mdl-color--deep-orange-500">' + articles.source.name + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Updated at: ' + lastUpdated + '</h6>');
            $titleDiv.append($news);
            var $supportingText = $('<div class="mdl-card__supporting-text"></div>');
            var $title = $('<a>' + article.title + '</a>').attr({ 'href': article.url, 'target':'_blank' }).css({'text-decoration' : 'none', 'color':'black','font-weight':'700'});
            var $description = $('<p>' + article.description + '</p>');
            $supportingText.add($title);
            $supportingText.add($description);

        }

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
        
        function getLastUpdated(date1, date2) {

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
            
            
        }
    </script>

</asp:Content>
