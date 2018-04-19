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
        private Holdings[] coin_data_holding = new Holdings[100];
        protected Object JSON_COIN_data, JSON_COIN_data_today, JSON_data_chart;
        protected String profit, acq_cost, holdings, realized_profit, port_min, port_max, least_profit, most_profit, worst_crypto, best_crypto;
        SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
        SqlConnection con2 = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
        SqlConnection con3 = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
        String[] listCOIN = new String[] {"BTC", "ETH", "XRP", "BCH", "NEO", "LTC", "ADA", "EOS", "XLM", "VEN", "IOTA", "XMR", "TRX", "ETC", "LSK", "QTUM", "OMG", "XVG", "USDT", "XRB"};

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
                else if (POST_TYPE == "delete_coin")
                {
                    HandleAJAXRequest_DeleteCoin();
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
        private class Holdings
        {
            public int trans_ID;
            public int coin_ID;
            public String coin_name;
            public String coin_symbol;
            public double coin_amount;
            public double buy_price;
            public string buy_date;
            public Int32 status;
            public Int32 buy_coin_id;
            public object APIdata;
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
            //Declare Serializerr
            var serializer = new JavaScriptSerializer();
            if (reader.HasRows)
            {
                int index = 0;
                while (reader.Read())
                {
                   
                    int trans_ID = reader.GetInt32(0);
                    int coin_ID = reader.GetInt32(2);
                    String coin_name = "";
                    String coin_symbol = "";
                    double coin_amount = reader.GetDouble(5);
                    double coin_price = reader.GetDouble(4);
                    Int32 status = reader.GetInt32(3);
                    DateTime date_created = reader.GetDateTime(6);
                    Int32 buy_coin_id = reader.GetInt32(7);
                    con2.Open();
                    SqlCommand cmd_coin = new SqlCommand("SELECT * FROM [Coin] WHERE ID = '" + coin_ID + "'", con2);

                    SqlDataReader reader_coin = cmd_coin.ExecuteReader();

                    if (reader_coin.HasRows)
                    {
                        if (reader_coin.Read())
                        {
                            // Secondly send GET request to API in order to get data for each coin
                            coin_name = reader_coin.GetString(2).Trim();
                            coin_symbol = reader_coin.GetString(1).Trim();
            
                            
                            
                        }
                    }
                    // TO calculate weight of each coin in portfolio
                    String data = Send_GET_REQUEST_TODAY_Price(coin_symbol, "USD");
                    Holdings transaction = new Holdings();
                    transaction.trans_ID = trans_ID;
                    transaction.coin_ID = coin_ID;
                    transaction.coin_name = coin_name;
                    transaction.coin_symbol = coin_symbol;
                    transaction.coin_amount = coin_amount;
                    transaction.buy_price = coin_price;
                    transaction.status = status;
                    transaction.buy_date = date_created.ToString("yyyy-MM-dd");
                    transaction.APIdata = data;
                    transaction.buy_coin_id = buy_coin_id;
                    coin_data_holding[index] = transaction;
                    index++;
                    reader_coin.Close();
                    con2.Close();
                }
            }
            else
            {
                Console.WriteLine("Portfolio does not have any coin yet");
            }


            con.Close();
            var json_coin_today = serializer.Serialize(coin_data_today);
            JSON_COIN_data_today = json_coin_today;

            var json_coin_holding = serializer.Serialize(coin_data_holding);
            JSON_COIN_data = json_coin_holding;
            
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
            CultureInfo provider = CultureInfo.InvariantCulture;
            // get data from body ajax
            Double amount, remain;
            Double price;
            Int32 portfolio, transaction_id, coin;
            Double.TryParse(Request.Params["amount"], out amount);
            Double.TryParse(Request.Params["price"], out price);
            Int32.TryParse(Decrypt(Session["PORTID"].ToString()), out portfolio);
            Double.TryParse(Request.Params["remainAmount"], out remain);
            Int32.TryParse(Request.Params["transaction_id"], out transaction_id);
            Int32.TryParse(Request.Params["coin"], out coin);
            DateTime date;
            date = DateTime.ParseExact(Request.Params["date"], "yyyy-MM-dd", provider);

            // DateTime.TryParse(Request.Params["date"].ToString(), out date);

         

            
            con.Open();
            SqlCommand cmd = new SqlCommand("INSERT INTO [Transaction] (p_ID, c_ID, status, price, amount, date_created) VALUES (@p_ID, @c_ID, @status, @price, @amount, @date_created);", con);
            cmd.Parameters.AddWithValue("@p_ID", portfolio);
            cmd.Parameters.AddWithValue("@c_ID", coin);
            cmd.Parameters.AddWithValue("@status", 2);
            cmd.Parameters.AddWithValue("@price", price);
            cmd.Parameters.AddWithValue("@amount", amount);
            cmd.Parameters.AddWithValue("@date_created", date.ToString());    
            cmd.Parameters.AddWithValue("@buy_coin_ID", transaction_id);
            cmd.ExecuteNonQuery();

            con.Close();
            con2.Open();
            //Update the amount of actual coin being sold
            SqlCommand cmd2 = new SqlCommand("UPDATE [Transaction] SET amount = @amount WHERE ID = @ID", con2);
            cmd2.Parameters.AddWithValue("@amount", remain);
            cmd2.Parameters.AddWithValue("@ID", transaction_id);
            cmd2.ExecuteNonQuery();
            Response.Write(1);
            Response.End();

        }

        // Handle update coin
        protected void HandleAJAXRequest_UpdateCoin()
        {
            con.Open();
            Response.Clear();
            Response.ContentType = "text/plain";

            // get data from body ajax

            Double amount;
            Double price;
            Double.TryParse(Request.Params["amount"], out amount);
            Double.TryParse(Request.Params["price"], out price);
            Int32 transaction_id;
            Int32.TryParse(Request.Params["transaction_id"], out transaction_id);
            DateTime date;
            DateTime.TryParseExact(Request.Params["date"].ToString(), "yyyy-MM-dd", null, DateTimeStyles.None, out date);
            // DateTime.TryParse(Request.Params["date"].ToString(), out date);

            //Validate  

            // add data to table
            SqlCommand cmd = new SqlCommand("update [Transaction] set price = @price, amount = @amount, date_created = @buy_date where ID = @ID", con);
            cmd.Parameters.AddWithValue("@price", price);
            cmd.Parameters.AddWithValue("@amount", amount);
            cmd.Parameters.AddWithValue("@buy_date", date);
            cmd.Parameters.AddWithValue("@ID", transaction_id);
            cmd.ExecuteNonQuery();
            con.Close();
            Response.Write(1);
            Response.End();

        }


        // Handle Delete coin
        protected void HandleAJAXRequest_DeleteCoin()
        {
            con.Open();
            Response.Clear();
            Response.ContentType = "text/plain";

            int transaction_id;
            Int32.TryParse(Request.Params["transaction_id"], out transaction_id);
            SqlCommand cmd = new SqlCommand("delete from [Transaction] where ID = @ID", con);
            cmd.Parameters.AddWithValue("@ID", transaction_id);
            cmd.ExecuteNonQuery();
            con.Close();
            Response.Write(1);
            Response.End();
        }


        protected String Send_GET_REQUEST_TODAY_Price(String coin, String currency)
        {
            StringBuilder sb = new StringBuilder();

            byte[] buf = new byte[8192];

            //do get request

            String url = "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=" + coin+"&tsyms=" + currency;
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