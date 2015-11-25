# 快速开发指南

假如你是企业用户，要为自己的公司开发微应用，查看[<font color=red >企业接入</font>](#企业接入)。

假如你是ISV(服务提供商)，作为第三方要给其他公司提供微应用，先查看[<font color=red >ISV接入</font>](#isv接入)。

钉钉开放平台提供了**企业通讯录管理、文件管理、发送企业会话消息**等功能，接口使用可以参考[<font color=red >服务端开发文档</font>](#服务端开发文档)；

我们定制了微应用专用的运行容器，提供了一组可以调用**钉钉的原生控件和业务逻辑**的JS接口，开发者可以通过这些接口使用钉钉中定制的原生控件或者复用钉钉原有的业务逻辑，降低开发成本，提高微应用在移动客户端的体验。接口使用可以参考[<font color=red >客户端开发文档</font>](#客户端开发文档)。

该指南主要介绍了企业和ISV（服务提供商）如何接入钉钉开放平台，其中涉及到接入过程中使用的工具、与钉钉开放平台相关的概念和接入钉钉开放平台的一些实践方法，以帮助开发者快速开发自己的微应用。


## 企业接入

企业接入指南重点介绍使用钉钉开放平台的开发微应用的流程，帮助企业快速接入钉钉开放平台。该节主要分为四个部分：第一部分介绍企业接入钉钉开放平台的准备工作；第二部介绍如何访问开放平台服务端接口；第三部分介绍钉钉开放平台提供的员工身份验证流程；第四部分介绍发送消息到微应用会话。

<br />

### 开发环境准备

开发者在使用钉钉开放平台开发微应用前需做好以下准备：

- 获取钉钉开放平台开发者信息；
- 服务端环境搭建和域名注册；
- 开发环境搭建；

开发者可以从 [<font color=red >钉钉管理后台</font>](https://oa.dingtalk.com) 获取必要的信息用于微应用开发，还可以利用该系统完成微应用配置相关的工作；开发者可以自己搭建服务器也可以购买云主机来搭建自己的服务端环境，开发者需要为自己的微应用注册合法有效的域名并配置在 [<font color=red >应用中心</font>](https://oa.dingtalk.com/#/microApp/microAppList) ；钉钉开放平台的服务端接口不区分语言和平台，开发者可以使用自己熟悉的技术搭建开发环境来开发微应用。

[<font color=red >钉钉管理后台</font>](https://oa.dingtalk.com) 系统为企业提供了企业通讯录管理、微应用、安全中心、员工数据统计和系统常用设置等功能。

![oa_system.jpg](https://img.alicdn.com/tps/TB1b4jcJFXXXXXOXpXXXXXXXXXX-666-421.jpg)

**钉钉管理后台管理员（以下简称钉钉后台管理员）** 在企业通讯录管理页面可以完成企业的组织结构和员工个人信息的添加、删除、查看和修改等操作；在微应用管理页面可以完成添加和删除微应用，获取CorpID和CorpSecret(接入钉钉开放平台的凭证)，查看微应用相关信息，管理微应用的运行状态等。开发者在使用该系统前需要注册成为钉钉后台管理员或者由钉钉后台管理员分配管理员子帐号。


### 创建微应用

一、进入 [<font color=red >钉钉管理后台</font>](https://oa.dingtalk.com) 页面, 点击 [<font color=red >企业注册</font>](https://oa.dingtalk.com/register.html?spm=0.0.0.0.dL51oc)；（已经注册可跳过此步骤）

![enterprise_register_entry](https://img.alicdn.com/tps/TB14kI8IFXXXXciapXXXXXXXXXX.jpg)

二、填写注册手机号码和短信验证码；

三、输入企业基本信息和管理员帐号和密码，点击 *注册* 按钮完成注册过程。

![input_enterprise_info](https://img.alicdn.com/tps/TB1bru8JFXXXXXcXFXXXXXXXXXX-1171-807.png)

<aside class="notice">
通过钉钉移动客户端创建的企业默认没有设置钉钉后台管理员，需要通过以上流程注册管理员帐号。
</aside>

#### 分配管理员子账号：

一、登录钉钉后台管理系统，按下图进入安全中心的添加管理员子帐号页面；

![add_sub_manager](https://img.alicdn.com/tps/TB1Q3DiJFXXXXbkXXXXXXXXXXXX-1147-377.png)

二、按下图提示填写子帐号信息

![set_sub_manager_account](https://img.alicdn.com/tps/TB16euYJFXXXXcRXFXXXXXXXXXX-601-336.png)

完成管理员子帐号设置后，子帐号关联的钉钉用户会在钉钉客户端的 *钉小秘* 会话中收到管理员帐号和初始密码，该钉钉用户可以通过收到的帐号和密码登录 [<font color=red >钉钉管理后台</font>](https://oa.dingtalk.com) 进入安全中心对初始密码进行修改。

#### 微应用管理和创建

登录钉钉管理后台后可以进入 *应用中心* 页面对微应用进行运行状态管理，进入微应用后台，微应用信息查看与设置，微应用添加和删除等操作。

![enter_microapp_center](https://img.alicdn.com/tps/TB1lnfcJFXXXXc6XXXXXXXXXXXX-1110-783.png)

点击 *新增微应用* 按钮，按下图填写微应用信息，点击确定后可以新增微应用。

![add_micro_app](https://img.alicdn.com/tps/TB1Qe_XJFXXXXalXpXXXXXXXXXX-598-477.png)

*首页地址* : 以`http://`或者`https://` 开头的URL，是微应用的首页地址；在移动设备上打开微应用Tab页，点击微应用列表中的微应用将访问这个URL指向的页面。

*后台地址* : 以`http://`或者`https://` 开头的URL，是微应用的后台管理页面地址；配置后台地址后可以通过应用中心页面进入到微应用的管理后台。

<aside class="notice">
<b>首页地址</b> 的URL域名务必保证真实有效，否则会导致钉钉用户无法正常使用微应用。
</aside>

每个微应用都有 *设置* 选项，点击后进入微应用的设置页面，开发者可以在这里修改微应用的常用信息设置

![get_micro_app_agentID](https://img.alicdn.com/tps/TB1N490JFXXXXceXFXXXXXXXXXX-602-524.png)

开发者在应用中心创建微应用后，如上图所示可获取到微应用的AgentID，AgentID可用于发送企业会话消息等场景。

开发者完成以上准备工作后就可以进入开发阶段。

<br />

创建成功之后将会在手机的工作tab上显示出来

![createMi](https://img.alicdn.com/tps/TB1xStVKpXXXXbjXFXXXXXXXXXX-361-640.jpg)


### 使用免登服务


假如在进入微应用的时候需要获取当前用户的信息，可以使用免登服务，实现账户打通。详细文档请参阅[<font color=red >免登服务</font>](#免登服务)。


<br />


### 调用平台接口

开发者在调用钉钉开放平台接口时需要附加AccessToken，AccessToken可以通过CorpID和CorpSecret获取。

#### 获取CorpID和CorpSecret

CorpID是企业的唯一标识，获取CorpID和CorpSecret的步骤如下:

一、使用管理员帐号登录 [<font color=red >钉钉管理后台</font>](https://oa.dingtalk.com) ；

二、选择顶部菜单 **微应用** 进入微应用页面，在左侧菜单选择 **微应用设置** 进入微应用设置页；

三、在微应用设置页面底部点击 **获取** 按钮即可获取CorpID和CorpSecret。

![get_scecret_corpId](https://img.alicdn.com/tps/TB1xStVKpXXXXbjXFXXXXXXXXXX-361-640.jpg)

<aside class="notice">
钉钉开放平台提供了获取和修改企业(团队)的组织结构信息、人员信息等功能，所以请妥善保管CorpID和CorpSecret，避免外泄影响企业信息安全。
</aside>

#### 获取AccessToken

开发者在调用开放平台接口前需要通过CorpID和CorpSecret获取AccessToken。获取AccessToken的方法是向 `https://oapi.dingtalk.com/gettoken?corpid=id&corpsecret=secrect` GET请求。

开发者获取AccessToken后便可以调用开放平台其他接口。

以获取部门列表接口为例，获取部门列表接口为：

`oapi.dingtalk.com/department/list`

在请求该接口时，需要将获取的AccessToken作为请求参数拼装到URL中：

`https://oapi.dingtalk.com/department/list?access_token=ACCESS_TOKEN`

更多关于AccessToken的信息请参考[<font color=red >《服务端开发文档-建立连接》</font>](#建立连接)一节。

<br />


### 发送企业会话消息

用户可以在企业会话中查看微应用发送的消息，开发者可以通过发送消息接口将消息发送到企业会话中。

![send_micro_app_message](https://img.alicdn.com/tps/TB1X.m6JFXXXXX0XFXXXXXXXXXX-1089-652.jpg)

调用消息发送接口时需要使用`HTTPS`协议，发送的数据包为`JSON`格式。目前钉钉开放平台支持文本、图片、声音、文件、链接、办公消息等消息类型。

### 示例程序

在[<font color=red >《Open API - 代码示例》</font>](#demo)中有发送消息的代码演示，开发者可以下载参考。

如果在使用开放平台中遇到困难请浏览[<font color=red >《常见问题》</font>](#faq)一节，若仍不能解决请按概述中的提供的反馈方式联系我们。

## ISV接入

### 钉钉ISV（服务提供商）应用授权和接口说明

欢迎成为钉钉微应用的服务提供商！
通过接入钉钉ISV的应用授权接口，可以快速发布自己的微应用套件，引导企业客户自动开通微应用，将自己的服务快速触达到自己的目标客户！
钉钉的应用授权方案包含以下两个场景：

#### ISV注册应用

你，作为ISV若要使用此方案，只需在阿里云上注册成为第三方服务提供商，在ISV接入后台创建应用套件，并在应用套件中配置好相应的应用。
本方案所说的应用套件，是第三方应用授权的主体，它可以包含多个第三方所提供的同一类型的应用。目前一个第三方最多可以注册五个应用套件，一个应用套件最多可以包含五个应用。

#### 企业管理员授权应用

企业的管理员在钉钉企业后台的微应用列表中浏览你的应用套件后，即可发起一键授权，系统将展示微应用的第三方授权页面，管理员根据授权页面的引导，确认授权内容，完成授权操作。
授权完成之后，企业就可使用ISV服务提供商所提供的应用服务了。一切将变得简单自然。以下是详细的接口调用时序图

![Mou icon](https://img.alicdn.com/tps/TB1RhMGJXXXXXXdXVXXXXXXXXXX-876-659.jpg)

### 1:注册成为第三方服务提供商

#### 1.1需要提供的数据项


字段  		| 属性
-----------	| -------------
开发者介绍	| 100字
开发应用类型	| 选择“钉钉企业账号”
钉钉企业账号 	| 4-11位小写英文字符、数字、下划线
账号密码 		| 必须为6位以上数字、大小写字母的组合


#### 1.2 描述（Description）

阿里云用户登录后，在通过实名认证的情况下，填写相关信息，完成开发者的身份申请。

#### 1.3 前置条件（Pre-Conditions）

申请者首先是阿里云用户

#### 1.4 基本流程（Basic Flow）

##### a. 点击进入[<font color=red >控制台</font>](http://console.d.aliyun.com)，进行登录。

##### b. 登录阿里云账号

##### c. 进行实名认证（已经实名认证过的开发者直接看g.步骤）

用户未通过实名认证，需要实名认证后，才能申请开发者，流程如下：

##### d. 点击“立即认证”

![lijirz](https://img.alicdn.com/tps/TB1PUwmIVXXXXbbXXXXXXXXXXXX-866-305.png)

##### e. 新开窗口跳转到阿里云认证页面

![shimingrz](https://img.alicdn.com/tps/TB1lv3iIVXXXXa6XpXXXXXXXXXX-866-412.png)

##### f. 实名认证通过，在弹窗点击“立即刷新”按钮

![zhengzairz](https://img.alicdn.com/tps/TB11m_VIVXXXXaqapXXXXXXXXXX-866-334.png)

##### g. 显示已通过实名认证

![shiming](https://img.alicdn.com/tps/TB1C3T6IVXXXXXWaXXXXXXXXXXX-866-335.png)

##### h. 选择开发应用类型为“钉钉企业类型”，填入“钉钉企业账号”

##### i. 显示申请开发者成功




### 2: 创建套件

#### 2.1 需要提供的数据项：

字段  		| 属性
-----------	| -------------
套件Logo		| 上传大小不超过1M，长宽等比且范围在50px至200px之间的png格式图片
回调URL		| 以http://开头，系统将会把此套件的SuiteTicket，临时授权码以及授权变更事件推送给此URL，详细请看[<font color=red >回调接口</font>](#5-回调接口（分为五个回调类型）)
Token 		| 可任意填写，用于生成签名，校验回调请求的合法性。本套件下相关应用产生的回调消息都使用该值来解密。
数据加密密钥 	| 回调消息加解密参数，是AES密钥的Base64编码，用于解密回调消息内容对应的密文。本套件下相关应用产生的回调消息都使用该值来解密。
IP白名单		| 调用钉钉API时的合法IP列表，多个IP请以“,”隔开，如IP有变化，请立即更新
部署方式		| 选择ACE，系统接下来将自动开通基于ACE的开发环境，选择其他则需要自行准备开发环境
当前状态 		| 对于需要公开售卖的套件，只有处于已完成状态，才可进入售卖流程

#### 2.2 描述（Description）

在开发钉钉应用前，首先要创建一个套件，套件可以包含一组应用，并对这组应用统一进行权限管理。

#### 2.3 前置条件（Pre-Conditions）

阿里云用户成功申请开发者

#### 2.4 基本流程（Basic Flow）

##### a.钉钉应用菜单-套件列表，点击“创建套件”

![createtj](https://img.alicdn.com/tps/TB1fyqYJFXXXXcXXVXXXXXXXXXX-1346-479.jpg)

##### b．填写创建套件表单

![createtjbd](https://img.alicdn.com/tps/TB1Az_EJFXXXXb3XFXXXXXXXXXX-678-539.jpg)


**当您注册套件时，钉钉服务器为了避免无效推送，将会验证回调url的有效性，对回调url推送"验证回调URL有效性事件"，收到推送后您需要做正确的处理，才能成功创建套件。详细处理步骤请查看[<font color=red >回调接口</font>](#5-回调接口（分为五个回调类型）)和"验证回调URL有效性事件"。**

##### c.点击“确定”按钮进入套件列
在这里可以查看套件详细信息，比如套件Key（suite_key），套件secret(suite_secret)


### 3: 创建微应用

#### 3.1 需要提供的数据项：

字段  		| 属性
-----------	| -------------
名称 		| 应用的名称，2-16个字。
图标 		| 上传大小不超过1M，长宽等比且范围在50px至200px之间的png格式图片
应用描述 		| 描述该应用的功能与特色，4-120个字内
主页地址	 	| 以http://开头，用于接收托管企业应用的用户消息，URL支持使用$CORPID$模板参数表示corpid，用户访问应用的时候将把$CORPID$替换成用户所属企业的corpid，例如http://www.dingtalk.com/index?corpid=$CORPID$
权限设置		| 多选
接口权限		| 多选

#### 3.2 描述（Description）

开发者编辑套件基本信息，创建微应用。

#### 3.3 前置条件（Pre-Conditions）

阿里云用户，申请成为开发者，套件列表点击“管理”操作

#### 3.4 基本流程（Basic Flow）

##### a 查看套件基本信息

##### b 点击“创建微应用按钮”

![createmini1](https://img.alicdn.com/tps/TB19X14JFXXXXc3XFXXXXXXXXXX-1164-326.jpg)

##### c 添加创建微应用表单，点击“确定”按钮

![createmini2](https://img.alicdn.com/tps/TB1G0nnJFXXXXa8XXXXXXXXXXXX-705-649.jpg)

##### d 微应用列表添加一行记录

![createmini3](https://img.alicdn.com/tps/TB1V7DoJFXXXXarXXXXXXXXXXXX-1164-440.jpg)

### 4: 注册测试企业

#### 1.描述（Description）

钉钉套件在开发过程中，需要在钉钉移动端上登录绑定了相关企业的钉钉帐号来进行调试。在此之前，需要开发者对注册的测试企业"发起授权所有套件"，之后钉钉服务器会向您填写的回调url[<font color=red>推送临时授权码</font>](##5-回调接口（分为五个回调类型）)，您需要通过临时授权码一步一步到[<font color=red>激活授权套件</font>](#11-激活授权套件)，才能让测试企业的微应用列表出现您开发的微应用。

#### 2.前置条件（Pre-Conditions）

阿里云用户成功申请开发者

#### 3.基本流程（Basic Flow）

##### a.钉钉应用菜单—开发环境列表，点击“注册测试企业”

![signintest1](https://img.alicdn.com/tps/TB1VBWRJVXXXXXGaXXXXXXXXXXX-1022-78.jpg)
##### b.填写企业相关信息

![signintest2](https://img.alicdn.com/tps/TB1p1H3IVXXXXX8aXXXXXXXXXXX-729-447.png)

##### c.点击“确定”后列表增加一行记录

![signintest3](https://img.alicdn.com/tps/TB1pvqVJVXXXXahXVXXXXXXXXXX-1029-343.jpg)

##### d.点击“模拟测试企业发起授权所有套件”，弹窗提示微应用开通成功

注意：只有在微应用注册的回调接口能够接收推送，才能成功开通微应用，具体详情查看[<font color=red>回调接口</font>](#5-回调接口（分为五个回调类型）)

![signintest4](https://img.alicdn.com/tps/TB1B2njJVXXXXaEXXXXXXXXXXXX-1048-158.jpg)

##### e.点击“登录管理”跳转钉钉登录后台

![signintest5](https://img.alicdn.com/tps/TB1lEKUJVXXXXaSXVXXXXXXXXXX-1048-158.jpg)

![signintest6](https://img.alicdn.com/tps/TB1snUfIVXXXXbSXpXXXXXXXXXX-866-456.png)

### 5: 回调接口（分为五个回调类型）
在使用回调接口之前您需要了解的是，

首先要拿到您创建套件时填写的"回调URL"，"Token"，"数据加密密钥(ENCODING_AES_KEY)"，

- 回调URL:服务提供商接收推送请求的协议和地址

- Token:服务提供商在注册时任意填写的，用来生成signature，用来和回调参数中的signature比对，校验消息的合法性

- 数据加密密钥(ENCODING_AES_KEY):用于消息体的加解密。

钉钉服务器会向服务提供商申请时填写的套件回调URL定时推送SuiteTicket，以及临时授权码和授权设置变更。

假设您提供的回调URL是

`https://127.0.0.1/suite/receive`

那么在钉钉服务器每一次访问回调URL的时候
将请求(下面链接中的signature,timestamp,nonce的值只是示例，并不代表真实返回的值):

`https://127.0.0.1/suite/receive?signature=111108bb8e6dbce3c9671d6fdb69d15066227608
&timestamp=1783610513&nonce=380320111`

```
{
	"encrypt":"1ojQf0NSvw2WPvW7LijxS8UvISr8pdDP+rXpPbcLGOmIBNbWetRg7IP0vdhVgkVwSoZBJeQwY2zhROsJq/HJ+q6tp1qhl9L1+ccC9ZjKs1wV5bmA9NoAWQiZ+7MpzQVq+j74rJQljdVyBdI/dGOvsnBSCxCVW0ISWX0vn9lYTuuHSoaxwCGylH9xRhYHL9bRDskBc7bO0FseHQQasdfghjkl"
}
```

回调数据的格式如右所示：

其中的encrypt字段是经过加密的消息体，encrypt经过一系列解密步骤后，才能产生下面所说的“POST数据解密后示例”，服务提供商可以直接使用钉钉提供的库进行解密的处理。

除此之外，在接收到推送之后，**需要返回相应的加密字符串（代表了你收到了推送）**，如果ISV未能成功返回，钉钉服务器将持续推送下去，达到100次后将不再推送。

"Talk is cheap, show me the code."所以我们也为开发者提供了加解密的demo，目前提供Java/PHP等语言版本。
加解密库和demo的下载：[<font color=red >加解密库和demo下载</font>](#加解密库和demo下载)

本地调试：[<font color=red >如何本地进行调试？</font>](#调试工具)

如有需要，可以查看具体加解密步骤：[<font color=red >查看</font>](#12-加解密方案)



#### a.<font color=red >验证回调URL有效性事件</font>

此事件的推送会发生在注册套件，点击下图按钮之时。注意，若未能成功验证回调URL有效性，套件将不能被创建。

![verifyurl](https://img.alicdn.com/tps/TB1RuHzJFXXXXahXVXXXXXXXXXX-615-100.jpg)

```
dingTalkEncryptor = new DingTalkEncryptor(Env.TOKEN, Env.ENCODING_AES_KEY, Env.CREATE_SUITE_KEY);//套件在创建中，使用默认的SUITE_KEY进行加解密

```

此时，由于套件尚未创建成功，还未生成套件的SUITE_KEY，所以在解密post数据的时候，需要使用默认的Env.CREATE_SUITE_KEY（默认值为"suite4xxxxxxxxxxxxxxx"）来解密，以java-demo代码为例（Env为Demo中配置文件），如右。


待成功处理『验证回调URL有效性事件』事件，套件创建成功之后，就不能再使用默认的SUITE_KEY了，需要使用套件本身的SUITE_KEY，所以需要在Env.java中配置SUITE_KEY，然后重新部署代码,此时将用下面的语句进行加解密。


`dingTalkEncryptor = new DingTalkEncryptor(Env.TOKEN, Env.ENCODING_AES_KEY, Env.SUITE_KEY);//套件创建成功后，使用套件本身的SUITE_KEY进行加解密`



POST数据解密后示例

```

{

  "EventType":"check_create_suite_url",
  "Random":"brdkKLMW",
  "TestSuiteKey":"suite4xxxxxxxxxxxxxxx"

}

```


参数      | 说明
-------   | -------------
Random  | 随机字符串
EventType | check_create_suite_url
TestSuiteKey  | 校验的SuiteKey

##### 返回说明

服务提供商在收到此事件推送后务必返回包含经过加密后"Random"字段的json数据，比如对于上面的示例，需要返回的即是加密后的"brdkKLMW"字符串。

只有返回了对应的json数据，钉钉才会判断此事件推送成功，套件才能创建成功。

```

{
  "msg_signature":"111108bb8e6dbce3c9671d6fdb69d15066227608",
  "timeStamp":"1783610513",
  "nonce":"123456",
  "encrypt":"1ojQf0NSvw2WPvW7LijxS8UvISr8pdDP+rXpPbcLGOmIBNbWetRg7IP0vdhVgkVwSoZBJeQwY2zhROsJq/HJ+q6tp1qhl9L1+ccC9ZjKs1wV5bmA9NoAWQiZ+7MpzQVq+j74rJQljdVyBdI/dGOvsnBSCxCVW0ISWX0vn9lYTuuHSoaxwCGylH9xRhYHL9bRDskBc7bO0FseHQQasdfghjkl" // "Random"字段的加密数据
}

```

参数      | 说明
-------   | -------------
msg_signature  | 消息体签名
timeStamp | 时间戳
nonce  | 随机字符串
encrypt  | "Random"字段的加密字符串






#### b: 定时推送Ticket

服务器会向服务提供商申请时填写的套件事件接收 URL定时（二十分钟）推送ticket：


服务提供商在收到ticket推送后务必返回经过加密的字符串"success"的json数据


如果不返回，钉钉服务器将连续推送，直到推送次数超过100次，就不再推送。倘若您希望钉钉服务器重新推送，需要进入[<font color=red>开发者后台</font>](http://console.d.aliyun.com)，进入套件管理页面，点击『重新推送』按钮，即可重新推送。
![repush](https://img.alicdn.com/tps/TB15j7OJFXXXXckXXXXXXXXXXXX-1121-124.jpg)

POST数据解密后示例

```
{
  "SuiteKey": "suitexxxxxx",
  "EventType": "suite_ticket ",
  "TimeStamp": 1234456,
  "SuiteTicket": "adsadsad"
}
```

参数			| 说明
-------		| -------------
SuiteKey	| 应用套件的SuiteKey
EventType	| suite_ticket
TimeStamp	| 时间戳
SuiteTicket	| Ticket内容

##### 返回说明

服务提供商在收到此事件推送后务必返回包含经过加密的字符串"success"的json数据

只有返回了对应的json数据，钉钉才会判断此事件推送成功，套件才能创建成功。

```

{
  "msg_signature":"111108bb8e6dbce3c9671d6fdb69d15066227608",
  "timeStamp":"1783610513",
  "nonce":"123456",
  "encrypt":"1ojQf0NSvw2WPvW7LijxS8UvISr8pdDP+rXpPbcLGOmIBNbWetRg7IP0vdhVgkVwSoZBJeQwY2zhROsJq/HJ+q6tp1qhl9L1+ccC9ZjKs1wV5bmA9NoAWQiZ+7MpzQVq+j74rJQljdVyBdI/dGOvsnBSCxCVW0ISWX0vn9lYTuuHSoaxwCGylH9xRhYHL9bRDskBc7bO0FseHQQasdfghjkl" // "Random"字段的加密数据
}

```

参数      | 说明
-------   | -------------
msg_signature  | 消息体签名
timeStamp | 时间戳
nonce  | 随机字符串
encrypt  | "success"加密字符串


#### c:回调向ISV推送临时授权码

当授权方（即授权企业）在微应用管理端的授权管理中，向服务提供商的应用套件授权了访问权限，钉钉服务器会向服务提供商的套件事件接收 URL（创建套件时填写）推送临时授权码，

比如在[<font color=red>钉钉开发者后台</font>](http://console.d.aliyun.com)中，模拟测试企业发起授权，钉钉服务器就会向回调url推送测试企业的临时授权码

![shouqun](https://img.alicdn.com/tps/TB1rZerKpXXXXX8XXXXXXXXXXXX-720-124.jpg)


收到临时授权码之后请按照步骤换取永久授权码，并将永久授权码存下来。

POST数据解密后示例

```
{
  "SuiteKey": "suitexxxxxx",
  "EventType": " tmp_auth_code",
  "TimeStamp": 1234456,
  "AuthCode": "adads"
}
```

字段说明

参数			| 说明
-------		| -------------
SuiteKey	| 应用套件的SuiteKey
EventType	| tmp_auth_code
TimeStamp	| 时间戳
AuthCode	| 临时授权码

##### 返回说明

服务提供商在收到此事件推送后务必返回包含经过加密的字符串"success"的json数据

只有返回了对应的json数据，钉钉才会判断此事件推送成功，套件才能创建成功。

```

{
  "msg_signature":"111108bb8e6dbce3c9671d6fdb69d15066227608",
  "timeStamp":"1783610513",
  "nonce":"123456",
  "encrypt":"1ojQf0NSvw2WPvW7LijxS8UvISr8pdDP+rXpPbcLGOmIBNbWetRg7IP0vdhVgkVwSoZBJeQwY2zhROsJq/HJ+q6tp1qhl9L1+ccC9ZjKs1wV5bmA9NoAWQiZ+7MpzQVq+j74rJQljdVyBdI/dGOvsnBSCxCVW0ISWX0vn9lYTuuHSoaxwCGylH9xRhYHL9bRDskBc7bO0FseHQQasdfghjkl" // "Random"字段的加密数据
}

```

参数      | 说明
-------   | -------------
msg_signature  | 消息体签名
timeStamp | 时间戳
nonce  | 随机字符串
encrypt  | "success"加密字符串


#### d:回调向ISV推送授权变更消息

当授权方（即授权企业）在微应用管理端中，修改了对套件的授权托管后，钉钉服务器会向服务提供商的套件事件接收 URL（创建套件时填写）推送授权变更消息。注意，推送的授权变更信息并不包括企业用户具体做了什么修改，所以收到推送之后,

**ISV需要通过调用[<font color=red >获取企业的应用信息</font>](#10-获取企业的应用信息)接口**，获取接口返回值其中的"close"参数，才能得知微应用在企业用户做了授权变更之后的状态，有三种状态码，分别为0，1，2.含义如下：

- 0:禁用（例如企业用户在OA后台禁用了微应用）
- 1:正常 (例如企业用户在禁用之后又启用了微应用)
- 2:待激活 (企业已经进行了授权，但是ISV还未为企业激活应用)

再根据具体状态做具体操作。比如状态为2，就需要ISV为企业进行激活授权套件的操作。

POST数据解密后示例

```
{
  "SuiteKey": "suitexxxxxx",
  "EventType": " change_auth",
  "TimeStamp": 1234456,
  "AuthCorpId": "xxxxx"
}
```



字段说明

参数			| 说明
-------		| -------------
SuiteKey	| 应用套件的SuiteKey
EventType	| change_auth
TimeStamp	| 时间戳
AuthCorpID	| 授权方企业的corpid

##### 返回说明

服务提供商在收到此事件推送后务必返回包含经过加密的字符串"success"的json数据

只有返回了对应的json数据，钉钉才会判断此事件推送成功，套件才能创建成功。

```

{
  "msg_signature":"111108bb8e6dbce3c9671d6fdb69d15066227608",
  "timeStamp":"1783610513",
  "nonce":"123456",
  "encrypt":"1ojQf0NSvw2WPvW7LijxS8UvISr8pdDP+rXpPbcLGOmIBNbWetRg7IP0vdhVgkVwSoZBJeQwY2zhROsJq/HJ+q6tp1qhl9L1+ccC9ZjKs1wV5bmA9NoAWQiZ+7MpzQVq+j74rJQljdVyBdI/dGOvsnBSCxCVW0ISWX0vn9lYTuuHSoaxwCGylH9xRhYHL9bRDskBc7bO0FseHQQasdfghjkl" // "Random"字段的加密数据
}

```

参数      | 说明
-------   | -------------
msg_signature  | 消息体签名
timeStamp | 时间戳
nonce  | 随机字符串
encrypt  | "success"加密字符串



#### e."套件信息更新"事件

此事件的推送会发生在更新套件信息的时候。

POST数据解密后示例

```

{
  "EventType":"check_update_suite_url",
  "Random":"Aedr5LMW",
  "TestSuiteKey":"suited6db0pze8yao1b1y"

}

```

服务提供商在收到"套件信息更新"事件推送后务必返回经过加密后"Random"字段，比如对于右边的示例，需要返回的即是加密后的"Aedr5LMW"字符串。


参数			| 说明
-------		| -------------
Random	| 随机字符串
EventType	| check_update_suite_url
TestSuiteKey	| 校验的SuiteKey(此处为套件的SuiteKey)

##### 返回说明

服务提供商在收到此事件推送后务必返回包含经过加密后"Random"字段的json数据，比如对于上面的示例，需要返回的即是加密后的"Aedr5LMW"字符串。

只有返回了对应的json数据，钉钉才会判断此事件推送成功，套件才能创建成功。

```

{
  "msg_signature":"111108bb8e6dbce3c9671d6fdb69d15066227608",
  "timeStamp":"1783610513",
  "nonce":"123456",
  "encrypt":"1ojQf0NSvw2WPvW7LijxS8UvISr8pdDP+rXpPbcLGOmIBNbWetRg7IP0vdhVgkVwSoZBJeQwY2zhROsJq/HJ+q6tp1qhl9L1+ccC9ZjKs1wV5bmA9NoAWQiZ+7MpzQVq+j74rJQljdVyBdI/dGOvsnBSCxCVW0ISWX0vn9lYTuuHSoaxwCGylH9xRhYHL9bRDskBc7bO0FseHQQasdfghjkl" // "Random"字段的加密数据
}

```

参数      | 说明
-------   | -------------
msg_signature  | 消息体签名
timeStamp | 时间戳
nonce  | 随机字符串
encrypt  | "Random"字段的加密字符串




### 6: 获取套件访问Token（suite_access_token）

该API用于获取应用套件令牌（suite_access_token）

接口调用请求说明
https请求方式: POST
https://oapi.dingtalk.com/service/get_suite_token

POST数据示例

```
{
	"suite_key":"key_value",
 	"suite_secret": "secret_value",
	"suite_ticket": "ticket_value"
}
```

请求参数说明

参数				| 说明
-------			| -------------
suite_key		| 应用套件的key
suite_secret	| 应用套件secret
suite_ticket	| 钉钉后台推送的ticket


返回结果示例

```
{
	"suite_access_token":"61W3mEpU66027wgNZ_MhGHNQDHnFATkDa9-2llqrMBjUwxRSNPbVsMmyD-yq8wZETSoE5NQgecigDrSHkPtIYA", 	"expires_in":7200
}
```

结果参数说明

参数		| 说明
-------	| -------------
suite_access_token	| 应用套件access_token
expires_in			| 有效期


### 7: 获取企业的永久授权码

该API用于使用临时授权码换取授权方的永久授权码，并换取授权信息、企业access_token。得到永久授权码之后请将永久授权码存储下来。

注：临时授权码使用一次后即失效

接口调用请求说明
https请求方式: POST
https://oapi.dingtalk.com/service/get_permanent_code?suite_access_token=xxxx

POST数据示例

```
{
	"tmp_auth_code": " value"
}
```

请求参数说明

参数		| 说明
-------	| -------------
tmp_auth_code | 回调接口（tmp_auth_code）获取的临时授权码

返回结果示例

```
{
	"permanent_code": "xxxx",
	"auth_corp_info":
	{
		"corpid": "xxxx",
		"corp_name": "name"
    },
    "auth_user_info":
    {
    	"userId":""
	}
}
```

结果参数说明

参数		| 说明
-------	| -------------
permanent_code | 永久授权码
auth_corp_info | 授权方企业信息
corpid | 授权方企业id
corp_name | 授权方企业名称
auth_user_info | 授权方管理员信息
mobile | 管理员电话
name | 管理员名字

### 8:获取企业授权的access_token

服务提供商在取得企业的永久授权码并完成对企业应用的设置之后，便可以开始通过调用企业接口来运营这些应用。其中，调用企业接口所需的access_token获取方法如下。

接口调用请求说明

https请求方式: POST
https://oapi.dingtalk.com/service/get_corp_token?suite_access_token=xxxx

POST数据示例

```
{
	"auth_corpid": "auth_corpid_value",
	"permanent_code": "code_value"
}
```

请求参数说明

参数		| 说明
-------	| -------------
auth_corpid	| 授权方corpid
permanent_code | 永久授权码，通过get_permanent_code获取

返回结果示例

```
{
	"access_token": "xxxxxx",
	"expires_in": 7200
}
```

结果参数说明

参数 | 说明
-------	| -------------
access_token | 授权方（企业）access_token
expires_in | 授权方（企业）access_token超时时间

### 9: 获取企业授权的授权数据

该API用于通过永久授权码换取授权信息。 永久授权码的获取，是通过临时授权码使用get_permanent_code 接口获取到的permanent_code。

接口调用请求说明

https请求方式: POST

https://oapi.dingtalk.com/service/get_auth_info?suite_access_token=xxxx

POST数据示例

```
{
	"auth_corpid":"auth_corpid_value",
	"permanent_code":"code_value",
	"suite_key":"key_value"
}
```

请求参数说明

参数					| 说明
-------				| -------------
suite_key			| 应用套件key
auth_corpid			| 授权方corpid
permanent_code		| 永久授权码，通过get_permanent_code获取

返回结果示例

```
{
   "auth_corp_info":{
	  "corp_logo_url":"http://xxxx.png",
	  "corp_name":"corpid",
	  "corpid":"auth_corpid_value",
	  "industry":"互联网",
	  "invite_code" : "1001"
	},
	"auth_user_info":
    {
    	"userId":""
	},
    "auth_info":{
	"agent":[{
			"agent_name":"aaaa",
			"agentid":1,
			"appid":-3,
			"logo_url":"http://aaaaaa.com"
	}
	,{
			"agent_name":"bbbb",
			"agentid":4,
			"appid":-2,
			"logo_url":"http://vvvvvv.com"
	}]
	},
		  "errcode":0,
		  "errmsg":"ok"
}
```

结果参数说明

参数					| 说明
-------				| -------------
auth_corp_info		| 授权方企业信息
corpid				| 授权方企业id
invite_code         | 表示邀请码，只有填写过且是ISV自己邀请码的数据才会返回,否则值为空字符串
industry			| 表示企业所属行业
corp_name			| 授权方企业名称
auth_user_info      | 授权方管理员信息
mobile              | 管理员电话
name                | 管理员名字
corp_logo_url		| 企业logo
auth_info			| 授权信息
agent				| 授权的应用信息
agentid				| 授权方应用id
agent_name			| 授权方应用名字
logo_url			| 授权方应用头像
appid				| 服务商套件中的对应应用id


### 10:获取企业的应用信息

该API用于获取授权方的企业的某个应用的基本信息，包括LOGO,名称，描述等,信息接口调用请求说明

https请求方式: POST

https://oapi.dingtalk.com/service/get_agent?suite_access_token=xxxx

POST数据示例

```
{	"suite_key":"key_value",
	"auth_corpid":"auth_corpid_value",
	"permanent_code":"code_value",
	"agentid":541
}
```

请求参数说明

参数					| 说明
-------				| -------------
suite_key			| 应用套件key
auth_corpid			| 授权方corpid
permanent_code		| 永久授权码，从get_permanent_code接口中获取
agentid				| 授权方应用id

返回结果示例

```
{
	"agentid":541,
	"name":"公告",	
	"logo_url":"http://xxxxxxx/png",
	"description":"企业重要消息",
	"close":1,
	"errcode":0,
	"errmsg":"ok"
}
```

结果参数说明

参数			| 说明
-------		| -------------
agentid		| 授权方企业应用id
name		| 授权方企业应用名称
logo_url	| 授权方企业应用头像
description	| 授权方企业应用详情
close		| 授权方企业应用是否被禁用（0:禁用  1:正常  2:待激活 ）

### 11:激活授权套件

该API用于激活授权方企业的套件微应用,信息接口调用请求说明

https请求方式: POST

https://oapi.dingtalk.com/service/activate_suite?suite_access_token=xxxx

POST数据示例

```
{
	"suite_key":"key_value",
	"auth_corpid":"auth_corpid_value",
	"permanent_code":"permanent_code"
}
```

请求参数说明

参数				| 说明
-------			| -------------
suite_key		| 应用套件key
auth_corpid		| 授权方corpid
permanent_code	| 永久授权码，从get_permanent_code接口中获取

返回结果示例

```
{
	"errcode":0,
	"errmsg":"ok"
}
```

### 12: 加解密方案

开启回调模式时，有以下术语需要了解：

1. signature是签名，用于验证调用者的合法性。具体算法见以下'消息体签名'章节

2. EncodingAESKey：注册套件提供的数据加密密钥。用于消息体的加密，长度固定为43个字符，从a-z, A-Z, 0-9共62个字符中选取，是AESKey的Base64编码。解码后即为32字节长的AESKey

3. AESKey=Base64_Decode(EncodingAESKey + “=”)，是AES算法的密钥，长度为32字节。AES采用CBC模式，数据采用PKCS#7填充；IV初始向量大小为16字节，取AESKey前16字节。具体详见：http://tools.ietf.org/html/rfc2315

4. msg为消息体明文，格式为JSON

5. 钉钉服务器会把msg消息体明文编码成encrypt，encrypt = Base64_Encode(AES_Encrypt[random(16B) + msg_len(4B) + msg + $key])，是对明文消息msg加密处理后的Base64编码。其中random为16字节的随机字符串；msg_len为4字节的msg长度，网络字节序；msg为消息体明文；$key对于ISV开发来说，填写对应的suitekey，$key对于普通企业开发，填写企业的Corpid。
最终传给回调者的是encrypt，字段名为encrypt。


### 消息体签名

为了验证调用者的合法性，钉钉在回调url中增加了消息签名，以参数signature标识，企业需要验证此参数的正确性后再解密。

验证步骤：

1.  企业计算签名：dev_msg_signature=sha1(sort(token、timestamp、nonce、msg_encrypt))。sort的含义是将参数按照字母字典排序，然后从小到大拼接成一个字符串

2. 比较dev_msg_signature和回调接口中推送的字段signature是否相等，相等则表示验证通过


##### 加解密方案说明

######	对明文msg加密的过程如下：

msg_encrypt = Base64_Encode( AES_Encrypt[random(16B) + msg_len(4B) + msg + $key] )
AES加密的buf由16个字节的随机字符串、4个字节的msg长度、明文msg和$key组成。其中msg_len为msg的字节数，网络字节序；

* $key对于ISV来说，填写对应的suitekey
* $key对于普通企业开发，填写企业的Corpid

##### 对应于加密方案，解密方案如下：

* 取出返回的JSON中的encrypt字段。
* 对密文BASE64解码：aes_msg=Base64_Decode(encrypt)
* 使用AESKey做AES解密：rand_msg=AES_Decrypt(aes_msg)
* 验证解密后$key、msg_len
* 去掉rand_msg头部的16个随机字节，4个字节的msg_len,和尾部的$CorpID即为最终的消息体原文msg

### 加解密库和demo下载
#### Java库和demo
首先，您需要做以下准备工作

1.请开发者使用jdk1.6或以上版本，针对加解密包中使用的org.apache.commons.codec.binary.Base64，须导入jar包commons-codec-1.10(或comm ons-codec-1.9等其他版本)，在java-demo的WebContent/WEB_INF/lib目录中我们也提供了commons-codec-1.10.jar。

官方下载地址：[http://commons.apache.org/proper/commons-codec/download_codec.cgi](http://commons.apache.org/proper/commons-codec/download_codec.cgi)

2.异常java.security.InvalidKeyException:illegal Key Size和『计算解密文字错误』的解决方案：

在官方网站下载JCE无限制权限策略文件
JDK6的下载地址：[http://www.oracle.com/technetwork/java/javase/downloads/jce-6-download-429243.html](http://www.oracle.com/technetwork/java/javase/downloads/jce-6-download-429243.html)

JDK7的下载地址：[http://www.oracle.com/technetwork/java/javase/downloads/jce-7-download-432124.html](http://www.oracle.com/technetwork/java/javase/downloads/jce-7-download-432124.html)

下载后解压，可以看到local_policy.jar和US_export_policy.jar以及readme.txt。如果安装的是JRE，将两个jar文件放到%JRE_HOME% \lib\security目录下覆盖原来的文件，如果安装的是JDK，将两个jar文件放到%JDK_HOME%\jre\lib\security目录下覆盖原来文件。

库地址：[https://github.com/injekt/openapi-demo-java/tree/master/src/com/alibaba/dingtalk/openapi/demo/utils/aes](https://github.com/injekt/openapi-demo-java/tree/master/src/com/alibaba/dingtalk/openapi/demo/utils/aes)

demo地址：[https://github.com/injekt/openapi-demo-java/blob/master/src/com/alibaba/dingtalk/openapi/servlet](https://github.com/injekt/openapi-demo-java/blob/master/src/com/alibaba/dingtalk/openapi/servlet)

#### php库和demo
库地址：[https://github.com/injekt/openapi-demo-php/tree/master/crypto](https://github.com/injekt/openapi-demo-php/tree/master/crypto)

demo地址：[https://github.com/injekt/openapi-demo-php/blob/master/receive.php](https://github.com/injekt/openapi-demo-php/blob/master/receive.php)

#### C#库和demo
库地址：[https://github.com/ian-cuc/suite-demo-c-/tree/master/API](https://github.com/ian-cuc/suite-demo-c-/tree/master/API)

demo地址：[https://github.com/ian-cuc/suite-demo-c-/blob/master/receive.ashx.cs](https://github.com/ian-cuc/suite-demo-c-/blob/master/receive.ashx.cs)

###调试工具

回调接口本地调试方案：由于回调接口需要在外网环境接收钉钉服务器的推送，假如开发者暂时没有外网地址，需要在本地调试回调接口的加解密方案，可以在本地环境构造推送。具体构造参数示例：
URL后面带的参数：signature=5a65ceeef9aab2d149439f82dc191dd6c5cbe2c0&timestamp=1445827045067&nonce=nEXhMP4r
Post参数：{"encrypt":"1a3NBxmCFwkCJvfoQ7WhJHB+iX3qHPsc9JbaDznE1i03peOk1LaOQoRz3+nlyGNhwmwJ3vDMG+OzrHMeiZI7gTRWVdUBmfxjZ8Ej23JVYa9VrYeJ5as7XM/ZpulX8NEQis44w53h1qAgnC3PRzM7Zc/D6Ibr0rgUathB6zRHP8PYrfgnNOS9PhSBdHlegK+AGGanfwjXuQ9+0pZcy0w9lQ=="
}
Token：123456
数据加密密钥(ENCODING_AES_KEY)：4g5j64qlyl3zvetqxz5jiocdr586fn2zvjpa8zls3ij

suitekey：suite4xxxxxxxxxxxxxxx


ISV接入相关接口调试：[<font color=red >ISV接入调试工具</font>](https://debug.dingtalk.com/isv.html)








