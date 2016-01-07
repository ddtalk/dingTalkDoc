# 企业接入指南

此处为企业接入微应用的快速指南，按照此处的实现步骤，您（企业）可以将已有系统快速接入钉钉，您也可以独立开发一个微应用按照此步骤接入钉钉。

<br />

## Step 1 -- 注册钉钉企业

### 注册钉钉企业

一、进入 [<font color=red >钉钉管理后台</font>](https://oa.dingtalk.com) 页面, 点击 [<font color=red >企业注册</font>](https://oa.dingtalk.com/register.html?spm=0.0.0.0.dL51oc)；（已经注册可跳过此步骤）

![enterprise_register_entry](https://img.alicdn.com/tps/TB14kI8IFXXXXciapXXXXXXXXXX.jpg)

二、填写注册手机号码和短信验证码；

三、输入企业基本信息和管理员帐号和密码，点击 *注册* 按钮完成注册过程。

![input_enterprise_info](https://img.alicdn.com/tps/TB1bru8JFXXXXXcXFXXXXXXXXXX-1171-807.png)

<aside class="notice">
通过钉钉移动客户端创建的企业默认没有设置钉钉后台管理员，需要通过以上流程注册管理员帐号。
</aside>

### 分配管理员子账号

一、登录钉钉后台管理系统，按下图进入安全中心的添加管理员子帐号页面；

![add_sub_manager](https://img.alicdn.com/tps/TB1Q3DiJFXXXXbkXXXXXXXXXXXX-1147-377.png)

二、按下图提示填写子帐号信息

![set_sub_manager_account](https://img.alicdn.com/tps/TB16euYJFXXXXcRXFXXXXXXXXXX-601-336.png)

完成管理员子帐号设置后，子帐号关联的钉钉用户会在钉钉客户端的 *钉小秘* 会话中收到管理员帐号和初始密码，该钉钉用户可以通过收到的帐号和密码登录 [<font color=red >钉钉管理后台</font>](https://oa.dingtalk.com) 进入安全中心对初始密码进行修改。

## Step 2 -- 新增微应用

- 您需要通过[<font color=red >Step 1 -- 注册钉钉企业</font>](#step-1-注册钉钉企业)完成钉钉企业账号注册；

完成此步骤您就可以在钉钉上使用微应用了
### 新增微应用
您登录钉钉管理后台后可以进入 *应用中心* 页面对添加微应用

![enter_microapp_center](https://img.alicdn.com/tps/TB1GqkTLXXXXXcsXFXXXXXXXXXX-1122-641.jpg)

点击上图中 *新增微应用* 按钮，按下图填写微应用信息，点击确定后可以新增微应用。

![add_micro_app](https://img.alicdn.com/tps/TB1Qe_XJFXXXXalXpXXXXXXXXXX-598-477.png)

*首页地址* : 以`http://`或者`https://` 开头的URL，是微应用的首页地址；在移动设备上打开微应用Tab页，点击微应用列表中的微应用将访问这个URL指向的页面。

*后台地址* : 以`http://`或者`https://` 开头的URL，是微应用的后台管理页面地址；配置后台地址后可以通过应用中心页面进入到微应用的管理后台。

<aside class="notice">
<b>首页地址</b> 的URL域名务必保证真实有效，否则会导致钉钉用户无法正常使用微应用。
</aside>

![get_micro_app_agentID](https://img.alicdn.com/tps/TB1N490JFXXXXceXFXXXXXXXXXX-602-524.png)

您在应用中心创建微应用后，如上图所示可获取到微应用的AgentID，AgentID可用于发送企业会话消息等场景。

<br />

创建成功之后将会在手机的工作tab上显示出来

![createMi](https://img.alicdn.com/tps/TB1xStVKpXXXXbjXFXXXXXXXXXX-361-640.jpg)

至此您已经可以在钉钉上使用微应用了，如果您需要对微应用与钉钉有进一步的融合，请进行定制开发，参考[<font color=red >开发微应用</font>](#step-3-开发微应用)

## Step 3 -- 开发微应用

- 您需要通过[<font color=red >新增微应用</font>](#新增微应用)获取微应用的AgentID，用来在微应用开发时调用开放平台的接口

钉钉开放提供丰富的接口、工具供您使用，用以降低您的开发成本：

- 钉钉开放平台提供了企业通讯录管理、文件管理、发送企业会话消息等功能，接口使用可以参考[<font color=red >服务端开发文档</font>](#服务端开发文档)；

- 钉钉开放平台提供了定制的微应用在钉钉客户端的专用运行容器，并提供了一组可以调用钉钉的本地能力和业务能力的JSApi接口，您可以通过这些接口使用钉钉的本地能力或者钉钉的业务逻辑，进行微应用与钉钉功能的结合；接口使用可以参考[<font color=red >客户端开发文档</font>](#客户端开发文档)。

- 钉钉开放平台提供了与钉钉PC版本集成的能力，接口使用可以参考[<font color=red >PC端开发文档</font>](#pc端开发文档)；

- 钉钉开放平台提供了开发过程中需要的调试工具和性能优化的建议，您可以参考[<font color=red >调试工具&性能优化</font>](#调试工具-amp-性能优化)；


### 实现免登

您的微应用接入钉钉后，通过钉钉实现免登无需让员工进行二次登录，员工在进入微应用的时可以获取当前用户的信息实现与原系统中的账户打通。详细文档请参阅[<font color=red >免登服务</font>](#免登服务)。


<br />


### 调用API接口

您在调用钉钉开放平台接口时需要附加AccessToken，AccessToken可以通过CorpID和CorpSecret获取。

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







