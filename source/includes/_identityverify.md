# 免登服务

通过免登服务，在企业微应用的H5中，可以获取当前使用钉钉的用户身份及相关信息。

具体流程为：

1.获取CODE(免登授权码)，获取CODE的方式有两种，一种是调用js-api接口（推荐），一种是使用标准OAUTH2.0 HTTP 302跳转的方式。

2.通过CODE换取用户身份。


通过CODE获取用户身份会有一定的时间开销。对于频繁获取用户身份的场景，建议采用如下方案：

1. 用户跳转到企业页面时，企业校验是否有代表用户身份的cookie，此cookie由企业生成
2. 如果没有获取到cookie，调用免登服务，获取用户身份后，由企业生成代表用户身份的cookie
3. 根据cookie获取用户身份，进入相应的页面

##手机客户端调用免登

### 使用JS-API(推荐使用)

步骤一：首先需要获取当前用户的corpid。ISV开发者请在微应用主页地址使用$CORPID$模板参数表示corpid，用户访问微应用的时候钉钉服务器将把$CORPID$替换成用户所属企业的corpid，例如原本的主页地址是http://www.dingtalk.com/index，则能获取用户corpid的主页地址为http://www.dingtalk.com/index?corpid=$CORPID$

步骤二：使用钉钉js-api提供的[<font color=red >获取免登授权码</font>](#获取免登授权码)接口获取CODE

步骤二：[<font color=red >通过CODE换取身份</font>](#通过code换取用户身份)

demo地址:[<font color=red >https://github.com/injekt/openapi-demo-php/blob/master/public/javascripts/demo.js</font>](https://github.com/injekt/openapi-demo-php/blob/master/public/javascripts/demo.js)

### 使用标准OAUTH2.0
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

##PC web调用免登

敬请期待

##钉钉PC版调用免登

敬请期待



## 通过CODE换取用户身份

企业应用的服务器在拿到CODE后，需要将CODE发送到钉钉开放平台接口，如果验证通过，则返回CODE对应的用户信息。

###### 请求说明

Https请求方式: GET

`https://oapi.dingtalk.com/user/getuserinfo?access_token=ACCESS_TOKEN&code=CODE`

###### 参数说明

参数 | 参数类型 | 必须 | 说明
---------- | ------- | ------- | ------
access_token | String | 是 | 调用接口凭证
code | String | 是 | 通过Oauth认证会给URL带上CODE

###### 返回结果

正确时返回示例如下：

```
{
    "errcode": 40029,
    "errmsg": "invalid code",
    "userid": "USERID",
    "deviceId":"DEVICEID",
    "is_sys": "true",
    "sys_level": 0|1|2
}
```

参数 | 说明
---------- | ------
userid | 员工在企业内的UserID
deviceId | 手机设备号,由钉钉在安装时随机产生
is_sys | 是否是管理员
sys_level | 级别，三种取值。0:非管理员 1：普通管理员 2：超级管理员


出错时返回示例如下：

```
{
    "errcode": 40029,
    "errmsg": "invalid code"
}
```

##OA后台调用管理员免登

本节的免登服务将在管理员访问微应用后台地址时调用

所以需要您先配置微应用后台地址

普通企业在[<font color=red>OA后台</font>](https://oa.dingtalk.com/#/microApp/microAppList)添加微应用配置如下

![normalcorp](https://img.alicdn.com/tps/TB1YUZjKpXXXXXaXXXXXXXXXXXX-642-734.jpg)

ISV在[<font color=red>开发者后台</font>](http://console.d.aliyun.com)添加微应用配置如下

![isvmicro](https://img.alicdn.com/tps/TB1W23iKpXXXXXiXXXXXXXXXXXX-715-913.jpg)


此免登服务，可以获取当前访问微应用后台地址的企业管理员身份及相关信息。

使用场景：希望后台地址只有企业管理员才有权限访问，则调用这个免登接口。

步骤一：在管理员访问后台地址的时候，企业在后台构造一个连接，通过HTTP 302跳转方式，让用户访问钉钉开放平台授权网址，构造的地址如下:

`https://oa.dingtalk.com/omp/api/micro_app/admin/landing?corpid=CORPID&redirect_url=REDIRECT_URL`

参数 | 说明
---------- | ------
corpid | 开发此微应用的公司corpid
redirect_url | 重定向地址


REDIRECT_URL为微应用后台地址，钉钉开放平台授权服务器如果判断当前用户属于当前企业的管理员时，会再次通过HTTP 302跳转回微应用的后台地址(即REDIRECT_URL)，并在REDIRECT_URL后面追加参数code=CODE,即

`REDIRECT_URL?code=CODE`

步骤二：企业在后台解析code参数，获取CODE

步骤三：通过[<font color=red >获取管理员免登Token接口</font>](#获取管理员免登token)获取token

步骤四：[<font color=red >通过CODE和Token换取管理员身份</font>](#通过code换取管理员身份)

demo查看:[https://github.com/injekt/openapi-demo-java/tree/master/src/com/alibaba/dingtalk/openapi/servlet](https://github.com/injekt/openapi-demo-java/tree/master/src/com/alibaba/dingtalk/openapi/servlet)

## 通过CODE换取管理员身份

企业应用的服务器在拿到CODE后，需要将CODE发送到钉钉开放平台接口，如果验证通过，则返回CODE对应的管理员信息。

###### 请求说明

Https请求方式: GET

`https://oapi.dingtalk.com/sso/getuserinfo?access_token=ACCESS_TOKEN&code=CODE`

###### 参数说明

参数 | 参数类型 | 必须 | 说明
---------- | ------- | ------- | ------
access_token | String | 是 | [<font color=red >获取微应用管理员免登需要的Token</font>](#获取管理员免登token)
code | String | 是 | 通过Oauth认证给URL带上的CODE

###### 返回结果

正确时返回示例如下：

```
{
    "corp_info": {
        "corp_name": "一家公司",
        "corpid": "dingxxxxxx"
    },
    "errcode": 0,
    "errmsg": "ok",
    "is_sys": true,
    "user_info": {
        "avatar": "http://xxxxxxx.jpg",
        "email": "123456@aliyun.com",
        "name": "名称",
        "userid": "0571"
    }
}
```

参数 | 说明
---------- | ------
corp_name | 公司名字
corpid | 公司corpid
is_sys | 是否是管理员（在这里是true）
avatar | 头像地址
email | email地址",
name | 用户名字,
userid | 员工在企业内的UserID


出错时返回示例如下：

```
{
    "errcode": 40029,
    "errmsg": "invalid code"
}
```

