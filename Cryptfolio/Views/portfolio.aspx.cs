using System;
using System.Collections.Generic;
using System.Globalization;
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
    public partial class WebForm9 : System.Web.UI.Page
    {

        protected String[] coin_holdings;
        protected String[] coin_data = new String[1000];
        protected Object JSON_COIN_data;

        protected void Page_Load(object sender, EventArgs e)
        {
            // check GET or POST request
            if (HttpContext.Current.Request.HttpMethod == "POST")
            {

                HandleAJAXRequest_AddCoin();
            }
            else
            {
                HandleGET();
            }
        }

        protected void HandleGET()
        {
            // First list all coins which that users have been already holding
            coin_holdings = new String[2] { "BTC", "ETH" };

            // Secondly send GET request to API in order to get data for each coin
            int index = 0;
            for (int i = 0; i < coin_holdings.Length; i++)
            {
                String data = Send_GET_REQUEST_Historical(coin_holdings[i], "USD", 1000);
                coin_data[index++] = data;

            }
            var serializer = new JavaScriptSerializer();
            var json = serializer.Serialize(coin_data);
            JSON_COIN_data = json;
        }

        // Handle AJAX request

        protected void HandleAJAXRequest_AddCoin()
        {
            Response.Clear();
            Response.ContentType = "text/plain";

            // get data from body ajax

            if (Request.Params["type"].ToString() == "add_coin")
            {
                Response.Write("POST:The value Add Coin ");
                Int32 amount;
                int.TryParse(Request.Params["amount"], out amount);
                String coin = Request.Params["coin"].ToString();
                DateTime date;
                DateTime.TryParseExact(Request.Params["date"].ToString(), "yyyy-MM-dd", null, DateTimeStyles.None, out date);
                // DateTime.TryParse(Request.Params["date"].ToString(), out date);

                Response.Write(amount + " " + coin + " ");
                Response.Write(date.ToString());
            }
            else if (Request.Params["type"].ToString() == "nope")
            {
                Response.Write("POST:The value is none");
            }

            // validate data

            // add data to table

            Response.End();

        }

        // Handle Get data from API
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