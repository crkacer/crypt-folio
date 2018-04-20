using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net.Mail;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Cryptfolio.Views
{
    public partial class WebForm11 : System.Web.UI.Page
    {
        SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
        
        protected void Page_Load(object sender, EventArgs e)
        {
            if (HttpContext.Current.Request.HttpMethod == "POST")
            {
                if (Request.Params["type"] == "forgot_password")
                {
                    HandleAJAXRequest_POSTForgot();
                }

            }
            else
            {
                HandleGET();

            }
        }
        protected void HandleGET()
        {
            if (Session["USERID"] != null)
            {
                Response.Redirect("index.aspx");
            }
        }
        protected void HandleAJAXRequest_POSTForgot()
        {
            con.Open();
            String email, password;
            email = Request.Params["email"];
            SqlCommand cmd = new SqlCommand("SELECT * FROM [User] WHERE email = @email;", con);
            cmd.Parameters.AddWithValue("@email", email);
            var result = cmd.ExecuteScalar();
            if(result == null)
            {
                Response.Write(0);
            }
            else
            {
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.HasRows)
                {
                    // email correct
                    if(reader.Read())
                    {
                        password = Decrypt(reader.GetString(2));
                        sendEmail(email, password);
                        
                    }
                }
            }

            Response.End();
        }
        protected void sendEmail(String email, String password)
        {

            System.Net.Mail.MailMessage mail = new System.Net.Mail.MailMessage();
            mail.To.Add(email);
            mail.From = new MailAddress("cryptfolio.cust.6969@gmail.com", "Cryptfolio Customer Support", System.Text.Encoding.UTF8);
            
            mail.Subject = "Reset Password";
            mail.SubjectEncoding = System.Text.Encoding.UTF8;
            mail.Body = "You password to Cryptfolio under (" + email + ") is: " + password;
            mail.BodyEncoding = System.Text.Encoding.UTF8;
            mail.IsBodyHtml = true;
            mail.Priority = MailPriority.High;
            SmtpClient client = new SmtpClient();
            client.Credentials = new System.Net.NetworkCredential("cryptfolio.cust.6969@gmail.com", "1234567890cryptfolio");
            client.Port = 587;
            client.Host = "smtp.gmail.com";
            client.EnableSsl = true;
            try
            {
                client.Send(mail);
                Response.Write(1);
            }
            catch (Exception ex)
            {
                
                Response.Write(ex);
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