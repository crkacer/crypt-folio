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
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Cryptfolio.Views
{
    
    public partial class WebForm10 : System.Web.UI.Page
    {
        SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);

        protected String status = "None";
        protected Object JSON_status;

        protected void Page_Load(object sender, EventArgs e)
        {
            var serializer = new JavaScriptSerializer();

            var jStatus = serializer.Serialize(status);
            JSON_status = jStatus;
            // check GET or POST request
            if (Request.Headers["type_request"] != null)
            {
                Response.Clear();
                
                status = "Received"; 
                HandleAJAXRequest_Register();
                jStatus = serializer.Serialize(status);
                JSON_status = jStatus;
                Response.End();
            }
            else
            {
                if (Session["USERID"] != null)
                {
                    Response.Redirect("index.aspx");
                }
            }


            
        }


      

        protected void HandleAJAXRequest_Register()
        {
            String email, password, username;
            username = Request.Params["username"];
            email = Request.Params["email"];
            password = Request.Params["password"];

            try
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("SELECT * FROM [User] WHERE email = @email;", con);
                cmd.Parameters.AddWithValue("@email", email);

                var result = cmd.ExecuteScalar();

                if (result != null)
                {
                    // username already existed
                    status = "Username already existed";
                    Response.Write("Username already existed");
                }
                else
                {
                    // username did not exist
                    // create new user 

                    SqlCommand cmd2 = new SqlCommand("INSERT INTO [User] (username, email, password) VALUES (@username, @email, @password);", con);
                    cmd2.Parameters.AddWithValue("@username", username);
                    cmd2.Parameters.AddWithValue("@email", email);
                    cmd2.Parameters.AddWithValue("@password", Encrypt(password));

                    cmd2.ExecuteNonQuery();
                    // successful created new user
                    status = "Successful registered user";

                    // create new portfolio for that user
                    int maxID;

                    SqlCommand cmdzs = new SqlCommand("SELECT MAX (ID) as max_user_id FROM [User];", con);
                    cmdzs.CommandType = CommandType.Text;
                    int.TryParse(cmdzs.ExecuteScalar().ToString(), out maxID);

                    SqlCommand cmd_port = new SqlCommand("INSERT INTO [Portfolio] (user_ID, name) VALUES (@user_ID, @name);", con);
                    cmd_port.Parameters.AddWithValue("@user_ID", maxID);
                    cmd_port.Parameters.AddWithValue("@name", email);
                    cmd_port.ExecuteNonQuery();

                    Response.Write(1);

                }

                con.Close();
            }
            catch (Exception e)
            {
                Response.Write(e);
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