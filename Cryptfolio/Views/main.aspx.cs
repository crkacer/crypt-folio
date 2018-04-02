using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Cryptfolio.Views
{
    public partial class WebForm4 : System.Web.UI.Page
    {
        protected String[] Data_COINS = new String[20] { "BTC", "ETH", "XRP", "BCH", "NEO", "LTC", "ADA", "EOS", "XLM", "VEN", "IOTA", "XMR", "TRX", "ETC", "LSK", "QTUM", "OMG", "XVG", "USDT", "XRB" };

        protected Object Data_COINS_Historical;
        protected Object Data_COINS_Current;
        protected String Send_GET_REQUEST(String[] coins, String[] currencies)
        {
            // generate coins string
            String listCoins = "";
            for (int i = 0; i < coins.Length - 1; i++)
            {
                listCoins += coins[i] + ",";
            }
            listCoins += coins[coins.Length - 1];
            // generate currencies string
            String listCurrencies = "";
            for (int i = 0; i < currencies.Length - 1; i++)
            {
                listCurrencies += currencies[i] + ",";
            }
            listCurrencies += currencies[currencies.Length - 1];

            // handle GET request
            StringBuilder sb = new StringBuilder();

            byte[] buf = new byte[8192];

            //do get request

            String url = "https://min-api.cryptocompare.com/data/pricemulti?fsyms=" + listCoins + "&tsyms=" + listCurrencies;
            HttpWebRequest request = (HttpWebRequest)
                WebRequest.Create(url);


            HttpWebResponse response = (HttpWebResponse)
                request.GetResponse();


            Stream resStream = response.GetResponseStream();

            string tempString = null;
            int count = 0;
            //read the data and print it
            do
            {
                count = resStream.Read(buf, 0, buf.Length);
                if (count != 0)
                {
                    tempString = Encoding.ASCII.GetString(buf, 0, count);

                    sb.Append(tempString);
                }
            }
            while (count > 0);
            return sb.ToString();

        }
        protected void Page_Load(object sender, EventArgs e)
        {
            Data_COINS_Current = Send_GET_REQUEST(Data_COINS, new String[1] { "USD" });
            // Response.Write(a);
            Dictionary<String, String> historical_coins = new Dictionary<String, String>();
            for (int i = 0; i < Data_COINS.Length; i++)
            {
                historical_coins.Add(Data_COINS[i].ToString(), Send_GET_REQUEST_Historical(Data_COINS[i], "USD", 30));
            }
            var serializer = new JavaScriptSerializer();
            var json = serializer.Serialize(historical_coins);
            Data_COINS_Historical = json;


        }


        protected string ALL_COINS
        {
            get
            {
                return Send_GET_REQUEST(Data_COINS, new String[1] { "USD" });

            }
        }



        // Handle SELL coin

        [System.Web.Services.WebMethod]
        public string Sell_Coin(String coin, int userID)
        {
            String price = Send_GET_REQUEST(new String[1] { coin }, new String[1] { "USD" });
            return coin;
        }


        [System.Web.Services.WebMethod]
        public string Buy_Coin(String coin, int userID)
        {
            String price = Send_GET_REQUEST(new String[1] { coin }, new String[1] { "USD" });

            return coin;
        }

        protected String Send_GET_REQUEST_Historical(String coin, String currency, int limit)
        {
            // https://min-api.cryptocompare.com/data/histoday?fsym=BTC&tsym=USD&limit=1000&aggregate=3&e=CCCAGG


            // handle GET request
            StringBuilder sb = new StringBuilder();

            byte[] buf = new byte[8192];

            //do get request

            String url = "https://min-api.cryptocompare.com/data/histoday?fsym=" + coin + "&tsym=" + currency + "&limit=" + limit + "&aggregate=3&e=CCCAGG";
            HttpWebRequest request = (HttpWebRequest)
                WebRequest.Create(url);


            HttpWebResponse response = (HttpWebResponse)
                request.GetResponse();


            Stream resStream = response.GetResponseStream();

            string tempString = null;
            int count = 0;
            //read the data and print it
            do
            {
                count = resStream.Read(buf, 0, buf.Length);
                if (count != 0)
                {
                    tempString = Encoding.ASCII.GetString(buf, 0, count);

                    sb.Append(tempString);
                }
            }
            while (count > 0);
            return sb.ToString();
        }

    }
}