using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Cryptfolio.Views
{
    public partial class WebForm12 : System.Web.UI.Page
    {
        protected Object JSON_username, JSON_email, JSON_userID;
        protected string _username, _email, _password;
        SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["USERID"] == null)
            {
                Response.Redirect("login.aspx");
            }
            else
            {
                con.Open();
                if (HttpContext.Current.Request.HttpMethod == "POST")
                {
                    String type = Request.Params["type"];
                    if (type == "update_info")
                    {
                        getUserInfo();

                        String update_username = (Request.Params["username"] == null || Request.Params["username"] == "") ? _username : Request.Params["username"].ToString();
                        String update_email = (Request.Params["email"] == null || Request.Params["email"] == "") ? _email : Request.Params["email"].ToString();
                        String update_password = (Request.Params["password"] == null || Request.Params["password"] == "") ? Encrypt(_password) : Encrypt(Request.Params["password"].ToString());

                        SqlCommand cmd_update = new SqlCommand("UPDATE [User] SET username = @username, password = @password, email = @email WHERE ID = @ID", con);
                        cmd_update.Parameters.AddWithValue("@username", update_username);
                        cmd_update.Parameters.AddWithValue("@email", update_email);
                        cmd_update.Parameters.AddWithValue("@password", update_password);
                        cmd_update.Parameters.AddWithValue("@ID", Decrypt(Session["USERID"].ToString()));
                        try
                        {
                            cmd_update.ExecuteNonQuery();
                            Response.Write(1);
                        }
                        catch(Exception)
                        {
                            Response.Write(0);
                        }

                        
                        
                        
                        Response.End();
                    }
                }
                else
                {
                    getUserInfo();
                }
                con.Close();

            }
        }
        protected void getUserInfo()
        {


            String userID = Decrypt(Session["USERID"].ToString());

            SqlCommand cmd = new SqlCommand("SELECT * FROM [User] WHERE ID = '" + userID + "'", con);
            SqlDataReader reader = cmd.ExecuteReader();

            if (reader.HasRows)
            {
                if (reader.Read())
                {
                    // Secondly send GET request to API in order to get data for each coin
                    _username = reader.GetString(1).Trim();
                    _email = reader.GetString(3).Trim();
                    _password = Decrypt(reader.GetString(2).Trim());

                    var serializer = new JavaScriptSerializer();

                    var json_username = serializer.Serialize(_username);
                    JSON_username = json_username;

                    var json_email = serializer.Serialize(_email);
                    JSON_email = json_email;

                    var json_id = serializer.Serialize(userID);
                    JSON_userID = json_id;

                    reader.Close();
                }
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