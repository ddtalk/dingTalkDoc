# 企业接入指南

企业接入指南重点介绍使用钉钉开放平台的开发微应用的流程，帮助企业快速接入钉钉开放平台。该节主要分为四个部分：第一部分介绍企业接入钉钉开放平台的准备工作；第二部介绍如何访问开放平台服务端接口；第三部分介绍钉钉开放平台提供的员工身份验证流程；第四部分介绍发送消息到微应用会话。

<br />

## 开发环境准备

开发者在使用钉钉开放平台开发微应用前需做好以下准备：

- 获取钉钉开放平台开发者信息；
- 服务端环境搭建和域名注册；
- 开发环境搭建；

开发者可以从 [<font color=red >钉钉管理后台</font>](https://oa.dingtalk.com) 获取必要的信息用于微应用开发，还可以利用该系统完成微应用配置相关的工作；开发者可以自己搭建服务器也可以购买云主机来搭建自己的服务端环境，开发者需要为自己的微应用注册合法有效的域名并配置在 [<font color=red >应用中心</font>](https://oa.dingtalk.com/#/microApp/microAppList) ；钉钉开放平台的服务端接口不区分语言和平台，开发者可以使用自己熟悉的技术搭建开发环境来开发微应用。

[<font color=red >钉钉管理后台</font>](https://oa.dingtalk.com) 系统为企业提供了企业通讯录管理、微应用、安全中心、员工数据统计和系统常用设置等功能。

![oa_system.jpg](https://img.alicdn.com/tps/TB1b4jcJFXXXXXOXpXXXXXXXXXX-666-421.jpg)

**钉钉管理后台管理员（以下简称钉钉后台管理员）** 在企业通讯录管理页面可以完成企业的组织结构和员工个人信息的添加、删除、查看和修改等操作；在微应用管理页面可以完成添加和删除微应用，获取CorpID和CorpSecret(接入钉钉开放平台的凭证)，查看微应用相关信息，管理微应用的运行状态等。开发者在使用该系统前需要注册成为钉钉后台管理员或者由钉钉后台管理员分配管理员子帐号。


## 创建微应用

一、进入 [<font color=red >钉钉管理后台</font>](https://oa.dingtalk.com) 页面, 点击 [<font color=red >企业注册</font>](https://oa.dingtalk.com/register.html?spm=0.0.0.0.dL51oc)；（已经注册可跳过此步骤）

![enterprise_register_entry](https://img.alicdn.com/tps/TB14kI8IFXXXXciapXXXXXXXXXX.jpg)

二、填写注册手机号码和短信验证码；

三、输入企业基本信息和管理员帐号和密码，点击 *注册* 按钮完成注册过程。

![input_enterprise_info](https://img.alicdn.com/tps/TB1bru8JFXXXXXcXFXXXXXXXXXX-1171-807.png)

<aside class="notice">
通过钉钉移动客户端创建的企业默认没有设置钉钉后台管理员，需要通过以上流程注册管理员帐号。
</aside>

### 分配管理员子账号：

一、登录钉钉后台管理系统，按下图进入安全中心的添加管理员子帐号页面；

![add_sub_manager](https://img.alicdn.com/tps/TB1Q3DiJFXXXXbkXXXXXXXXXXXX-1147-377.png)

二、按下图提示填写子帐号信息

![set_sub_manager_account](https://img.alicdn.com/tps/TB16euYJFXXXXcRXFXXXXXXXXXX-601-336.png)

完成管理员子帐号设置后，子帐号关联的钉钉用户会在钉钉客户端的 *钉小秘* 会话中收到管理员帐号和初始密码，该钉钉用户可以通过收到的帐号和密码登录 [<font color=red >钉钉管理后台</font>](https://oa.dingtalk.com) 进入安全中心对初始密码进行修改。

### 微应用管理和创建

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


## 使用免登服务


假如在进入微应用的时候需要获取当前用户的信息，可以使用免登服务，实现账户打通。详细文档请参阅[<font color=red >免登服务</font>](#免登服务)。


<br />


## 调用平台接口

开发者在调用钉钉开放平台接口时需要附加AccessToken，AccessToken可以通过CorpID和CorpSecret获取。

### 获取CorpID和CorpSecret

CorpID是企业的唯一标识，获取CorpID和CorpSecret的步骤如下:

一、使用管理员帐号登录 [<font color=red >钉钉管理后台</font>](https://oa.dingtalk.com) ；

二、选择顶部菜单 **微应用** 进入微应用页面，在左侧菜单选择 **微应用设置** 进入微应用设置页；

三、在微应用设置页面底部点击 **获取** 按钮即可获取CorpID和CorpSecret。

![get_scecret_corpId](https://img.alicdn.com/tps/TB1xStVKpXXXXbjXFXXXXXXXXXX-361-640.jpg)

<aside class="notice">
钉钉开放平台提供了获取和修改企业(团队)的组织结构信息、人员信息等功能，所以请妥善保管CorpID和CorpSecret，避免外泄影响企业信息安全。
</aside>

### 获取AccessToken

开发者在调用开放平台接口前需要通过CorpID和CorpSecret获取AccessToken。获取AccessToken的方法是向 `https://oapi.dingtalk.com/gettoken?corpid=id&corpsecret=secrect` GET请求。

开发者获取AccessToken后便可以调用开放平台其他接口。

以获取部门列表接口为例，获取部门列表接口为：

`oapi.dingtalk.com/department/list`

在请求该接口时，需要将获取的AccessToken作为请求参数拼装到URL中：

`https://oapi.dingtalk.com/department/list?access_token=ACCESS_TOKEN`

更多关于AccessToken的信息请参考[<font color=red >《服务端开发文档-建立连接》</font>](#建立连接)一节。

<br />


## 发送企业会话消息

用户可以在企业会话中查看微应用发送的消息，开发者可以通过发送消息接口将消息发送到企业会话中。

![send_micro_app_message](https://img.alicdn.com/tps/TB1X.m6JFXXXXX0XFXXXXXXXXXX-1089-652.jpg)

调用消息发送接口时需要使用`HTTPS`协议，发送的数据包为`JSON`格式。目前钉钉开放平台支持文本、图片、声音、文件、链接、办公消息等消息类型。

### 示例程序

在[<font color=red >《Open API - 代码示例》</font>](#demo)中有发送消息的代码演示，开发者可以下载参考。

如果在使用开放平台中遇到困难请浏览[<font color=red >《常见问题》</font>](#faq)一节，若仍不能解决请按概述中的提供的反馈方式联系我们。







