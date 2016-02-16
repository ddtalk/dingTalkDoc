# 分享SDK

该功能是钉钉团队为开发者提供，帮助移动应用通过用户社交快速传播的功能。

“分享SDK”需要客户端接入，请将对应SDK集成至开发者移动端应用中。

## 场景介绍

用户使用开发者制作的移动应用时，可以将自己喜欢的内容，通过该功能快速地转发给自己在钉钉内的好友。好友点击打开内容链接，
将通过钉钉内置浏览器打开网页的形式进行呈现。在传播内容的同时，也会同时露出应用的名称与logo，起到品牌传播的效果。

## 应用范例

### 支付宝

从支付宝发送红包可以分享给钉钉同事，用户分享后，钉钉好友可以通过这个分享直接打开支付宝抢红包。

## 渠道显示说明

1、当用户手机安装钉钉2.7及以上版本，正常分享；

2、当用户手机没有安装钉钉，点击分享渠道可以弹出提示，也可以引导用户下载钉钉。IOS引导至appstore，安卓引导至：http://www.dingtalk.com/index-b.html

3、当用户手机安装钉钉版本低于2.7，点击分享渠道出提示升级钉钉。

## 分享sdk接入前准备

分享到钉钉好友的所有接口功能，均需要使用在开放平台上创建的应用进行调用。目前仅支持阿里内部渠道的线下接入。线上的应用创建流程还在开发中。请随时关注文档更新。

## 接入流程

### Android接入流程

1、搭建开发环境

[1] 推荐用Android Studio建立工程。

[2] 在工程中新建一个libs目录，将开发工具包中libs目录下的libddshare.jar复制到该目录中（如下图所示，建立了一个名为DDShareDemo 的工程，并把jar包复制到libs目录下）。

<img src="https://img.alicdn.com/tps/TB1gMLMKVXXXXbFXFXXXXXXXXXX-1082-690.png"  />

[3] 将libs目录下的libddshare.jar文件添加到工程依赖中。

2、 在代码中使用开发工具包

[1] 具体可参考demo的代码。

[2] 接收钉钉的回调
如果你的程序需要接收钉钉发送的请求，或者接收发送到钉钉请求的响应结果，需要下面3步操作：

a. 在你的包名相应目录下新建一个ddshare包，并在该ddshare目录下新增一个DDShareActivity类，该类继承自Activity（例如应用程序的包名为com.laiwang.ding.share.openapi.ddshareopenapi，则新添加的类如下图所示）

<img src="https://img.alicdn.com/tps/TB1s0PEKVXXXXa.aXXXXXXXXXXX-1000-468.png"  />

并在AndroidManifest文件里面加上exported属性，设置为true，例如：

<img src="https://img.alicdn.com/tps/TB1jGn8KVXXXXa6XXXXXXXXXXXX-1030-322.png"  />

b. 实现IDDAPIEventHandler接口，发送到定递给你请求的响应结果将回调到onResp方法

c. 在DDShareActivity中将接收到的intent及实现了IDDAPIEventHandler接口的对象传递给IDDShareApi接口的handleIntent方法，示例如下图：

<img src="https://img.alicdn.com/tps/TB1SXrSKVXXXXaWXFXXXXXXXXXX-952-220.png"  />

应用请求钉钉的响应结果将通过onResp回调。
注意
如果需要混淆代码，为了保证sdk的正常使用，需要在proguard.cfg加上下面两行配置：
-keep class  com.android.dingtalk.share.ddsharemodule.** {
   *;
}

3、 判断当前设备是否支持分享

钉钉从2.7版本开始支持分享，api中提供了接口来判断当前设备是否能够支持分享到钉钉

[1]判断当前设备是否已经安装钉钉

    boolean isInstalled = iddShareApi.isDDAppInstalled();

[2]判断当前设备是否支持分享到钉钉（已经安装钉钉&&钉钉版本支持分享）

    boolean isSupport = iddShareApi.isDDSupportAPI();

4、 分享支持的类型

支持文本、图片、链接以及特殊的支付宝红包类型，具体使用可参考Demo

### iOS接入流程

准备工作

- 申请AppID, 申请时请提供，应用的BundleID，应用名称和应用图标，图标需要提供两个尺寸：28x28px和 108x108px，格式为PNG；
- 下载DTShareSDK；DTShareSDK最低部署系统版本为iOS7.0，包含 `armv7, i386, x86_64, arm64` 架构；
- 安装钉钉iOS客户端2.7.0及以后的版本；

步骤1：将SDK的下列文件导入到工程中；

![share_sdk_import](https://img.alicdn.com/tps/TB1hydHLXXXXXXFXXXXXXXXXXXX-290-97.png)

步骤2：配置工程

- 在Other Linker Flags添加 `-all_load`选项;

![other_linker_flags](https://img.alicdn.com/tps/TB118c9KVXXXXcIaXXXXXXXXXXX-808-201.png)

- 将申请的appId添加到URL Types中作为钉钉回调的scheme, `identifier` 填写`dingtalk`; `URL Schemes`填写申请的AppId。 iOS9及以后的系统需要将钉钉和分享SDK的scheme配置在Info.plist的LSApplicationQueriesSchemes列表中，scheme分别为 `dingtalk, dingtalk-open`

![Alt text](https://img.alicdn.com/tps/TB1QyhdLXXXXXbZXVXXXXXXXXXX-973-709.png)

步骤4：注册应用并添加必要的URL Handler

如示例中，在AppDelegate.m文件中引用`AppDelegate.h`，在@implementation AppDelegate中增加如下代码：

![share_sdk_code_sample](https://img.alicdn.com/tps/TB1F7xvLXXXXXbHXpXXXXXXXXXX-999-554.png)

步骤4：分享数据到钉钉客户端

发送分享请求的过程主要分为两部分：

- 组装DTMediaMessage对象；
- 调用+[DTOpenAPI sendReq:]发送数据；

不同类型的分享数据通过DTMediaMessage的mediaObject区分：

- DTMediaTextObject 纯文本数据；
- DTMediaImageObject 纯图片数据；
- DTMediaWebObject Web页面数据；

下面是分享文本部分代码，其它类型请参考Demo示例：

![share_sdk_text_sample_code](https://img.alicdn.com/tps/TB1ZWthLXXXXXbxXVXXXXXXXXXX-595-257.png)

**注意：分享纯图片数据和Web页面缩略图时，可以使用两种形式：图片URL和图片Data，钉钉内优先使用图片Data形式；分享数据的数据量限制在SDK的头文件中均有描述，超过限制的数据不会发送到钉钉客户端。**

#### 判断当前设备是否支持分享到钉钉

钉钉从2.7版本开始支持分享，SDK中提供了接口来判断当前设备是否能够支持分享到钉钉。

![share_sdk_check_dingtalk_api](https://img.alicdn.com/tps/TB1zfhBLXXXXXXpXpXXXXXXXXXX-556-288.png)

**注意：在iOS9上需要将钉钉SDK相关的Scheme注册到Info.plist的LSApplicationQueriesSchemes明代中，否则会导致检测方法总是返回NO。**

## Demo下载

[<font color=blue >Android Demo 下载</font>](http://download.taobaocdn.com/freedom/31112/compress/p1a71dcqcqen6g7e2joobd1bdm4.zip)

[<font color=blue >iOS Demo 下载</font>](http://download.taobaocdn.com/freedom/31112/compress/DTShareKit.zip)