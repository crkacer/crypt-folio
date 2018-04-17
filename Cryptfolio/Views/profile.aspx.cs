using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Cryptfolio.Views
{
    public partial class WebForm12 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (HttpContext.Current.Request.HttpMethod == "POST")
            {

            }
            else
            {
                if (Session["USERID"] == null) {
                    Response.Redirect("login.aspx");
                }
                else
                {

                }
            }
        }
    }
}