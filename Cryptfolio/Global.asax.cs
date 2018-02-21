using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;
using System.Web.UI;

namespace Cryptfolio
{
    public class Global : System.Web.HttpApplication
    {
        protected void Application_Start(object sender, EventArgs e)
        {
            ScriptManager.ScriptResourceMapping.AddDefinition("jquery", new ScriptResourceDefinition
            {
                Path = "~/Public/Resources/JS/jquery-3.3.1.min.js",
                DebugPath = "~/Public/Resources/JS/jquery-3.3.1.min.js"
            });
        }
    }
}