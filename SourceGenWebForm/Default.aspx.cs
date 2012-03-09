using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text.RegularExpressions;
using System.Data;
using System.Dynamic;

namespace SourceGenWebForm
{
    public partial class Default : System.Web.UI.Page
    {
        private static object _lockObj = new object();
        private static Dictionary<string, string> _languageMapFiles = new Dictionary<string, string>();

        private GenService _svc;
        public int SelectedTabIndex { get; set; }

        static Default()
        {
            _languageMapFiles["java"] = ".java";
            _languageMapFiles["csharp"] = ".cs";
            _languageMapFiles["vb.net"] = ".vb";
        }

        protected void Page_Load(object sender, EventArgs e)
        {

            if (Request["hideLogout"] == "logout")
            {
                System.Web.Security.FormsAuthentication.SignOut();
                Response.Redirect("Login.aspx");
            }
            
            if (!User.Identity.IsAuthenticated)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            _svc = new GenService();
            SelectedTabIndex = 1;

            if (!IsPostBack)
            {
                var template = _svc.GetTemplates().First();
                txtTemplateName.Text = template.Name;
                txtTemplate.Text = template.Content;
                BindDataList();

                ddlSourceLanguage.DataSource = _languageMapFiles.ToList();
                ddlSourceLanguage.DataTextField = "Key";
                ddlSourceLanguage.DataValueField = "Value";
                ddlSourceLanguage.DataBind();
            }
        }

        protected void LinkButton_Command(Object sender, CommandEventArgs e)
        {
            if (e.CommandName == "select")
            {
                var template = _svc.GetTemplates(e.CommandArgument.ToString()).First();
                txtTemplateName.Text = template.Name;
                txtTemplate.Text = template.Content;
                BindDataList();
            }

            if (e.CommandName == "delete")
            {
                if (User.Identity.Name == "admin")
                {
                    _svc.DeleteTemplate(e.CommandArgument.ToString());
                    BindDataList();
                }
            }

            SelectedTabIndex = 2;
            
        }

        protected void BindDataList()
        {
            templates.DataSource = _svc.GetTemplates();
            templates.DataBind();
        }

        protected void btnGenerate_Click(object sender, EventArgs e)
        {
            var globalData = txtGlobal.Text;
            var listData = txtListData.Text;
            var template = txtTemplate.Text;
            try
            {
                var splitterFlag = Request["radSplitter"];
                char[] splitter = null;
                switch (splitterFlag)
                { 
                    case "space":
                        splitter = new[] { ' ' };
                        break;
                    case "comma":
                        splitter = new[] { ',' };
                        break;
                    case "tab":
                        splitter = new[] { '\t' };
                        break;
                    default:
                        splitter = new[] { ' ' };
                        break;

                }
                txtResult.Style.Remove("color");
                var model = _svc.ParseData(globalData, listData, splitter);
                var header = (IDictionary<string, object>)model.global;
                if (header.ContainsKey("name"))
                    Session["FileName"] = header["name"] + ddlSourceLanguage.SelectedValue;
                txtResult.Text = _svc.Generate(model, template);
            }
            catch (Exception ex)
            {
                txtResult.Style.Add("color", "red");
                txtResult.Text = "出错啦：" + ex.Message;
            }
        }

        protected void btnDownload_Click(object sender, EventArgs e)
        {
            var data = System.Text.Encoding.UTF8.GetBytes(txtResult.Text);
            var filename = Convert.ToString(Session["FileName"]) ?? "temp.txt";

            Response.Clear();
            Response.AddHeader("Content-Disposition ", "attachment;filename=" + filename);
            Response.AddHeader("Content-Length ", data.Length.ToString());
            Response.ContentType = "application/octet-stream";
            Response.BinaryWrite(data);

            Response.End();
            Response.Flush();
            Response.Clear(); 
           
        }
       
        protected void btnSaveTemplate_Click(object sender, EventArgs e)
        {
            var template = new Template { Name=txtTemplateName.Text, Content=txtTemplate.Text };
            _svc.SaveTemplate(template);
            BindDataList();

            SelectedTabIndex = 2;
        }


    }
}