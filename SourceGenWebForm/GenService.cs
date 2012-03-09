using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Activation;
using System.ServiceModel.Web;
using System.Text;
using System.Web;
using System.IO;
using System.Dynamic;
using System.Text.RegularExpressions;

namespace SourceGenWebForm
{
    [ServiceContract(Namespace = "")]
    [AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Allowed)]
    public class GenService
    {

        private static Dictionary<string, object> _lockDict = new Dictionary<string, object>();

        [WebGet]
        public List<ComboxItem> GetTemplateNames()
        {
            var data = new List<Dictionary<string, string>>();
            var dir = HttpContext.Current.Server.MapPath("~/templates");
            var index = 1;
            var list = Directory.GetFiles(dir, "*.txt")
                      .Select(f => new ComboxItem { id = index++, text = Path.GetFileNameWithoutExtension(f), selected = false }).ToList();
            if (list.Count > 0)
                list[0].selected = true;
            return list;
        }

        [WebGet(UriTemplate = "Template/{name=null}")]
        public List<Template> GetTemplates(string name=null)
        {
            var dir = HttpContext.Current.Server.MapPath("~/templates");
            if (string.IsNullOrEmpty(name))
                return Directory.GetFiles(dir, "*.txt").Select(f => new Template { Name = Path.GetFileNameWithoutExtension(f), Content = File.ReadAllText(f) }).ToList();
            else
            {
                var filepath = Path.Combine(HttpContext.Current.Server.MapPath("~/templates"), name + ".txt");
                return new List<Template> { new Template { Name = name, Content = File.ReadAllText(filepath) } };
            }
        }

        [WebInvoke(Method = "POST", UriTemplate="Template")]
        public void SaveTemplate(Template template)
        {
            if (!_lockDict.ContainsKey(template.Name))
                _lockDict.Add(template.Name, new object());

            lock (_lockDict[template.Name])
            {
                var filepath = Path.Combine(HttpContext.Current.Server.MapPath("~/templates"), template.Name + ".txt");
                File.WriteAllText(filepath, template.Content);
            }
        }

        [WebInvoke(Method = "DELETE", UriTemplate = "Template/{name}")]
        public void DeleteTemplate(string name)
        {
            if (!_lockDict.ContainsKey(name))
                _lockDict.Add(name, new object());

            lock (_lockDict[name])
            {
                var filepath = Path.Combine(HttpContext.Current.Server.MapPath("~/templates"), name + ".txt");
                if (File.Exists(filepath))
                    File.Delete(filepath);
            }
        }

        public dynamic ParseData(string globalData, string listData, char[] listDataSeparator)
        {
            dynamic model = new ExpandoObject();
            model.global = ParseGlobalData(globalData);
            model.data = ParseListData(listData, listDataSeparator);
            return model;
        }

        public string Generate(dynamic model, string template)
        {
            return RazorEngine.Razor.Parse(template, model);
        }

        public string Generate(string globalData, string listData, string template, char[] listDataSeparator = null)
        {
            listDataSeparator = listDataSeparator ?? new[] { ' ' };
            dynamic model = new ExpandoObject();
            model.GlobalData = ParseGlobalData(globalData);
            model.ListData = ParseListData(listData, listDataSeparator);

            return RazorEngine.Razor.Parse(template, model);
        }

        private dynamic ParseGlobalData(string content)
        {
            dynamic data = new ExpandoObject();
            var dict = (IDictionary<string, object>)data;
            var lines = content.Split(new[] { '\n', '\r' }, StringSplitOptions.RemoveEmptyEntries);
            if (lines.Length <= 0)
                return data;

            foreach (var line in lines)
            {
                var tmp = line.Split(':');
                if (tmp.Length > 1)
                {
                    dict[tmp[0]] = tmp[1].Trim();
                }
                else
                {
                    dict[line] = line;
                }
            }

            return data;
        }

        private List<dynamic> ParseListData(string content, char[] separator)
        {
            var datas = new List<dynamic>();
            var lines = content.Split(new[] { '\n', '\r' }, StringSplitOptions.RemoveEmptyEntries);

            if (lines.Length <= 0)
                return datas;

            string[] columns = null;
            int index = 0;

            foreach (var line in lines)
            {
                var handledline = line;
                if (separator.Any(c => c == ' '))
                {
                    handledline = Regex.Replace(line, "\\s+", " ");
                }

                if (index == 0)
                {
                    columns = handledline.Split(separator, StringSplitOptions.RemoveEmptyEntries);
                    columns = columns.Select(col => col.Trim()).ToArray();
                }
                else
                {                    
                    var fieldValues = handledline.Split(separator);
                    dynamic obj = new ExpandoObject();
                    var dict = (IDictionary<string, object>)obj;
                    for (int i = 0; i < fieldValues.Length; i++)
                    {
                        dict[columns[i].Trim()] = fieldValues[i].Trim();
                    }
                    datas.Add(obj);
                }
                index++;
            }
            return datas;
        }


    }

    public class ComboxItem
    {
        public int id;
        public string text;
        public bool selected;
    }

    [DataContract]
    public class Template
    {
        [DataMember(Name ="name")]
        public string Name { get; set; }
        [DataMember(Name = "content")]
        public string Content { get; set; }
    }


}
