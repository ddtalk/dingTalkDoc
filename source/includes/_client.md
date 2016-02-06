# 客户端开发文档

微应用是 钉钉 为连接企业办公打造的移动入口，通过微应用你可以将企业的业务审批，内部系统，生成，协作，管理，上下游沟通连接到钉钉，更简单和低成本实现企业移动化； 结合钉钉的基础通信能力，让企业应用更活跃，员工更高效，移动化成本更低。

而客户端开发文档将为微应用提供调用原生控件的能力，带给微应用接近原生代码的体验。

## Demo和调试工具

我们提供了Demo和调试工具给您的开发提供方便，如果对调用参数有疑问，请使用调试工具。对jsapi用法有疑问，可查看Demo.

[<font color=red >调试工具</font>](http://wsdebug.dingtalk.com/):[http://wsdebug.dingtalk.com](http://wsdebug.dingtalk.com)
打开左边的超链接之后，手机扫描二维码，然后在PC页面上配置jsapi参数，点击执行手机就会给予相应反馈

[<font color=red >jsapi使用样例地址</font>](http://h5.m.laiwang.com/home/ding.html):[http://h5.m.laiwang.com/home/ding.html](http://h5.m.laiwang.com/home/ding.html)

[<font color=red >微应用Demo地址</font>](https://github.com/outlookxie/app-todolist):[https://github.com/outlookxie/app-todolist](https://github.com/outlookxie/app-todolist)

## 开发版钉钉客户端
版本：2.7.6

#### Android
[下载地址](http://mupppub.cn-hangzhou.oss.aliyun-inc.com/25197/1315294/1315294/66d02c0966c8abedb5199c9a745e844b/702553%40Rimet-dingtalk-dev-2.7.6.apk)

启用开发者模式后即可使用chrome inspector进行调试。开发版客户端仅供微应用开发调试使用。

启用步骤：

* 进入“我的”(个人资料页)
* 选择“设置”
* 选择“通用”
* 选择“开发者选项”
* 打开“微应用调试”

[Remote debugging on Android with Chrome DevTools](https://developers.google.com/web/tools/chrome-devtools/debug/remote-debugging/remote-debugging?hl=en#remote-debugging-on-android-with-chrome-devtools)

#### iOS
[下载地址](http://yunpan.taobao.com/s/12fdWyQ05BM) (提取码：nj6LVK)

[Remote debugging on iOS with Safari Web Inspector](https://developers.google.com/web/tools/chrome-devtools/debug/remote-debugging/remote-debugging?hl=en#remote-debugging-on-ios-with-safari-web-inspector)


## 通用

### 页面引入js文件

js文件版本在添加升级功能时地址会变化，如有需要（比如要使用新增的js-api）,请随时关注地址变更。但是旧版本js文件也将一直可用。

`http://g.alicdn.com/ilw/ding/0.7.5/scripts/dingtalk.js`

或者

`https://g.alicdn.com/ilw/ding/0.7.5/scripts/dingtalk.js`

### 全局变量、命名空间

直接引入dingtalk.js会得到一个全局变量`dd`，支持amd、cmd引入方式

全局变量dd，命名空间：设备(dd.device)、业务(dd.biz)

### 权限验证配置(beta)

钉钉JS API安全验证，只有经过安全验证的微应用才能调用安全级别较高的API。

获取JS-API权限验证使用的签名的方法请参考附录-[<font color=red >JS-API权限签名算法</font>](#js-api权限签名算法)

[<font color=red >jsapi权限验证配置demo--node.js版本</font>](https://github.com/injekt/jsapi-demo)

[<font color=red >jsapi权限验证配置demo--java版本</font>](https://github.com/injekt/openapi-demo-java)

[<font color=red >jsapi权限验证配置demo--php版本</font>](https://github.com/injekt/openapi-demo-php)


```javascript
 dd.config({
    agentId: '', // 必填，微应用ID
    corpId: '',//必填，企业ID
    timeStamp: , // 必填，生成签名的时间戳
    nonceStr: '', // 必填，生成签名的随机串
    signature: '', // 必填，签名
    jsApiList: ['device.notification.alert', 'device.notification.confirm'] // 必填，需要使用的jsapi列表
});
```

##### 参数说明

参数 | 参数类型 | 必须 | 说明
------ | ----- | ------| ------
agentId | String |是 | 微应用ID，普通企业可以通过OA后台的微应用－设置查看agentID，ISV需要通过调用授权成功后的get_auth_info获取授权方的agentid
corpId | String |是 | 企业ID
timeStamp | String |是 | 生成签名的时间戳
nonceStr | String |是 | 生成签名的随机串
signature | String |是 | 签名
jsApiList | Array | 是 | 需要调用的jsapi列表

### 通过ready接口处理成功验证

dd.ready参数为回调函数，在环境准备就绪时触发，jsapi的调用需要保证在该回调函数触发后调用，否则无效。

```javascript
dd.ready(function(){
    ;
});
```

### 通过error接口处理失败验证

config信息验证失败会执行error函数，错误信息可以在返回的error参数中参看

```javascript
dd.error(function(error){
    ;
});
```

### 接口约定

* 所有接口都为异步
* 接受一个object类型的参数
* 成功回调 onSuccess(某些异步接口的成功回调，将在事件触发时被调用，具体详情请查看相关onSuccess回调时机，未做描述的即为同步接口)
* 失败回调 onFail

```javascript
dd.命名空间.功能.方法({
    参数1: '',
    参数2: '',
    onSuccess: function(result) {
    //成功回调
    /*
    {
        //所有返回信息都输出在这里
    }*/
    },
    onFail: function(){
    //失败回调
    }
})
```

## 容器

dd.runtime

### 获取容器信息

```javascript
dd.runtime.info({
    onSuccess: function(result) {
    /*{
        ability: '0.0.2' //容器版本，用来标识JSAPI能力，可根据该版本来决定能否使用jsapi
    }*/
    }
    onFail : function(err) {}

})
```

##### 返回说明

参数 | 说明
---- | -----
ability | 容器版本，用来标识JSAPI能力，可根据该版本来决定能否使用jsapi

### 获取免登授权码

0.0.5

```javascript
dd.runtime.permission.requestAuthCode({
	corpId: "corpid",
    onSuccess: function(result) {
    /*{
        code: 'hYLK98jkf0m' //string authCode
    }*/
    },
    onFail : function(err) {}

})
```
##### 参数说明

参数 | 参数类型 | 必须 | 说明
----- | ------- | ------- | ------
corpId | String | 是 | 企业ID

##### 返回说明

参数 | 说明
---- | -----
code | 授权码


<!--### 请求jsapi

0.0.5

```javascript
dd.runtime.permission.requestJsApis({
    corpId: '', //企业ID
    timeStamp: '', //生成签名的时间戳
    nonceStr: '', //生成签名的随机串
    signature: '', //签名
    jsApiList: [], //需要调用的jsapi列表
    onSuccess: function(result) {
    /*{
        jsApilist: [] //array[string] authJsApiList
    }*/
    }
})
```
##### 参数说明

参数 | 参数类型 | 必须 | 说明
----- | ------- | ------- | ------
corpId | String | 是 | 企业ID
timeStamp | String | 是 | 生成签名的时间戳
nonceStr | String | 是 | 生成签名的随机串
signature | String | 是 | 签名
jsApiList | array[string] | 是 | 需要调用的jsapi列表

##### 返回说明

参数 | 说明
---- | -----
jsApilist | 授权的JsApi列表
-->

## 设备

dd.device

### 基础信息

### 获取通用唯一识别码

0.0.5

```javascript
dd.device.base.getUUID({
    onSuccess : function(data) {
        /*
        {
            uuid: '3udbhg98ddlljokkkl' //
        }
        */
    },
    onFail : function(err) {}
});
```

##### 返回说明

参数 | 说明
---- | -----
uuid | 通用唯一识别码

### 获取热点接入信息

0.0.5

```javascript
dd.device.base.getInterface({
    onSuccess : function(data) {
        /*
        {
            ssid: 'alibaba-inc',
            macIp: '3c:12:aa:09'
        }
        */
    },
    onFail : function(err) {}
});
```

##### 返回说明

参数 | 说明
---- | -----
ssid | 热点ssid
macIp | 热点mac地址

## 启动器

dd.device

### 检测应用是否安装

0.0.5

```javascript
dd.device.launcher.checkInstalledApps({
    apps: ['taobao', 'tmall'], //iOS:应用scheme;Android:应用包名
    onSuccess : function(data) {
        /*
        {
            installed: ['taobao', 'tmall'] //iOS:应用scheme;Android:应用包名
        }
        */
    },
    onFail : function(err) {}
});
```

##### 参数说明

参数 | 参数类型 | 说明
----- | ------- | ------
apps | Array[String] | iOS:应用scheme;Android:应用包名

##### 返回说明

参数 | 说明
---- | -----
installed | 安装过的应用列表

### 启动第三方应用

0.0.5

```javascript
dd.device.launcher.launchApp({
    app: 'taobao', //iOS:应用scheme;Android:应用包名
    onSuccess : function(data) {
        /*
        {
            result: true //true 唤起成功 false 唤起失败
        }
        */
    },
    onFail : function(err) {}
});
```
##### 参数说明

参数 | 参数类型 | 说明
----- | ------- | -------
app | String | iOS:应用scheme;Android:应用包名

##### 返回说明

参数 | 说明
---- | -----
result | 值为true说明唤起成功，值为false说明唤起失败


### 获取当前网络类型

0.0.2

```javascript
dd.device.connection.getNetworkType({
    onSuccess : function(data) {
        /*
        {
            result: 'wifi' // result值: wifi 2g 3g 4g unknown none   none表示离线
        }
        */
    },
    onFail : function(err) {}
});
```
##### 返回说明

参数 | 说明
---- | -----
result | result值: wifi、2g、3g、4g、unknown、none，none表示离线


### 事件

支持事件： pause、resume、backbutton(android)


```
//退到后台(webview)
document.addEventListener('pause', function(e) {
    e.preventDefault();
    console.log('事件：pause')
}, false);

//唤醒(webview)
document.addEventListener('resume', function(e) {
    e.preventDefault();
    console.log('事件：resume')
}, false);


//返回按钮(android)
document.addEventListener('backbutton', function(e) {
    e.preventDefault();
    dd.device.notification.alert({
        message: '哎呀，你不小心点到返回键啦!',
        title: '...警告...'
    });
}, false);
```


## 钉盘

dd.biz

###转存文件到钉盘

```javascript
	dd.biz.cspace.saveFile({
				corpId:"dingf8b3508f3073b265",
				url:"https://ringnerippca.files.wordpress.com/20.pdf",
				name:"文件名",         
				onSuccess: function(data) {
				 /* data结构
				 {"data":
    				[
    				{
     				"corpId": "", //公司id
      				"spaceId": "" //空间id
      				"fileId": "", //文件id
      				"fileName": "", //文件名
      				"fileSize": 111111, //文件大小
      				"fileType": "", //文件类型
     				}
   					]
   				 }
 				 */
		        },
	            onFail: function(err) {
	                alert(JSON.stringify(err));
	            }
			});
```
##### 参数说明

参数 | 参数类型 | 说明
----- | ----- | -----
corpId | String | 用户当前的corpid，将只能存储到当前corpid对应企业的钉盘和个人钉盘
url | String | 文件地址
name | String | 文件保存的名字



## 弹窗

dd.device

### alert

```javascript
dd.device.notification.alert({
    message: "亲爱的",
    title: "提示",//可传空
    buttonName: "收到",
    onSuccess : function() {
    	//onSuccess将在点击button之后回调
        /*回调*/
    },
    onFail : function(err) {}
});
```
<img src="https://gw.alicdn.com/tps/TB1.3UPJpXXXXbEXVXXXXXXXXXX-750-1334.jpg" width = "200" height = "355" alt="图片名称" align=right />

##### 参数说明

参数 | 参数类型 | 说明
----- | ----- | -----
message | String | 消息内容
title | String | 弹窗标题
buttonName | String |按钮名称



### confirm


```javascript
dd.device.notification.confirm({
    message: "你爱我吗",
    title: "提示",
    buttonLabels: ['爱', '不爱'],
    onSuccess : function(result) {
    	//onSuccess将在点击button之后回调
        /*
        {
            buttonIndex: 0 //被点击按钮的索引值，Number类型，从0开始
        }
        */
    },
    onFail : function(err) {}
});
```
<img src="https://img.alicdn.com/tps/TB1cL.KJpXXXXXJaXXXXXXXXXXX-750-1334.jpg" width = "200" height = "355" alt="图片名称" align=right />

##### 参数说明

参数 | 参数类型 | 说明
----- | ----- | -----
message | String | 消息说明
title | String |标题
buttonLabels | Array[String]| 按钮名称

##### 返回说明

参数 | 说明
---- | -----
buttonIndex | 被点击按钮的索引值，Number类型，从0开始

### prompt

```javascript
dd.device.notification.prompt({
    message: "再说一遍？",
    title: "提示",
    buttonLabels: ['继续', '不玩了'],
    onSuccess : function(result) {
        //onSuccess将在点击button之后回调
        /*
        {
            buttonIndex: 0, //被点击按钮的索引值，Number类型，从0开始
            value: '' //输入的值
        }
        */
    },
    onFail : function(err) {}
});
```
<img src="https://img.alicdn.com/tps/TB1lZZJJpXXXXazaXXXXXXXXXXX-750-1334.jpg" width = "200" height = "355" alt="图片名称" align=right />

##### 参数说明

参数 | 参数类型 | 说明
----- | ----- | -----
message | String |消息内容
title | String |标题
buttonLabels | Array[String] | 按钮名称

##### 返回说明

参数 | 说明
---- | -----
buttonIndex | 被点击按钮的索引值，Number类型，从0开始
value | 输入的值

### vibrate
震动

```javascript
dd.device.notification.vibrate({
    duration: 300, //震动时间，android可配置 iOS忽略
    onSuccess : function(result) {
        /*
        {}
        */
    },
    onFail : function(err) {}
})
```
##### 参数说明

参数 | 参数类型 | 说明
----- | ----- | -----
duration | Number | 震动时间，android可配置 iOS忽略

### showPreloader
（显示浮层，请和hidePreloader配对使用）

```javascript
dd.device.notification.showPreloader({
    text: "使劲加载中..", //loading显示的字符，空表示不显示文字
    showIcon: true, //是否显示icon，默认true
    onSuccess : function(result) {
        /*{}*/
    },
    onFail : function(err) {}
})
```
<img src="https://img.alicdn.com/tps/TB17bBXJFXXXXb3XXXXXXXXXXXX-750-1334.jpg" width = "200" height = "355" alt="图片名称" align=right />

##### 参数说明

参数 | 参数类型 | 说明
----- | ----- | -----
text | String | loading显示的字符，空表示不显示文字
showIcon | Boolean | 是否显示icon，默认true

### hidePreloader

```javascript
dd.device.notification.hidePreloader({
    onSuccess : function(result) {
        /*{}*/
    },
    onFail : function(err) {}
})
```

### toast

```javascript
dd.device.notification.toast({
    icon: '', //icon样式，有success和error，默认为空 0.0.2
    text: String, //提示信息
    duration: Number, //显示持续时间，单位秒，默认按系统规范[android只有两种(<=2s >2s)]
    delay: Number, //延迟显示，单位秒，默认0
    onSuccess : function(result) {
        /*{}*/
    },
    onFail : function(err) {}
})
```

<img src="https://img.alicdn.com/tps/TB1jjdJKVXXXXXbXpXXXXXXXXXX-200-356.jpg" alt="图片名称" align=right />

##### 参数说明

参数 | 参数类型 | 说明
----- | ----- | -----
icon | Boolean | icon样式，有success和error，默认为空 0.0.2
text | String | 提示信息
duration |  Number |显示持续时间，单位秒，默认按系统规范[android只有两种(<=2s >2s)]
delay | Number | 延迟显示，单位秒，默认0


### actionsheet
单选列表

0.0.2

```javascript
dd.device.notification.actionSheet({
    title: "谁是最棒哒？", //标题
    cancelButton: '取消', //取消按钮文本
    otherButtons: ["孙悟空","猪八戒","唐僧","沙和尚"],
    onSuccess : function(result) {
        //onSuccess将在点击button之后回调
        /*{
            buttonIndex: 0 //被点击按钮的索引值，Number，从0开始, 取消按钮为-1
        }*/
    },
    onFail : function(err) {}
})
```
<img src="https://img.alicdn.com/tps/TB1jn70JpXXXXXEXFXXXXXXXXXX-750-1334.jpg" width = "200" height = "355" alt="图片名称" align=right />

##### 参数说明

参数 | 参数类型 | 说明
----- | ----- | -----
title | String | 标题
cancelButton | String |取消按钮文本
otherButtons | Array[String] | 其他按钮列表

##### 返回说明

参数 | 说明
----- | -----
buttonIndex | 被点击按钮的索引值，Number，从0开始, 取消按钮为-1


### modal

modal弹浮层

```javascript
dd.device.notification.modal({
    image:"http://gw.alicdn.com/tps/i2/TB1SlYwGFXXXXXrXVXX9vKJ2XXX-2880-1560.jpg_200x200.jpg", // 标题图片地址
    title:"2.4版本更新", //标题
    content:"1.功能更新2.功能更新;", //文本内容
    buttonLabels:["了解更多","知道了"],// 最多两个按钮，至少有一个按钮。
    onSuccess : function(result) {
        //onSuccess将在点击button之后回调
        /*{
            buttonIndex: 0 //被点击按钮的索引值，Number，从0开始
        }*/
    },
    onFail : function(err) {}
})
```
<img src="https://img.alicdn.com/tps/TB1M1MKJpXXXXadaXXXXXXXXXXX-720-1280.jpg" width = "200" height = "355" alt="图片名称" align=right />

##### 参数说明

参数 | 参数类型 | 说明
----- | ----- | -----
image | String | 图片地址
title | String | 标题
content | String | 文本内容
buttonLabels | Array[String] | 其他按钮列表

##### 返回说明

参数 | 说明
----- | -----
buttonIndex | 被点击按钮的索引值，Number，从0开始


## 地图

dd.device

### 获取当前地理位置

钉钉Android2.1及之前版本返回的数据会多嵌套一层location字段,2.2版本会改成和钉钉iOS客户端一致，请注意，建议对返回的数据先判断存在location，做向后兼容处理。

目前androidJSAPI返回的坐标是高德坐标，ios是标准坐标，如果服务端调用的是高德API，则需要对ios返回的经纬度做下处理，详细请见[<font color=red >http://lbsbbs.amap.com/forum.php?mod=viewthread&tid=724&page=2</font>](http://lbsbbs.amap.com/forum.php?mod=viewthread&tid=724&page=2)。坐标转换API [<font color=red >http://lbs.amap.com/api/javascript-api/example/p/1602-2/</font>](http://lbs.amap.com/api/javascript-api/example/p/1602-2/)

```javascript
dd.device.geolocation.get({
	targetAccuracy : Number,
    onSuccess : function(result) {
        /*
        {
            longitude : Number,
            latitude : Number,
            accuracy : Number,
            isWifiEnabled : Boolean,
            isGpsEnabled : Boolean,
            isFromMock : Boolean,
            provider : wifi|lbs|gps,
            accuracy : Number,
            isMobileEnabled : Boolean,
            errorMessage : String,
			errorCode : Number
        }
        */
    },
    onFail : function(err) {}
});
```

##### 参数说明

参数 | 参数类型 | 说明
----- | ----- | -----
targetAccuracy | Number | 期望定位精度半径（单位米），定位结果尽量满足该参数要求，但是不一定能保证小于该误差


##### 返回说明

参数 | 说明
----- | -----
longitude | 经度
latitude | 纬度
accuracy | 实际的定位精度半径（单位米）
isWifiEnabled | wifi设置是否开启，不保证已连接上
isGpsEnabled | gps设置是否开启，不保证已经连接上
isFromMock | 定位返回的经纬度是否是模拟的结果
provider | 我们使用的是混合定位，具体定位提供者有wifi/lbs/gps" 这三种
isMobileEnabled | 移动网络是设置是否开启，不保证已经连接上
errorMessage | 对错误码的描述
errorCode | 错误码
<!--

### 搜索
0.0.6

```javascript
dd.biz.map.search({
  scope: Number, //定位范围
  extraInfo: {
	  prompt: "提示信息"
  }
  onSuccess: function(data) {
  /* data结构
	  {
	  "province": ""//省
	  "provinceCode": "" //省份编码
	  "city": "" //城市
	  "cityCode": "" //城市编码
	  "adCode": "" // POI的行政区划代码
	  "adName": "" // POI的行政区划名称
	  "distance": "" //获取POI距离中心点的距离
	  "postCode": "" //返回POI的邮编
	  "title": "" //POI的名称
	  "snippet": "" //POI的地址
	  "longitude": 11.11, //该点经度
	  "latitude": 11.11, //该点纬度
	  }
  */
  },
  onFail : function(err) {
  }
})
```
##### 参数说明

参数 | 参数类型 | 说明
----- | ----- | -----
scope | Number | 定位范围
extraInfo.prompt | String | 提示信息

##### 返回说明

参数 | 说明
----- | -----
province | 省份
provinceCode | 省份编码
city | 城市
cityCode | 城市编码
adCode | POI的行政区划代码
adName | POI的行政区划名称
distance | 获取POI距离中心点的距离
postCode | 返回POI的邮编
title | POI的名称
snippet | POI的地址
longitude | 该点经度
latitude | 该点纬度

###定位
0.0.6

```javascript
dd.biz.map.locate({
  onSuccess: function(data) {
   /* data结构
	  {
	  "province": ""//省
	  "provinceCode": "" //省份编码
	  "city": "" //城市
	  "cityCode": "" //城市编码
	  "adCode": "" // POI的行政区划代码
	  "adName": "" // POI的行政区划名称
	  "distance": "" //获取POI距离中心点的距离
	  "postCode": "" //返回POI的邮编
	  "title": "" //POI的名称
	  "snippet": "" //POI的地址
	  "longitude": 11.11, //该点经度
	  "latitude": 11.11, //该点纬度
	  }
  */
  },
  onFail : function(err) {
  }
})
```

##### 返回说明

参数 | 说明
----- | -----
province | 省份
provinceCode | 省份编码
city | 城市
cityCode | 城市编码
adCode | POI的行政区划代码
adName | POI的行政区划名称
distance | 获取POI距离中心点的距离
postCode | 返回POI的邮编
title | POI的名称
snippet | POI的地址
longitude | 该点经度
latitude | 该点纬度

-->

## 加速器

dd.device

### 摇一摇

开启监听

```javascript
dd.device.accelerometer.watchShake({
    sensitivity: 20,//振动幅度，Number类型，加速度变化超过这个值后触发shake
    frequency: 150,//采样间隔(毫秒)，Number类型，指每隔多长时间对加速度进行一次采样， 然后对比前后变化，判断是否触发shake
    callbackDelay: 3000,//触发『摇一摇』后的等待时间(毫秒)，Number类型，防止频繁调用
    onSuccess : function(result) {
        /*
        {}
        */
    },
    onFail : function(err) {}
});
```
##### 参数说明

参数 | 参数类型 | 说明
----- | ----- | -----
sensitivity | Number |振动幅度，Number类型，加速度变化超过这个值后触发shake
frequency | Number | 采样间隔(毫秒)，Number类型，指每隔多长时间对加速度进行一次采样， 然后对比前后变化，判断是否触发shake
callbackDelay| Number |触发『摇一摇』后的等待时间(毫秒)，Number类型，防止频繁调用


清除监听

```javascript
dd.device.accelerometer.clearShake({
    onSuccess : function(result) {
        /* 调用成功
        */
    },
    onFail : function(err) {}
});
```


## 业务

dd.biz


### 打开应用内页面

```
dd.biz.util.open({
    name:String,//页面名称
    params:JSONObject,//传参
    onSuccess : function() {
        /**/
    },
    onFail : function(err) {}
});
```

参数 | 参数类型 | 说明
----- | ----- | -----
name | String | 页面名称
params | JSONObject | 传参

目前支持以下页面，具体参数看右边

a.个人资料页

```
// 页面名称：
    profile
// 传参：
    id :用户工号 String
    corpId: '' //企业id
```

b.聊天页面

```
// 页面名称：
    chat
// 传参：
    users: ['123'] 用户列表,工号
    corpId: '' //企业id
```

c.免费电话页面

```
// 页面名称：
    call
// 传参：
```

d.联系人添加页面

```
// 页面名称：
    contactAdd
// 传参：
```

f.唤起添加好友页面


```
// 页面名称：
    friendAdd
// 传参：
```


### 分享

```javascript
dd.biz.util.share({
    type: Number,//分享类型，0:全部组件 默认； 1:只能分享到钉钉；2:不能分享，只有刷新按钮
    url: String,
    title: String,
    content: String,
    image: String,
    onSuccess : function() {
        //onSuccess将在分享完成之后回调
        /**/
    },
    onFail : function(err) {}
})
```
<img src="https://img.alicdn.com/tps/TB1L6RvKVXXXXa3XFXXXXXXXXXX-200-356.jpg" alt="图片名称" align=right />

##### 参数说明

参数 | 参数类型 |  说明
----- | ----- | -----
type | Number | 分享类型，0:全部组件默认； 1:只能分享到钉钉；2:不能分享，只有刷新按钮
url | String | url地址
title | String | 分享标题
content | String | 分享内容
image | String |分享的图片


### ut数据埋点
ISV与钉钉进行数据对接的数据埋点接口，用于采集用户数据，ISV可根据微应用中关键操作进行埋点

```javascript
dd.biz.util.ut({
    key: String,//打点名
    value: String/JSONObject,//打点传值
    onSuccess : function() {
        /**/
    },
    onFail : function(err) {}
})
```
##### 参数说明

参数 | 参数类型 | 说明
----- | ----- | -----
key | String | 打点名，目前建议值open_micro_general_operat
value | String | 打点传值，必须传入’corpId':'传入corpId','agentId':'传入agentId','type':'传入type’；type(由isv自由提供的点击类型，默认可以传空)


<!--### 选取图片[暂不开放]

```javascript
dd.biz.util.chooseImage({
    multiple: false, //是否多选，默认false
    destType: String, //返回格式 DATA_URL(base64编码) FILE_URI(文件路径)，默认FILE_URI
    onSuccess : function(result) {
        /**/
    },
    onFail : function() {}
})
```
-->

### 上传图片
选择图片+上传，防止恶意上传

将在成功上传之后回调onSuccess方法，返回alicdn上的图片链接。微应用也可以调用`<input type="file" accept="image/*">`来自定义上传图片，此标签钉钉客户端版本2.5及以上支持。

```javascript
dd.biz.util.uploadImage({
    multiple: false, //是否多选，默认false
    max: 3, //最多可选个数
    onSuccess : function(result) {
    	//onSuccess将在图片上传成功之后调用
        /*
        [
          'http://gtms03.alicdn.com/tps/i3/TB1VF6uGFXXXXalaXXXmh5R_VXX-237-236.png'
        ]
        */
    },
    onFail : function() {}
})
```
<img src="https://img.alicdn.com/tps/TB1FhFlKVXXXXbNXVXXXXXXXXXX-200-356.png" alt="图片名称" align=right />

##### 参数说明

参数 | 参数类型 | 说明
----- | ----- | -----
multiple | Boolean | 是否多选，默认false
max | Number | Number为正整数，最多可选个数


### 上传图片（仅支持拍照上传）
只支持直接拍照上传，即调用这个API之后将直接调起相机界面

比如可以应用在，需要用户上传即时照片的场景。成功上传之后回调onSuccess方法，返回图片链接
```javascript
dd.biz.util.uploadImageFromCamera({
    compression:true,//(是否压缩，默认为true)
    onSuccess : function(result) {
    	 //onSuccess将在图片上传成功之后调用
        /*
        [
          'http://gtms03.alicdn.com/tps/i3/TB1VF6uGFXXXXalaXXXmh5R_VXX-237-236.png'
        ]
        */
    },
    onFail : function() {}
})
```
##### 参数说明

参数 | 参数类型 |说明
----- | ----- | -----
compression | Boolean | 图片地址列表


### 图片浏览器

调用此api，将显示一个图片浏览器

```javascript
dd.biz.util.previewImage({
    urls: [String],//图片地址列表
    current: String,//当前显示的图片链接
    onSuccess : function(result) {
        /**/
    },
    onFail : function() {}
})
```

<img src="https://img.alicdn.com/tps/TB1UjhmKVXXXXboXVXXXXXXXXXX-200-356.jpg" alt="图片名称" align=right />

##### 参数说明

参数 | 参数类型 |说明
----- | ----- | -----
urls | Array[String] | 图片地址列表
current | String | 当前显示的图片链接

<!-- ### 扫码

```javascript
dd.biz.util.qrcode({
    onSuccess : function(result) {
        /*
        {
            text: String
        }
        */
    },
    onFail : function(err) {}
})
```
##### 返回说明
参数 | 说明
----- | ------
text | 扫码的内容 -->


### 日期选择器

日期

注意：format只支持android系统规范，即2015-03-31格式为yyyy-MM-dd

```javascript
dd.biz.util.datepicker({
    format: 'yyyy-MM-dd',
    value: '2015-04-17', //默认显示日期
    onSuccess : function(result) {
        //onSuccess将在点击完成之后回调
        /*{
            value: "2015-02-10"
        }
        */
    },
    onFail : function() {}
})
```
<img src="https://img.alicdn.com/tps/TB1bcRLKVXXXXb8XXXXXXXXXXXX-200-356.png" width = "200" height = "355" alt="图片名称" align=right />

##### 参数说明

参数 | 参数类型 | 说明
----- | ----- | -----
format | String | format只支持android系统规范，即2015-03-31格式为yyyy-MM-dd
value | String | 默认显示日期

#####　返回说明
参数 | 说明
----- | ------
value | 返回选择的日期

时间

```javascript
dd.biz.util.timepicker({
    format: 'HH:mm',
    value: '14:00', //默认显示时间  0.0.3
    onSuccess : function(result) {
        //onSuccess将在点击完成之后回调
        /*{
            value: "10:00"
        }
        */
    },
    onFail : function() {}
})
```
##### 参数说明

参数 | 参数类型 | 说明
----- | ----- | -----
format | String | 时间格式
value | String | 默认显示时间

#####　返回说明
参数 | 说明
----- | ------
value | 返回选择的时间

日期+时间

0.0.4

```javascript
dd.biz.util.datetimepicker({
    format: 'yyyy-MM-dd HH:mm',
    value: '2015-04-17 08:00', //默认显示
    onSuccess : function(result) {
        //onSuccess将在点击完成之后回调
        /*{
            value: "2015-06-10 09:50"
        }
        */
    },
    onFail : function() {}
})
```
##### 参数说明

参数 | 参数类型 | 说明
----- | ----- | -----
format |String | 日期和时间的格式
value | String | 默认显示的日期和时间

#####　返回说明
参数 | 说明
----- | ------
value | 返回选择的日期和时间

### 下拉控件

0.0.5

```javascript
dd.biz.util.chosen({
    source:[{
        key: '选项1', //显示文本
        value: '123' //值，
    },{
        key: '选项2',
        value: '234'
    }],
    onSuccess : function(result) {
    //onSuccess将在点击完成之后回调
        /*
        {
            key: '选项2',
            value: '234'
        }
        */
    },
    onFail : function() {}
})
```
<img src="https://img.alicdn.com/tps/TB177sWJpXXXXbeXFXXXXXXXXXX-750-1334.jpg" width = "200" height = "355" alt="图片名称" align=right />

##### 参数说明

参数 | 参数类型 |  说明
----- | ----- | -----
source | Array[String] | 下拉控件的内容
key | String | 显示文本
value | String | 文本对应的值

#####　返回说明
参数 | 说明
----- | ------
key | 返回选择的文本
value | 返回选择的值

## 会话

dd.biz

### 获取会话信息

0.0.7

corpid必须是用户所属的企业的corpid


```javascript
dd.biz.chat.pickConversation({
    corpId: '', //企业id
    isConfirm:'true', //是否弹出确认窗口，默认为true
    onSuccess : function() {
    	//onSuccess将在选择结束之后调用
        /*{
            cid: 'xxxx',
            title:'xxx'
        }*/
},
    onFail : function() {}
})
```
<img src="https://img.alicdn.com/tps/TB1cXJPKVXXXXXFXXXXXXXXXXXX-200-356.png" width = "200" height = "355" alt="图片名称" align=right />

##### 参数说明

参数 | 参数类型 | 说明
----- | ----- | -----
corpId | String | 企业ID
isConfirm | Boolean | 是否弹出确认窗口，默认为true

##### 返回说明
参数 | 说明
----- | -----
cid | 会话id
title | 会话标题

### 根据corpid选择会话

0.0.11

corpid必须是用户所属的企业的corpid

2.6版本新增

```javascript
dd.biz.chat.chooseConversationByCorpId({
    corpId: 'xxx', //企业id
    onSuccess : function() {
        	//onSuccess将在选择结束之后调用
        /*{
            chatId: 'xxxx',
            title:'xxx'
        }*/
},
    onFail : function() {}
})
```
##### 参数说明

参数 | 参数类型 | 说明
----- | ----- | -----
corpId | String | 企业ID

##### 返回说明
参数 | 说明
----- | -----
chatId | 会话id
title | 会话标题


### 根据chatid跳转到对应会话

0.0.11

corpid必须是用户所属的企业的corpid

2.6版本新增

```javascript
dd.biz.chat.toConversation({
    corpId: 'xxx', //企业id
    chatId:'xxx',//会话Id
    onSuccess : function() {},
    onFail : function() {}
})
```
##### 参数说明

参数 | 参数类型 | 说明
----- | ----- | -----
corpId | String | 企业ID
chatId | String | 会话ID

##### 返回说明（无）



<!--### 发送消息

```javascript
dd.biz.chat.sendMessage({
    users : ['100', '101'],//用户列表，工号
    corpId: '', //企业id
    type: 1,//消息类型 1：image  2：link  [暂定和发钉保持一致]
    attachment: {
        images: [''],
    },
    text: String,
    onSuccess : function() {},
    onFail : function() {}
})
```

### 选择会话(群)

类似分享到钉钉的选取页面，只能选一个回话 0.0.3

```javascript
dd.biz.chat.chooseConversation({
    onSuccess : function(data) {
    /*
    {
        id: '123' //会话id
    }
    */
    },
    onFail : function() {}
})
```
#####　返回说明
参数 | 说明
----- | ------
id | 会话id

###获取会话信息

0.0.6

```javascript
dd.biz.chat.getConversationInfo ({
  cid: String, //会话ID
  onSuccess: function(data) {
  /* data结构
	  "cid": "1111", //会话ID
	  "title": '123', //会话标题
	  "avatarIcons": ["http://", ...], //会话的头像数组
	  "memberCount": 11, //群聊成员总数
	  }
  */
  },
  onFail : function(err) {
  }
})
```
##### 参数说明

参数 | 参数类型 | 说明
----- | ----- | -----
cid | String | 会话ID

##### 返回说明
参数 | 说明
----- | -----
cid | 会话ID
title | 会话标题
avatarIcons | 会话的头像数组
memberCount | 群聊成员总数
-->

## Ding

dd.biz

### 发钉

#### 图片类型

0.0.3

```javascript
dd.biz.ding.post({
    users : ['100', '101'],//用户列表，工号
    corpId: '', //企业id
    type: 1, //钉类型 1：image  2：link
    alertType: 2,
    alertDate: {"format":"yyyy-MM-dd HH:mm","value":"2015-05-09 08:00"},
    attachment: {
        images: [''],
    }, //附件信息
    text: '', //消息
    onSuccess : function() {
    //onSuccess将在点击发送之后调用
    },
    onFail : function() {}
})
```
<img src="https://img.alicdn.com/tps/TB1h_JtKVXXXXbNXFXXXXXXXXXX-200-356.png" alt="图片名称" align=right />

##### 参数说明

参数 | 参数类型 | 说明
----- | ----- | -----
users | Array[String] | 用户列表，工号
corpId | String | 企业id
type | Number |Number为整数。钉类型 1：image，2：link
alertType |  Number |  钉提醒类型 0:电话, 1:短信, 2:应用内
alertDate |  Object  | 钉提醒时间
attachment | Object |附件信息
text | String |  消息

#### Link类型

0.0.3

```javascript
dd.biz.ding.post({
    users : ['100', '101'],//用户列表，工号
    corpId: '', //企业id
    type: 2, //钉类型 1：image  2：link
    alertType: 2,
    alertDate: {"format":"yyyy-MM-dd HH:mm","value":"2015-05-09 08:00"},
    attachment: {
        title: '',
        url: '',
        image: '',
        text: ''
    }
    text: '', //消息
    onSuccess : function() {},
    onFail : function() {}
})
```
##### 参数说明

参数 | 参数类型 | 说明
----- | ----- | -----
users | Array[String] | 用户列表，工号
corpId | String | 企业id
type | Number |Number为整数。钉类型 1：image  2：link
alertType |  Number |  钉提醒类型 0:电话, 1:短信, 2:应用内
alertDate |  Object  | 钉提醒时间
attachment | Object | 附件信息
text | String |  消息

## 电话

dd.biz

### 打电话

0.0.3

```javascript
dd.biz.telephone.call({
    users: ['101', '102'], //用户列表，工号
    corpId: '', //企业id
    onSuccess : function() {},
    onFail : function() {}
})
```
##### 参数说明

参数 | 参数类型 |说明
----- | ----- | -----
users | Array[String] | 用户列表，工号
corpId | String | 企业id


## UI控件

dd.ui

### 输入框

0.0.2

```javascript
dd.ui.input.plain({
    placeholder: '说点什么吧', //占位符
    text: '', //默认填充文本
    onSuccess: function(data) {
    	//onSuccess将在点击发送之后调用
        /*{
            text: String
        }*/
    },
    onFail: function() {

    }
})
```
<img src="https://img.alicdn.com/tps/TB1ju0BKVXXXXcrXpXXXXXXXXXX-200-356.png" width = "200" height = "355" alt="图片名称" align=right />

##### 参数说明

参数 | 参数类型 | 说明
----- | ----- | -----
placeholder | String | 占位符
text | String | 默认填充文本

##### 返回说明
参数 | 说明
----- | ------
text | 返回文本

### 设置顶部进度条颜色

0.0.5

```javascript
dd.ui.progressBar.setColors({
    colors: [], //array[number] 进度条变化颜色，最多支持4个颜色
    onSuccess: function(data) {
        /*
            true:成功  false:失败
        */
    },
    onFail: function() {
    }
})
```
##### 参数说明

参数 | 参数类型 | 说明
----- | ----- | -----
colors | array[number] | 进度条变化颜色，最多支持4个颜色



### 启用下拉刷新

0.0.5

```javascript
dd.ui.pullToRefresh.enable({
    onSuccess: function() {
    },
    onFail: function() {
    }
})
```

### 收起下拉loading

0.0.5

```javascript
dd.ui.pullToRefresh.stop()
```

### 禁用下拉刷新

0.0.5

```javascript
dd.ui.pullToRefresh.disable()
```

### 启用bounce

启用iOS webview弹性效果(仅iOS支持) 0.0.5

```javascript
dd.ui.webViewBounce.enable()
```

### 禁用bounce

禁用iOS webview弹性效果(仅iOS支持) 0.0.5

```javascript
dd.ui.webViewBounce.disable()
```

##扫码

dd.biz

0.0.6

```javascript
dd.biz.util.scan({
    type: String,//type为qrCode或者barCode
    onSuccess: function(data) {
    //onSuccess将在扫码成功之后回调
      /* data结构
        { 'text': String}
      */
    },
   onFail : function(err) {
   }
})
```

##### 参数说明

参数 | 参数类型 | 说明
----- | ----- | -----
type | String | type为qrCode或者barCode

#####　返回说明

参数 | 说明
------|------
text | 扫码内容

## 企业通讯录

dd.biz

###选人
0.0.6

corpid必须是用户所属的企业的corpid

此接口只能对用户进行选择，若要同时选择部门，请使用“选人，选部门”接口。

```javascript
dd.biz.contact.choose({
  startWithDepartmentId: Number, //-1表示打开的通讯录从自己所在部门开始展示, 0表示从企业最上层开始，(其他数字表示从该部门开始:暂时不支持)
  multiple: Boolean, //是否多选： true多选 false单选； 默认true
  users: [String, String, ...], //默认选中的用户列表，userid；成功回调中应包含该信息
  corpId: String, //企业id
  max: Number, //人数限制，当multiple为true才生效，可选范围1-1500
  onSuccess: function(data) {
  //onSuccess将在选人结束，点击确定按钮的时候被回调
  /* data结构
    [{
      "name": "张三", //姓名
      "avatar": "http://g.alicdn.com/avatar/zhangsan.png" //头像图片url，可能为空
      "emplId": '0573', //userid
     },
     ...
    ]
  */
  },
  onFail : function(err) {}
});
```
<img src="https://img.alicdn.com/tps/TB1j_JPKVXXXXXbXXXXXXXXXXXX-200-356.png" width = "200" height = "355" alt="图片名称" align=right />


##### 参数说明

参数 | 参数类型 | 说明
----- | ----- | -----
startWithDepartmentId | Number | -1表示从自己所在部门开始, 0表示从企业最上层开始，(其他数字表示从该部门开始:暂时不支持)
multiple | Boolean | 是否多选： true多选，false单选； 默认true
users | Array[String] | 默认选中的用户列表，userid；成功回调中应包含该信息
corpId | String | 企业id
max | Number | 人数限制，当multiple为true才生效，可选范围1-1500

<!--
startWithDepartmentId: Number, //-1表示从自己所在部门开始, 0表示从企业最上层开始，(其他数字表示从该部门开始:暂时不支持)
startWithDepartmentId | Number | -1表示从自己所在部门开始, 0表示从企业最上层开始，(其他数字表示从该部门开始:暂时不支持)
-->

#####　返回说明

参数 | 说明
------|------
name | 姓名
avatar | 头像图片url，可能为空
emplId | userid，[<font color=red>获取成员详情接口</font>](#获取部门成员（详情）)

###选人，选部门

0.0.6

corpid必须是用户所属的企业的corpid


```javascript
dd.biz.contact.complexChoose({
  startWithDepartmentId: Number, //-1表示从自己所在部门开始, 0表示从企业最上层开始，其他数字表示从该部门开始
  selectedUsers: [String, String, ...], //预选用户
  corpId: String, //企业id
  onSuccess: function(data) {
  //onSuccess将在选人，选部门结束，点击确定按钮的时候被回调
  /* data结构
    {
      "users": [
      {
        "name": "张三", //姓名
        "avatar": "htp://g.alicdn.com/avatar/zhangsan.png" //头像图片url，可能为空
        "emplId": "0573", //userid:
      },
      ...
      ],
      "department": [
      {
        "id": 2,
        "name": "来往事业部",
      },
      ...
      ]
    }
  */
  },
  onFail : function(err) {}
});
```

<img src="https://img.alicdn.com/tps/TB1QCXuKVXXXXbWXFXXXXXXXXXX-750-1334.jpg
" width = "200" height = "355" alt="图片名称" align=right />


##### 参数说明

参数 | 参数类型 | 说明
----- | ----- | -----
startWithDepartmentId | Number | -1表示从自己所在部门开始, 0表示从企业最上层开始，其他数字表示从该部门开始
selectedUsers | Array[String] | 预选用户
corpId | String | 企业id

<!--隐藏selectedDepartments
selectedDepartments | Array | 预选部门 id必选，name可选
selectedDepartments: [{name: '', id: ''}, ...],//预选部门 id必选，name可选
-->

#####　返回说明

参数 | 说明
------|------
users | 选取的用户
users.name | 姓名
users.avatar | 头像图片url，可能为空
users.emplId | userid,[<font color=red>获取成员详情接口</font>](#获取部门成员（详情）)
department | 选取的部门
department.id | 部门id
department.name | 部门名称

<!-- ### 选取

默认展示当前  业通讯录，开发中

```javascript
dd.biz.contact.choose({
    multiple: true, //是否多选： true多选 false单选； 默认true
    users: ['100','101'], //默认选中的用户列表，userid；成功回调中应包含该信息
    corpId: '', //企业id
    max: 50, //人数限制，当multiple为true才生效，可选范围1-1500
    onSuccess : function(result) {
        /*
        [{
            emplId: '0573', //userid
            name: '张三', //姓名
            nickNameCn: '三张', //花名
            mobilePhone: '****', //手机号 后续不再返回该字段
            emailAddr: '***', //邮箱  后期不再返回该字段
            pinyin: 'zhangsan', //姓名拼音
            avatar: 'htp://g.alicdn.com/avatar/zhangsan.png' //头像图片url，可能为空
        }]
        */
    },
    onFail : function(err) {}
});
```

##### 参数说明

参数 | 参数类型 | 说明
----- | ----- | -----
multiple | Boolean | 是否多选： true多选 false单选； 默认true
users | Array[String] | 默认选中的用户列表，工号；成功回调中应包含该信息
corpId | String |  企业id
max | Number| Number为正整数。人数限制，当multiple为true才生效，可选范围1-1500


#####　返回说明

参数 | 说明
------|------
emplID | 是否多选： true多选 false单选； 默认true
name | 姓名
nickNameCn | 花名
mobilePhone | 手机号，后续不再返回该字段
emailAddr | 邮箱，后期不再返回该字段
pinyin | 姓名拼音
avatar | 头像图片url，可能为空 -->

### 创建企业群聊天

0.0.4

corpid必须是用户所属的企业的corpid

```javascript
dd.biz.contact.createGroup({
    corpId: '', //企业id，可选，配置该参数即在指定企业创建群聊天
    users: ['100','101'], //默认选中的用户工号列表，可选；使用此参数必须指定corpId
    onSuccess: function(result) {
        /*{
            id: 123   //企业群id
        }*/
    },
    onFail: function(err) {
    }
});
```

##### 参数说明

参数 | 参数类型 | 说明
----- | ----- | -----
corpId | String |  企业id，可选，配置该参数即在指定企业创建群聊天
users | Array[String] |  默认选中的用户列表，可选；使用此参数必须指定corpId

#####　返回说明

参数 | 说明
------|------
id | 企业群id

<!--### 添加好友

```javascript
dd.biz.contact.addFriend({
    onSuccess: function(result) {
        /*{
            id: 123   //企业群id
        }*/
    },
    onFail: function(err) {
    }
})
```
-->

<!--## 用户

### 获取当前用户信息

目前只开放emplId字段

```javascript
dd.biz.user.get({
    onSuccess : function(result) {
        /*
        {
            id: '112', //id
            emplId: '0573' //工号
        }
        */
    },
    onFail : function(err) {}
});
```
-->
## 自定义联系人

dd.biz

### 单选自定义联系人

选取单个自定义联系人

```javascript
dd.biz.customContact.choose({
    title: '选人的标题', //标题
    users: ['10001', '10002', ...],//一组员工工号
    corpId: 'dingb4ff1079f84f8d54',//加密的企业 ID，
    isShowCompanyName: true,   //true|false，默认为 false
    onSuccess: function(data) {
    /* data结构
      [{
        "name": "张三", //姓名
        "avatar": "http://g.alicdn.com/avatar/zhangsan.png" //头像图片url，可能为空
        "emplId": '0573', //工号
       },
       ...
      ]
    */
    },
    onFail : function(err) {}
});
```

##### 参数说明

参数 | 参数类型 | 说明
----- | ----- | -----
corpId | String | 企业ID
users | Array[String] | 一组员工工号
isShowCompanyName | Boolean | 是否显示公司名称
title | String | 标题

#####　返回说明

参数 | 说明
------|------
name | 姓名
avatar | 头像图片url，可能为空
emplId | 工号


### 多选自定义联系人

选取多个自定义联系人

```javascript
dd.biz.customContact.multipleChoose({
    title: '多选人的标题', //标题
    users: ['10001', '10002', ...],//一组员工工号
    corpId: 'dingb4ff1079f84f8d54',//企业 ID，
    isShowCompanyName: false,   //true|false，默认为 false
    selectedUsers: ["18658"], //默认选中的人
    disabledUsers: ["78308"], //不能选的人
    max: 10, //人数限制
    onSuccess: function(data) {
    /* data结构
      [{
        "name": "张三", //姓名
        "avatar": "http://g.alicdn.com/avatar/zhangsan.png" //头像图片url，可能为空
        "emplId": '0573', //工号
       },
       ...
      ]
    */
    },
    onFail : function(err) {}
});
```

##### 参数说明

参数 | 参数类型 | 说明
----- | ----- | -----
corpId | String | 企业ID
users | Array[String] | 是否多选： true多选，false单选； 默认true
isShowCompanyName | Boolean | 默认选中的用户列表，工号；成功回调中应包含该信息
title | String | 选择窗口的标题
selectedUsers | Array[String] | 默认选中的人
disabledUsers | Array[String] | 不能选的人
max | Number | 人数限制


#####　返回说明

参数 | 说明
------|------
name | 姓名
avatar | 头像图片url，可能为空
emplId | 工号




## 导航栏

**想要对导航栏更加个性化的定义，比如设置导航栏左侧按钮，右侧按钮，标题，可以查看**

<a href="http://ddtalk.github.io/blog/2015/12/29/navbar/" target="_blank"><font color = red >
钉钉微应用定制化导航栏</font></a>

## 分享到会话

该功能是钉钉团队为开发者提供，帮助移动应用通过用户社交快速传播的功能。

“分享到会话”功能为客户端调用功能，请将对应SDK集成至开发者移动端应用中。

### 场景介绍

用户使用开发者制作的移动应用时，可以将自己喜欢的内容，通过该功能快速地转发给自己在钉钉内的好友。好友点击打开内容链接，
将通过钉钉内置浏览器打开网页的形式进行呈现。在传播内容的同时，也会同时露出应用的名称与logo，起到品牌传播的效果。

### 应用范例

#### 支付宝

从支付宝发送红包可以分享给钉钉同事，用户分享后，钉钉好友可以通过这个分享直接打开支付宝抢红包。

### 渠道显示说明

1、当用户手机安装钉钉2.7及以上版本，正常分享；

2、当用户手机没有安装钉钉，点击分享渠道可以弹出提示，也可以引导用户下载钉钉。IOS引导至appstore，安卓引导至：http://www.dingtalk.com/index-b.html

3、当用户手机安装钉钉版本低于2.7，点击分享渠道出提示升级钉钉。

### 分享sdk接入前准备

分享到钉钉好友的所有接口功能，均需要使用在开放平台上创建的应用进行调用。目前仅支持阿里内部渠道的线下接入。线上的应用创建流程还在开发中。请随时关注文档更新。

### 接入流程

#### Android接入流程

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

#### iOS接入流程

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

### Demo下载

[<font color=blue >Android Demo 下载</font>](http://download.taobaocdn.com/freedom/31112/compress/p1a71dcqcqen6g7e2joobd1bdm4.zip)

[<font color=blue >iOS Demo 下载</font>](http://download.taobaocdn.com/freedom/31112/compress/DTShareKit.zip)

## 附录

### JS-API权限签名算法

如果开发者想使用钉钉容器开放的jsapi接口，需要经过以下流程：

- 首先需要[<font color=red >获取jsapi_ticket</font>](#获取jsapi_ticket)。

- 然后在web页面加载到钉钉容器时，通过[<font color=red >jsapi权限验证配置接口</font>](#页面引入js文件)验证可用的jsapi。这个接口使用的参数signature，在下文中有详细的说明。

#### 1.获取jsapi_ticket
jsapi_ticket,是开发者调用钉钉JS接口的临时授权码，其作用主要用于生成签名，这个签名在[<font color=red >jsapi权限验证配置接口</font>](http://open.dingtalk.com/#页面引入js文件)中使用。

正常的情况下，jsapi_ticket的有效期为7200秒，通过access_token（注意，假如您是ISV开发者，这个access_token需要[<font color=red >企业授权的access_token接口</font>](#8-获取企业授权的access_token)）来获取。由于频繁刷新jsapi_ticket会导致api调用受限，影响自身业务，开发者必须在自己的服务全局缓存jsapi_ticket。
获取jsapi_ticket，具体可以[<font color=red >参考文档</font>](#js接口api)
#### 2.签名生成算法
开发者在web页面使用钉钉容器提供的jsapi时，需要验证调用权限，并以参数signature标识合法性

签名生成的规则：

List keyArray = sort(noncestr,timestamp,jsapi_ticket,url);

String str = assemble(keyArray);

signature = sha1(str);

参与签名的字段包括在上文中获取的jsapi_ticket，noncestr（随机字符串，自己随便填写即可）,timestamp（当前时间戳，具体值为当前时间到1970年1月1号的秒数）,url（当前网页的URL，不包含#及其后面部分）。例如：

- noncestr=Zn4zmLFKD0wzilzM
- jsapi_ticket=mS5k98fdkdgDKxkXGEs8LORVREiweeWETE40P37wkidkfksDSKDJFD5h9nbSlYy3-Sl-HhTdfl2fzFy1AOcKIDU8l
- timestamp=1414588745
- url=http://open.dingtalk.com

步骤1. sort()含义为对所有待签名参数按照字段名的ASCII 码从小到大排序（字典序）

步骤2. assemble()含义为根据步骤1中获的参数字段的顺序，使用URL键值对的格式（即key1=value1&key2=value2…）拼接成字符串

步骤2. sha1()的含义为对在步骤2拼接好的字符串进行sha1加密。

### 图片缩放

通过JS-API获取的图片都支持缩放，比如图片：

`http://gtms02.alicdn.com/tps/i2/TB1SlYwGFXXXXXrXVXX9vKJ2XXX-2880-1560.jpg`

可通过文件名拼接的方法缩放为最大宽高为250x250的尺寸。

`http://gtms02.alicdn.com/tps/i2/TB1SlYwGFXXXXXrXVXX9vKJ2XXX-2880-1560.jpg_250x250.jpg`

拼接规则为:文件名+拼接规则；推荐使用以下拼接规则：



80x80 => _80x80.jpg

120x120 => _120x120.jpg

250x250 => _250x250.jpg

310x310 => _310x310.jpg

### 容器能力

[device.notification.alert](#alert)

[device.notification.confirm](#confirm)

[device.notification.prompt](#prompt)

[device.notification.vibrate](#vibrate)

[device.accelerometer.watchShake](#摇一摇)

[device.accelerometer.clearShake](#摇一摇)

[biz.util.open](#打开应用内页面)

[biz.util.share](#分享)

[biz.util.ut](#ut打点)

[biz.util.datepicker](#日期选择器) //android

[biz.util.timepicker](#日期选择器) //android

[biz.contact.choose](#选人)

<!--
[biz.user.get](#get)
-->

[biz.navigation.setLeft](#设置左侧导航按钮)

[biz.navigation.setRight](#设置右侧导航按钮)

[biz.navigation.setTitle](#设置标题)



// v0.0.1

[device.notification.toast](#toast)

[device.notification.showPreloader](#showpreloader)

[device.notification.hidePreloader](#hidepreloader)

[device.geolocation.get](#获取当前地理位置)

[biz.util.uploadImage](#上传图片)

[biz.util.previewImage](#图片浏览器)

//v0.0.2

[ui.input.plain](#输入框)

[device.notification.actionSheet](#actionsheet)

[device.connection.getNetworkType](#获取当前网络类型)

[runtime.info](#获取容器信息)

//v0.0.3

[biz.ding.post](#发钉)

[biz.telephone.call](#打电话)

//v0.0.4

[biz.contact.createGroup](#创建企业群聊天)

[biz.util.datetimepicker](#日期选择器)

//v0.0.5

[biz.util.chosen](#下拉控件)

[device.base.getUUID](#获取通用唯一识别码)

[device.base.getInterface](#获取热点接入信息)

[device.launcher.checkInstalledApps](#检测应用是否安装)

[device.launcher.launchApp](#启动第三方应用)

[ui.progressBar.setColors](#设置顶部进度条颜色)

[runtime.permission.requestAuthCode](#获取免登授权码)

[ui.pullToRefresh.enable](#启用下拉刷新)

[ui.pullToRefresh.stop](#收起下拉loading)

[ui.pullToRefresh.disable](#禁用下拉刷新)

[ui.webViewBounce.enable](#启用bounce)

[ui.webViewBounce.disable](#启用bounce)

[biz.navigation.close](#触发关闭)

//0.0.6

[biz.util.scan](#扫码)

[biz.contact.complexChoose](#选人，选部门)

//0.0.7

[biz.chat.pickConversation](#获取会话信息)

//0.0.8

[device.notification.modal](#modal)

[biz.util.uploadImageFromCamera](#上传图片（仅支持拍照上传）)

//0.0.11

[biz.chat.chooseConversationByCorpId](#根据corpid选择会话)

[biz.chat.toConversation](#根据chatid跳转到对应会话)



