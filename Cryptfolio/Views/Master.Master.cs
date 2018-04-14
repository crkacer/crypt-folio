using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Cryptfolio
{
    public partial class Master : System.Web.UI.MasterPage
    {
        protected Object Session_user;
        protected String Session_string = "None";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["ID"] != null)
            {
                Session_user = Session["ID"].ToString();
            }
            var serializer = new JavaScriptSerializer();
            var jSession = serializer.Serialize(Session_string);
            Session_user = jSession;
        }
    }
}