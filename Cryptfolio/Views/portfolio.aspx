<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Master.Master" AutoEventWireup="true" CodeBehind="portfolio.aspx.cs" Inherits="Cryptfolio.Views.WebForm9" %>
<asp:Content ID="Content1" ContentPlaceHolderID="Style" runat="server">
    <link type="text/css" rel="stylesheet" href="../Public/Resources/CSS/portfolio-style.css" />
    <link type="text/css" rel="stylesheet" href="../Public/Resources/CSS/vuetify.min.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Body" runat="server">
    <div class="wallet-content" id="app">
           <div class="wallet-inside-content">
               <div class="wallet-title">
                   <h2 style="margin:0; padding:10px; font-family: 'Dancing Script', cursive;"><i class="material-icons" style="font-size:32px;top:2px;">account_balance_wallet</i>&nbsp;&nbsp;My Portfolio</h2>
               </div>
               <div class="wallet-option">
                   <v-app id="app3">
                       <v-dialog
                            v-model="createCoinDialog"
                            max-width="600px"
                       >
                           <v-form v-model="validCreate" ref="formCreate">
                                <v-card>
                                    <v-card-title>
                                    <span class="headline">Add Coin</span>
                                    </v-card-title>
                                    <v-card-text>
                                            <v-container grid-list-md>
                                                <v-layout wrap>
                                                <v-flex xs12>
                                                    <v-select
                                                        label="Coin Name"
                                                        autocomplete
                                                        :loading="loading"
                                                        cache-items
                                                        required
                                                        :items="coinList"
                                                        attach
                                                        :rules="createRules"
                                                        :search-input.sync="searchForCoin"
                                                        v-model="coinCreate.coin"
                                                        id="coinNameInput"
                                                        ></v-select>
                                                </v-flex>
                                                <v-flex xs12 sm6 md3>
                                                    <v-text-field label="Amount" v-model="coinCreate.amount" :rules="amountRules"></v-text-field>
                                                </v-flex>
                                                <v-flex xs12 sm6 md4>
                                                    <v-text-field label="Buy Price" v-model="coinCreate.buyPrice" :rules="priceRules"></v-text-field>
                                                </v-flex>
                                                <v-flex xs12 sm6 md4>
                                                    <v-menu
                                                        ref="menuCreate"
                                                        lazy
                                                        attach="createDatePicker"
                                                        :close-on-content-click="false"
                                                        v-model="menuCreate"
                                                        transition="scale-transition"
                                                        full-width
                                                        offset-y
                                                        :nudge-right="40"
                                                        max-width="290px"
                                                        min-width="290px"
                                                        :return-value.sync="coinCreate.buyDate"
                                                    >
                                                            <v-text-field slot="activator" label="Bought on" v-model="coinCreate.buyDate" readonly :rules="dateRules" id="createDate"></v-text-field>
                                                            <v-date-picker v-model="coinCreate.buyDate" no-title scrollable actions>
                                                            <template slot-scope="{ save, cancel }">
                                                                <v-card-actions>
                                                                    <v-spacer></v-spacer>
                                                                    <v-btn flat color="primary" @click="menuCreate = false">Cancel</v-btn>
                                                                    <v-btn flat color="primary" @click="$refs.menuCreate.save(coinCreate.buyDate)">OK</v-btn>
                                                                </v-card-actions>
                                                            </template>
                                                        </v-date-picker>
                                                </v-menu>
                                            </v-flex>
                                                           
                                            </v-layout>
                                        </v-container>
                                        </v-card-text>
                                        <v-card-actions>
                                        <v-spacer></v-spacer>
                                        <v-btn color="blue darken-1" flat @click.native="close">Cancel</v-btn>
                                        <v-btn color="blue darken-1" flat @click.native="create" :disabled="!validCreate">Create</v-btn>
                                        </v-card-actions>
                                    </v-card>
                                </v-form>
                       </v-dialog>
                   </v-app>
                   <button class="mdl-button mdl-js-button mdl-button--raised mdl-js-ripple-effect mdl-button--colored" style="margin:10px;" @click="createCoin()">
                      <i class="material-icons">add</i>&nbsp;Coin
                   </button>
               </div>
               <div class="wallet-summary">
                   <div class="acquisition-cost mdl-card mdl-shadow--4dp">
                       <div class="mdl-card__title">
                           Acquisition Cost
                       </div>
                       <div class="mdl-card__supporting-text mdl-typography--text-left">
                           $ {{acquisitionCost}}
                       </div>
                   </div>
                   <div class="holdings mdl-card mdl-shadow--4dp">
                       <div class="mdl-card__title">
                           Holdings
                       </div>
                       <div class="mdl-card__supporting-text mdl-typography--text-left">
                           $ {{holdings}}
                       </div>
                   </div>
                   <div class="day-profit-loss mdl-card mdl-shadow--4dp ">
                       <div class="mdl-card__title">
                           Realized Profit/Loss
                       </div>
                       <div class="mdl-card__supporting-text mdl-typography--text-left">
                           $ {{realizedPL}}
                       </div>
                   </div>
               </div>
               <div class="outer-overview">
                   <div class="overview mdl-tabs mdl-js-tabs mdl-js-ripple-effect mdl-shadow--6dp">
                       <div class="mdl-tabs__tab-bar overview-tabs-bar">
                           <a href="#summary" class="mdl-tabs__tab is-active"><i class="material-icons" style="vertical-align:middle;">assignment</i>&nbsp;&nbsp;Overview</a>
                           <a href="#accounting" class="mdl-tabs__tab" id="newsTab"><i class="material-icons" style="vertical-align:middle;">attach_money</i>&nbsp;&nbsp;Accounting</a>
                       </div>
                       <div class="mdl-tabs__panel is-active overview-summary" id="summary">
                           <div class="mdl-grid" style="padding:0;">
                               <div class="mdl-cell mdl-cell--4-col wallet-change">

                                    <div class="stats-header">
                                        <span class="label-portfolio-stat">Portfolio Change</span>
                                        <div class="period-change value-portfolio-stat">$ {{portfolioChange}} <span style="font-size: 12px;">({{portfolioChangePercentage}} %)</span></div>
                                    </div>
                                    <div class="mdl-grid--no-spacing" style="text-align:left;">
                                        <div class="mdl-cell mdl-cell--6-col block-stat portfolio-min">
                                            <span class="label-portfolio-stat">Portfolio MIN</span>
                                            <span class="value-portfolio-stat">$ {{portfolioMin}}</span>
                                        </div>
                                        <div class="mdl-cell mdl-cell--6-col block-stat portfolio-max">
                                            <span class="label-portfolio-stat">Portfolio MAX</span>
                                            <span class="value-portfolio-stat">$ {{portfolioMax}}</span>
                                        </div>
                                        <div class="mdl-cell mdl-cell--6-col block-stat least-profitable">
                                            <span class="label-portfolio-stat">Least Profitable</span>
                                            <span class="value-portfolio-stat">{{leastProfitableCoinName}} $ {{leastProfitableCoinMoney}}</span>
                                        </div>
                                        <div class="mdl-cell mdl-cell--6-col block-stat most-profitable">
                                            <span class="label-portfolio-stat">Most Profitable</span>
                                            <span class="value-portfolio-stat">{{mostProfitableCoinName}} $ {{mostProfitableCoinMoney}}</span>
                                        </div>
                                        <div class="mdl-cell mdl-cell--6-col block-stat worst-crypto">
                                            <span class="label-portfolio-stat">Worst Crypto</span>
                                            <span class="value-portfolio-stat">{{leastProfitableCoinName}} ({{leastProfitableCoinPercentage}} %)</span>
                                        </div>
                                        <div class="mdl-cell mdl-cell--6-col block-stat best-crypto">
                                            <span class="label-portfolio-stat">Best Crypto</span>
                                            <span class="value-portfolio-stat">{{mostProfitableCoinName}} ({{mostProfitableCoinPercentage}} %)</span>
                                        </div>
                                    </div>
                                </div>
                                <div class="mdl-cell mdl-cell--8-col chart">
                                    <div id="chart-portfolio">

                                    </div>
                                </div>
                           </div> 
                           
                       </div>
                       <div class="mdl-tabs__panel calculating-sales" id="accounting">
                           <div class="mdl-grid" style="padding:0;">
                               <div class="mdl-cel mdl-cell--4-col holdings-pie-chart" style="padding-top:20px; padding-left:10px;">
                                    <h4 style="font-size: 17px;
                                              color: #ff8e13;
                                              text-align:left;">Coins</h4>
                                    <div id="pie-chart" style="min-width: 310px; height: 400px; max-width: 600px; margin: 0 auto"></div>
                               </div>
                               <div class="mdl-cell mdl-cell--5-col-desktop income-statement" style="padding:20px; overflow-x:auto;">
                                   <h4 style="font-size: 17px;
                                              color: #ff8e13;
                                              text-align:left;">Income Statement</h4>
                                   <table class="mdl-data-table mdl-js-data-table" >
                                       <thead>
                                           <tr>
                                               <th>Item</th>
                                               <th>Amount</th>  
                                           </tr>
                                       </thead>
                                       <tbody>
                                           <tr>
                                               <td>Total Investment On Sold Positions</td>
                                               <td>$ {{investmentSold}}</td>
                                           </tr>
                                           <tr>
                                               <td>Total Revenue</td>
                                               <td>$ {{revenue}}</td>
                                           </tr>
                                           <tr>
                                               <td >Realized P/L</td>
                                               <td>$ {{realizedPL}}</td>
                                           </tr>
                                       </tbody>
                                   </table>
                               </div>
                               <div class="mdl-cell mdl-cell--3-col-desktop cashflow-statement" style="padding-top: 20px; ">
                                   <h4 style="font-size: 17px;
                                              color: #ff8e13;
                                              text-align:left;">Cashflow Statement</h4>
                                   <table class="mdl-data-table mdl-js-data-table" >
                                       <thead>
                                           <tr>
                                               <th>Item</th>
                                               <th>Amount</th>  
                                           </tr>
                                       </thead>
                                       <tbody>
                                           <tr>
                                               <td>Total Investment</td>
                                               <td>$ {{investmentCashflow}}</td>
                                           </tr>
                                           <tr>
                                               <td>Total Revenue</td>
                                               <td>$ {{revenue}}</td>
                                           </tr>
                                           <tr>
                                               <td>Net Cashflow</td>
                                               <td>$ {{netCashflow}}</td>
                                           </tr>
                                       </tbody>
                                   </table>
                               </div>
                           </div>
                       </div>
                   </div>
               </div>
               <div class="outer-detail-view">
                   <div class="detail-view mdl-tabs mdl-js-tabs mdl-js-ripple-effect">
                        <div class="mdl-tabs__tab-bar detail-tabs-bar">
                           <a href="#current" class="mdl-tabs__tab is-active"><i class="material-icons" style="vertical-align:middle;">timeline</i>&nbsp;&nbsp;Current</a>
                           <a href="#sold" class="mdl-tabs__tab"><i class="material-icons" style="vertical-align:middle;">indeterminate_check_box</i>&nbsp;&nbsp;Sold</a> 
                        </div>
                       <div class="mdl-tabs__panel is-active coin-current" id="current">
                           <%--Vuetify Data Tables--%>
                           <v-app id="inspire">
                               <v-dialog v-model="dialog" max-width="600px">
                                <v-tabs
                                  color="light-blue lighten-3"
                                  hide-slider
                                  centered 
                                >
                                  <v-tab href="#edit" @click="overFlow()">
                                      Edit
                                  </v-tab>
                                  <v-tab href="#sell" @click="overFlow()">
                                      Sell
                                  </v-tab>
                                 
                                  <v-tabs-items>
                                      
                                  <v-tab-item id="edit">
                                          <v-form v-model="validEdit" ref="formEdit">
                                                <v-card>
                                                  <v-card-title>
                                                    <span class="headline">Edit Coin</span>
                                                  </v-card-title>
                                                  <v-card-text>
                                                          <v-container grid-list-md>
                                                              <v-layout wrap>
                                                                <v-flex xs12>
                                                                  <v-text-field label="Coin Name" v-model="editedItem.coin" disabled></v-text-field>
                                                                </v-flex>
                                                                <v-flex xs12 sm6 md3>
                                                                  <v-text-field label="Amount" v-model="editedItem.amount" :rules="amountRules"></v-text-field>
                                                                </v-flex>
                                                                <v-flex xs12 sm6 md4>
                                                                  <v-text-field label="Buy Price" v-model="editedItem.buyPrice" :rules="priceRules"></v-text-field>
                                                                </v-flex>
                                                                <v-flex xs12 sm6 md4>
                                                                    <v-menu
                                                                      ref="menu"
                                                                      lazy
                                                                      attach="datePicker"
                                                                      :close-on-content-click="false"
                                                                      v-model="menu"
                                                                      transition="scale-transition"
                                                                      full-width
                                                                      offset-y
                                                                      :nudge-right="40"
                                                                      max-width="290px"
                                                                      min-width="290px"
                                                                      :return-value.sync="editedItem.buyDate"
                                                                    >
                                                                         <v-text-field @click.native="stopOverFlow()" slot="activator" label="Bought on" v-model="editedItem.buyDate" readonly :rules="dateRules" id="buyDate"></v-text-field>
                                                                          <v-date-picker v-model="editedItem.buyDate" no-title scrollable actions>
                                                                            <template slot-scope="{ save, cancel }">
                                                                                <v-card-actions>
                                                                                    <v-spacer></v-spacer>
                                                                                    <v-btn flat color="primary" @click="menu = false">Cancel</v-btn>
                                                                                    <v-btn flat color="primary" @click="$refs.menu.save(editedItem.buyDate)">OK</v-btn>
                                                                                </v-card-actions>
                                                                            </template>
                                                                        </v-date-picker>
                                                                </v-menu>
                                                            </v-flex>
                                                           
                                                          </v-layout>
                                                        </v-container>
                                                      </v-card-text>
                                                      <v-card-actions>
                                                        <v-spacer></v-spacer>
                                                        <v-btn color="blue darken-1" flat @click.native="close">Cancel</v-btn>
                                                        <v-btn color="blue darken-1" flat @click.native="update" :disabled="!validEdit">Update</v-btn>
                                                      </v-card-actions>
                                                    </v-card>
                                                </v-form>  
                                      </v-tab-item>
                                      <v-tab-item id="sell">
                                          <v-form v-model="validSell" ref="formSell">
                                                <v-card>
                                                      <v-card-title>
                                                        <span class="headline">Sell Coin</span>
                                                      </v-card-title>
                                                      <v-card-text>
                                                          <v-container grid-list-md>
                                                              <v-layout wrap>
                                                                  <v-flex xs12>
                                                                      <v-text-field label="Coin Name" v-model="sellItem.coin" disabled></v-text-field>
                                                                    </v-flex>
                                                                    <v-flex xs12 sm6 md3>
                                                                      <v-text-field label="Sell Amount" v-model="sellItem.sellAmount" :rules="sellAmountRules"></v-text-field>
                                                                    </v-flex>
                                                                    <v-flex xs12 sm6 md4>
                                                                      <v-text-field label="Sell Price" v-model="sellItem.sellPrice" :rules="priceRules"></v-text-field>
                                                                    </v-flex>
                                                                    
                                                                    <v-flex xs12 sm6 md4>
                                                                        <v-menu
                                                                          ref="sellMenu"
                                                                          lazy
                                                                          attach="sellDatePicker"
                                                                          :close-on-content-click="false"
                                                                          v-model="sellMenu"
                                                                          transition="scale-transition"
                                                                          full-width
                                                                          offset-y
                                                                          :nudge-right="40"
                                                                          max-width="290px"
                                                                          min-width="290px"
                                                                          :return-value.sync="sellItem.soldDate"
                                                                        >
                                                                             <v-text-field @click.native="stopOverFlow()" slot="activator" label="Sold on" v-model="sellItem.soldDate" readonly :rules="dateRules" id="sellDate"></v-text-field>
                                                                              <v-date-picker v-model="sellItem.soldDate" no-title scrollable actions>
                                                                                <template slot-scope="{ save, cancel }">
                                                                                    <v-card-actions>
                                                                                        <v-spacer></v-spacer>
                                                                                        <v-btn flat color="primary" @click="sellMenu = false">Cancel</v-btn>
                                                                                        <v-btn flat color="primary" @click="$refs.sellMenu.save(sellItem.soldDate)">OK</v-btn>
                                                                                    </v-card-actions>
                                                                                </template>
                                                                            </v-date-picker>
                                                                    </v-menu>
                                                                        </v-flex>
                                                              </v-layout>
                                                          </v-container>
                                                      </v-card-text>
                                                      <v-card-actions>
                                                        <v-spacer></v-spacer>
                                                        <v-btn color="blue darken-1" flat @click.native="close">Cancel</v-btn>
                                                        <v-btn color="blue darken-1" flat @click.native="sell" :disabled="!validSell">Sell</v-btn>
                                                      </v-card-actions>
                                                </v-card>
                                          </v-form>
                                      </v-tab-item>
                                      
                                  </v-tabs-items>
                                  
                                </v-tabs>
                                
                              </v-dialog>
                               <v-data-table
                                   
                                   class="detailTable"
                                   :headers="headers"
                                   :items="itemsToDisplay"
                                   :search="search"
                                   :pagination.sync="pagination"
                                   hide-actions
                                >
                                   <template slot="headerCell" slot-scope="props">
                                       <v-tooltip bottom>
                                           <span slot="activator">
                                               {{props.header.text}}
                                           </span>
                                           <span>
                                               {{props.header.text}}
                                           </span>
                                       </v-tooltip>
                                   </template>
                                   <template slot="items" slot-scope="props">
                                       <td>{{props.item.coin}}</td>
                                       <td class="text-xs-center">$ {{props.item.marketPrice}} <div class="text-xs-center" style="font-size:10px;">{{props.item.amount}} @ $ {{props.item.buyPrice}}</div></td>
                                       <td class="text-xs-right">$ {{props.item.totalValue}}</td>
                                       <td class="text-xs-right">$ {{props.item.profitLoss}}</td>
                                       <td class="text-xs-right">{{props.item.change}} %</td>
                                       <td class="justify-center layout px-0">
                                            <v-btn icon class="mx-0" @click="editItem(props.item)">
                                              <i class="material-icons" color="teal">mode_edit</i>
                                            </v-btn>
                                            <v-btn icon class="mx-0" @click="deleteItem(props.item)">
                                              <i class="material-icons" color="pink">delete</i>
                                            </v-btn>
                                      </td>
                                   </template>
                               </v-data-table>
                               <div class="text-xs-center">
                                   <v-pagination v-model="pagination.page" :length="pages" circle></v-pagination>
                               </div>
                           </v-app> 
                       </div>
                       <div class="mdl-tabs__panel coin-sold" id="sold">
                           <v-app id="inspire2">
                               <v-data-table
                                   
                                   class="detailTable"
                                   :headers="sellHeaders"
                                   :items="soldItemsToDisplay"
                                   :search="search"
                                   :pagination.sync="pagination2"
                                   hide-actions
                                >
                                   <template slot="headerCell" slot-scope="props">
                                       <v-tooltip bottom>
                                           <span slot="activator">
                                               {{props.header.text}}
                                           </span>
                                           <span>
                                               {{props.header.text}}
                                           </span>
                                       </v-tooltip>
                                   </template>
                                   <template slot="items" slot-scope="props">
                                       <td>{{props.item.coin}}</td>
                                       <td class="text-xs-center">$ {{props.item.sellPrice}} <div class="text-xs-center" style="font-size:10px;">{{props.item.amount}} @ $ {{props.item.buyPrice}}</div></td>
                                       <td class="text-xs-right">$ {{props.item.sellTotalValue}}</td>
                                       <td class="text-xs-right">$ {{props.item.profitLoss}}</td>
                                       <td class="text-xs-right">{{props.item.change}} %</td>
                                       
                                   </template>
                               </v-data-table>
                               <div class="text-xs-center">
                                   <v-pagination v-model="pagination2.page" :length="pages2" circle></v-pagination>
                               </div>
                           </v-app>
                       </div>
                   </div>
               </div>
           </div>

    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Script" runat="server">
    <script type="text/javascript">


        //Coin_holdings
        var portfolio_coin_holdings = <%=JSON_COIN_data%>;
        console.log(portfolio_coin_holdings);
        var holdingsPortfolio = [];
        var soldPortfolio = [];
        var emptyPortfolio = [];
        portfolio_coin_holdings.forEach(function (e, i) {
            if (e != null) {
                if (e.status == 1) {
                    if (e.coin_amount > 0) {
                        holdingsPortfolio.push(populateHoldingsPortfolio(e));
                    } else {
                        emptyPortfolio.push(populateEmptyPortfolio(e));
                    }
                }
            }
            
           
        });
        portfolio_coin_holdings.forEach(function (e, i) {
            if (e != null) {
                if (e.status == 2) {
                    soldPortfolio.push(populateSoldPortfolio(e));
                }
            }
        });
        console.log(holdingsPortfolio);
        console.log(soldPortfolio);
        console.log(emptyPortfolio);
        //Populate Empty
        function populateEmptyPortfolio(item) {
            var foo = [];
            foo.trans_ID = item.trans_ID;
            foo.buyPrice = item.price.toFixed(2);
            return foo;
        }
        //Populate Coins
        function populateHoldingsPortfolio(item) {
            var foo = [];
            var APIdata = JSON.parse(item.APIdata).RAW;
            APIdata = APIdata[item.coin_symbol].USD;
            console.log(APIdata);
            foo.buy_coin_id = item.buy_coin_id;
            foo.coin_symbol = item.coin_symbol;
            foo.coin = item.coin_name + " (" + item.coin_symbol + ")";
            foo.buyPrice = item.price.toFixed(2);
            foo.buyDate = item.date;
            foo.status = item.status;
            foo.marketPrice = APIdata.PRICE;
            foo.historyData = [];
            JSON.parse(item.HistoryData)['Data'].forEach(function (el) {
                foo.historyData.push([el['time'], el['close']]);
            });
            foo.amount = item.coin_amount.toFixed(2);
            foo.totalValue = foo.marketPrice * foo.amount;
            foo.trans_ID = item.trans_ID;
            foo.totalValue = foo.totalValue.toFixed(2);
            foo.profitLoss = (foo.marketPrice * foo.amount) - (foo.buyPrice * foo.amount);
            foo.profitLoss = foo.profitLoss.toFixed(2);
            foo.change = ((foo.marketPrice * foo.amount) / (foo.buyPrice * foo.amount)) * 100 - 100;
            foo.change = foo.change.toFixed(2);
            return foo;
        }
        function populateSoldPortfolio(item) {
            var foo = [];
            foo.buy_coin_id = item.buy_coin_id;
            foo.coin_symbol = item.coin_symbol;
            foo.trans_ID = item.trans_ID;
            foo.coin = item.coin_name + " (" + item.coin_symbol + ")";
            foo.buyPrice = 0;
            emptyPortfolio.forEach(function (e, i) {
                if (e.trans_ID == foo.buy_coin_id) {
                    foo.buyPrice = parseFloat(e.buyPrice);
                }
            });
            if (foo.buyPrice == 0) {
                holdingsPortfolio.forEach(function (e, i) {
                    if (e.trans_ID == foo.buy_coin_id) {
                        foo.buyPrice = parseFloat(e.buyPrice);
                    }
                });
            }
            foo.sellPrice = item.price;
            foo.sellDate = item.date;
            foo.status = item.status;
            foo.amount = item.coin_amount;
            foo.buyTotalValue = (foo.buyPrice * foo.amount).toFixed(2);
            foo.sellTotalValue = (foo.sellPrice * foo.amount).toFixed(2);
            
            foo.profitLoss = foo.sellTotalValue - foo.buyTotalValue;
            foo.profitLoss = foo.profitLoss.toFixed(2);
            foo.change = (parseFloat(foo.sellTotalValue) / parseFloat(foo.buyTotalValue)) * 100 - 100;
            foo.change = foo.change.toFixed(2);
            return foo;
        }
        //Handle Portfolio Chart
        function drawPortfolioChart(data) {

            var chart = Highcharts.stockChart('chart-portfolio', {
                title: {
                    text: 'Portfolio 1 Week Chart'
                },

                rangeSelector: {
                    enabled: false
                },
                scrollbar: {
                    enabled: false
                },
                series: [{
                    name: 'Total Portfolio',
                    data: data,
                    type: 'area',
                    threshold: null,
                    tooltip: {
                        valueDecimals: 2
                    }
                }],
                responsive: {
                    rules: [{
                        condition: {
                            maxWidth: 500
                        },
                        chartOptions: {
                            chart: {
                                height: 300
                            },
                            subtitle: {
                                text: null
                            },
                            navigator: {
                                enabled: false
                            }
                        }
                    }]
                },
                credits: {
                    enabled: false
                },
                navigator: {
                    enabled: false
                },
                navigation: {
                    buttonOptions: {
                        enabled: false
                    }
                }
            });
        }
        function drawPieChart(data) {
            console.log(data);
            Highcharts.chart('pie-chart', {
                chart: {
                    plotBackgroundColor: null,
                    plotBorderWidth: null,
                    plotShadow: false,
                    type: 'pie'
                },
                title: {
                    text: 'Coins Held'
                },
                tooltip: {
                    pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
                },
                plotOptions: {
                    pie: {
                        allowPointSelect: true,
                        cursor: 'pointer',
                        dataLabels: {
                            enabled: false
                        },
                        showInLegend: true
                    }
                },
                series: [{
                    name: 'Coin',
                    colorByPoint: true,
                    data: data
                }],
                credits: {
                    enabled: false
                }
            });
        }
        var portfolioChartData = [];
        function getPortfolioChartData() {

            holdingsPortfolio.forEach(function (e, i) {
                e.historyData.forEach((e2) => {
                    e2[1] *= parseFloat(e.amount);
                });
            });
            //Deep Copy Portfolio Chart Data
            holdingsPortfolio[0].historyData.forEach(function (e) {
                portfolioChartData.push(deepCopy(e));
            });
            //Adding the value to portfolioChartData
            portfolioChartData.forEach(function (e3, k) {
                holdingsPortfolio.forEach(function (e, i) {
                    if (i != 0) {
                        e.historyData.forEach(function (e2, i2) {

                            if (k == i2) {

                                e3[1] += e2[1];
                            }
                        });
                    }

                });
            });


            console.log(portfolioChartData);
        }
        function deepCopy(arr) {
            var foo = [];
            arr.forEach(function (e) {
                foo.push(e);
            });
            return foo;
        }
        if (holdingsPortfolio.length > 0) {
            getPortfolioChartData();
        }

        
        //Handle Pie Chart
        var pieChartData = [];

        function getPieChartData() {

            var bar = {};
            var total = 0;
            var flag = false;
            holdingsPortfolio.forEach(function (e, i) {
                total += parseFloat(e.totalValue);
            });
            holdingsPortfolio.forEach((e, i) => {
                bar = {};
                flag = false;
                bar.name = e.coin_symbol;
                pieChartData.forEach((e2, i2) => {
                    if (e2.name == bar.name) {
                        e2.y += (parseFloat(e.totalValue) / total) * 100;
                        flag = true;
                    }
                });
                if (!flag) {
                    bar.y = (parseFloat(e.totalValue) / total) * 100;
                    pieChartData.push(bar);
                }
            });
            pieChartData[0].sliced = true;
            pieChartData[0].selected = true;
            console.log(total);

        }
        if (holdingsPortfolio.length > 0) {
            getPieChartData();
        }


        
        var vm = new Vue({
            el: '#app',
            data: {
                active: null,
                validEdit: true,
                validSell: true,
                
                sellAmountRules: [
                    v => !!v || 'Field is required',
                    v => (v && !isNaN(v) && ~~v == v && v > 0) || 'Field has to be in correct format',
                    v => (v && v <= vm.sellItem.amount) || 'The amount must not exceed holdings'
                ],
                amountRules: [
                    v => !!v || 'Field is required',
                    v => (v && !isNaN(v) && ~~v == v && v > 0) || 'Field has to be in correct format'
                ],
                priceRules: [
                    v => !!v || 'Field is required',
                    v => (v && !isNaN(v) && v > 0) || 'Field has to be in correct format'
                ],
                dateRules: [
                    v => !!v || 'Field is required'
                ],
                sellMenu: false,
                menu: false,
                //Dialog for Creating Coins
                createCoinDialog: false,
                validCreate: true,
                menuCreate: false,
                loading: false,
                coinList: [],
                searchForCoin: null,                                                                                                                                                                                                  
                coins: [ "BTC", "ETH", "XRP", "BCH", "NEO", "LTC", "ADA", "EOS", "XLM", "VEN", "IOTA", "XMR", "TRX", "ETC", "LSK", "QTUM", "OMG", "XVG", "USDT", "XRB"],
                createRules: [
                    v => !!v || 'Field is required'
                ],
                //Edit/Sell Dialog
                dialog: false,
                search: '',
                searchSell: '',
                //For Current
                pagination: {},
                //For Sold
                pagination2: {},
                selected: [],
                headers: [
                    {
                        text: '#  Coin',
                        align: 'left',
                        value: 'coin',
                        sortable: false
                    },
                    {
                        text: 'Price',
                        align: 'center',
                        value: 'price',
                        sortable: false
                    },
                    {
                        text: 'Total Value (Based on Market Value)',
                        align: 'right',
                        value: 'totalValue',
                        sortable: false
                    },
                    {
                        text: 'Profit/Loss',
                        align: 'right',
                        value: 'profitLoss',
                        sortable: false
                    },
                    {
                        text: 'Change',
                        align: 'right',
                        value: 'change',
                        sortable: false
                    },
                    { text: 'Actions', value: 'name', sortable: false }
                ],
                sellHeaders: [
                    {
                        text: '#  Coin',
                        align: 'left',
                        value: 'coin',
                        sortable: false
                    },
                    {
                        text: 'Price',
                        align: 'center',
                        value: 'price',
                        sortable: false
                    },
                    {
                        text: 'Total Value',
                        align: 'right',
                        value: 'totalValue',
                        sortable: false
                    },
                    {
                        text: 'Profit/Loss',
                        align: 'right',
                        value: 'profitLoss',
                        sortable: false
                    },
                    {
                        text: 'Change',
                        align: 'right',
                        value: 'change',
                        sortable: false
                    }
                ],
                items: holdingsPortfolio,
                soldItems: soldPortfolio,
                emptyItems: emptyPortfolio,
                portfolioData: portfolioChartData,
                allCoinsPortfolioData: [],
                soldItemsToDisplay: [],
                itemsToDisplay: [],
                editedItem: {
                    coin: '',
                    price: 0,
                    totalValue: '0',
                    profitLoss: '0',
                    change: 0,
                    amount: 0,
                    buyPrice: 0.00,
                    buyDate: ''
                },
                defaultItem: {
                    coin: '',
                    price: 0,
                    totalValue: '0',
                    profitLoss: '0',
                    change: 0,
                    amount: 0,
                    buyPrice: 0.00,
                    buyDate: ''
                },
                //Dummy to hold value to sell
                sellItem: {
                    coin: '',
                    price: 0,
                    totalValue: '0',
                    profitLoss: '0',
                    change: 0,
                    amount: 0,
                    buyPrice: 0.00,
                    buyDate: '',
                    sellAmount: 0,
                    soldDate: ''
                },
                defaultSellItem: {
                    coin: '',
                    price: 0,
                    totalValue: '0',
                    profitLoss: '0',
                    change: 0,
                    amount: 0,
                    buyPrice: 0.00,
                    buyDate: '',
                    sellAmount: 0,
                    soldDate: ''
                },
                //Dummy value for creating coin
                coinCreate: {
                    coin: '',
                    amount: 0,
                    buyPrice: 0.00,
                    buyDate: ''
                },
                coinCreateDefault: {
                    coin: '',
                    amount: 0,
                    buyPrice: 0.00,
                    buyDate: ''
                }
                
            },
            computed: {
                //For Current
                pages() {
                    if (this.pagination.rowsPerPage == null || this.pagination.totalItems == null) {
                        return 0;
                    }
                    return Math.ceil(this.pagination.totalItems / this.pagination.rowsPerPage)
                },
                //For Sold
                pages2() {
                    if (this.pagination2.rowsPerPage == null || this.pagination2.totalItems == null) {
                        return 0;
                    }
                    return Math.ceil(this.pagination2.totalItems / this.pagination2.rowsPerPage)
                },
                //For Edit
                datePicker() {
                    return document.getElementById('buyDate');
                },
                //For Sell
                sellDatePicker() {
                    return document.getElementById('sellDate');
                },
                //For Create
                createDatePicker() {
                    return document.getElementById('createDate');
                },
                attachCoinName() {
                    return document.getElementById('coinNameInput');
                },
                //Compute Acquisation Cost
                acquisitionCost() {
                    var cost = 0;
                    this.items.forEach(function (e, i) {
                        cost += parseFloat(e.buyPrice) * parseFloat(e.amount);
                    });
                    return cost.toFixed(2);
                },
                //Compute Holdings 
                holdings() {
                    var cost = 0;
                    this.items.forEach(function (e, i) {
                        cost += parseFloat(e.totalValue);
                    });
                    return cost.toFixed(2);
                },
                //Compute Realized P/L
                realizedPL() {
                    var cost = 0;
                    this.soldItems.forEach(function (e, i) {
                        cost += parseFloat(e.profitLoss);
                    });
                    return cost.toFixed(2);
                },
                //Total Investment on Sold
                investmentSold() {
                    var cost = 0;
                    this.soldItems.forEach(function (e, i) {
                        cost += parseFloat(e.buyPrice) * parseFloat(e.amount);
                    });
                    return cost.toFixed(2);
                },
                //Total Investment on Cashflow
                investmentCashflow() {
                    var cost = 0;
                    this.soldItems.forEach(function (e, i) {
                        cost += parseFloat(e.buyPrice) * parseFloat(e.amount);
                    });
                    this.items.forEach(function (e, i) {
                        cost += parseFloat(e.buyPrice) * parseFloat(e.amount);
                    });
                    return cost.toFixed(2);

                },
                //Total Revenue
                revenue() {
                    var cost = 0;
                    this.soldItems.forEach(function (e, i) {
                        cost += parseFloat(e.sellPrice) * parseFloat(e.amount);
                    });
                    return cost.toFixed(2);
                },
                //Net cashflow
                netCashflow() {
                    return (this.revenue - this.investmentCashflow).toFixed(2);
                },
                //Portfolio Change
                portfolioChange() {
                    if (this.portfolioData.length > 0) {
                        return (this.portfolioData[portfolioChartData.length - 1][1] - this.portfolioData[0][1]).toFixed(2);
                    }
                    else {
                        return "NaN";
                    }
                },
                //Portfolio Change in Percentage
                portfolioChangePercentage() {
                    if (this.portfolioData.length > 0) {
                        return (((this.portfolioData[portfolioChartData.length - 1][1] / this.portfolioData[0][1]) * 100) - 100).toFixed(2);
                    }
                    else {
                        return "NaN";
                    }
                    
                },
                //Portfolio MIN
                portfolioMin() {
                    var res = "NaN";
                    if (this.portfolioData.length > 0) {
                        var res = this.portfolioData[0][1];
                        this.portfolioData.forEach(function (e) {
                            if (res > e[1]) {
                                res = e[1];
                            }
                        });
                        res = res.toFixed(2);
                    }
                    
                    return res;
                },
                //Portfolio MAX
                portfolioMax() {
                    var res = "NaN";
                    if (this.portfolioData.length > 0) {
                        var res = this.portfolioData[0][1];
                        this.portfolioData.forEach(function (e) {
                            if (res < e[1]) {
                                res = e[1];
                            }
                        });
                        res = res.toFixed(2);
                    }

                    return res;
                },
                //Least Profitable
                leastProfitableCoinName() {
                    var res = "NaN";
                    if (this.allCoinsPortfolioData.length > 0) {
                        res = this.allCoinsPortfolioData[0].coin_symbol;
                        var placeholder = this.allCoinsPortfolioData[0].coin_history[this.allCoinsPortfolioData[0].coin_history.length - 1][1] - this.allCoinsPortfolioData[0].coin_history[0][1]
                        this.allCoinsPortfolioData.forEach(function (e) {

                            if (placeholder > e.coin_history[e.coin_history.length - 1][1] - e.coin_history[0][1]) {
                                res = e.coin_symbol;
                            }
                        });
                    }
                    
                    return res;
                },
                //Least Profitable by money
                leastProfitableCoinMoney() {
                    var res = 0;
                    if (this.allCoinsPortfolioData.length > 0) {
                        res = this.allCoinsPortfolioData[0].coin_history[this.allCoinsPortfolioData[0].coin_history.length - 1][1] - this.allCoinsPortfolioData[0].coin_history[0][1]
                        this.allCoinsPortfolioData.forEach(function (e) {

                            if (res > e.coin_history[e.coin_history.length - 1][1] - e.coin_history[0][1]) {
                                res = e.coin_history[e.coin_history.length - 1][1] - e.coin_history[0][1];
                            }
                        });
                        res = res.toFixed(2);
                    }
                    return res;
                },
                //Least Profitable by Percentage
                leastProfitableCoinPercentage() {
                    var res = 0;
                    if (this.allCoinsPortfolioData.length > 0) {
                        res = ((this.allCoinsPortfolioData[0].coin_history[this.allCoinsPortfolioData[0].coin_history.length - 1][1] / this.allCoinsPortfolioData[0].coin_history[0][1]) * 100) - 100;
                        this.allCoinsPortfolioData.forEach(function (e) {

                            if (res > ((e.coin_history[e.coin_history.length - 1][1] / e.coin_history[0][1]) * 100) - 100) {
                                res = ((e.coin_history[e.coin_history.length - 1][1] / e.coin_history[0][1]) * 100) - 100;
                            }
                        });
                        res = res.toFixed(2);
                    }
                    return res;
                },
                //Most Profitable
                mostProfitableCoinName() {
                    var res = "NaN";
                    if (this.allCoinsPortfolioData.length > 0) {
                        res = this.allCoinsPortfolioData[0].coin_symbol;
                        var placeholder = this.allCoinsPortfolioData[0].coin_history[this.allCoinsPortfolioData[0].coin_history.length - 1][1] - this.allCoinsPortfolioData[0].coin_history[0][1]
                        this.allCoinsPortfolioData.forEach(function (e) {

                            if (placeholder < e.coin_history[e.coin_history.length - 1][1] - e.coin_history[0][1]) {
                                res = e.coin_symbol;
                            }
                        });
                    }

                    return res;
                },
                //Most Profitable Coin Money
                mostProfitableCoinMoney() {
                    var res = 0;
                    if (this.allCoinsPortfolioData.length > 0) {
                        res = this.allCoinsPortfolioData[0].coin_history[this.allCoinsPortfolioData[0].coin_history.length - 1][1] - this.allCoinsPortfolioData[0].coin_history[0][1];
                        this.allCoinsPortfolioData.forEach(function (e) {

                            if (res < e.coin_history[e.coin_history.length - 1][1] - e.coin_history[0][1]) {
                                res = e.coin_history[e.coin_history.length - 1][1] - e.coin_history[0][1];
                            }
                        });
                        res = res.toFixed(2);
                    }
                    return res;
                },
                //Most Profitable Coin Percentage
                mostProfitableCoinPercentage() {
                    var res = 0;
                    if (this.allCoinsPortfolioData.length > 0) {
                        res = ((this.allCoinsPortfolioData[0].coin_history[this.allCoinsPortfolioData[0].coin_history.length - 1][1] / this.allCoinsPortfolioData[0].coin_history[0][1]) * 100) - 100;
                        this.allCoinsPortfolioData.forEach(function (e) {

                            if (res < ((e.coin_history[e.coin_history.length - 1][1] / e.coin_history[0][1]) * 100) - 100) {
                                res = ((e.coin_history[e.coin_history.length - 1][1] / e.coin_history[0][1]) * 100) - 100;
                            }
                        });
                        res = res.toFixed(2);
                    }
                    return res;
                }
            }, watch: {
                dialog(val) {
                    val || this.close()
                },
                searchForCoin(val) {
                    val && this.querySelections(val)
                }
            },

            created() {
                this.initialize();
            },

            methods: {
                //Populate Items to display
                populateHoldings(item) {
                    var foo = [];
                    foo["status"] = item.status;
                    foo["coin_symbol"] = item.coin_symbol;
                    foo["transaction_id"] = item.trans_ID;
                    foo["sell_coin_id"] = item.sell_coin_id;
                    foo["coin"] = item.coin;
                    foo["buyPrice"] = item.buyPrice;
                    foo["marketPrice"] = item.marketPrice;
                    foo["totalValue"] = item.totalValue;
                    foo["profitLoss"] = item.profitLoss;
                    foo["buyDate"] = item.buyDate;
                    foo["change"] = item.change;
                    foo["amount"] = item.amount;
                    return foo;
                },
                populateSellings(item) {
                    var foo = [];
                    foo["coin"] = item.coin;
                    foo["sellTotalValue"] = item.sellTotalValue;
                    foo["buyPrice"] = item.buyPrice;
                    foo["sellPrice"] = item.sellPrice;
                    foo["amount"] = item.amount;
                    foo["profitLoss"] = item.profitLoss;
                    foo["change"] = item.change;
                    return foo;
                },
                populatePortfolioData(item) {
                    var foo = [];
                    foo["coin_symbol"] = item.coin_symbol;
                    foo["coin_history"] = item.historyData;
                    return foo;
                },
                initialize() {
                    this.items.forEach((e) => {
                        this.allCoinsPortfolioData.push(this.populatePortfolioData(e));
                    });
                    console.log(this.allCoinsPortfolioData);
                    this.items.forEach((item, index) => {
                        if (item != null && item.status == 1) {
                            this.itemsToDisplay.push(this.populateHoldings(item))
                        }
                    });
                    this.soldItems.forEach((item, index) => {
                        this.soldItemsToDisplay.push(this.populateSellings(item));
                    });
                },
                
                editItem(item) {

                    this.editedIndex = this.itemsToDisplay.indexOf(item)
                    this.editedItem = Object.assign({}, this.items[this.editedIndex])
                    this.sellItem = Object.assign({ sellAmount: this.editedItem.amount, soldDate: this.editedItem.buyDate, sellPrice: this.editedItem.marketPrice }, this.items[this.editedIndex])
                    //console.log(this.sellItem);
                    this.dialog = true
                },

                deleteItem(item) {
                    const index = this.itemsToDisplay.indexOf(item)
                    if (confirm('Are you sure you want to delete this item?')) {
                        var bodyAjax = {
                            type: 'delete_coin',
                            transaction_id: this.items[index].trans_ID
                        }
                        console.log(bodyAjax);
                        $.ajax({
                            type: "POST",
                            url: "portfolio.aspx",
                            data: bodyAjax,
                            success: function (data) {
                                if (data == 1) {
                                    location.reload();
                                } else {
                                    alert(data);
                                }
                            },
                            error: function (data) {
                                alert(data)
                            }
                        });
                    }
                },
                
                close() {
                    this.dialog = false
                    this.createCoinDialog = false
                    setTimeout(() => {
                        this.editedItem = Object.assign({}, this.defaultItem)
                        this.sellItem = Object.assign({}, this.defaultSellItem)
                        this.coinCreate = Object.assign({}, this.coinCreateDefault)
                        this.editedIndex = -1
                    }, 300)
                   
                },
                
                update() {
                    
                    //Implementing AJAX request for Update
                    var bodyAjax = {
                        type: "update_coin",
                        transaction_id: this.editedItem.trans_ID,
                        amount: this.editedItem.amount,
                        price: this.editedItem.buyPrice,
                        date: this.editedItem.buyDate
                    };
                    console.log(bodyAjax);
                    $.ajax({
                        type: "POST",
                        url: "portfolio.aspx",
                        data: bodyAjax,
                        success: function (data) {
                            if (data == 1) {
                                location.reload();
                            } else {
                                alert(data);
                            }
                        },
                        error: function (data) {
                            console.log(data);
                        }
                    });
                },
                sell() {
                    //Implementing AJAX request for Sell
                    console.log
                    var bodyAjax = {
                        type: "sell_coin",
                        coin: this.coins.indexOf(this.sellItem.coin_symbol) +1,
                        transaction_id: this.sellItem.trans_ID,
                        amount: this.sellItem.sellAmount,
                        remainAmount: this.sellItem.amount - this.sellItem.sellAmount,
                        price: this.sellItem.sellPrice,
                        date: this.sellItem.soldDate
                    };
                    console.log(bodyAjax);
                    $.ajax({
                        type: "POST",
                        url: "portfolio.aspx",
                        data: bodyAjax,
                        success: function (data) {
                            if (data == 1) {
                                location.reload();
                            }
                            else {
                                alert(data);
                            }
                        },
                        error: function (data) {
                            console.log(data);
                        }
                    });
                },
                create() {
                    //Implementing AJAX request for Create
                    var bodyAjax = {
                        type: "add_coin",
                        coin: this.coins.indexOf(this.coinCreate.coin) + 1,
                        amount: this.coinCreate.amount,
                        price: this.coinCreate.buyPrice,
                        date: this.coinCreate.buyDate
                    };
                    
                    $.ajax({
                        type: "POST",
                        url: "portfolio.aspx",
                        data: bodyAjax,
                        success: function (data) {
                            location.reload();
                        },
                        error: function (data) {
                            alert(data);
                        }
                    });
                },
                compare(a, b) {
                    return (
                        isFinite(a = this.convertToDateObject(a).valueOf()) &&
                            isFinite(b = this.convertToDateObject(b).valueOf()) ?
                            (a > b) - (a < b) :
                            NaN
                    )
                },
                convertToDateObject(dateString) {
                    return (
                        dateString.constructor === Date ? dateString :
                            dateString.constructor === Number ? new Date(dateString) :
                                dateString.constructor === String ? new Date(dateString) :
                                    typeof dateString === "object" ? new Date(dateString.year, dateString.month, dateString.date) :
                                        NaN
                    )
                },
                /**
                 * Custom Class to fix Tabs - overflow attribute with Date Picker
                 */
                stopOverFlow() {
                    var tabs = $('.tabs__items');
                    tabs.css({ 'overflow': 'visible' });
                },
                overFlow() {
                    var tabs = $('.tabs__items');
                    tabs.css({ 'overflow': 'hidden' });
                },
                //Create Coin
                createCoin() {
                    this.createCoinDialog = true;
                },
                querySelections(v) {
                    this.loading = true
                    setTimeout(() => {
                        this.coinList = this.coins.filter((e) => {
                            return (e || '').toLowerCase().indexOf((v || '').toLowerCase()) != -1
                        });
                        this.loading = false
                    },500);
                }
                
            }
        });
        drawPortfolioChart(portfolioChartData);
        drawPieChart(pieChartData);
    </script>
</asp:Content>