<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="SourceGenWebForm.Login" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>泛用代码生成器</title>

    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link rel="stylesheet" type="text/css" href="scripts/jquery-easyui/themes/default/easyui.css">
    <link rel="stylesheet" type="text/css" href="scripts/jquery-easyui/themes/icon.css">
    <script type="text/javascript" src="scripts/jquery-easyui/jquery-1.4.4.min.js"></script>
    <script type="text/javascript" src="scripts/jquery-easyui/jquery.easyui.min.js"></script>
    <style type="text/css">
        
    body {
        font-family: "Microsoft YaHei",arial,sans-serif;
        font-size: 18px;
        color: #444;
        background-color:#cccccc
    }
  
    .button {
       height:28px;width:100px;
    }
    .Form input[type="text"], .Form input[type="password"], .Form textarea {
        display: inline-block;
        box-sizing: border-box;
        -moz-box-sizing: border-box;
        -ms-box-sizing: border-box;
        -webkit-box-sizing: border-box;
        padding: 6px 12px;
        font-size: 18px;
        font-weight: 300;
        line-height: 1.4;
        color: #221919;
        background: white;
        border: 1px solid #A4A2A2;
        border-radius: 6px;
        -moz-border-radius: 6px;
        -webkit-border-radius: 6px;
        box-shadow: inset 0 1px rgba(34,25,25,.15),0 1px rgba(255,255,255,.8);
        -moz-box-shadow: inset 0 1px rgba(34,25,25,.15),0 1px rgba(255,255,255,.8);
        -webkit-box-shadow: inset 0 1px rgba(34,25,25,.15),0 1px rgba(255,255,255,.8);
        -webkit-transition: all .08s ease-in-out;
        -moz-transition: all .08s ease-in-out;
        border-color: #DDD #E1DFDF #D1CDCD;
        resize: none;
        outline: 0;
        -webkit-rtl-ordering: logical;
        -webkit-user-select: text;
        cursor: auto;
        letter-spacing: normal;
        word-spacing: normal;
        line-height: normal;
        text-transform: none;
        text-indent: 0px;
        text-shadow: none;
        text-align: -webkit-auto;
    }
    .btn {
        position: relative;
        display: inline-block;
        padding: .45em .825em .45em;
        text-align: center;
        line-height: 1em;
        border: 1px solid transparent;
        border-radius: .2em;
        -moz-border-radius: .2em;
        -webkit-border-radius: .2em;
        -moz-transition-property: color,-moz-box-shadow,text-shadow;
        -moz-transition-duration: .05s;
        -moz-transition-timing-function: ease-in-out;
        -webkit-transition-property: color,-webkit-box-shadow,text-shadow;
        -webkit-transition-duration: .05s;
        -webkit-transition-timing-function: ease-in-out;
        box-shadow: 0 1px rgba(255,255,255,.8),inset 0 1px rgba(255,255,255,.35);
        -moz-box-shadow: 0 1px rgba(255,255,255,.8),inset 0 1px rgba(255,255,255,.35);
        -webkit-box-shadow: 0 1px rgba(255,255,255,.8),inset 0 1px rgba(255,255,255,.35);
        cursor: pointer;
    }
    a {
        color: #221919;
        text-decoration: none;
        outline: 0;
    }
    .wbtn {
        color: #524D4D;
        text-shadow: 0 1px rgba(255, 255, 255, .9);
    }
    .btn18, .btn18 span {
        font-size: 18px;
        border-radius: 4px;
        -moz-border-radius: 4px;
        -webkit-border-radius: 4px;
    }
    .btn strong {
        position: relative;
        z-index: 2;
        line-height: 15px;
    }
    .wbtn:hover {
        color: #666060;
        text-shadow: 0 1px rgba(255, 255, 255, 1);
    }
    .btn {
        text-align: center;
        line-height: 1em;
        cursor: pointer;
    }
    .wbtn span {
        border-color: #BBB;
        background: -webkit-gradient(linear,0% 0,0% 100%,from( #FDFAFB),to( #F0EDED),color-stop(.5, #F9F7F7),color-stop(.5, #F6F3F4));
        background: -moz-linear-gradient(center top, #FDFAFB, #F9F7F7 50%, #F6F3F4 50%, #F0EDED);
        background: -o-linear-gradient(top left, #FDFAFB, #F9F7F7 50%, #F6F3F4 50%, #F0EDED);
        background: -webkit-gradient(linear,0% 0,0% 100%,from( #FDFAFB),to( #F0EDED),color-stop(.5, #F9F7F7),color-stop(.5, #F6F3F4));
        filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#fdfafb', endColorstr='#f0eded');
    }
    .btn span {
        position: absolute;
        z-index: 1;
        top: -1px;
        right: -1px;
        bottom: -1px;
        left: -1px;
        display: block;
        border: 1px solid;
        opacity: 1;
        border-radius: .3em;
        -moz-border-radius: .3em;
        -webkit-border-radius: .3em;
        box-shadow: inset 0 1px rgba(255,255,255,.35);
        -moz-box-shadow: inset 0 1px rgba(255,255,255,.35);
        -webkit-box-shadow: inset 0 1px rgba(255,255,255,.35);
        -moz-transition-property: opacity;
        -moz-transition-duration: .5s;
        -moz-transition-timing-function: ease-in-out;
        -webkit-transition-property: opacity;
        -webkit-transition-duration: .5s;
        -webkit-transition-timing-function: ease-in-out;
    }
    </style>
    
</head>
<body>
    <form class="Form FancyForm" id="form1" runat="server">
    <div>
        <div>
            <span style="font-size:xx-large;">Generic Source Generator</span>
            <span style="color:Gray">&nbsp;&nbsp;&nbsp;&nbsp;designed by <a href="http://www.weibo.com/fangchuxuan">原数据</a></span>
        </div>
        <br /><br />
        <div style=" margin-left:20px">
           邀请码：<input id="request_code" name="request_code" type="text" value="">
           <a id="login_btn" href="#" onclick="document.forms[0].submit();" class="btn btn18 wbtn"><strong>登录</strong><span></span></a>
            <asp:Label ID="Error" runat="server" Text=""></asp:Label>
        </div>       
    </div>    
    </form>
</body>
</html>
