using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
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
        SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);

        protected void Page_Load(object sender, EventArgs e)
        {
            // check GET or POST request
            if (HttpContext.Current.Request.HttpMethod == "POST")
            {
                String POST_TYPE = Request.Params["type"].ToString();
                if (POST_TYPE == "add_coin")
                {
                    HandleAJAXRequest_AddCoin();
                } 
                else if (POST_TYPE == "sell_coin")
                {
                    HandleAJAXRequest_SellCoin();
                }
                else if (POST_TYPE == "update_coin")
                {
                    HandleAJAXRequest_UpdateCoin();
                }
                else
                {
                    Response.Write("POST:The value is none");
                }


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

        // Handle AJAX request add coin

        protected void HandleAJAXRequest_AddCoin()
        {
            Response.Clear();
            Response.ContentType = "text/plain";

            // get data from body ajax

            Double amount, price;
            double.TryParse(Request.Params["amount"], out amount);
            double.TryParse(Request.Params["price"], out price);

            String coin = Request.Params["coin"].ToString();
            DateTime date;
            DateTime.TryParseExact(Request.Params["date"].ToString(), "yyyy-MM-dd", null, DateTimeStyles.None, out date);
            // DateTime.TryParse(Request.Params["date"].ToString(), out date);

            Response.Write(amount + " " + coin + " ");
            Response.Write(date.ToString());

            // validate data

            // add data to table

            Response.End();

        }

        // Handle Sell coin
        protected void HandleAJAXRequest_SellCoin()
        {
            Response.Clear();
            Response.ContentType = "text/plain";

            // get data from body ajax

            Double amount, price;
            Int32 portfolio, coin;

            double.TryParse(Request.Params["price"], out price);
            Int32.TryParse(Request.Params["p_ID"], out portfolio);
            Int32.TryParse(Request.Params["c_ID"], out coin);
            
            DateTime date;
            DateTime.TryParseExact(Request.Params["date"].ToString(), "yyyy-MM-dd", null, DateTimeStyles.None, out date);
            // DateTime.TryParse(Request.Params["date"].ToString(), out date);
            
            Response.Write(date.ToString());

            // validate data

            // add data to table
            SqlCommand cmd = new SqlCommand("update Transaction set price = '" + price + "' where p_ID = '" + portfolio + "' and c_ID = '" + coin + "')", con);

            Response.End();

        }

        // Handle update coin
        protected void HandleAJAXRequest_UpdateCoin()
        {
            Response.Clear();
            Response.ContentType = "text/plain";

            // get data from body ajax

            Double price, amount;
            double.TryParse(Request.Params["amount"], out amount);
            double.TryParse(Request.Params["price"], out price);
            String coin = Request.Params["coin"].ToString();
            DateTime date;
            DateTime.TryParseExact(Request.Params["date"].ToString(), "yyyy-MM-dd", null, DateTimeStyles.None, out date);
            // DateTime.TryParse(Request.Params["date"].ToString(), out date);

            Response.Write(amount + " " + coin + " ");
            Response.Write(date.ToString());

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