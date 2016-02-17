# PC端开发文档

微应用是 钉钉 为连接企业办公打造的办公入口，通过微应用你可以将企业的业务审批，内部系统，生成，协作，管理，上下游沟通连接到钉钉，更简单和低成本实现企业协同；

结合钉钉的基础通信能力，让企业应用更活跃，员工更高效。

钉钉的 PC 端开发文档将为开发者提供调用钉钉基础控件的能力，通过与客户端微应用结合，给用户带来多端的体验。



## Demo 和调试工具

我们提供了Demo和调试工具给您的开发提供方便，如果对调用参数有疑问，请使用调试工具。

<!-- 对jsapi用法有疑问，可查看Demo. -->

调试工具: 点击 [https://t.dingtalk.com/invite/index?code=5b2a85509e&inviterUid=80E166E782C43269](https://t.dingtalk.com/invite/index?code=5b2a85509e&inviterUid=80E166E782C43269)申请加入该组织，获得同意后，在 PC 端点击 [工作] - [钉钉API测试]。

<!-- github:`待补充` -->

通过Ctrl+Shift+I可以唤出钉钉PC/Mac客户端的浏览器页面调试窗口，开发者可以通过这个工具调试微应用页面。注意：在使用快捷键时需要把光标移除输入框。

## 配置展示形式

### 企业接入

通过访问管理后台[https://oa.dingtalk.com](https://oa.dingtalk.com)，点击[微应用]-[新增微应用]，输入 PC 端地址，重新登录即可出现。

### ISV接入



参考[创建微应用](http://open.dingtalk.com/doc/index.html?spm=a3140.7785475.0.0.07BTXr#3-创建微应用)，配置 pc 端地址即可。

### 企业会话支持 PC 端打开

参考[发送企业会话消息](http://open.dingtalk.com/doc/index.html?spm=a3140.7785475.0.0.07BTXr#发送企业会话消息)，消息体中带入 pc_message_url 即可实现在 PC 端的打开。



## 应用设计

<!--

#### 样式库

钉钉不限制第三方微应用的表现形式，但是需要引入钉钉的默认基础样式，基础样式确保了字体，字体颜色，行间距等基础的样式统一。

引入下列 reset.css:`待补充`

同时，钉钉提供了部分通用样式供开发者参考，包含了头像，按钮，icon等资源。 `待补充`

同时，钉钉要求开发者在设计微应用的时候，基于 `retina` 进行开发； -->



#### 响应式

因为钉钉的 PC 端的宽度是可变的，所以微应用的页面都要求进行响应式设计。

##### 基础尺寸 - 企业会话详情

![](https://static.dingtalk.com/media/lALOArO7PM0CWs0DhA_900_602.png)

企业会话详情目前是定宽设计（360px），但不排除未来该宽度可以调整，所以需要开发者将此页面进行响应式设计。

##### 基础尺寸 - 微应用首页

![](https://static.dingtalk.com/media/lALOArO6j80CWs0DhA_900_602.png)

微应用首页默认宽度是585px，支持用户拖拽更改宽高，所以需要开发者将此页面进行响应式设计。



## 通用

### 页面引入js文件

js文件版本在添加升级功能时地址会变化，如有需要（比如要使用新增的js-api）,请随时关注地址变更。但是旧版本js文件也将一直可用。

`http://g.alicdn.com/dingding/dingtalk-pc-api/2.3.1/index.js`



### 全局变量、命名空间

直接引入index.js会得到一个全局变量`DingTalkPC `，支持amd、cmd引入方式

全局变量DingTalkPC，命名空间：设备(DingTalkPC.device)、业务(DingTalkPC.biz)

### 权限验证配置(beta)

钉钉JS API安全验证，只有经过安全验证的微应用才能调用安全级别较高的API。

获取JS-API权限验证使用的签名的方法请参考附录-[<font color=red >JS-API权限签名算法</font>](#js-api权限签名算法)

[<font color=red >jsapi权限验证配置demo--node.js版本</font>](https://github.com/injekt/jsapi-demo)

[<font color=red >jsapi权限验证配置demo--java版本</font>](https://github.com/injekt/openapi-demo-java)

[<font color=red >jsapi权限验证配置demo--php版本</font>](https://github.com/injekt/openapi-demo-php)



``` javascript
 DingTalkPC.config({
    agentId: '', // 必填，微应用ID
    corpId: '',//必填，企业ID
    timeStamp: , // 必填，生成签名的时间戳
    nonceStr: '', // 必填，生成签名的随机串
    signature: '', // 必填，签名
    jsApiList: ['device.notification.alert', 'device.notification.confirm'] // 必填，需要使用的jsapi列表
});
```

##### 参数说明

| 参数        | 参数类型   | 必须   | 说明           |
| --------- | ------ | ---- | ------------ |
| agentId   | String | 是    | 微应用ID        |
| corpId    | String | 是    | 企业ID         |
| timeStamp | String | 是    | 生成签名的时间戳     |
| nonceStr  | String | 是    | 生成签名的随机串     |
| signature | String | 是    | 签名           |
| jsApiList | Array  | 是    | 需要调用的jsapi列表 |

### 通过ready接口处理成功验证

DingTalkPC.ready参数为回调函数，在环境准备就绪时触发，jsapi的调用需要保证在该回调函数触发后调用，否则无效。

``` javascript
DingTalkPC.ready(function(res){
  /*{
      authorizedAPIList: ['device.notification.alert'], //已授权API列表
      unauthorizedAPIList: [''], //未授权API列表
  }*/
  //接口操作应该在ready后才可调用
});
```

### 通过error接口处理失败验证

config信息验证失败会执行error函数，错误信息可以在返回的error参数中参看

``` javascript
DingTalkPC.error(function(error){
  /*{
      errorCode: 1001, //错误码
      errorMessage: '', //错误信息
  }*/
});
```

### 接口约定

* 所有接口都为异步
* 接受一个object类型的参数
* 成功回调 onSuccess
* 失败回调 onFail

``` javascript
DingTalkPC.命名空间.功能.方法({
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



### PC版获取免登授权码



``` javascript
DingTalkPC.runtime.permission.requestAuthCode({
    corpId: "", //企业ID
    onSuccess: function(result) {
    /*{
        code: 'hYLK98jkf0m' //string authCode
    }*/
    },
    onFail : function(err) {}

})
```

##### 参数说明

| 参数     | 参数类型   | 必须   | 说明   |
| ------ | ------ | ---- | ---- |
| corpId | String | 是    | 企业ID |

##### 返回说明

| 参数   | 说明   |
| ---- | ---- |
| code | 授权码  |

## 弹窗

DingTalkPC.device

### alert

``` javascript
DingTalkPC.device.notification.alert({
    message: "亲爱的",
    title: "提示",//可传空
    buttonName: "收到",
    onSuccess : function() {
        /*回调*/
    },
    onFail : function(err) {}
});
```

<img src="http://gtms04.alicdn.com/tps/i4/TB1mXnaKFXXXXbvXVXXV8PWOVXX-1792-1200.png" width = "350" height = "" alt="图片名称" align=right />

##### 参数说明

| 参数         | 参数类型   | 说明   |
| ---------- | ------ | ---- |
| message    | String | 消息内容 |
| title      | String | 弹窗标题 |
| buttonName | String | 按钮名称 |

### confirm



``` javascript
DingTalkPC.device.notification.confirm({
    message: "你爱我吗",
    title: "提示",
    buttonLabels: ['爱', '不爱'],
    onSuccess : function(result) {
        /*
        {
            buttonIndex: 0 //被点击按钮的索引值，Number类型，从0开始
        }
        */
    },
    onFail : function(err) {}
});
```

<img src="http://gtms01.alicdn.com/tps/i1/TB1I4jbKFXXXXbBXVXX._qIYpXX-1794-1198.png" width = "350" height = "" alt="图片名称" align=right />

##### 参数说明

| 参数           | 参数类型          | 说明   |
| ------------ | ------------- | ---- |
| message      | String        | 消息说明 |
| title        | String        | 标题   |
| buttonLabels | Array[String] | 按钮名称 |

##### 返回说明

| 参数          | 说明                      |
| ----------- | ----------------------- |
| buttonIndex | 被点击按钮的索引值，Number类型，从0开始 |

### prompt

``` javascript
DingTalkPC.device.notification.prompt({
    message: "再说一遍？",
    title: "提示",
    buttonLabels: ['继续', '不玩了'],
    onSuccess : function(result) {
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

<img src="http://gtms02.alicdn.com/tps/i2/TB1iwLlKFXXXXbgXFXXFvH2OVXX-1792-1194.png" width = "350" height = "" alt="图片名称" align=right />

##### 参数说明

| 参数           | 参数类型          | 说明   |
| ------------ | ------------- | ---- |
| message      | String        | 消息内容 |
| title        | String        | 标题   |
| buttonLabels | Array[String] | 按钮名称 |

##### 返回说明

| 参数          | 说明                      |
| ----------- | ----------------------- |
| buttonIndex | 被点击按钮的索引值，Number类型，从0开始 |
| value       | 输入的值                    |

### toast

``` javascript
DingTalkPC.device.notification.toast({
    type: "information", //toast的类型 alert, success, error, warning, information, confirm
    text: '这里是个toast', //提示信息
    duration: 3, //显示持续时间，单位秒，最短2秒，最长5秒
    delay: 0, //延迟显示，单位秒，默认0, 最大限制为10
    onSuccess : function(result) {
        /*{}*/
    },
    onFail : function(err) {}
})
```

<img src="http://gtms03.alicdn.com/tps/i3/TB18p6hKFXXXXXBXVXXrQ409pXX-1786-1198.png" width ="350" height = "" alt="图片名称"  align=right />

##### 参数说明

| 参数       | 参数类型   | 说明                                       |
| -------- | ------ | ---------------------------------------- |
| type     | String | toast的类型 alert, success, error, warning, information, confirm，默认information |
| text     | String | 提示信息                                     |
| duration | Number | 显示持续时间，单位秒，最小2，最大限制为5                    |
| delay    | Number | 延迟显示，单位秒，默认0，最大限制为10                     |

### actionsheet

单选列表

``` javascript
DingTalkPC.device.notification.actionSheet({
    title: "谁是最棒哒？", //标题
    cancelButton: '取消', //取消按钮文本
    otherButtons: ["孙悟空","猪八戒","唐僧","沙和尚"],
    onSuccess : function(result) {
        /*{
            buttonIndex: 0 //被点击按钮的索引值，Number，从0开始, 取消按钮为-1
        }*/
    },
    onFail : function(err) {}
})
```

<img src="http://gtms04.alicdn.com/tps/i4/TB1mSvwKFXXXXX7XFXXpXX.QFXX-1886-1278.png" width = "350" height = "" alt="图片名称" align=right />

##### 参数说明

| 参数           | 参数类型          | 说明     |
| ------------ | ------------- | ------ |
| title        | String        | 标题     |
| cancelButton | String        | 取消按钮文本 |
| otherButtons | Array[String] | 其他按钮列表 |

##### 返回说明

| 参数          | 说明                             |
| ----------- | ------------------------------ |
| buttonIndex | 被点击按钮的索引值，Number，从0开始, 取消按钮为-1 |

## 业务

DingTalkPC.biz



### 打开应用内页面

``` javascript
DingTalkPC.biz.util.open({
    name:'profile',//页面名称
    params:{
        id: '123456',// String 必选 用户工号
        corpId:'dingb4ff1079f84f8d54' //String 必选 企业id
    },//传参
    onSuccess : function() {
        /**/
    },
    onFail : function(err) {}
});
```

| 参数     | 参数类型       | 说明   |
| ------ | ---------- | ---- |
| name   | String     | 页面名称 |
| params | JSONObject | 传参   |

目前支持以下页面，具体参数看右边

1. 个人资料页

传参例子(右旁代码区)以及参数说明

``` 
{
    "name": "profile",
    "params":{
        "id": "123456",
        "corpId":"dingb4ff1079f84f8d54"
    },
    "onSuccess":function() {

    },
    "onFail":function(err) {}
}

```

| 参数            | 参数类型   | 必须   | 说明            |
| ------------- | ------ | ---- | ------------- |
| name          | String | 是    | 固定为 "profile" |
| params.id     | String | 是    | 用户工号          |
| params.corpId | String | 是    | 企业ID          |

<!--

b.聊天页面

``` javascript
// 页面名称：
    chat
// 传参：
    users: ['123'] 用户列表,工号
    corpId: '' //企业id
```

c.免费电话页面

``` javascript
// 页面名称：
    call
// 传参：
```

d.联系人添加页面

``` javascript
// 页面名称：
    contactAdd
// 传参：
```

f.唤起添加好友页面



``` 
// 页面名称：
    friendAdd
// 传参：
​``` -->

### 打开模态框（modal）

打开一个模态框

​```javascript
DingTalkPC.biz.util.openModal({
    size:'middle',  // modal的尺寸
    url: 'https://test.dingtalk.com/modal.html', //打开modal的内容的url
    title: 'modal title', //顶部标题
    onSuccess : function(result) {
        /*

        */
    },
    onFail : function() {}
})
```

<img src="http://gtms02.alicdn.com/tps/i2/TB1PqPwKFXXXXa8XFXXsaR5YpXX-1880-1276.png" width = "350" height = "" alt="图片名称" align=right />

##### 参数说明

| 参数    | 参数类型   | 说明                  |
| ----- | ------ | ------------------- |
| size  | String | 模态框的尺寸大小 三种选择 具体看下表 |
| url   | String | 模态框内部显示内容的url       |
| title | String | 模态框标题               |

##### 尺寸选择详情：

| 名称       | size输入   | 尺寸长宽               |
| -------- | -------- | ------------------ |
| （默认）大模态框 |          | 包括标题 676px * 545px |
| 中模态框     | "middle" | 包括标题 440px * 300px |
| 小模态框     | "mini"   | 包括标题 366px * 120px |

### 打开侧边面板（SlidePanel）

打开侧边面板

``` javascript
DingTalkPC.biz.util.openSlidePanel({
    url: 'about:blank', //打开侧边栏的url
    title: 'title', //侧边栏顶部标题
    onSuccess : function(result) {
        /*
        */
    },
    onFail : function() {}
})
```

<img src="http://gtms02.alicdn.com/tps/i2/TB1mzDBKFXXXXcTXpXXhMAQZVXX-1888-1278.png" width = "350" height = "" alt="图片名称" align=right />

##### 参数说明

| 参数    | 参数类型   | 说明             |
| ----- | ------ | -------------- |
| title | String | 侧边面板顶部显示标题     |
| url   | String | 侧边面板内部显示内容的url |

### 上传图片

选择图片+上传，防止恶意上传

``` javascript
DingTalkPC.biz.util.uploadImage({
    multiple: false, //是否多选，默认false
    max: 3, //最多可选个数
    onSuccess : function(result) {
        /*
        [
          'https://static.dingtalk.com/media/lADOA9bQH8zIzMg_200_200.jpg'
        ]
        */
    },
    onFail : function() {}
})
```

##### 参数说明

| 参数       | 参数类型    | 说明                |
| -------- | ------- | ----------------- |
| multiple | Boolean | 是否多选，默认false      |
| max      | Number  | Number为正整数，最多可选个数 |

### 下载文件

下载一个文件

``` javascript
DingTalkPC.biz.util.downloadFile({
    url: '//static.dingtalk.com/media/lADOADTWJM0C2M0C7A_748_728.jpg_60x60q90.jpg', //要下载的文件的url
    name: '一个图片.jpg', //定义下载文件名字
    onProgress: function(msg){
      // 文件下载进度回调
    },
    onSuccess : function(result) {
        /*
          true
        */
    },
    onFail : function() {}
})
```

<img src="http://gtms02.alicdn.com/tps/i2/TB1TfjCKFXXXXXwXFXXDZsQZVXX-1888-1280.png" width = "350" height = "" alt="图片名称" align=right />

##### 参数说明

| 参数         | 参数类型     | 说明                           |
| ---------- | -------- | ---------------------------- |
| url        | String   | 要下载文件的url                    |
| name       | String   | 定义下载文件的名字，记得添加文件扩展名，默认无文件扩展名 |
| onProgress | Function | 文件下载进度回调                     |

### 打开本地文件

打开本地文件接口

``` javascript
DingTalkPC.biz.util.openLocalFile({
    url: '', //本地文件的url
    onSuccess : function(result) {
        /*
          true
        */
    },
    onFail : function() {}
})
```

##### 参数说明

| 参数   | 参数类型   | 说明           |
| ---- | ------ | ------------ |
| url  | String | url是缓存文件的key |

### 批量检测本地文件是否存在

批量检测本地文件是否存在

``` javascript
DingTalkPC.biz.util.isLocalFileExist({
    params: [{
        url: '', //本地文件的url
      },{
        url: ''
      }
    ],
    onSuccess : function(result) {
        /*
          [{
              url: '', //本地文件的url
              path: '', // 文件的path
              isExist: true //根据你输入的文件的url检测出的结果，true:存在，false：不存在
          }]
        */
    },
    onFail : function() {}
})
```

##### 参数说明

| 参数   | 参数类型   | 说明           |
| ---- | ------ | ------------ |
| url  | String | url是缓存文件的key |

### 预览图片

``` javascript
DingTalkPC.biz.util.previewImage({
    urls: ['//static.dingtalk.com/media/1.jpg', '//static.dingtalk.com/media/2.jpg'],//图片地址列表
    current: '//static.dingtalk.com/media/1.jpg',//当前显示的图片链接
    onSuccess : function(result) {
        /**/
    },
    onFail : function() {}
})
```

<img src="http://gtms02.alicdn.com/tps/i2/TB1SaYsKFXXXXaIXVXXkOgK6FXX-1882-1276.png" width = "350" height = "" alt="图片名称" align=right />

##### 参数说明

| 参数      | 参数类型          | 说明        |
| ------- | ------------- | --------- |
| urls    | Array[String] | 图片地址列表    |
| current | String        | 当前显示的图片链接 |

### 在浏览器上打开链接

``` javascript
DingTalkPC.biz.util.openLink({
    url: "http://www.dingtalk.com",//要打开链接的地址
    onSuccess : function(result) {
        /**/
    },
    onFail : function() {}
})
```

| 参数   | 参数类型   | 说明       |
| ---- | ------ | -------- |
| url  | String | 要打开链接的地址 |

## 导航

DingTalkPC.biz

### 触发关闭

注意：只在SlidePanel和Modal里起作用

``` javascript
DingTalkPC.biz.navigation.quit({
    message: "quit message",//退出信息，传递给openModal或者openSlidePanel的onSuccess函数的result参数
    onSuccess : function(result) {
        /**/
    },
    onFail : function() {}
})
```

| 参数      | 参数类型   | 说明                                       |
| ------- | ------ | ---------------------------------------- |
| message | String | 退出信息，传递给openModal或者openSlidePanel的onSuccess函数的result参数 |

### 设置标题

注意：只在SlidePanel和Modal里起作用

``` javascript
DingTalkPC.biz.navigation.setTitle({
    title: "lalala",//标题
    onSuccess : function(result) {
        /**/
    },
    onFail : function() {}
})
```

| 参数    | 参数类型   | 说明   |
| ----- | ------ | ---- |
| title | String | 标题   |

### 设置左侧导航按钮

注意：只在SlidePanel里起作用

``` javascript
DingTalkPC.biz.navigation.setLeft({
    text: "lalala",//显示文字信息
    onSuccess : function(result) {
        /**/
    },
    onFail : function() {}
})
```

| 参数   | 参数类型   | 说明     |
| ---- | ------ | ------ |
| text | String | 显示文字信息 |

#### 设置左侧按钮点击后的回调

DingTalkPC.addEventListener('leftBtnClick', handleFn);

``` javascript
//添加监听回调函数
DingTalkPC.addEventListener('leftBtnClick', handleFn);

//移除相应handleFn的监听回调函数
DingTalkPC.removeEventListener('leftBtnClick', handleFn);

```



## Ding

DingTalkPC.biz

### 发钉

#### 图片类型



``` javascript
DingTalkPC.biz.ding.post({
    users : ['100', '101'],//用户列表，工号
    corpId: 'dingb4ff1079f84f8d54', //加密的企业id
    type: 1, //钉类型 1：image  2：link
    alertType: 2,
    alertDate: {"format":"yyyy-MM-dd HH:mm","value":"2015-05-09 08:00"},
    attachment: {
        images: [''], //只取第一个image
    }, //附件信息
    text: '', //消息体
    onSuccess : function() {},
    onFail : function() {}
})
```

##### 参数说明

| 参数         | 参数类型          | 说明                           |
| ---------- | ------------- | ---------------------------- |
| users      | Array[String] | 用户列表，工号                      |
| corpId     | String        | 企业id                         |
| type       | Number        | Number为整数。钉类型 1：image，2：link |
| alertType  | Number        | 钉提醒类型 0：电话, 1：短信, 2：应用内      |
| alertDate  | Object        | 钉提醒时间                        |
| attachment | Object        | 附件信息                         |
| text       | String        | 消息体                          |

#### Link类型



``` javascript
DingTalkPC.biz.ding.post({
    users : ['100', '101'],//用户列表，工号
    corpId: 'dingb4ff1079f84f8d54', //企业id
    type: 2, //钉类型 1：image  2：link
    alertType: 2,
    alertDate: {"format":"yyyy-MM-dd HH:mm","value":"2015-05-09 08:00"},
    attachment: {
        title: '', //附件的标题
        url: '', //附件点击后跳转url
        image: '', //附件显示时的图片 【可选】
        text: '' //附件显示时的消息体 【可选】
    }
    text: '', //消息体
    onSuccess : function() {},
    onFail : function() {}
})
```

##### 参数说明

| 参数         | 参数类型          | 说明                            |
| ---------- | ------------- | ----------------------------- |
| users      | Array[String] | 用户列表，工号                       |
| corpId     | String        | 企业id                          |
| type       | Number        | Number为整数。钉类型 1：image  2：link |
| alertType  | Number        | 钉提醒类型 0：电话, 1：短信, 2：应用内       |
| alertDate  | Object        | 钉提醒时间                         |
| attachment | Object        | 附件信息                          |
| text       | String        | 消息体                           |

## 企业通讯录

DingTalkPC.biz

### 选人

此接口只能对用户进行选择，若要同时选择部门，请使用“选人，选部门”接口。

``` javascript
DingTalkPC.biz.contact.choose({
    multiple: true, //是否多选： true多选 false单选； 默认true
    users: ['10001', '10002', ...], //默认选中的用户列表，工号；成功回调中应包含该信息
    corpId: 'dingb4ff1079f84f8d54', //企业id
    max: 10, //人数限制，当multiple为true才生效，可选范围1-1500
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

| 参数       | 参数类型          | 说明                                |
| -------- | ------------- | --------------------------------- |
| multiple | Boolean       | 是否多选： true多选，false单选； 默认true      |
| users    | Array[String] | 默认选中的用户列表，工号；成功回调中应包含该信息          |
| corpId   | String        | 企业id                              |
| max      | Number        | 人数限制，当multiple为true才生效，可选范围1-1500 |

<!--

startWithDepartmentId: Number, //-1表示从自己所在部门开始, 0表示从企业最上层开始，(其他数字表示从该部门开始:暂时不支持)

startWithDepartmentId | Number | -1表示从自己所在部门开始, 0表示从企业最上层开始，(其他数字表示从该部门开始:暂时不支持)

-->

##### 　返回说明

| 参数     | 说明           |
| ------ | ------------ |
| name   | 姓名           |
| avatar | 头像图片url，可能为空 |
| emplId | 工号           |

## 自定义联系人

DingTalkPC.biz

### 单选自定义联系人

选取单个自定义联系人

``` javascript
DingTalkPC.biz.customContact.choose({
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

| 参数                | 参数类型          | 说明       |
| ----------------- | ------------- | -------- |
| corpId            | String        | 企业ID     |
| users             | Array[String] | 一组员工工号   |
| isShowCompanyName | Boolean       | 是否显示公司名称 |
| title             | String        | 标题       |

##### 　返回说明

| 参数     | 说明           |
| ------ | ------------ |
| name   | 姓名           |
| avatar | 头像图片url，可能为空 |
| emplId | 工号           |

### 多选自定义联系人

选取多个自定义联系人

``` javascript
DingTalkPC.biz.customContact.multipleChoose({
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

| 参数                | 参数类型          | 说明                           |
| ----------------- | ------------- | ---------------------------- |
| corpId            | String        | 企业ID                         |
| users             | Array[String] | 是否多选： true多选，false单选； 默认true |
| isShowCompanyName | Boolean       | 默认选中的用户列表，工号；成功回调中应包含该信息     |
| title             | String        | 选择窗口的标题                      |
| selectedUsers     | Array[String] | 默认选中的人                       |
| disabledUsers     | Array[String] | 不能选的人                        |
| max               | Number        | 人数限制                         |

##### 　返回说明

| 参数     | 说明           |
| ------ | ------------ |
| name   | 姓名           |
| avatar | 头像图片url，可能为空 |
| emplId | 工号           |

<!-- ## 聊天

DingTalkPC.biz

### 选择会话

``` javascript
DingTalkPC.biz.chat.chooseConversation({
    onSuccess: function(data) {
    /* data结构
      {
        "id":"25001:2442003", //会话id
        "title":"钉钉-轻浅-pc专业户" // 会话名称
      }
    */
    },
    onFail : function(err) {}
});
```

#### 参数说明

空



#### 返回说明

| 参数    | 说明       |
| ----- | -------- |
| id    | 会话id     |
| title | 会话名称 --> |

## 附录

### JS-API权限签名算法

如果开发者想使用钉钉容器开放的jsapi接口，需要经过以下流程：

- 首先需要[<font color=red >获取jsapi_ticket</font>](#获取jsapi_ticket)。
- 然后在web页面加载到钉钉容器时，通过[<font color=red >jsapi权限验证配置接口</font>](#页面引入js文件)验证可用的jsapi。这个接口使用的参数signature，在下文中有详细的说明。

#### 1.获取jsapi_ticket

jsapi_ticket,是开发者调用钉钉JS接口的临时授权码，其作用主要用于生成签名，这个签名在[<font color=red >jsapi权限验证配置接口</font>](http://open.dingtalk.com/#页面引入js文件)中使用。

正常的情况下，jsapi_ticket的有效期为7200秒，通过access_token来获取。由于频繁刷新jsapi_ticket会导致api调用受限，影响自身业务，开发者必须在自己的服务全局缓存jsapi_ticket。

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

<!--

### 容器能力

[runtime.permission.requestAuthCode](#获取免登授权码)

[device.notification.alert](#alert)

[device.notification.confirm](#confirm)

[device.notification.prompt](#prompt)

[device.notification.toast](#toast)

[device.notification.actionSheet](#actionSheet)

[biz.util.open](#打开应用内页面)

[biz.util.openModal](#打开模态框（modal）)

[biz.util.openSlidePanel](#打开侧边面板（SlidePanel）)

[biz.util.uploadImage](#上传图片)

[biz.util.downloadFile](#下载文件)

[biz.util.openLocalFile](#打开文件)

[biz.util.isLocalFileExist](#批量检测文件是否存在)

[biz.util.previewImage](#预览图片)

[biz.util.openLink](#在浏览器上打开链接)

[biz.navigation.quit](#触发关闭)

[biz.navigation.setTitle](#设置标题)

[biz.navigation.setLeft](#设置左侧导航按钮)

[biz.ding.post](#发钉)

[biz.contact.choose](#选人)

[biz.customContact.choose](#单选自定义联系人)

[biz.customContact.multipleChoose](#多选自定义联系人) -->