# 免登服务

通过免登服务，在企业微应用的H5中，无需重复输入用户名和密码，可以通过身份认证获取当前使用钉钉的用户身份及相关信息。

具体流程为：

1.获取CODE(免登授权码)，获取CODE的方式是调用js-api接口。

2.通过CODE换取用户身份。


通过CODE获取用户身份会有一定的时间开销。对于频繁获取用户身份的场景，建议采用如下方案：

1. 用户跳转到企业页面时，企业校验是否有代表用户身份的cookie，此cookie由企业生成
2. 如果没有获取到cookie，调用免登服务，获取用户身份后，由企业生成代表用户身份的cookie
3. 根据cookie获取用户身份，进入相应的页面

## 手机客户端微应用中调用免登

### 使用JS-API

步骤一：首先需要获取当前用户的corpid。ISV开发者请在微应用主页地址使用$CORPID$模板参数表示corpid，用户访问微应用的时候钉钉服务器将把$CORPID$替换成用户所属企业的corpid，例如原本的主页地址是http://www.dingtalk.com/index，则能获取用户corpid的主页地址为http://www.dingtalk.com/index?corpid=$CORPID$

步骤二：使用钉钉js-api提供的[<font color=red >获取免登授权码</font>](#获取免登授权码)接口获取CODE

步骤二：[<font color=red >通过CODE换取身份</font>](#通过code换取用户身份)

demo地址:[<font color=red >https://github.com/injekt/openapi-demo-php/blob/master/corp/public/javascripts/demo.js</font>](https://github.com/injekt/openapi-demo-php/blob/master/corp/public/javascripts/demo.js)


## 钉钉PC版微应用中调用免登

### 使用JS-API

步骤一：首先需要获取当前用户的corpid。ISV开发者请在微应用主页地址使用$CORPID$模板参数表示corpid，用户访问微应用的时候钉钉服务器将把$CORPID$替换成用户所属企业的corpid，例如原本的主页地址是http://www.dingtalk.com/index，则能获取用户corpid的主页地址为http://www.dingtalk.com/index?corpid=$CORPID$

步骤二：使用钉钉js-api提供的[<font color=red >PC版获取免登授权码</font>](#pc版获取免登授权码)接口获取CODE

步骤二：[<font color=red >通过CODE换取身份</font>](#通过code换取用户身份)

demo： 可参考手机客户端免登demo，但全局变量dd替换成DingTalkPC



## 微应用后台管理员免登
实现微应用后台管理系统与钉钉OA后台的免登

应用场景示例如下图：

![normalcorp](https://img.alicdn.com/tps/TB1iw.4KFXXXXXoXFXXXXXXXXXX-594-302.png)

**准备工作**：

1: 配置微应用后台地址

普通企业在[<font color=red>OA后台</font>](https://oa.dingtalk.com/#/microApp/microAppList)添加微应用配置如左图，ISV在[<font color=red>开发者后台</font>](http://console.d.aliyun.com)添加微应用配置如下图

![oaback](https://img.alicdn.com/tps/TB15zWTKFXXXXcEXVXXXXXXXXXX-642-367.jpg)

2: 获取完成免登过程中验证身份的密钥（SSOSecret）

<font color=red >重要说明：企业和ISV获取的方法一致，都是通过OA后台获取，ISV开发套件微应用的管理后台，使用自己企业的SSOSecret即可完成身份认证</font>

在[<font color=red>OA后台</font>](https://oa.dingtalk.com/#/microApp/microAppSet)获取SSOSecret的方法如下：


![normalcorp](https://img.alicdn.com/tps/TB1y_xcKVXXXXa6XXXXXXXXXXXX-1084-621.jpg)



**使用方法（钉钉管理员登陆态）**


步骤一：在OA后台，点击微应用的“进入后台”，自动跳转到准备工作1中配置的微应用后台地址，开发者从跳转的URL中解析code参数，获取CODE并保存下来，通过此CODE获取管理员的身份信息

步骤二：通过[<font color=red >获取微应用后台管理Token</font>](#获取微应用后台管理token)获取AccessToken

步骤三：使用AccessToken[<font color=red >通过步骤一获取的CODE换取微应用管理员的身份信息</font>](#通过code换取微应用管理员的身份信息)


**更多用法**

在钉钉管理员非登陆态，使用钉钉管理后台的Oauth身份认证可以通过下面方法：

在管理员访问后台地址的时候，企业在后台构造一个连接，通过HTTP 302跳转方式，让用户访问钉钉开放平台授权网址，构造的地址如下:

`https://oa.dingtalk.com/omp/api/micro_app/admin/landing?corpid=CORPID&redirect_url=REDIRECT_URL`

参数 | 说明
---------- | ------
corpid | 开发此微应用的公司corpid，ISV填写自己企业的CorpID
redirect_url | 重定向地址(需要urlencode编码)


REDIRECT_URL为微应用后台地址，首先跳转到钉钉OA管理后台登录页，登陆成功后，会再次通过HTTP 302跳转回微应用的后台地址(即REDIRECT_URL)，并在REDIRECT_URL后面追加参数code=CODE,即

`REDIRECT_URL?code=CODE`

开发者从URL中解析code参数，获取CODE并保存下来，再按照上面使用方法中的步骤二和步骤三 获得管理员信息

demo查看:[https://github.com/injekt/openapi-demo-java/tree/master/src/com/alibaba/dingtalk/openapi/servlet](https://github.com/injekt/openapi-demo-java/tree/master/src/com/alibaba/dingtalk/openapi/servlet)

## 普通钉钉用户账号开放及免登

第三方web服务提供者，通过此项服务，可以使用普通钉钉用户账号登录自有的系统，并可将自有系统的账号与钉钉账号进行绑定，同时还能够获取钉钉用户的个人及企业数据，如姓名、手机号、对应企业的名称、企业是否认证过、企业的权益等级、其在企业内是否为管理人员等信息(取决于用户最终授权)。

<font color=red >注:此功能与ISV没有关系，任何外部系统都可以使用。</font>

1: 在钉钉用户访问你的Web系统时，如果用户选择使用钉钉账号登录，则需要由你构造并引导用户跳转到如下链接。

https://oapi.dingtalk.com/connect/oauth2/sns_authorize?appid=APPID&response_type=code&scope=snsapi_login&state=STATE&redirect_uri=REDIRECT_URI

参数 | 说明
---------- | ------
appid | 参看第2步获取，代表了你提供的服务，必填
redirect_uri | 重定向地址(需要urlencode编码)，该地址所在域名需要配置为appid对应的安全域名，必填
state | 用于防止重放攻击，选填
response_type | 固定为code，必填
scope | 固定为snsapi_login，必填

2: 获取完成免登过程中验证身份的appId及appSecret。

请加入钉钉"沟通组"：https://t.dingtalk.com/invite/index?code=86d9eaf4ff 点击该链接申请加入

在您基本完成开发后，可在"沟通组"里的审批中申请获得appId及appSecret。

3: 使用appid及appSecret访问如下接口，获取accesstoken，此处获取的token有效期为2小时，有效期内重复获取，返回相同值，并自动续期，如果在有效期外获取会获得新的token值，建议定时获取本token，不需要用户登录时再获取。

[<font color=red >https://oapi.dingtalk.com/sns/gettoken?appid=APPID&appsecret=APPSECRET</font>](#获取钉钉开放应用的access_token)

4:在钉钉用户登录钉钉系统后，会302到你指定的redirect_uri，并向url参数中追加code及state两个参数。

5:在你的web系统获取到代表用户的code之后，使用第3步获取的AccessToken及code获取当前钉钉用户授权给你的持久授权码，此授权码目前无过期时间，可反复使用，参数code只能使用一次。

[<font color=red >https://oapi.dingtalk.com/sns/get_persistent_code?access_token=ACCESS_TOKEN</font>](#获取用户授权的持久授权码)

6:在获得钉钉用户的持久授权码后，通过以下接口获取该用户授权的SNS_TOKEN，此token的有效时间为2小时，重复获取不会续期。

[<font color=red >https://oapi.dingtalk.com/sns/get_sns_token?access_token=ACCESS_TOKEN</font>](#获取用户授权的sns_token)

7:在获得钉钉用户的SNS_TOKEN后，通过以下接口获取该用户的个人信息。

[<font color=red >https://oapi.dingtalk.com/sns/getuserinfo?sns_token=SNS_TOKEN</font>](#获取用户授权的个人信息)

## 网站应用钉钉扫码登录开发指南

第三方web服务提供者，通过此项服务，可以使用钉钉用户扫码登录自有的系统，并可将自有系统的账号与钉钉账号进行绑定，同时还能够获取钉钉用户的个人及企业数据，如姓名、手机号、对应企业的名称、企业是否认证过、企业的权益等级、其在企业内是否为管理人员等信息(取决于用户最终授权)。

<font color=red >注:此功能与ISV没有关系，任何外部系统都可以使用。</font>

1: 你的Web系统可以通过两种方式实现钉钉扫码登录，如下：

1.1: 第一种方式是直接使用钉钉提供的扫码登录页面，在企业Web系统里，用户点击使用钉钉扫描登录，第三方Web系统跳转到如下地址：

https://oapi.dingtalk.com/connect/qrconnect?appid=APPID&response_type=code&scope=snsapi_login&state=STATE&redirect_uri=REDIRECT_URI

url里的参数需要换成第三方Web系统对应的参数。

在钉钉用户扫码登录并确认后，会302到你指定的redirect_uri，并向url参数中追加code及state两个参数。

1.2: 第二种方式是支持网站将钉钉登录二维码内嵌到自己页面中，用户使用钉钉扫码登录后JS会将loginTmpCode返回给网站。

JS钉钉登录主要用途：网站希望用户在网站内就能完成登录，无需跳转到钉钉域下登录后再返回，提升钉钉登录的流畅性与成功率。 网站内嵌二维码钉钉登录JS实现办法：

步骤1：在页面中先引入如下JS文件（支持https）：


```<script src="g.alicdn.com/dingding/dinglogin/0.0.2/ddLogin.js"></script>
```

步骤2：在需要使用钉钉登录的地方实例以下JS对象：

<code>
var obj = DDLogin({<br>
     &nbsp;&nbsp;&nbsp;id:"login_container",<br>
     &nbsp;&nbsp;&nbsp;goto: "",<br>
     &nbsp;&nbsp;&nbsp;style: "",<br>
     &nbsp;&nbsp;&nbsp;href: "",<br>
     &nbsp;&nbsp;&nbsp;width : "300px",<br>
     &nbsp;&nbsp;&nbsp;height: "300px"<br>
 });<br>
</code>
其中goto参数需要这样构造：https://oapi.dingtalk.com/connect/oauth2/sns_authorize?appid=APPID&response_type=code&scope=snsapi_login&state=STATE&redirect_uri=REDIRECT_URI
并且要将goto参数urlencode编码

参数说明见下方

您引入的js会在获取用户扫描之后将获取的loginTmpCode通过window.parent.postMessage(loginTmpCode,'*');返回给您的网站。您可以通过以下代码获取这个loginTmpCode：
<code>
<br>
var hanndleMessage = function (event) {<br>
    &nbsp;&nbsp;&nbsp;var data = event.data;<br>
    &nbsp;&nbsp;&nbsp;var origin = event.origin;<br>
};<br>
if (typeof window.addEventListener != 'undefined') {<br>
    &nbsp;&nbsp;&nbsp;window.addEventListener('message', hanndleMessage, false);<br>
} else if (typeof window.attachEvent != 'undefined') {<br>
    &nbsp;&nbsp;&nbsp;window.attachEvent('onmessage', hanndleMessage);<br>
}<br>
</code>

通过JS获取到loginTmpCode后，需要由你构造并跳转到如下链接。
https://oapi.dingtalk.com/connect/oauth2/sns_authorize?appid=APPID&response_type=code&scope=snsapi_login
&state=STATE&redirect_uri=REDIRECT_URI&loginTmpCode=loginTmpCode

参数 | 说明
---------- | ------
appid | 参看第2步获取，代表了你提供的服务，必填
redirect_uri | 重定向地址(如果是第一种方式需要urlencode编码，如果是第二种方式则需要将JS goto参数整体urlencode编码，不要单独对redirect_uri编码)，该地址所在域名需要配置为appid对应的安全域名，必填
state | 用于防止重放攻击，选填
response_type | 固定为code，必填
scope | 固定为snsapi_login，必填
loginTmpCode | 通过js获取到的loginTmpCode，必填

2: 获取完成免登过程中验证身份的appId及appSecret。

请加入钉钉"扫码登录沟通组"：https://t.dingtalk.com/invite/index?code=86d9eaf4ff 点击该链接申请加入

在您基本完成开发后，可在"扫码登录沟通组"里的审批中申请获得appId及appSecret。

3: 使用appid及appSecret访问如下接口，获取accesstoken，此处获取的token有效期为2小时，有效期内重复获取，返回相同值，并自动续期，如果在有效期外获取会获得新的token值，建议定时获取本token，不需要用户登录时再获取。

[<font color=red >https://oapi.dingtalk.com/sns/gettoken?appid=APPID&appsecret=APPSECRET</font>](#获取钉钉开放应用的access_token)

4:在你的web系统获取到代表用户的code之后，使用第3步获取的AccessToken及code获取当前钉钉用户授权给你的持久授权码，此授权码目前无过期时间，可反复使用，参数code只能使用一次。

[<font color=red >https://oapi.dingtalk.com/sns/get_persistent_code?access_token=ACCESS_TOKEN</font>](#获取用户授权的持久授权码)

5:在获得钉钉用户的持久授权码后，通过以下接口获取该用户授权的SNS_TOKEN，此token的有效时间为2小时，重复获取不会续期。

[<font color=red >https://oapi.dingtalk.com/sns/get_sns_token?access_token=ACCESS_TOKEN</font>](#获取用户授权的sns_token)

6:在获得钉钉用户的SNS_TOKEN后，通过以下接口获取该用户的个人信息。

[<font color=red >https://oapi.dingtalk.com/sns/getuserinfo?sns_token=SNS_TOKEN</font>](#获取用户授权的个人信息)
