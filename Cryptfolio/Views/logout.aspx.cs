using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Cryptfolio.Views
{
    public partial class WebForm13 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (HttpContext.Current.Request.HttpMethod == "POST")
            {
                if (Request.Params["type"] == "sign_out")
                {
                    HandleAJAXRequest_Signout();
                }


            }
            else
            {
                HandleGET();
            }
        }
        protected void HandleGET()
        {

        }
        private void HandleAJAXRequest_Signout()
        {
            Session["USERID"] = null;
            Response.Write(1);
            Response.End();
        }
    }
}