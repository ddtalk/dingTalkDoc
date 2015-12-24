# 快速开发指南

假如你是企业用户，要为自己的公司开发微应用，查看[<font color=red >企业接入</font>](#企业接入)。

假如你是ISV(服务提供商)，作为第三方要给其他公司提供微应用，先查看[<font color=red >ISV接入</font>](#isv接入)。

钉钉开放平台提供了**企业通讯录管理、文件管理、发送企业会话消息**等功能，接口使用可以参考[<font color=red >服务端开发文档</font>](#服务端开发文档)；

我们定制了微应用专用的运行容器，提供了一组可以调用**钉钉的本地能力和业务逻辑**的JS接口，开发者可以通过这些接口使用钉钉的本地能力或者钉钉的业务逻辑，降低开发成本，提高微应用在移动客户端的体验。接口使用可以参考[<font color=red >客户端开发文档</font>](#客户端开发文档)。

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
AuthCorpId	| 授权方企业的corpid

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


#### f."解除授权"事件

此事件的推送会发生在企业解除套件授权的时候。

POST数据解密后示例

```

{
  "EventType":"suite_relieve",
  "SuiteKey":"suited6db0pze8yao1b1y",
  "TimeStamp":"12351458245",
  "AuthCorpId":"ding4583267d28sd61"
}

```

服务提供商在收到"解除授权"事件推送后务必返回包含经过加密的字符串"success"的json数据。


参数			| 说明
-------		| -------------
SuiteKey	| 应用套件的SuiteKey
EventType	| suite_relieve
TimeStamp	| 时间戳
AuthCorpId	|授权方企业的corpid

##### 返回说明

服务提供商在收到"解除授权"事件推送后务必返回包含经过加密的字符串"success"的json数据。

只有返回了对应的json数据，钉钉才会判断此事件推送成功。

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
encrypt  | "success"字段的加密字符串


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

//注意，是suite_access_token，不是授权方（企业）的access_token

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
	  "license_code" : "sdfjduqoxdmxhakdj"
	  "invite_url" : "https://t.dingtalk.com/invite/index?code=xxxx&inviterUid=xxxxx"
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
license_code 		| 套件许可号
invite_url			| 企业对外部人员邀请码
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
### 12: 解除授权套件

当ISV想重新模拟测试企业发起授权套件，需要先进行解除对套件的授权。

解除授权需要进入进入测试企业OA后台--微应用进行操作，如图：

![deleteSuite](https://img.alicdn.com/tps/TB1GpUAKVXXXXckaXXXXXXXXXXX-858-302.jpg)

### 13: ISV套件上架流程

#### 1. 云市场介绍 

- 1.1 背景介绍

钉钉应用当前依托云市场提供商品管理、交易管理的能力，为钉钉企业提供应用必须通过云市场进行商品相关的操作。

- 1.2 概念定义

名称 | 说明 
------ | ----- 
服务商 | 云市场中的卖家，提供钉钉应用
服务商入驻 | 申请成为云市场卖家的过程，需要填写信息并审核
保证金 | 在云市场的卖家需要缴纳一定金额的保证金，保障服务水平和商品质量
市场 | 云市场将商品进行管理、展示、交易
商品 | 在云市场中进行售卖的应用
商品类型 | 对商品的划分，影响商品展示属性和生产过程，当前只需关注钉钉类商品
商品接入 | 部分商品由云市场进行生产，因此需要先将商品的生产信息提交到云市场进行接入
订单 | 通过订单来完成商品购买的过程
业务 | 订单生成的订单实例即业务，通过业务完成商品生产和交付的过程
云市场API | 云市场生产时可以调用服务商提供的API，服务商完成一定的生产工作后返回结果给云市场

- 1.2 整体流程
![wholeProcess](https://img.alicdn.com/tps/TB10Q8lLXXXXXbaaXXXXXXXXXXX-826-1279.png)

#### 2.如何入驻云市场 

入驻云市场您需要完成以下步骤 申请入驻 -> 补充供应商资料 -> 提交店铺资料 -> 支付保证金

- 2.1 申请入驻

您可以通过[<font color=red>申请入驻</font>](http://market.aliyun.com/supplierApply)查看入驻条件和提交入驻申请。云市场分为软件市场、服务市场和建站市场，不同的市场有不同的入驻条件，入驻市场后您可以在该市场发布商品。您首次入驻时，需要选择需要入驻的市场(钉钉类商品选择 软件市场)，填写信息后提交审核。当您已经入驻某个市场后，可以从此页面入驻其他市场，此时不需要重新填写资料，直接提交审核即可。您提交入驻申请后，云市场小二将会联系您。

- 2.2 补充供应商资料

入驻成功后，您可以访问[<font color=red>服务商平台</font>](http://msp.aliyun.com/)进行操作。
请在左侧菜单中点击”服务商信息”，进入服务商信息维护页面。
[<font color=red>注意，供应商名称、淘宝账号、支付宝账号填写后无法修改，请慎重填写！</font>]

- 2.3 提交店铺资料
访问[<font color=red>服务商平台</font>](http://msp.aliyun.com/)，在左侧菜单中点击”店铺管理”提交店铺资料。每个服务商拥有自己的店铺，例如：http://market.aliyun.com/store/771374.html 后续我们会开放对店铺首页进行装修的功能
- 2.4 支付保证金为了更好地保障阿里云用户及钉钉的权益，提升云市场服务商的服务水平和商品质量。发布钉钉商品前，其服务商需缴纳保证金；如果服务商未缴纳保证金，其名下的商品不得上架售卖分类 | 保证金金额
------ | ----- A、免费应用 | 5万元B、收费应用 |	累计交易额 0＜X≤500（万元） | 10万累计交易额 500＜X≤1000（万元）| 50万累计交易额 1000万元以上 | 100万

保证金需按照上述表格中的规定进行缴纳。保证金缴纳方式：服务商签订《云市场服务商入驻协议》后，将指定金额的保证金汇款到阿里云账户，收到保证金后，联系钉钉运营小二，确认后阿里云会开具保证金收据并邮寄给服务商。阿里云账户：

开户银行： 招商银行杭州分行高新支行

开户名称： 阿里云计算有限公司

帐号： 5719 0549 3610 900
#### 3. 如何进行商品管理 

- 3.1 提交商品审核

1.请在发布商品页面选择钉钉类商品。
2.填写应用钉钉类商品的接入信息。![submitProduct](https://img.alicdn.com/tps/TB1HvdzLXXXXXbLXFXXXXXXXXXX-865-283.png)
a)商品名称：请填写您的商品名称，此信息将作为商品名称直接展示给客户。
b)选择套件：系统会提供从开发者平台读取到的您的钉钉套件，您可以选择一个套件作为售卖的商品。
c)主页地址：当您选择钉钉套件后，系统会自动读取，您不需要填写此地址。
d)生产系统接口地址：您可以在此处录入您的生产系统接口地址，当客户购买您的商品后，云市场会调用此链接通知您的系统，以便您通过系统处理客户的请求。
e)源代码地址：请您填写您的软件的源代码地址以便我们进行安全扫描，此项为非必填内容。
f)填写完成后，请点击”下一步”进入商品基础信息填写页面3.填写钉钉类商品的基础信息。
![submitProduct1](https://img.alicdn.com/tps/TB1A_XoLXXXXXXZaXXXXXXXXXXX-865-363.png)
![submitProduct2](https://img.alicdn.com/tps/TB1lTduLXXXXXakXVXXXXXXXXXX-865-396.png)
![submitProduct3](https://img.alicdn.com/tps/TB1gE4sLXXXXXbrXVXXXXXXXXXX-865-199.png)a)商品图片：请上传商品列表页面和商品详情页面展示的商品图片。推荐图片大小为160*120像素。
b)商品介绍：请填写您的商品简介，此信息将在云市场的商品列表页面进行展示，建议字数控制在100字以内。
c)商品详情：请填写您商品的详细介绍信息，此信息将在商品详情页面进行展示，建议尽量详情得描述您的商品。
d)成功案例：可以填写您的商品的成功案例，此信息将在商品详情页面进行展示，可以不填写。
e)app展示图片：您可以上传在app端展示的商品图片。
f)填写完成后，请点击”下一步”进入商品业务信息填写页面。4.填写钉钉类商品的业务信息。
![submitProductBiz](https://img.alicdn.com/tps/TB1PMNHLXXXXXb8XpXXXXXXXXXX-865-210.png)

a)商品所属类目：请填写您将商品放在哪个类目下，此选项会影响用户搜索商品时在哪个类目下进行展现。同时，当您选择类目后，系统会显示该类目的商品特有的一些属性，您可以根据实际情况填写属性信息，如果您的商品不包含该属性也可以不进行填写。
b)填写完成后，请点击”下一步”进入商品销售信息填写页面。

5.填写钉钉类商品的销售信息。![submitProductSel1](https://img.alicdn.com/tps/TB1vcJHLXXXXXb0XpXXXXXXXXXX-865-305.png)
![submitProductSel2](https://img.alicdn.com/tps/TB1cbFjLXXXXXcSaXXXXXXXXXXX-844-303.png)
a)售卖方式：钉钉类商品支持按次售卖或按周期售卖。
b)商品版本名称：请填写售卖的版本名称，在商品页面会显示在上图红框处的位置。一个商品可添加多个版本并设置不同价格。
c)商品定价：	如果选择按次售卖，则请设置商品单次价格。	如果选择按周期售卖，则需要设置允许订购的周期，新购价格，续费价格。新购、续费价格以单月为基价，不同订购周期的价格为基价*订购周期的月份数。如果需要设置优惠，请联系小二操作。
d)填写完成后，请点击”提交”。提交后商品会进入审核流程。6.钉钉类商品Sku Code

如果您的钉钉类商品需要版本对应的Sku Code，请提交商品信息后，在商品列表页面点击”管理”。进入商品详情页面后，点击”销售信息”tab，在下图位置可以查看版本对应的Sku Code。
<img src="https://img.alicdn.com/tps/TB1Ts0RLXXXXXbgXXXXXXXXXXXX-865-460.png"  alt="图片名称" align=right />

- 3.2 查看商品

您可以在[<font color=red>服务商平台</font>](http://msp.aliyun.com/commodity/manage/index)左侧菜单中商品管理查看您的商品。
您可以通过商品的上架状态和审核状态对商品进行筛选，并且可以通过列表进入商品详情页面进行商品管理。
![viewProduct](https://img.alicdn.com/tps/TB1R44FLXXXXXc1XpXXXXXXXXXX-865-284.png)
- 3.3 查看审核

提交商品后，小二会针对商品进行审核。商品审核分为两个阶段：商品接入审核、商品售卖信息审核。商品接入审核：小二会先对商品的接入信息进行审核，如果审核通过，则开始进行售卖信息审核。如果接入信息审核驳回，您可以在商品列表中看到商品审核状态为驳回，并且查看驳回原因。您可以编辑商品信息，重新提交审核。商品售卖信息审核：完成商品接入审核后，小二会进行商品售卖信息的审核。如果售卖信息审核驳回，您可以在商品列表中看到商品审核状态为驳回，并且查看驳回原因。您可以编辑商品的售卖信息，重新提交审核。(此时不能修改商品接入信息。)如果售卖信息审核通过，商品会自动上架。- 3.4 编辑商品

您的商品审核通过上架后，您可以在商品详情页面编辑商品信息。
![updateProduct](https://img.alicdn.com/tps/TB1y4FVLXXXXXXfXXXXXXXXXXXX-865-179.png)
切换不同的tab页面，点击”编辑”按钮进入编辑状态。商品的接入信息修改后，需要小二重新进行审核。审核通过后，会将显示给用户的信息自动更新。商品的基本信息、业务信息和销售信息修改后，不需要经过小二审核，会直接影响前台展示的内容。- 3.5 下架商品

如果您的商品已经上架，需要进行下架，请联系小二进行操作。您的商品下架后，您可以在商品列表中点击”继续发布”，重新提交审核。
#### 4. 如何进行交易管理- 4.1 订单管理

您可以在[<font color=red>服务商平台</font>](http://msp.aliyun.com/order/order_list.htm)左侧菜单中交易管理-订单管理查看订单信息
![orderManage](https://img.alicdn.com/tps/TB1wvXFLXXXXXc8XpXXXXXXXXXX-465-387.png)

您可以通过订单ID、客户ID、订单状态等条件查询订单。在”操作”栏，点击”查看”可以查看订单详细信息。
![orderManage1](https://img.alicdn.com/tps/TB1fI4yLXXXXXc_XFXXXXXXXXXX-865-396.png)

在订单还未支付前，可以点击”订单改价”修改订单的支付价格。在支付价格中填入金额，填写修改原因，点击”提交”，可以将订单的支付价格修改为您填写的金额。
![orderManage2](https://img.alicdn.com/tps/TB1GetsLXXXXXbJXVXXXXXXXXXX-865-257.png)
在订单支付后，可以点击”关联业务”查看订单生成的业务实例。您也可以从业务管理菜单中直接查看业务信息。

- 4.2 业务管理

您可以在[<font color=red>服务商平台</font>](http://msp.aliyun.com/orderbiz/order_biz_list.htm)左侧菜单中交易管理-业务管理查看业务信息
![bizManage](https://img.alicdn.com/tps/TB1eUhwLXXXXXXQXVXXXXXXXXXX-865-376.png)
您可以通过业务ID、客户ID、业务状态等条件查询业务。在”操作”栏，点击”查看”可以查看业务详细信息。在业务详细信息中，可以在”补充页面信息”栏中填写您对业务的备注，并且在列表页面可以根据这个信息进行搜索。![bizStatusManage](https://img.alicdn.com/tps/TB1yXXNLXXXXXXKXpXXXXXXXXXX-865-144.png)钉钉类商品的业务状态
		开通中
		已开通
		已过期
		已关闭	对于钉钉类型商品，如果状态是开通中，可以点击”开通应用”来手动开通。<img src="https://img.alicdn.com/tps/TB1ynxtLXXXXXa1XVXXXXXXXXXX-865-133.png"  alt="图片名称" align=right />- 4.3 退款管理

您可以在[<font color=red>服务商平台</font>](http://msp.aliyun.com/refund/refund_record_list.htm)左侧菜单中交易管理-退款管理查看退款信息。
![refundManage](https://img.alicdn.com/tps/TB1zoJJLXXXXXaeXpXXXXXXXXXX-865-250.png)用户购买的商品，在交易担保期内，可以享受不满意全额退款。详细规则请参考http://help.aliyun.com/knowledge_detail/6555340.html用户申请退款后，您可以在退款管理中查看到退款申请。您可以通过申请人、退款状态等条件查询退款申请。在”操作”栏，点击”查看”可以查看退款详细信息。退款状态:
审核中： 用户提交退款申请，需要服务商进行审核
已取消：用户取消了提交的退款申请
退款中：服务商同意退款申请，系统进行退款中
退款成功：已经成功进行退款
审核不通过：服务商驳回了用户的退款申请审核中的退款申请，您可以在退款申请的详情页面进行审核通过或者审核驳回。如果您不处理用户的退款申请，3个自然日后系统会自动通过退款申请。- 4.4 评价管理
您可以在[<font color=red>服务商平台</font>](http://msp.aliyun.com/orderrate/index.htm)左侧菜单中买家评价管理查看和回复用户对商品的评价。![evaluateManage](https://img.alicdn.com/tps/TB17JxrLXXXXXcPXVXXXXXXXXXX-865-383.png)
您可以通过客户ID、商品名称、回复状态等条件查询用户回复。用户可以对交易进行一次初评和一次追评，您可以分别针对初评和追评进行回复。用户的评价信息和您的回复都会显示在商品详情下方。- 4.5 客户管理您可以在[<font color=red>服务商平台</font>](http://msp.aliyun.com/orderrate/index.htm)左侧菜单中客户管理查看购买了您商品的客户。![customersManage](https://img.alicdn.com/tps/TB1kHlULXXXXXX8XXXXXXXXXXXX-865-360.png)您可以通过客户ID、客户名称、联系方式来查找客户。在操作栏点击”关联产品”可以查看这个客户购买的业务。

#### 5. 如何生产商品钉钉类型的商品的生产过程：商品类型 | 生产/服务过程
------ | ----- 钉钉类商品	 | 需要先通过钉钉验收，审核上架后，用户购买商品进行授权开通，ISV应用接收授权信息后立即开通
- 5.1 ISV接入APIISV通过接入API实现用户购买、续费、商品过期信息的处理，通过购买时云市场传入的corpid与钉钉企业进行关联，实现开通时的企业绑定；通过续费接口实现对钉钉企业商品有效期的管理；通过商品过期接口实现对应用内企业数据的导出、备份等操作

接口调试工具：http://msp.aliyun.com/isvDoc  ISV需要使用用MSP的帐号登陆进行调试接口说明：[<font color=red>云市场商品接入API文档</font>](http://gongdan.oss-cn-hangzhou.aliyuncs.com/market/%E4%BA%91%E5%B8%82%E5%9C%BA%E5%95%86%E5%93%81%E6%8E%A5%E5%85%A5%E6%96%87%E6%A1%A3.zip?spm=5176.776672277.0.0.EFfNfS&file=%E4%BA%91%E5%B8%82%E5%9C%BA%E5%95%86%E5%93%81%E6%8E%A5%E5%85%A5%E6%96%87%E6%A1%A3.zip)

#### 6. 线下操作

- 6.1 结算收款次月底前阿里云为ISV结算上月全部交易额- 6.2 开据发票ISV开全额发票给企业用户- 6.3 线下退款ISV可与企业用户协商进行线下退款
#### 7.  用户授权

当企业管理员通过云市场完成套件购买后，通过钉钉授权功能进行钉钉套件授权开通，具体授权开通流程见：
[<font color=red >企业管理员授权应用</font>](#企业管理员授权应用)


### 14: ISV为授权方的企业单独设置IP白名单

该API用于为授权方的企业单独设置IP白名单,以达到套件中的微应用相关服务私有化部署的目的。

https请求方式: POST

https://oapi.dingtalk.com/service/set_corp_ipwhitelist?suite_access_token=xxxx

POST数据示例

```
{	
	"auth_corpid":"dingabcdefgxxx",
	"ip_whitelist":["1.2.3.4","5.6.*.*"]
}
```

请求参数说明

参数					| 说明
-------				| -------------
auth_corpid			| 授权方corpid
ip_whitelist		| 要为其设置的IP白名单,格式支持IP段,用星号表示,如【5.6.\*.\*】,代表从【5.6.0.\*】到【5.6.255.\*】的任意IP,在第三段设为星号时,将忽略第四段的值,注意:仅支持后两段设置为星号

返回结果示例

```
{
	"errcode":0,
	"errmsg":"ok"
}
```


### 消息体签名

为了验证调用者的合法性，钉钉在回调url中增加了消息签名，以参数signature标识，企业需要验证此参数的正确性后再解密。

验证步骤：

1.  企业计算签名：dev_msg_signature=sha1(sort(token、timestamp、nonce、msg_encrypt))。sort的含义是将参数按照字母字典排序，然后从小到大拼接成一个字符串

2. 比较dev_msg_signature和回调接口中推送的字段signature是否相等，相等则表示验证通过


##### 加解密方案说明

开启回调模式时，有以下术语需要了解：

1. signature是签名，用于验证调用者的合法性。具体算法见以下'消息体签名'章节

2. EncodingAESKey：注册套件提供的数据加密密钥。用于消息体的加密，长度固定为43个字符，从a-z, A-Z, 0-9共62个字符中选取，是AESKey的Base64编码。解码后即为32字节长的AESKey

3. AESKey=Base64_Decode(EncodingAESKey + “=”)，是AES算法的密钥，长度为32字节。AES采用CBC模式，数据采用PKCS#7填充；IV初始向量大小为16字节，取AESKey前16字节。具体详见：http://tools.ietf.org/html/rfc2315

4. msg为消息体明文，格式为JSON

5. 钉钉服务器会把msg消息体明文编码成encrypt，encrypt = Base64_Encode(AES_Encrypt[random(16B) + msg_len(4B) + msg + $key])，是对明文消息msg加密处理后的Base64编码。其中random为16字节的随机字符串；msg_len为4字节的msg长度，网络字节序；msg为消息体明文；$key对于ISV开发来说，填写对应的suitekey，$key对于普通企业开发，填写企业的Corpid。
最终传给回调者的是encrypt，字段名为encrypt。

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

Post参数：
```
{"encrypt":"1a3NBxmCFwkCJvfoQ7WhJHB+iX3qHPsc9JbaDznE1i03peOk1LaOQoRz3+nlyGNhwmwJ3vDMG+OzrHMeiZI7gTRWVdUBmfxjZ8Ej23JVYa9VrYeJ5as7XM/ZpulX8NEQis44w53h1qAgnC3PRzM7Zc/D6Ibr0rgUathB6zRHP8PYrfgnNOS9PhSBdHlegK+AGGanfwjXuQ9+0pZcy0w9lQ=="
}
```
Token：123456

数据加密密钥(ENCODING_AES_KEY)：4g5j64qlyl3zvetqxz5jiocdr586fn2zvjpa8zls3ij

suitekey：suite4xxxxxxxxxxxxxxx


ISV接入相关接口调试：[<font color=red >ISV接入调试工具</font>](https://debug.dingtalk.com/isv.html)








