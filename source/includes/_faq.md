# FAQ

### Q:从哪里可以获得CorpID和CorpSecret?

A:在钉钉管理后台的微应用设置页面可以获取，详细方法请参见[<font color=red >《接入指南-获取CorpID和CorpSecret》</font>](#获取corpid和corpsecret)。

### Q:『计算解密文字错误』怎么解决？
A:查看[<font color=red >加解密库和demo下载</font>](#加解密库和demo下载)第二个步骤


### Q:调用管理通讯录接口返回430004，无效的HTTP HEADER Content-Type如何解决？

A:管理通讯录的部分接口采用了POST请求，请求体使用JSON格式，请在HTTP请求头中设置Content-Type:application/json。

### Q:如何试用套件

A:参见[<font color=red >套件试用流程</font>](http://download.taobaocdn.com/freedom/31112/pdf/p1a01o2gfr4q811go5fq19i5ni14.pdf)



### Q:部署阿里云ssl证书出现问题如何解决？

A:参见[<font color=red >阿里云证书配置-slb（负载均衡）</font>](http://ddtalk.github.io/blog/2015/09/24/dingtalk/)


### Q:jsapi权限校验时返回{message:"权限校验失败"，errorCode:3}

A:首先检查用来生成签名(signature)的jsapi_ticket是否过期（jsapi_ticket有效期为7200秒，而且当你请求了新的ticket之后，旧的ticket就失效了）。

然后检查生成签名的Url参数，与调用dd.config 所在的url是否一致

(生成签名用的url需要去除hash部分，e.g. 如果当前页面url是http://abc.def/ghi/jkl?m=123&n=456#opq，则用于生成签名的url是http://abc.def/ghi/jkl?m=123&n=456)

可以使用[<font color=red >调试工具</font>](https://debug.dingtalk.com)来生成jsapi_ticket和signature，并和你实际使用的进行对比。

### Q:上传文件不成功
A:使用multipart/form-data请求上传文件，需要附加文件标示信息，参数名为media，java示例代码为

`
HttpEntity requestEntity =MultipartEntityBuilder.create().addPart("media",
new FileBody(file, ContentType.APPLICATION_OCTET_STREAM, file.getName())).build();
`

### Q:ISV如何在App及后台获取企业及用户相关信息

A:微应用主页支持使用$CORPID$模板参数表示corpid，用户访问微应用的时候钉钉将把$CORPID$替换成用户所属企业的corpid，例如http://www.dingtalk.com/index?corpid=$CORPID$。

获取用户信息请参考[<font color=red >免登服务</font>](#免登服务)


### Q:ISV接入回调接口没有suiteticket推送，为什么？

A:当你注册套件之后，钉钉服务器会向你填写的回调接口推送suite_ticket。接收到推送之后需要返回加密后的字符串“success”,如果不返回，钉钉服务器将连续推送，直到推送次数超过100次，就不再推送。
此时您需要进入[<font color=red>开发者后台</font>](http://console.d.aliyun.com)，进入套件管理页面，点击『重新推送』按钮，即可重新推送。
![repush](https://img.alicdn.com/tps/TB15j7OJFXXXXckXXXXXXXXXXXX-1121-124.jpg)

### Q:ISV套件回调url验证有效性失败

A:在填写套件回调url的时候，需要ISV填写回调url是可用的。

钉钉服务器通过向回调url推送一条『验证回调URL有效性事件』来判断回调url是否可用，具体流程请参见[<font color=red>回调接口</font>](#5-回调接口（分为五个回调类型）)

### Q:不存在的临时授权码

当您通过临时授权码(tmp_auth_code)和套件token(suite_access_token)去换取永久授权码(permanent_code)之时，需要保证suite_access_token,tmp_auth_code都没有过期。

### Q:钉钉发送会话消息时候，cid怎么获取?
A:请查看
[<font color=red>jsapi-获取会话信息</font>](#获取会话信息)。

使用场景示例:用户在微应用中拉起本地聊天窗口列表(通过调用jsapi-获取会话信息)，选择某一个聊天窗口，微应用将收到钉钉返回的cid，通过这个cid会送会话消息。

如果希望在后台直接发送消息，请查看服务端开发文档-[<font color=red>发送企业会话消息</font>](#发送企业会话消息)。

### Q:新增部门和员工信息为中文时，创建不成功
A:请检查编码格式，需要是UTF-8编码


### Q:使用JSAPI返回签名或者Ticket获取失败
A:JSAPI返回失败主要有两种错误

[<font color=red >错误码:52011</font>] [jsapi ticket 读取失败]

	1)确认agentId参数正确传入
	
	2)确认以传入agentId对应的企业身份获取过jsapi_ticket,也就是调用过get_jsapi_ticket方法
	
	3)确认agentId对应的企业身份获取的jsapi_ticket没有过期.即在两个小时的有效期之内
	
[<font color=red >错误码:52013</font>][签名校验失败]	

	1)确认agentId参数正确传入
	
	2)确认获得的jsapi_ticket为最新的,没有其他服务同时调用get_jsapi_ticket方法,导致生成签名的jsapi_ticket过期
	
	3)确认生成jsapi签名正确,可以使用debug工具进行调试https://debug.dingtalk.com/		


### Q:开发遇到困难怎样反馈给你们?

A:我们目前在阿里云开发者论坛开放了一个[<font color=red >钉钉开放平台</font>](http://bbs.aliyun.com/thread/276.html?spm=5176.7189909.0.0.bq46VP)模块，你可以按照以下格式发帖到这个模块，我们会定期搜集和解决。

请编辑如下信息，发到论坛，这样便于快速解决问题。

企业完整名称 | 例如 阿里巴巴
---------- | -------
访问接口的路径 | 例如 https://oapi.dingtalk.com/gettoken，不需要把token之类的信息附上
输入参数 | 需要提供CorpId，不需要提供AccessToken及CorpSecret
发起请求的服务器的外网IP地址 |
发起请求的时间点 | 例如 2015-6-16 10:03:50
返回的错误结果 | 例如 系统繁忙


