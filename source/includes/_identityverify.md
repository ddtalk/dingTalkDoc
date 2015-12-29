# 免登服务

通过免登服务，在企业微应用的H5中，无需重复输入用户名和密码，可以通过身份认证获取当前使用钉钉的用户身份及相关信息。

具体流程为：

1.获取CODE(免登授权码)，获取CODE的方式有两种，一种是调用js-api接口（推荐），一种是使用标准OAUTH2.0 HTTP 302跳转的方式。

2.通过CODE换取用户身份。


通过CODE获取用户身份会有一定的时间开销。对于频繁获取用户身份的场景，建议采用如下方案：

1. 用户跳转到企业页面时，企业校验是否有代表用户身份的cookie，此cookie由企业生成
2. 如果没有获取到cookie，调用免登服务，获取用户身份后，由企业生成代表用户身份的cookie
3. 根据cookie获取用户身份，进入相应的页面

##手机客户端微应用中调用免登

### 使用JS-API(推荐使用)

步骤一：首先需要获取当前用户的corpid。ISV开发者请在微应用主页地址使用$CORPID$模板参数表示corpid，用户访问微应用的时候钉钉服务器将把$CORPID$替换成用户所属企业的corpid，例如原本的主页地址是http://www.dingtalk.com/index，则能获取用户corpid的主页地址为http://www.dingtalk.com/index?corpid=$CORPID$

步骤二：使用钉钉js-api提供的[<font color=red >获取免登授权码</font>](#获取免登授权码)接口获取CODE

步骤二：[<font color=red >通过CODE换取身份</font>](#通过code换取用户身份)

demo地址:[<font color=red >https://github.com/injekt/openapi-demo-php/blob/master/public/javascripts/demo.js</font>](https://github.com/injekt/openapi-demo-php/blob/master/public/javascripts/demo.js)

<!--### 使用标准OAUTH2.0
[<font color=red >什么是OAUTH2.0</font>](#http://tools.ietf.org/html/rfc6749)

步骤一：企业在后台构造一个连接，通过HTTP 302跳转方式，让用户访问钉钉开放平台授权网址，构造的地址如下:

`https://oapi.dingtalk.com/connect/oauth2/authorize?appid=CORPID&redirect_uri=REDIRECT_URI&response_type=code&scope=SCOPE&state=STATE`

其中REDIRECT_URI为企业H5地址，钉钉开放平台授权服务器如果判断当前用户属于当前企业时，会再次通过HTTP 302跳转回企业应用的H5地址(即REDIRECT_URI)，并在H5的URL后面追加参数code=CODE&state=STATE,即

`REDIRECT_URI?code=CODE&state=abcd1234`

步骤二：企业在后台解析code参数，获取CODE

步骤三：[<font color=red >通过CODE换取身份</font>](#通过code换取用户身份)

<aside class="notice">
有安全限制，REDIRECT_URI域名必须包含在企业所有的微应用域名内,否则会提示无权访问页面，微应用请到钉钉oa后台->选择微应用菜单->微应用中心，添加微应用
</aside>
-->

##钉钉PC版微应用中调用免登

### 使用JS-API(推荐使用)

步骤一：首先需要获取当前用户的corpid。ISV开发者请在微应用主页地址使用$CORPID$模板参数表示corpid，用户访问微应用的时候钉钉服务器将把$CORPID$替换成用户所属企业的corpid，例如原本的主页地址是http://www.dingtalk.com/index，则能获取用户corpid的主页地址为http://www.dingtalk.com/index?corpid=$CORPID$

步骤二：使用钉钉js-api提供的[<font color=red >PC版获取免登授权码</font>](#pc版获取免登授权码)接口获取CODE

步骤二：[<font color=red >通过CODE换取身份</font>](#通过code换取用户身份)

demo： 可参考手机客户端免登demo，但全局变量dd替换成DingTalkPC

<!--### 使用标准OAUTH2.0
[<font color=red >什么是OAUTH2.0</font>](#http://tools.ietf.org/html/rfc6749)

步骤一：企业在后台构造一个连接，通过HTTP 302跳转方式，让用户访问钉钉开放平台授权网址，构造的地址如下:

`https://oapi.dingtalk.com/connect/oauth2/authorize?appid=CORPID&redirect_uri=REDIRECT_URI&response_type=code&scope=SCOPE&state=STATE`

其中REDIRECT_URI为企业H5地址，钉钉开放平台授权服务器如果判断当前用户属于当前企业时，会再次通过HTTP 302跳转回企业应用的H5地址(即REDIRECT_URI)，并在H5的URL后面追加参数code=CODE&state=STATE,即

`REDIRECT_URI?code=CODE&state=abcd1234`

步骤二：企业在后台解析code参数，获取CODE

步骤三：[<font color=red >通过CODE换取身份</font>](#通过code换取用户身份)

<aside class="notice">
有安全限制，REDIRECT_URI域名必须包含在企业所有的微应用域名内,否则会提示无权访问页面，微应用请到钉钉oa后台->选择微应用菜单->微应用中心，添加微应用
</aside>
-->


##微应用后台管理员免登
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


步骤一：在OA后台，点击微应用的“进入后台”，自动跳转到准备工作1中配置的微应用后台地址，开发者从跳转的URL中解析code参数，获取CODE并保存下来

步骤二：通过[<font color=red >获取微应用后台管理Token</font>](#获取微应用后台管理Token)获取AccessToken

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

##普通钉钉用户账号开放及免登(暂未开放，敬请期待)
第三方web服务提供者，通过此项服务，可以使用普通钉钉用户账号登录自有的系统，并可将自有系统的账号与钉钉账号进行绑定，同时还能够获取钉钉用户的个人及企业数据，如姓名、手机号、对应企业的名称、企业是否认证过、企业的权益等级、其在企业内是否为管理员等信息(取决于用户最终授权)。

<font color=red >注:此功能与ISV没有关系，任何外部系统都可以使用。</font>

1: 获取完成免登过程中验证身份的appId及appSecret。

<font color=red >暂未开放，敬请期待</font>

2: 使用appid及appSecret访问如下接口，获取accesstoken。

https://oapi.dingtalk.com/sns/gettoken?appid=APPID&appsecret=APPSECRET

3: 在钉钉用户访问你的Web系统时，如果用户选择使用钉钉账号登录，则需要由你构造并引导用户跳转到如下链接。

https://oapi.dingtalk.com/connect/oauth2/sns_authorize?appid=APPID&response_type=code&scope=snsapi_login&state=STATE&redirect_uri=REDIRECT_URL

参数 | 说明
---------- | ------
appid | 需要在第1步获取,代表了你提供的服务，必填
redirect_url | 重定向地址(需要urlencode编码),该地址所在域名需要配置为appid对应的安全域名，必填
state | 用于防止重放攻击，选填
response_type | 固定为code，必填
scope | 固定为snsapi_login，必填

4:在钉钉用户登录钉钉系统后，会302到你指定的redirect_url，并向url参数中追加code及state两个参数。

5:在你的web系统获取到代表用户的code之后，使用第2步获取的AccessToken及code获取当前钉钉用户授权过的个人数据。

[<font color=red >https://oapi.dingtalk.com/sns/getuserinfo?access_token=ACCESS_TOKEN&code=CODE</font>](#通过code换取普通钉钉用户的身份信息)
