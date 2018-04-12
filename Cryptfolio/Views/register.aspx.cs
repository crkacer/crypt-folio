﻿using System;
using System.Collections.Generic;
using System.Configuration;
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
    public partial class WebForm10 : System.Web.UI.Page
    {
        SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);

        protected void Page_Load(object sender, EventArgs e)
        {
            // check GET or POST request
            if (HttpContext.Current.Request.HttpMethod == "POST")
            {
                String POST_TYPE = Request.Params["type"];
                if (POST_TYPE == "register_post")
                {
                    HandleAJAXRequest_Register();
                }
            
            } else
            {
                Response.Write("GET");
                Response.End();
            }
        }

        protected void HandleAJAXRequest_Register()
        {
            String email, password, username;
            username = Request.Params["username"];
            email = Request.Params["email"];
            password = Request.Params["password"];


            // check if username exists
            con.Open();
            SqlCommand cmd = new SqlCommand("SELECT * FROM [User] WHERE email = @email;", con);
            cmd.Parameters.AddWithValue("@email", email);

            var result = cmd.ExecuteScalar();
            Response.Write(1);
            Response.End();
            if (result != null)
            {
                // username already existed
                // create session 
                
                Response.Write(-1);
                Response.End();
            }
            else
            {
                // username did not exist
                // create new user 

                SqlCommand cmd2 = new SqlCommand("INSERT INTO dbo.User (username, password, email)" + "VALUES (@username, @email, @password);", con);
                cmd2.Parameters.AddWithValue("@username", email);
                cmd2.Parameters.AddWithValue("@email", email);
                cmd2.Parameters.AddWithValue("@password", Encrypt(password));

                cmd2.ExecuteNonQuery();
                // successful created new user
                
            }
            
            con.Close();
            
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