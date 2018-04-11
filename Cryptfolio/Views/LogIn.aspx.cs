using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
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
            if ((HttpContext.Current.Request.HttpMethod == "POST") && (Request.Params["type"].ToString() == "post_login"))
            {

                HandleAJAXRequest_POSTLogin();
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
            username = Request.Params["username"].ToString();
            password = Request.Params["password"].ToString();

            // check if username and password are both correct

        }
    }
}