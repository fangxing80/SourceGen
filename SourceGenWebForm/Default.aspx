<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="SourceGenWebForm.Default" ValidateRequest="false"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>泛用代码生成器</title>
    <style type="text/css">
    body {
       font-family:Microsoft YaHei;
    }  
  
    .button {
       height:28px;width:100px;
    }
    </style>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link rel="stylesheet" type="text/css" href="scripts/jquery-easyui/themes/default/easyui.css">
    <link rel="stylesheet" type="text/css" href="scripts/jquery-easyui/themes/icon.css">
    <script type="text/javascript" src="scripts/jquery-easyui/jquery-1.4.4.min.js"></script>
    <script type="text/javascript" src="scripts/jquery-easyui/jquery.easyui.min.js"></script>
    <script type="text/javascript">
        $(function () {
            $("#tabpage<%= SelectedTabIndex %>").attr("selected", true);
            $('#tt').tabs({
                tools: [{
                    iconCls: 'icon-logout',
                    handler: function () {
                        $("#hideLogout").val("logout");
                        document.forms[0].submit();
                    }
                }]
            });
        });

        function isEmpty(id) {
            if ($("#" + id).val() == "") {
                return true;
            }
            return false;
        }

        function focusOn(id) {
            $("#" + id).focus();
        }

        function checkGenerate() {
            
            if (isEmpty("txtGlobal")) {
                alert("全局变量未定义。");
                focusOn("txtGlobal");
                return false;
            }
            if (isEmpty("txtListData")) {
                alert("列表变量未定义。");
                focusOn("txtListData");
                return false;
            }
            if (isEmpty("txtTemplate")) {
                alert("模板未定义。");
                $('#tt').tabs('select', '设置模板');
                focusOn("txtTemplate");
                return false;
            }
            return true;
        }

        function checkDownload() {
            if (isEmpty("txtResult")) {
                alert("没有生成内容，无法下载");
                focusOn("txtResult");
                return false;
            }
        }

        function checkSave() {
            if (isEmpty("txtTemplateName")) {
                alert("模板名未定义。");
                focusOn("txtTemplateName");
                return false;
            }
            if (isEmpty("txtTemplate")) {
                alert("模板名未定义。");
                focusOn("txtTemplate");
                return false;
            }
            return true;
        }

        function checkDelete(name) {
            if ("<%= User.Identity.Name %>" == "user") {
                alert("当前用户没有权限！");
                return false;
            } else {
                return confirm("确认要删除当前模板吗: " + name);
            }
            return true;
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div><span style="font-size:xx-large;">Generic Source Generator</span><span style="color:Gray">&nbsp;&nbsp;&nbsp;&nbsp;designed by <a href="http://www.weibo.com/fangchuxuan">原数据</a></span></div>
    <div id="tt" style="height:600px;">
        <div title="输入-输出" style="padding:20px;" id="tabpage1">
            <table>
            <tr>
                <td>
                    <fieldset>
                    <legend>输入</legend>
                    <table>
                    <tr><td style="vertical-align:top">全局数据：<asp:TextBox ID="txtGlobal" runat="server" Height="200px" Width="400px" TextMode="MultiLine"  Columns="80"></asp:TextBox></td></tr>
                    <tr>
                    <tr>
                    <td>每行数据按照：
                    <span style="color:Blue">
                    <input type="radio" name="radSplitter" id="rad1" value="space" checked runat="server"/><label for="rad1">空格</label>&nbsp;
                    <input type="radio" name="radSplitter" id="rad2" value="tab" runat="server"/><label for="rad2">Tab</label>&nbsp;
                    <input type="radio" name="radSplitter" id="rad3" value="comma" runat="server" /><label for="rad3">逗号</label>&nbsp;
                    </span>
                    进行分割。
                    </td></tr>
                    <td style="vertical-align:top">
                    列表数据：
                    <asp:TextBox ID="txtListData" runat="server" Height="200px" Width="400px" TextMode="MultiLine"  Columns="80" ></asp:TextBox>
                    </td></tr>
                    </table>  
                    </fieldset>
                </td>
                <td><asp:Button ID="btnGenerate" runat="server" Text="点击生成" Height="125px" OnClientClick="return checkGenerate();" onclick="btnGenerate_Click" /></td>
                <td style="vertical-align:top">
                  <fieldset>
                  <legend>输出</legend>
                      <asp:DropDownList ID="ddlSourceLanguage" runat="server">
                      </asp:DropDownList><asp:Button ID="btnDownload" runat="server" Text="下载" CssClass="button" OnClientClick="return checkDownload();" onclick="btnDownload_Click"/>
                      *系统会将<b>全局数据</b>中的 name 的值作为文件名。
                      <br />
                  <asp:TextBox ID="txtResult" runat="server" Height="422px" Width="600px" TextMode="MultiLine" Columns="80"></asp:TextBox>
                 
                  </fieldset>
                </td>
            </tr>
            </table>
        </div>
        <div title="设置模板" style="padding:20px;width:100%" id="tabpage2">
            <table>
            <tr>
             <td style="vertical-align:top">
                <div>
                    <div style="border-bottom:1pt solid gray ">
                    选择模板：
                    <asp:DataList ID="templates" runat="server">
                      <HeaderTemplate><ul></HeaderTemplate>
                      <ItemTemplate>
                         <li>
                            <asp:LinkButton runat="server" ID="linkDelete" Text='删除' CommandArgument='<%# Eval("Name") %>' CommandName="delete"  OnCommand="LinkButton_Command" OnClientClick='<%# Eval("Name","return checkDelete(\"{0}\")") %>'></asp:LinkButton>
                            &nbsp;&nbsp;<asp:LinkButton runat="server" ID="linkName" Text='<%# Eval("Name") %>' CommandArgument='<%# Eval("Name") %>'  CommandName="select" OnCommand="LinkButton_Command" ></asp:LinkButton>
                         </li>
                      </ItemTemplate>
                      <FooterTemplate></ul></FooterTemplate>
                    </asp:DataList>
                    <br />
                    </div>                    
                    <div>
                    <br />
                     说明：<br /><br /> 
                     (1) 全局数据通过<span style="color:Red">@Model.global</span>引用。<br />
                     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;例如：@Model.global.name<br />
                     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(name在全局数据输入框中定义)<br />
                     (2) 列表数据通过<span style="color:Red">@Model.data</span>引用。<br />
                     (3) 通过<span style="color:Red">@helper methodname(...)</span>可以定义内部方法<br />
                    </div>
                </div>
            </td>
            <td>&nbsp;&nbsp;</td>
            <td>
                <asp:TextBox ID="txtTemplateName" runat="server"></asp:TextBox>* 修改完模板别忘记：
                <asp:Button ID="btnSaveTemplate" runat="server" Text="保存" OnClientClick="return checkSave();" CssClass="button" onclick="btnSaveTemplate_Click" /><br />
                <asp:TextBox ID="txtTemplate" runat="server" Height="480px" Width="800px" TextMode="MultiLine" Columns="150" ></asp:TextBox><br />
            </td>          
            <td style=" vertical-align:top"></td> 
            </tr>
            </table>
        </div>
        <input type="hidden" id="hideLogout" name="hideLogout" value="" />
    </div>
    <div><center><a href="http://razorengine.codeplex.com/wikipage?title=Quick%20Start%20Guide&referringTitle=Documentation"><img alt="" src="images/Logo.jpg" /></a></center></div>
    </form>
</body>
</html>