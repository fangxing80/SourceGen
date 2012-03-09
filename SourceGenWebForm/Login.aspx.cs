using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Drawing;

namespace SourceGenWebForm
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (User.Identity.IsAuthenticated)
            {
                Response.Redirect("Default.aspx");
            }

            if (IsPostBack)
            {
                var requestCode = Request["request_code"];
                switch (requestCode)
                { 
                    case "admin":
                        System.Web.Security.FormsAuthentication.SetAuthCookie("admin", false);
                        break;
                    case "neusoft":
                        System.Web.Security.FormsAuthentication.SetAuthCookie("user", true);
                        break;
                    default:
                        Error.Text = "输入的邀请码不正确。";
                        Error.ForeColor = Color.Red;
                        return;
                }
                Response.Redirect("Default.aspx");
            }
        }
    }
}