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


namespace Cryptfolio
{
    public class User
    {
        public string user_id;
        public string username;
        public string email;
    }
    public partial class Master : System.Web.UI.MasterPage
    {
        protected Object Session_user;
        protected String Session_string = "None";
        SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
        protected void Page_Load(object sender, EventArgs e)
        {
            
            GetSession();
        }
        
        
        private void GetSession()
        {
            
            if (Session["USERID"] != null)
            {
                con.Open();
                Session_string = Decrypt(Session["USERID"].ToString());
                SqlCommand cmd = new SqlCommand("SELECT * FROM [User] WHERE ID = @ID;", con);
                cmd.Parameters.AddWithValue("@ID", Session_string);
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.HasRows)
                {
                    if (reader.Read())
                    {
                        User u1 = new User();
                        u1.user_id = reader.GetValue(0).ToString().Trim();
                        u1.username = reader.GetValue(1).ToString().Trim();
                        u1.email = reader.GetValue(3).ToString().Trim();
                        var serializer = new JavaScriptSerializer();
                        var jSession = serializer.Serialize(u1);
                        Session_user = jSession;
                        
                    }

                }
                con.Close();
                
            }
            else
            {
                var serializer = new JavaScriptSerializer();
                var jSession = serializer.Serialize(Session_string);
                Session_user = jSession;
            }
            
            
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