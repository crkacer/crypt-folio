using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net;
using System.Security.Cryptography;
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
        protected String[] coin_data_today = new String[1000];
        protected String[,] coin_data_holding = new String[100, 100];
        protected Object JSON_COIN_data, JSON_COIN_data_today, JSON_data_chart;
        protected String profit, acq_cost, holdings, realized_profit, port_min, port_max, least_profit, most_profit, worst_crypto, best_crypto;
        SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
        SqlConnection con2 = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);

        protected void Page_Load(object sender, EventArgs e)
        {
            // check GET or POST request
          

            if (HttpContext.Current.Request.HttpMethod == "POST")
            {
                String POST_TYPE = Request.Params["type"];
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
                if (Session["USERID"] != null) HandleGET();
                else
                {
                    Response.Redirect("login.aspx");
                }
            }
        }

        protected void HandleGET()
        {
            // GET userID
            int userID;
            int.TryParse(Decrypt(Session["USERID"].ToString()), out userID);

            // GET portfolioID
           
            int port_ID;
            int.TryParse(Decrypt(Session["PORTID"].ToString()), out port_ID);

            // GET data for graph 
            Dictionary<String, String> historical_coins = new Dictionary<String, String>();

            // Get all coin from the user's portfolio
            con.Open();
            SqlCommand cmd = new SqlCommand("SELECT * FROM [Transaction] WHERE p_ID = '" + port_ID + "'", con);

            SqlDataReader reader = cmd.ExecuteReader();

            if (reader.HasRows)
            {
                int index = 0;
                while (reader.Read())
                {
                    int coin_ID = reader.GetInt32(2);
                    String coin_name = "";
                    double coin_amount = reader.GetDouble(5);
                    double coin_price = reader.GetDouble(4);
                    Int32 status = reader.GetInt32(3);

                    con2.Open();
                    SqlCommand cmd_coin = new SqlCommand("SELECT * FROM [Coin] WHERE ID = '" + coin_ID + "'", con2);

                    SqlDataReader reader_coin = cmd_coin.ExecuteReader();

                    if (reader_coin.HasRows)
                    {
                        if (reader_coin.Read())
                        {
                            // Secondly send GET request to API in order to get data for each coin
                            coin_name = reader_coin.GetString(2);
                            String data = Send_GET_REQUEST_TODAY_Price(coin_name, "USD");
                            coin_data_today[index] = data;
                            
                            // Send request to get historical data for each coin and push to array
                            historical_coins.Add(coin_name, Send_GET_REQUEST_Historical(coin_name, "USD", 50));
                        }
                    }
                    // TO calculate weight of each coin in portfolio
                    coin_data_holding[index, 0] = coin_ID.ToString();
                    coin_data_holding[index, 1] = coin_name;
                    coin_data_holding[index, 2] = coin_amount.ToString();
                    coin_data_holding[index, 3] = coin_price.ToString();
                    coin_data_holding[index, 4] = status.ToString();

                    index++;
                    reader_coin.Close();
                    con2.Close();
                }
            }
            else
            {
                Console.WriteLine("Portfolio does not have any coin yet");
            }

            var serializer = new JavaScriptSerializer();
        
            var json_coin_today = serializer.Serialize(coin_data_today);
            JSON_COIN_data_today = json_coin_today;

            var json_coin_holding = serializer.Serialize(coin_data_holding);
            JSON_COIN_data = json_coin_holding;
            

            var json_data = serializer.Serialize(historical_coins);
            JSON_data_chart = json_data;


            reader.Close();
        }

        // Handle AJAX request add coin

        protected void HandleAJAXRequest_AddCoin()
        {
            con.Open();
            Response.Clear();
            Response.ContentType = "text/plain";

            // get data from body ajax

            Double amount, price;
            Int32 p_ID, c_ID;
            double.TryParse(Request.Params["amount"], out amount);
            double.TryParse(Request.Params["price"], out price);
            Int32.TryParse(Decrypt(Session["PORTID"].ToString()), out p_ID);

            int.TryParse(Request.Params["coin"].ToString(), out c_ID);
            DateTime date;
            DateTime.TryParseExact(Request.Params["date"].ToString(), "yyyy-MM-dd", null, DateTimeStyles.None, out date);
            // DateTime.TryParse(Request.Params["date"].ToString(), out date);

            //SqlCommand cmd = new SqlCommand("insert into [Transaction] (p_ID, c_ID, status, price, amount, date_created) values ('" + p_ID + "','" + c_ID + "','" + 1 + "','" + price + "','" + amount + "','" + date + "')", con);
            SqlCommand cmd2 = new SqlCommand("INSERT INTO [Transaction] (p_ID, c_ID, status, price, amount, date_created) VALUES (@p_ID, @c_ID, @status, @price, @amount, @date_created);", con);
            cmd2.Parameters.AddWithValue("@p_ID", p_ID);
            cmd2.Parameters.AddWithValue("@c_ID", c_ID);
            cmd2.Parameters.AddWithValue("@status", 1);
            cmd2.Parameters.AddWithValue("@price", price);
            cmd2.Parameters.AddWithValue("@amount", amount);
            cmd2.Parameters.AddWithValue("@date_created", date.ToString());

            cmd2.ExecuteNonQuery();
            
            Response.Write(amount + " " + c_ID + " " + price + " " + date.ToString() + " " + p_ID + " ");

            // validate data

            // add data to table

            Response.End();
            con.Close();
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
            SqlCommand cmd = new SqlCommand("update [Transaction] set price = '" + price + "' where p_ID = '" + portfolio + "' and c_ID = '" + coin + "')", con);

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

        protected String Send_GET_REQUEST_TODAY_Price(String coin, String currency)
        {
            // https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD
            // handle GET request
            StringBuilder sb = new StringBuilder();

            byte[] buf = new byte[8192];

            //do get request

            String url = "https://min-api.cryptocompare.com/data/price?fsym="+ coin+"&tsyms=" + currency + "&e=CCCAGG";
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

        private string Encrypt(string clearText)
        {
            string EncryptionKey = "MAKV2SPBNI99212";
            byte[] clearBytes = Encoding.Unicode.GetBytes(clearText);
            using (Aes encryptor = Aes.Create())
            {
                Rfc2898DeriveBytes pdb = new Rfc2898DeriveBytes(EncryptionKey, new byte[] { 0x49, 0x76, 0x61, 0x6e, 0x20, 0x4d, 0x65, 0x64, 0x76, 0x65, 0x64, 0x65, 0x76 });
                encryptor.Key = pdb.GetBytes(32);
                encryptor.IV = pdb.GetBytes(16);
                using (MemoryStream ms = new MemoryStream())
                {
                    using (CryptoStream cs = new CryptoStream(ms, encryptor.CreateEncryptor(), CryptoStreamMode.Write))
                    {
                        cs.Write(clearBytes, 0, clearBytes.Length);
                        cs.Close();
                    }
                    clearText = Convert.ToBase64String(ms.ToArray());
                }
            }
            return clearText;
        }

        private string Decrypt(string cipherText)
        {
            string EncryptionKey = "MAKV2SPBNI99212";
            byte[] cipherBytes = Convert.FromBase64String(cipherText);
            using (Aes encryptor = Aes.Create())
            {
                Rfc2898DeriveBytes pdb = new Rfc2898DeriveBytes(EncryptionKey, new byte[] { 0x49, 0x76, 0x61, 0x6e, 0x20, 0x4d, 0x65, 0x64, 0x76, 0x65, 0x64, 0x65, 0x76 });
                encryptor.Key = pdb.GetBytes(32);
                encryptor.IV = pdb.GetBytes(16);
                using (MemoryStream ms = new MemoryStream())
                {
                    using (CryptoStream cs = new CryptoStream(ms, encryptor.CreateDecryptor(), CryptoStreamMode.Write))
                    {
                        cs.Write(cipherBytes, 0, cipherBytes.Length);
                        cs.Close();
                    }
                    cipherText = Encoding.Unicode.GetString(ms.ToArray());
                }
            }
            return cipherText;
        }



    }
}