using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Cryptfolio.Views
{
    public partial class WebForm2 : System.Web.UI.Page
    {

        SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
        protected void Page_Load(object sender, EventArgs e)
        {
            // check GET or POST request
            if (HttpContext.Current.Request.HttpMethod == "POST")
            {
                if (Request.Params["type"] == "post_login")
                {
                    HandleAJAXRequest_POSTLogin();
                }
                else if (Request.Params["type"] == "post_register") {
                    HandleAJAXRequest_POSTRegister();
                }
                    
            }
            else
            {
                HandleGET();
            }
        }
        protected void Submit_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                Server.Transfer("login-confirmation.aspx");
            }
        }

        protected void HandleGET()
        {
            
        }


        protected void Add_Coin_DB()
        {
            String[] Data_COINS = new String[18] { "XRP", "BCH", "NEO", "LTC", "ADA", "EOS", "XLM", "VEN", "IOT", "XMR", "TRX", "ETC", "LSK", "QTUM", "OMG", "XVG", "USDT", "XRB" };
            String[] Data_NAMES = new String[18] { "Ripple", "Bitcoin Cash", "NEO", "LiteCoin", "Cardano", "EOS", "Stellar", "Vechain", "IOTA", "Monero", "Tronix", "Ethereum Classic", "Lisk", "QTUM", "OmiseGo", "Verge", "Tether", "Nano" };

            con.Open();
            for (int i = 0; i < Data_COINS.Length; i++)
            {
                SqlCommand cmd = new SqlCommand("insert into Coin (Symbol, Name) values ('" + Data_COINS[i] + "','" + Data_NAMES[i] + "')", con);

                cmd.ExecuteNonQuery();
            }
            con.Close();
        }

        protected void HandleAJAXRequest_POSTLogin()
        {
            String username, password;
            username = Request.Params["username"];
            password = Request.Params["password"];


            // check if username and password are both correct
            con.Open();
            SqlCommand cmd = new SqlCommand("SELECT * FROM [User] WHERE username = @username AND password = @password;", con);
            cmd.Parameters.AddWithValue("@username", username);
            cmd.Parameters.AddWithValue("@password", Encrypt(password));
       
            var result = cmd.ExecuteScalar();
            if (result != null)
            {
                // username and password are correct
                // create session 
                Session["username"] = Encrypt(username);
                Response.Write(1);
            }
            else
            {
                // username or password is incorrect
                Response.Write(-1);
            }
            con.Close();
            Response.End();

        }

        protected void HandleAJAXRequest_POSTRegister()
        {

            String username, password, email;
            username = Request.Params["username"].ToString();
            password = Request.Params["password"].ToString();
            email = Request.Params["email"].ToString();

            // check if that user already existed
            SqlCommand cmd = new SqlCommand("Select count(*) from User where username = @Username", con);
            cmd.Parameters.AddWithValue("@Username", username);
            con.Open();
            var result = cmd.ExecuteScalar();
            if (result != null)
            {
                // Username already existed
                Response.Write(-1);
            }
            else
            {
                // if not existed then post to database
                con.Open();
                SqlCommand cmd_add = new SqlCommand("insert into User (username, password, email, date_created) values ('" + username + "','" + Encrypt(password) + "','" + email + "')", con);
                cmd_add.ExecuteNonQuery();
                con.Close();

                Response.Write(1);
            }
            
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