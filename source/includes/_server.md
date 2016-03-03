# 服务端开发文档

欢迎您，钉钉的开发者，我们很期待你成为钉钉开放平台的开发者。

微应用是钉钉为连接企业办公打造的移动入口，通过微应用你可以将企业的业务审批，内部OA，CRM，协作，上下游沟通连接到钉钉，更简单和低成本实现企业移动化； 结合钉钉的基础通信能力，让企业应用更活跃，员工更高效，移动化成本更低。

此文档很适合于:

1. 企业的IT部，了解钉钉如何连接你所在企业的办公；

2. 服务提供商（ISV），了解如何通过钉钉为您的客户提供定制的企业办公软件，提升你的服务价值。

## 建立连接

你可以使用以下两种方式，将钉钉微应用连接到你的企业应用：

1. 企业应用服务器调用钉钉开放平台提供的接口，以钉钉微应用的身份给企业用户的钉钉账号推送消息，以下称 **主动调用模式**。

2. 钉钉用户在使用企业提供的微应用H5页面时，该页面可以调用钉钉提供的JS接口，使用钉钉开放的终端能力和业务能力，以下称 **JSAPI模式**。

3. 钉钉服务器把用户发送的消息或用户触发的事件推送给企业应用，由企业应用处理，以下称 **回调模式**。

### 主动调用

当企业应用服务器调用钉钉开放平台接口时，需使用https协议、Json数据格式、UTF8编码，访问域名为 https://oapi.dingtalk.com。
在每次主动调用钉钉开放平台接口时需要带上AccessToken参数。AccessToken参数由CorpID和CorpSecret换取。对于ISV来说，[<font color=red>获取企业授权的access_token</font>](#5-获取企业授权的access_token)

CorpID是企业在钉钉中的标识，每个企业拥有一个唯一的CorpID；

CorpSecret是企业每个应用的凭证密钥。

CorpID及CorpSecret可以在钉钉为企业提供的管理后台中找到，由钉钉自动分配。

<aside class="notice">
POST请求请在HTTP Header中设置 Content-Type:application/json，否则接口调用失败
</aside>

### 主动调用的频率限制

当你获取到AccessToken时，你的微应用后台就可以成功调用钉钉后台所提供的各种接口或访问相应企业的资源或给成员发消息。

为了防止微应用的程序错误而引发钉钉服务器负载异常，默认情况下，每个服务端调用接口都有一定的频率限制，当超过此限制时，调用对应接口会收到相应错误码。

以下是当前默认的频率限制，钉钉后台可能会根据运营情况调整此阈值：

- 每个企业调用单个接口的频率不可超过1500次/分

- 每个ISV（应用提供商）调用单个接口的频率不可超过2000次/分

- 每个ISV（应用提供商）调用单个企业的单个接口频率不可超过1500次/分

- 每个套件调用单个企业的单个接口频率不可超过1000次/分


#### 获取AccessToken

AccessToken是企业访问钉钉开放平台接口的全局唯一票据，调用接口时需携带AccessToken。

AccessToken需要用CorpID和CorpSecret来换取，不同的CorpSecret会返回不同的AccessToken。正常情况下AccessToken有效期为7200秒，有效期内重复获取返回相同结果，并自动续期。

###### 请求说明

Https请求方式: GET
`https://oapi.dingtalk.com/gettoken?corpid=id&corpsecret=secrect`

###### 参数说明

参数 | 参数类型 | 必须 | 说明
---------- | ------- | ------- | ------
corpid | String | 是 | 企业Id
corpsecret | String | 是 | 企业应用的凭证密钥

###### 返回说明

a)正确的Json返回结果:

```
{
    "errcode": 0,
    "errmsg": "ok",
    "access_token": "fw8ef8we8f76e6f7s8df8s"
}
```

参数 | 说明
---- | -----
errcode | 错误码
errmsg | 错误信息
access_token | 获取到的凭证

b)错误的Json返回示例:

```
{
   "errcode": 43003,
   "errmsg": "require https"
}
```

#### 获取微应用后台管理Token
本接口获取的Token和上面获取的AccessToken应用场景不一样，此token只在[<font color=red>微应用后台管理免登</font>](#oa后台调用管理员免登)服务中使用。
应用场景示例如下图：

![normalcorp](https://img.alicdn.com/tps/TB1iw.4KFXXXXXoXFXXXXXXXXXX-594-302.png)

###### 请求说明

Https请求方式: GET
`https://oapi.dingtalk.com/sso/gettoken?corpid=id&corpsecret=ssosecret`

企业在[<font color=red>OA后台</font>](https://oa.dingtalk.com/#/microApp/microAppSet)获取SSOSecret的方法如下

![normalcorp](https://img.alicdn.com/tps/TB1y_xcKVXXXXa6XXXXXXXXXXXX-1084-621.jpg)

###### 参数说明

参数 | 参数类型 | 必须 | 说明
---------- | ------- | ------- | ------
corpid | String | 是 | 企业Id
corpsecret | String | 是 | 这里必须填写专属的SSOSecret

###### 返回说明

a)正确的Json返回结果:

```
{
    "errcode": 0,
    "errmsg": "ok",
    "access_token": "fw8ef8we8f76e6f7s8df8s"
}
```

参数 | 说明
---- | -----
errcode | 错误码
errmsg | 错误信息
access_token | 获取到的凭证

b)错误的Json返回示例:

```
{
   "errcode": 43003,
   "errmsg": "require https"
}
```


## 管理通讯录

### 获取部门列表

###### 请求说明

Https请求方式: GET

`https://oapi.dingtalk.com/department/list?access_token=ACCESS_TOKEN`

###### 参数说明

参数 | 参数类型 | 必须 | 说明
---------- | ------- | ------- | ------
access_token | String | 是 | 调用接口凭证

###### 返回结果

```
{
    "errcode": 0,
    "errmsg": "ok",
    "department": [
        {
           "id": 2,
            "name": "钉钉事业部",
            "parentid": 1,
            "createDeptGroup": true,
            "autoAddUser": true
        },
        {
            "id": 3,
            "name": "服务端开发组",
            "parentid": 2,
            "createDeptGroup": false,
            "autoAddUser": false
        }
    ]
}
```

参数 | 说明
---- | -----
errcode | 返回码
errmsg | 对返回码的文本描述内容
department | 部门列表数据。以部门的order字段从小到大排列
id | 部门id
name | 部门名称
parentid | 父部门id，根部门为1
createDeptGroup | 是否同步创建一个关联此部门的企业群, true表示是, false表示不是
autoAddUser | 当群已经创建后，是否有新人加入部门会自动加入该群, true表示是, false表示不是


### 获取部门详情

###### 请求说明

Https请求方式: GET

`https://oapi.dingtalk.com/department/get?access_token=ACCESS_TOKEN&id=2`

###### 参数说明

参数 | 参数类型 | 必须 | 说明
---------- | ------- | ------- | ------
access_token | String | 是 | 调用接口凭证
id | String | 是 | 部门id

###### 返回结果

```
{
    "errcode": 0,
    "errmsg": "ok",
    "id": 2,
    "name": "钉钉事业部",
    "order" : 10,
    "parentid": 1,
    "createDeptGroup": true,
    "autoAddUser": true,
    "deptHiding" : true,
    "deptPerimits" : "3|4",
    "userPerimits" : "userid1|userid2",
    "outerDept" : true,
    "outerPermitDepts" : "1|2",
    "outerPermitUsers" : "userid3|userid4",
    "orgDeptOwner" : "manager1122",
    "deptManagerUseridList" : "manager1122|manager3211"
}
```

参数 | 说明
---- | -----
errcode | 返回码
errmsg | 对返回码的文本描述内容
id | 部门id
name | 部门名称
parentid | 父部门id，根部门为1
order | 在父部门中的次序值
createDeptGroup | 是否同步创建一个关联此部门的企业群, true表示是, false表示不是
autoAddUser | 当群已经创建后，是否有新人加入部门会自动加入该群, true表示是, false表示不是
deptHiding | 是否隐藏部门, true表示隐藏, false表示显示
deptPerimits | 可以查看指定隐藏部门的其他部门列表，如果部门隐藏，则此值生效，取值为其他的部门id组成的的字符串，使用' &#124; '符号进行分割
userPerimits | 可以查看指定隐藏部门的其他人员列表，如果部门隐藏，则此值生效，取值为其他的人员userid组成的的字符串，使用' &#124; '符号进行分割
outerDept | 是否本部门的员工仅可见员工自己, 为true时，本部门员工默认只能看到员工自己
outerPermitDepts | 本部门的员工仅可见员工自己为true时，可以配置额外可见部门，值为部门id组成的的字符串，使用' &#124; '符号进行分割
outerPermitUsers | 本部门的员工仅可见员工自己为true时，可以配置额外可见人员，值为userid组成的的字符串，使用' &#124; '符号进行分割
orgDeptOwner | 企业群群主
deptManagerUseridList | 部门的主管列表,取值为由主管的userid组成的字符串，不同的userid使用' &#124; '符号进行分割


### 创建部门

###### 请求说明

Https请求方式: POST

`https://oapi.dingtalk.com/department/create?access_token=ACCESS_TOKEN`

###### 请求包结构体

```
{
    "name": "钉钉事业部",
    "parentid": "1",
    "order": "1",
    "createDeptGroup": true
}
```

###### 参数说明

参数 | 参数类型 | 必须 | 说明
----------| ------- | ------- | ------
access_token | String | 是 | 调用接口凭证
name | String | 是 |  部门名称。长度限制为1~64个字符
parentid | String | 是 | 父部门id。根部门id为1
order  | String | 否 | 在父部门中的次序值。order值小的排序靠前
createDeptGroup | Boolean | 否 | 是否创建一个关联此部门的企业群，默认为false

###### 返回结果

```
{
    "errcode": 0,
    "errmsg": "created",
    "id": 2
}
```

参数 | 说明
----------  | ------
errcode | 返回码
errmsg | 对返回码的文本描述内容
id | 创建的部门id


### 更新部门

###### 请求说明

Https请求方式: POST

`https://oapi.dingtalk.com/department/update?access_token=ACCESS_TOKEN`

###### 请求包结构体

```
{
    "name": "钉钉事业部",
    "parentid": "1",
    "order": "1",
    "id": "1",
    "createDeptGroup": true,
    "autoAddUser": true,
    "deptManagerUseridList": "manager1111|2222",
    "deptHiding" : true,
    "deptPerimits" : "3|4",
    "userPerimits" : "userid1|userid2",
    "outerDept" : true,
    "outerPermitDepts" : "1|2",
    "outerPermitUsers" : "userid3|userid4",
    "orgDeptOwner": "manager1111"
}
```

###### 参数说明

参数 | 参数类型 | 必须 | 说明
----------| -------  | ------- | ------
access_token | string | 是 | 调用接口凭证
name | String | 否 | 部门名称。长度限制为1~64个字符
parentid | String | 否 | 父部门id。根部门id为1
order | String | 否 | 在父部门中的次序值。order值小的排序靠前
id | long | 是 | 部门id
createDeptGroup | Boolean | 否 | 是否创建一个关联此部门的企业群
autoAddUser | Boolean | 否 | 如果有新人加入部门是否会自动加入部门群
deptManagerUseridList | String | 否 | 部门的主管列表,取值为由主管的userid组成的字符串，不同的userid使用' &#124; '符号进行分割
deptHiding | Boolean | 否 | 是否隐藏部门, true表示隐藏, false表示显示
deptPerimits | String | 否 | 可以查看指定隐藏部门的其他部门列表，如果部门隐藏，则此值生效，取值为其他的部门id组成的的字符串，使用' &#124; '符号进行分割
userPerimits | String | 否 | 可以查看指定隐藏部门的其他人员列表，如果部门隐藏，则此值生效，取值为其他的人员userid组成的的字符串，使用' &#124; '符号进行分割
outerDept | Boolean | 否 | 是否本部门的员工仅可见员工自己, 为true时，本部门员工默认只能看到员工自己
outerPermitDepts | String | 否 | 本部门的员工仅可见员工自己为true时，可以配置额外可见部门，值为部门id组成的的字符串，使用' &#124; '符号进行分割
outerPermitUsers | String | 否 | 本部门的员工仅可见员工自己为true时，可以配置额外可见人员，值为userid组成的的字符串，使用' &#124; '符号进行分割
orgDeptOwner | String | 否 | 企业群群主


###### 返回结果

```
{
    "errcode": 0,
    "errmsg": "updated"
}
```

参数 | 说明
---------- | ------
errcode | 返回码
errmsg | 对返回码的文本描述内容

### 删除部门

###### 请求说明

Https请求方式: GET

`https://oapi.dingtalk.com/department/delete?access_token=ACCESS_TOKEN&id=ID`

###### 参数说明

参数 | 参数类型 | 必须 | 说明
----------| -------  | ------- | ------
access_token | String | 是 | 调用接口凭证
id | long | 是 | 部门id。（注：不能删除根部门；不能删除含有子部门、成员的部门）

###### 返回结果

```
{
    "errcode": 0,
    "errmsg": "deleted"
}
```

参数 | 说明
---------- | ------
errcode | 返回码
errmsg | 对返回码的文本描述内容

### 获取成员详情

###### 请求说明

Https请求方式: GET

`https://oapi.dingtalk.com/user/get?access_token=ACCESS_TOKEN&userid=zhangsan`

参数 | 参数类型 | 必须 | 说明
---------- | ------- | ------- | ------
access_token | String | 是 | 调用接口凭证
userid | String |是 | 员工在企业内的UserID，企业用来唯一标识用户的字段。

###### 返回结果

```
{
    "errcode": 0,
    "errmsg": "ok",
    "userid": "zhangsan",
    "name": "张三",
    "tel" : "010-123333",
    "workPlace" :"",
    "remark" : "",
    "mobile" : "13800000000",
    "email" : "dingding@aliyun.com",
    "active" : true,
    "orderInDepts" : "{1:10, 2:20}",
    "isAdmin" : false,
    "isBoss" : false,
    "dingId" : "WsUDaq7DCVIHc6z1GAsYDSA",
    "isLeaderInDepts" : "{1:true, 2:false}",
    "isHide" : false,
    "department": [1, 2],
    "position": "工程师",
    "avatar": "dingtalk.com/abc.jpg",
    "jobnumber": "111111",
    "extattr": {
                "爱好":"旅游",
                "年龄":"24"
                }
}
```

参数 |说明
---------- | ------
errcode | 返回码
errmsg | 对返回码的文本描述内容
userid | 员工唯一标识ID（不可修改）
name | 成员名称
tel  | 分机号（ISV不可见）
workPlace | 办公地点（ISV不可见）
remark | 备注（ISV不可见）
mobile | 手机号码（ISV不可见）
email | 电子邮箱（ISV不可见）
active | 是否已经激活, true表示已激活, false表示未激活
orderInDepts | 在对应的部门中的排序, Map结构的json字符串, key是部门的Id, value是人员在这个部门的排序值
isAdmin | 是否为企业的管理员, true表示是, false表示不是
isBoss | 是否为企业的老板, true表示是, false表示不是
dingId | 钉钉Id
isLeaderInDepts | 在对应的部门中是否为主管, Map结构的json字符串, key是部门的Id, value是人员在这个部门中是否为主管, true表示是, false表示不是
isHide | 是否号码隐藏, true表示隐藏, false表示不隐藏
department | 成员所属部门id列表
position | 职位信息
avatar | 头像url
jobnumber | 员工工号
extattr | 扩展属性，可以设置多种属性(但手机上最多只能显示10个扩展属性，具体显示哪些属性，请到OA管理后台->设置->通讯录信息设置和OA管理后台->设置->手机端显示信息设置)性

### 创建成员

###### 请求说明

Https请求方式: POST

`https://oapi.dingtalk.com/user/create?access_token=ACCESS_TOKEN`

###### 请求包结构体

```
{
    "userid": "zhangsan",
    "name": "张三",
    "orderInDepts" : "{1:10, 2:20}",
    "department": [1, 2],
    "position": "产品经理",
    "mobile": "15913215421",
    "tel" : "010-123333",
    "workPlace" :"",
    "remark" : "",
    "email": "zhangsan@gzdev.com",
    "jobnumber": "111111",
    "isHide": false,
    "isSenior": false,
    "extattr": {
                "爱好":"旅游",
                "年龄":"24"
                }
}
```

###### 参数说明

参数 | 参数类型 | 必须 | 说明
---------- | -------  | ------- | ------
access_token |String | 是 | 调用接口凭证
userid | String| 否 | 员工唯一标识ID（不可修改），企业内必须唯一。长度为1~64个字符，如果不传，服务器将自动生成一个userid
name | String | 是 | 成员名称。长度为1~64个字符
orderInDepts | JSONObject | 否 | 在对应的部门中的排序, Map结构的json字符串, key是部门的Id, value是人员在这个部门的排序值
department | List | 是 |数组类型，数组里面值为整型，成员所属部门id列表
position |String | 否 | 职位信息。长度为0~64个字符
mobile | String| 是 | 手机号码。企业内必须唯一
tel  | String| 否 | 分机号，长度为0~50个字符
workPlace | String| 否 | 办公地点，长度为0~50个字符
remark | String| 否 | 备注，长度为0~1000个字符
email | String| 否 | 邮箱。长度为0~64个字符。企业内必须唯一
jobnumber | String | 否 | 员工工号。对应显示到OA后台和客户端个人资料的工号栏目。长度为0~64个字符
isHide | Boolean| 否 | 是否号码隐藏, true表示隐藏, false表示不隐藏。隐藏手机号后，手机号在个人资料页隐藏，但仍可对其发DING、发起钉钉免费商务电话。
isSenior | Boolean| 否 | 是否高管模式，true表示是，false表示不是。开启后，手机号码对所有员工隐藏。普通员工无法对其发DING、发起钉钉免费商务电话。高管之间不受影响。
extattr | JSONObject | 否 | 扩展属性，可以设置多种属性(但手机上最多只能显示10个扩展属性，具体显示哪些属性，请到OA管理后台->设置->通讯录信息设置和OA管理后台->设置->手机端显示信息设置)

###### 返回结果

```
{
    "errcode": 0,
    "errmsg": "created",
    "userid": "dedwefewfwe1231"
}
```

参数 | 说明
---------- | ------
errcode | 返回码
errmsg | 对返回码的文本描述内容
userid | 员工唯一标识

### 更新成员

###### 请求说明

Https请求方式: POST

`https://oapi.dingtalk.com/user/update?access_token=ACCESS_TOKEN`

###### 请求包结构体

```
{
    "userid": "zhangsan",
    "name": "张三",
    "department": [1, 2],
    "orderInDepts": "{1:10}", 
    "position": "产品经理",
    "mobile": "15913215421",
    "tel" : "010-123333",
    "workPlace" :"",
    "remark" : "",
    "email": "zhangsan@gzdev.com",
    "jobnumber": "111111",
    "isHide": false,
    "isSenior": false,
    "extattr": {
                "爱好":"旅游",
                "年龄":"24"
                }
}
```

###### 参数说明（如果非必须的字段未指定，则钉钉后台不改变该字段之前设置好的值）

参数 | 参数类型 | 必须 | 说明
---------- | ------- | ------- | ------
access_token |String | 是 | 调用接口凭证
userid |String | 是 | 员工唯一标识ID（不可修改），企业内必须唯一。长度为1~64个字符
name |String | 是 | 成员名称。长度为1~64个字符
department |List | 否 | 成员所属部门id列表
orderInDepts | JSONObject | 否 | 实际是Map的序列化字符串，Map的Key是deptId，表示部门id，Map的Value是order，表示排序的值，列表是按order的倒序排列输出的，即从大到小排列输出的
position | String| 否 | 职位信息。长度为0~64个字符
mobile |String | 否 | 手机号码。企业内必须唯一
tel  | String| 否 | 分机号，长度为0~50个字符
workPlace | String| 否 | 办公地点，长度为0~50个字符
remark | String| 否 | 备注，长度为0~1000个字符
email |String | 否 | 邮箱。长度为0~64个字符。企业内必须唯一
jobnumber | String | 否 | 员工工号，对应显示到OA后台和客户端个人资料的工号栏目。长度为0~64个字符
isHide | Boolean| 否 | 是否号码隐藏, true表示隐藏, false表示不隐藏。隐藏手机号后，手机号在个人资料页隐藏，但仍可对其发DING、发起钉钉免费商务电话。
isSenior | Boolean| 否 | 是否高管模式，true表示是，false表示不是。开启后，手机号码对所有员工隐藏。普通员工无法对其发DING、发起钉钉免费商务电话。高管之间不受影响。
extattr |JSONObject | 否 | 扩展属性，可以设置多种属性(但手机上最多只能显示10个扩展属性，具体显示哪些属性，请到OA管理后台->设置->通讯录信息设置和OA管理后台->设置->手机端显示信息设置)

###### 返回结果

```
{
    "errcode": 0,
    "errmsg": "updated"
}
```

参数 | 说明
---------- | ------
errcode | 返回码
errmsg | 对返回码的文本描述内容

### 删除成员

###### 请求说明

Https请求方式: GET

`https://oapi.dingtalk.com/user/delete?access_token=ACCESS_TOKEN&userid=ID`


###### 参数说明

参数 | 参数类型 | 必须 | 说明
---------- | ------- | ------- | ------
access_token | String | 是 | 调用接口凭证
userid | String | 是 | 员工唯一标识ID（不可修改）

###### 返回结果

```
{
    "errcode": 0,
    "errmsg": "deleted"
}
```

参数 | 说明
---------- | ------
errcode | 返回码
errmsg | 对返回码的文本描述内容

### 批量删除成员

###### 请求说明
Https请求方式: POST

`https://oapi.dingtalk.com/user/batchdelete?access_token=ACCESS_TOKEN`

###### 请求包结构
```
{
   "useridlist":["zhangsan","lisi"]
}
```

###### 参数说明

参数 | 参数类型 | 必须 | 说明
----------| -------  | ------- | ------
access_token | String| 是 | 调用接口凭证
useridlist | List | 是 | 员工UserID列表。列表长度在1到20之间

###### 返回结果

```
{
    "errcode": 0,
    "errmsg": "deleted"
}
```

参数 | 说明
---------- | ------
errcode | 返回码
errmsg | 对返回码的文本描述内容

### 获取部门成员

###### 请求说明

Https请求方式: GET

`https://oapi.dingtalk.com/user/simplelist?access_token=ACCESS_TOKEN&department_id=1`

###### 参数说明

参数 | 参数类型 | 必须 | 说明
---------- | ------- | ------- | ------
access_token | String | 是 | 调用接口凭证
department_id | long | 是 | 获取的部门id
offset | long | 否 | 支持分页查询，与size参数同时设置时才生效，此参数代表偏移量
size | int | 否 | 支持分页查询，与offset参数同时设置时才生效，此参数代表分页大小，最大100
order | String | 否 | 支持分页查询，部门成员的排序规则，默认不传是按自定义排序；entry_asc代表按照进入部门的时间升序，entry_desc代表按照进入部门的时间降序，modify_asc代表按照部门信息修改时间升序，modify_desc代表按照部门信息修改时间降序，custom代表用户定义(未定义时按照拼音)排序

###### 返回结果

```
{
    "errcode": 0,
    "errmsg": "ok",
    "hasMore": false,
    "userlist": [
        {
            "userid": "zhangsan",
            "name": "张三"
        }
    ]
}
```

参数 | 说明
---------- | ------
errcode | 返回码
errmsg | 对返回码的文本描述内容
hasMore | 在分页查询时返回，代表是否还有下一页更多数据
userlist | 成员列表
userid | 员工唯一标识ID（不可修改）
name | 成员名称

### 获取部门成员（详情）

###### 请求说明

Https请求方式: GET

`https://oapi.dingtalk.com/user/list?access_token=ACCESS_TOKEN&department_id=1`

参数 | 参数类型 | 必须 | 说明
---------- | -------  | ------- | ------
access_token |String | 是 | 调用接口凭证
department_id | long | 是 | 获取的部门id
offset | long | 否 | 支持分页查询，与size参数同时设置时才生效，此参数代表偏移量
size | int | 否 | 支持分页查询，与offset参数同时设置时才生效，此参数代表分页大小，最大100
order | String | 否 | 支持分页查询，部门成员的排序规则，默认不传是按自定义排序；entry_asc代表按照进入部门的时间升序，entry_desc代表按照进入部门的时间降序，modify_asc代表按照部门信息修改时间升序，modify_desc代表按照部门信息修改时间降序，custom代表用户定义(未定义时按照拼音)排序

###### 返回结果

```
{
    "errcode": 0,
    "errmsg": "ok",
    "hasMore": false,
    "userlist":[
        {
            "userid": "zhangsan",
            "dingId": "dwdded",
            "mobile": "13122222222",
            "tel" : "010-123333",
            "workPlace" :"",
            "remark" : "",
            "order" : 1,
            "isAdmin": true,
            "isBoss": false,
            "isHide": true,
            "isLeader": true,
            "name": "张三",
            "active": true,
            "department": [1, 2],
            "position": "工程师",
            "email": "zhangsan@alibaba-inc.com",
            "avatar":  "./dingtalk/abc.jpg",
            "jobnumber": "111111",
            "extattr": {
                "爱好":"旅游",
                "年龄":"24"
                }
        }
    ]
}
```

参数 | 说明
---------- | ------
errcode | 返回码
errmsg | 对返回码的文本描述内容
hasMore | 在分页查询时返回，代表是否还有下一页更多数据
userlist | 成员列表
userid | 员工唯一标识ID（不可修改）
order | 表示人员在此部门中的排序，列表是按order的倒序排列输出的，即从大到小排列输出的
dingId | 钉钉ID
mobile | 手机号（ISV不可见）
tel  | 分机号（ISV不可见）
workPlace | 办公地点（ISV不可见）
remark | 备注（ISV不可见）
isAdmin | 是否是企业的管理员, true表示是, false表示不是
isBoss | 是否为企业的老板, true表示是, false表示不是
isHide | 是否隐藏号码, true表示是, false表示不是
isLeader | 是否是部门的主管, true表示是, false表示不是
name | 成员名称
active | 表示该用户是否激活了钉钉
department | 成员所属部门id列表
position |  职位信息
email | 邮箱
avatar  | 头像url
jobnumber | 员工工号
extattr |  扩展属性，可以设置多种属性(但手机上最多只能显示10个扩展属性，具体显示哪些属性，请到OA管理后台->设置->通讯录信息设置和OA管理后台->设置->手机端显示信息设置)

<!--
"mobile": "15913215421",
mobile | 手机号码
-->

## 管理微应用

### 创建微应用

###### 请求说明

Https请求方式: POST

`https://oapi.dingtalk.com/microapp/create?access_token=ACCESS_TOKEN`

###### 请求包结构体

```
{
    "appIcon": "@HIdsabikkhjsdsas",
    "appName": "测试微应用",
    "appDesc": "测试使用的微应用",
    "homepageUrl": "http://oa.dingtalk.com/?h5",
    "pcHomepageUrl": "http://oa.dingtalk.com/?pc",
    "ompLink": ""
}
```

###### 参数说明

参数 | 参数类型 | 必须 | 说明
----------| ------- | ------- | ------
access_token | String | 是 | 调用接口凭证
appIcon | String | 是 |  微应用的图标。需要调用上传接口将图标上传到钉钉服务器后获取到的mediaId
appName | String | 是 | 微应用的名称。长度限制为1~10个字符
appDesc  | String | 是 | 微应用的描述。长度限制为1~20个字符
homepageUrl | String | 是 | 微应用的移动端主页，必须以http开头或https开头
pcHomepageUrl | String | 否 | 微应用的PC端主页，必须以http开头或https开头，如果不为空则必须与homepageUrl的域名一致
ompLink | String | 否 | 微应用的OA后台管理主页，必须以http开头或https开头

###### 返回结果

```
{
    "errcode": 0,
    "errmsg": "created",
    "id": 2
}
```

参数 | 说明
----------  | ------
errcode | 返回码
errmsg | 对返回码的文本描述内容
id | 创建的微应用id



##群会话接口


### 创建会话

###### 请求说明

Https请求方式: POST

`https://oapi.dingtalk.com/chat/create?access_token=ACCESS_TOKEN`

###### 请求包结构体

```
{
    "name": "群名称",
    "owner": "zhangsan",
    "useridlist": ["zhangsan","lisi"]
}
```

###### 参数说明

参数 | 参数类型 | 必须 | 说明
----------| ------- | ------- | ------
access_token | String | 是 | 调用接口凭证
name | String | 是 |  群名称。长度限制为1~20个字符
owner | String | 是 | 群主userId，员工唯一标识ID；必须为该会话useridlist的成员之一
useridlist  | String[] | 是 | 群成员列表，每次最多操作40人，群人数上限为1000

###### 返回结果

```
{
    "errcode": 0,
    "errmsg": "ok",
    "chatid": "chatxxxxxxxxxxxxxxxxxxx"
}
```

参数 | 说明
----------  | ------
errcode | 返回码
errmsg | 对返回码的文本描述内容
chatid | 群会话的标识ID

### 修改会话

###### 请求说明

Https请求方式: POST

`https://oapi.dingtalk.com/chat/update?access_token=ACCESS_TOKEN`

###### 请求包结构体

```
{
    "chatid": "chatxxxxxxxxxxxxxxxxxxx",
    "name": "群名称",
    "owner": "zhangsan",
    "add_useridlist": ["lisi"],
    "del_useridlist": ["wangwu"]
}
```

###### 参数说明

参数 | 参数类型 | 必须 | 说明
----------| ------- | ------- | ------
access_token | String | 是 | 调用接口凭证
chatid | String | 是 | 会话id
name | String | 否 |  群名称。长度限制为1~20个字符，不传则不修改
owner | String | 否 | 群主userId，员工唯一标识ID；必须为该会话成员之一；不传则不修改
add_useridlist  | String[] | 否 | 添加成员列表，每次最多操作40人，群人数上限为1000
del_useridlist  | String[] | 否 | 删除成员列表，每次最多操作40人，群人数上限为1000

###### 返回结果

```
{
    "errcode": 0,
    "errmsg": "ok"
}
```

参数 | 说明
----------  | ------
errcode | 返回码
errmsg | 对返回码的文本描述内容

### 获取会话

###### 请求说明

Https请求方式: GET

`https://oapi.dingtalk.com/chat/get?access_token=ACCESS_TOKEN`

###### 参数说明

参数 | 参数类型 | 必须 | 说明
---------- | ------- | ------- | ------
access_token | String | 是 | 调用接口凭证
chatid | String | 是 | 会话id

###### 返回结果

```
{
    "errcode": 0,
    "errmsg": "ok",
    "chat_info":
        {
            "name": "群名称",
            "owner": "zhangsan",
            "useridlist": ["zhangsan","lisi"],
            "agentidlist": ["12345"]
        }
}
```

参数 | 说明
---- | -----
errcode | 返回码
errmsg | 对返回码的文本描述内容
chat_info | 群会话信息
name | 群名称
owner | 群主userid
useridlist | 群成员userId列表
agentidlist | 群绑定的微应用agentId列表


### 绑定微应用和群会话

此接口仅限ISV接入使用

###### 请求说明

Https请求方式: GET

`https://oapi.dingtalk.com/chat/bind?access_token=ACCESS_TOKEN`

###### 参数说明

参数 | 参数类型 | 必须 | 说明
---------- | ------- | ------- | ------
access_token | String | 是 | 调用接口凭证
chatid | String | 是 | 会话id
agentid | String | 是 | 微应用agentId，每个群最多绑定5个微应用，一个群只能被一个ISV套件绑定一次

###### 返回结果

```
{
    "errcode": 0,
    "errmsg": "ok"
}
```

参数 | 说明
---- | -----
errcode | 返回码
errmsg | 对返回码的文本描述内容

### 解绑微应用和群会话

此接口仅限ISV接入使用

###### 请求说明

Https请求方式: GET

`https://oapi.dingtalk.com/chat/unbind?access_token=ACCESS_TOKEN`

###### 参数说明

参数 | 参数类型 | 必须 | 说明
---------- | ------- | ------- | ------
access_token | String | 是 | 调用接口凭证
chatid | String | 是 | 会话id
agentid | String | 是 | 微应用agentId

###### 返回结果

```
{
    "errcode": 0,
    "errmsg": "ok"
}
```

参数 | 说明
---- | -----
errcode | 返回码
errmsg | 对返回码的文本描述内容

### 发送消息到群会话

###### 请求说明

Https请求方式: POST

`https://oapi.dingtalk.com/chat/send?access_token=ACCESS_TOKEN`

###### 参数说明

参数 | 参数类型 | 必须 | 说明
---------- | ------- | ------- | ------
access_token |String | 是 | 调用接口凭证

###### 返回说明

```
{
    "errcode": 0,
    "errmsg": "ok"
}
```
参数 | 说明
---- | -----
errcode | 返回码
errmsg | 对返回码的文本描述内容

#### 消息类型及数据格式

##### text消息

```
{
	"chatid": "chatxxxxxxxxx",
	"sender": "manager1122",
    "msgtype": "text",
    "text": {
        "content": "张三的请假申请"
    }
}
```

###### 参数说明

参数 | 参数类型 | 必须 | 说明
---------- | ------- | ------- | ------
chatid | String | 是 | 会话id
sender | String | 是 | 发送者的userid
msgtype |String | 是 | 消息类型，此时固定为：text

###### text消息体格式

参数 | 参数类型 | 必须 | 说明
---------- | ------- | ------- | ------
text.content |String | 是 | 消息内容

##### image消息

```
{
	"chatid": "chatxxxxxxxxx",
	"sender": "manager1122",
    "msgtype": "image",
    "image": {
        "media_id": "MEDIA_ID"
    }
}
```

###### 参数说明

参数 | 参数类型 | 必须 | 说明
---------- | ------- | ------- | ------
chatid | String | 是 | 会话id
sender | String | 是 | 发送者的userid
msgtype |String | 是 | 消息类型，此时固定为：image

###### image消息体格式

参数 | 参数类型 | 必须 | 说明
---------- | ------- | ------- | ------
image.media_id | String | 是 | 图片媒体文件id，可以调用上传媒体文件接口获取。建议宽600像素 x 400像素，宽高比3：2

##### voice消息

```
{
	"chatid": "chatxxxxxxxxx",
	"sender": "manager1122",
    "msgtype": "voice",
    "voice": {
       "media_id": "MEDIA_ID"
    }
}
```

###### 参数说明

参数 | 参数类型 | 必须 | 说明
---------- | ------- | ------- | ------
chatid | String | 是 | 会话id
sender | String | 是 | 发送者的userid
msgtype |String | 是 | 消息类型，此时固定为：voice

###### voice消息体格式

参数 | 参数类型 | 必须 | 说明
---------- | ------- | ------- | ------
voice.media_id |String | 是 | 语音媒体文件id，可以调用上传媒体文件接口获取。2MB，播放长度不超过60s，AMR格式

##### file消息

```
{
	"chatid": "chatxxxxxxxxx",
	"sender": "manager1122",
    "msgtype": "file",
    "file": {
       "media_id": "MEDIA_ID"
    }
}
```

###### 参数说明

参数 | 参数类型 | 必须 | 说明
---------- | ------- | ------- | ------
chatid | String | 是 | 会话id
sender | String | 是 | 发送者的userid
msgtype | String| 是 | 消息类型，此时固定为：file

###### file消息体格式

参数 | 参数类型 | 必须 | 说明
---------- | ------- | ------- | ------
file.media_id |String | 是 | 媒体文件id，可以调用上传媒体文件接口获取。10MB


##### link消息

```
{
	"chatid": "chatxxxxxxxxx",
	"sender": "manager1122",
    "msgtype": "link",
    "link": {
        "title": "测试",
        "text": "测试",
        "pic_url":"https://gw.alicdn.com/tps/TB1FN16LFXXXXXJXpXXXXXXXXXX-256-130.png",
        "message_url": "http://www.dingtalk.com"
    }
}
```

###### 参数说明

参数 | 参数类型 | 必须 | 说明
---------- | ------- | ------- | ------
chatid | String | 是 | 会话id
sender | String | 是 | 发送者的userid
msgtype | String | 是 | 消息类型，此时固定为：link

###### link消息体格式

参数 | 参数类型 | 必须 | 说明
---------- | ------- | ------- | ------
link.title | String | 是 | 消息标题
link.text | String | 是 | 消息描述
link.pic_url | String | 是 | 图片媒体文件id，可以调用上传媒体文件接口获取
link.message_url | String | 是 | 消息点击链接地址

##### OA消息

```
{
	 "chatid": "chatxxxxxxxxx",
	 "sender": "manager1122",
	 "msgtype": "oa",
     "oa": {
        "message_url": "https://www.dingtalk.com",
        "pc_message_url": "https://oa.dingtalk.com",
        "head": {
            "bgcolor": "FFBBBBBB",
            "text": "头部标题"
        },
        "body": {
            "title": "正文标题",
            "form": [
                {
                    "key": "姓名:",
                    "value": "张三"
                },
                {
                    "key": "年龄:",
                    "value": "20"
                },
                {
                    "key": "身高:",
                    "value": "1.8米"
                },
                {
                    "key": "体重:",
                    "value": "130斤"
                },
                {
                    "key": "学历:",
                    "value": "本科"
                },
                {
                    "key": "爱好:",
                    "value": "打球、听音乐"
                }
            ],
            "rich": {
                "num": "15.6",
                "unit": "元"
            },
            "content": "大段文本大段文本大段文本大段文本大段文本大段文本大段文本大段文本大段文本大段文本大段文本大段文本",
            "image": "@lADOADmaWMzazQKA",
            "file_count": "3",
            "author": "李四 "
        }
    }
}
```

###### 参数说明

参数 | 参数类型 | 必须 | 说明
----- | ------- | ------- | ------
chatid | String | 是 | 会话id
sender | String | 是 | 发送者的userid
msgtype |String | 是 | 消息类型，此时固定为：oa

###### OA消息体格式

参数 | 参数类型 | 必须 | 说明
------ | ------- | ------- | ------
oa.message_url| String | 是 | 客户端点击消息时跳转到的H5地址
oa.pc_message_url| String | 否 | PC端点击消息时跳转到的URL地址
oa.head | String | 是 | 消息头部内容
oa.head.bgcolor | String | 是 | 消息头部的背景颜色。长度限制为8个英文字符，其中前2为表示透明度，后6位表示颜色值。不要添加0x
oa.head.text | String | 是 | 消息的头部标题
oa.body | Array[JSON Object] | 是 | 消息体
oa.body.title | String | 否 | 消息体的标题
oa.body.form | Array[JSON Object] | 否 | 消息体的表单，最多显示6个，超过会被隐藏
oa.body.form.key | String | 否 | 消息体的关键字
oa.body.form.value | String | 否 | 消息体的关键字对应的值
oa.body.rich | Array[JSON Object] | 否 | 单行富文本信息
oa.body.rich.num | String | 否 | 单行富文本信息的数目
oa.body.rich.unit | String | 否| 单行富文本信息的单位
oa.body.content | String | 否 | 消息体的内容，最多显示3行
oa.body.image | String | 否 | 消息体中的图片media_id
oa.body.file_count | String | 否 | 自定义的附件数目。此数字仅供显示，钉钉不作验证
oa.body.author | String | 否 | 自定义的作者名字

#### OA消息截图

![oames](https://img.alicdn.com/tps/TB1gVcFIFXXXXcGXXXXXXXXXXXX.jpg)

##客户通讯录接口（暂未开放）

您可以通过使用客户通讯接口，将您的CRM应用中的员工与客户的关系、客户与客户联系人的关系在钉钉客户端通讯录中展现，与钉钉有更深入的功能融合，对于用户来说客户关系与通讯录的紧密结合，更容易管理和联系核心客户

### 员工新增客户信息

###### 请求说明

Https请求方式: POST

`https://oapi.dingtalk.com/crm/customer/create?access_token=ACCESS_TOKEN&user_id=USER_ID`

###### 请求包结构体

```
{
"customer":[
{
"name":"姓名",
"address":"地址",
"description":"描述",
"telephone":"电话"
}
],
"contacts":[
{
"name":"姓名",
"mobile":"手机",
"attached":"备注"
}
],
"userIds":[
"USER_ID","USER_ID"
],
"create_by":"创建时间"
}

```

###### 参数说明

参数 | 参数类型 | 必须 | 说明
----------| ------- | ------- | ------
access_token | String | 是 | 调用接口凭证
user_id | String | 是 |  员工在企业内的userid
customer | JSONObject | 是 |  客户信息
name | String | 是 |  客户名称
address | String | 是 |  客户地址
description | String | 是 |  客户描述
telephone | String | 是 |  客户电话
contacts | JSONObject | 否 |  客户联系人信息
name | String | 否 |  客户联系人名称
mobile | String | 否 |  客户联系人手机
attached | String | 否 |  客户联系人备注
userIds | String[] | 否 |  跟进客户的员工信息
create_by | String | 是 |  创建时间

###### 返回结果

```
{
    "errcode": 0,
    "errmsg": "ok",
    "customerid": "xxxxxxxxxxxxxxxxxx"
}
```

参数 | 说明
----------  | ------
errcode | 返回码
errmsg | 对返回码的文本描述内容
customerid | 客户id

### 员工修改客户信息

###### 请求说明

Https请求方式: POST

`https://oapi.dingtalk.com/crm/customer/update?access_token=ACCESS_TOKEN&user_id=USER_ID`

###### 请求包结构体

```
{
"id":"客户id",
"name":"客户名称",
"address":"客户地址",
"description":"客户描述",
"telephone":"电话",
"modified_by":"修改时间"
}
```

###### 参数说明

参数 | 参数类型 | 必须 | 说明
----------| ------- | ------- | ------
access_token | String | 是 | 调用接口凭证
user_id | String | 是 | 员工id
id | String | 是 |  客户id
name | String | 否 | 客户名称
address  | String | 否 | 客户地址信息
description  | String | 否 | 客户描述信息
telephone  | String | 否 | 客户联系电话
modified_by  | String | 否 | 修改时间

###### 返回结果

```
{
    "errcode": 0,
    "errmsg": "ok"
}
```

参数 | 说明
----------  | ------
errcode | 返回码
errmsg | 对返回码的文本描述内容

### 员工删除客户

###### 请求说明

Https请求方式: POST

`https://oapi.dingtalk.com/crm/customer/delete?access_token=ACCESS_TOKEN&user_id=USER_ID`

###### 请求包结构体

```
{
"id[]":"客户id"
}

```

###### 参数说明

参数 | 参数类型 | 必须 | 说明
---------- | ------- | ------- | ------
access_token | String | 是 | 调用接口凭证
user_id | String | 是 | 会话id
id | String[] | 是 | 客户id

###### 返回结果

```
{
    "errcode": 0,
    "errmsg": "ok"
 }
```

参数 | 说明
---- | -----
errcode | 返回码
errmsg | 对返回码的文本描述内容


### 获取客户详细信息

###### 请求说明

Https请求方式: GET

`https://oapi.dingtalk.com/crm/customer/get?access_token=ACCESS_TOKEN&id=CUSTOMER_ID`

###### 参数说明

参数 | 参数类型 | 必须 | 说明
---------- | ------- | ------- | ------
access_token | String | 是 | 调用接口凭证
id | String | 是 | 客户id

###### 返回结果

```
{
"customer":{

"name":"客户名称",
"address":"客户地址",
"description":"客户描述",
"telephone":"客户电话"
},
"contactList":[
{
"name":"客户联系人名称",
"mobile":"客户联系人电话",
"attached":"客户联系人备注"
}
],
"userIds":[
                "USER_ID","USER_ID"
],
"create_by":"创建时间"
}
```

参数 | 说明
---- | -----
customer  |  客户信息
name |  客户名称
address  |  客户地址
description |  客户描述
telephone  |  客户电话
contacts  |  客户联系人信息
name  |  客户联系人名称
mobile  |  客户联系人手机
attached  |  客户联系人备注
userIds  |  跟进客户的员工信息
create_by  |  创建时间

### 获取客户列表

###### 请求说明

Https请求方式: GET

`https://oapi.dingtalk.com/crm/customer/get?access_token=ACCESS_TOKEN`

###### 参数说明

参数 | 参数类型 | 必须 | 说明
---------- | ------- | ------- | ------
access_token | String | 是 | 调用接口凭证

###### 返回结果

```
{
"customerlist":[
{
"name":"客户名称",
"address":"客户地址",
"description":"客户描述",
"telephone":"客户电话"
}
]
}
```

参数 | 说明
---- | -----
customerlist  |  客户列表信息
name |  客户名称
address  |  客户地址
description |  客户描述
telephone  |  客户电话

### 员工新增客户联系人

###### 请求说明

Https请求方式: POST

`https://oapi.dingtalk.com/crm/contact/create?access_token=ACCESS_TOKEN&user_id=USER_ID`

###### 请求包结构体

```
{
"customerid":"客户id",
"name":"客户联系人名称",
"mobile":"客户联系人手机",
"attached":"客户联系人备注",
"create_by":"创建时间"
}

```

###### 参数说明

参数 | 参数类型 | 必须 | 说明
---------- | ------- | ------- | ------
access_token |String | 是 | 调用接口凭证
user_id |String | 是 | 员工id
customerid  |  客户id
name  |  客户联系人名称
mobile  |  客户联系人手机
attached  |  客户联系人备注
create_by  |  创建时间

###### 返回说明

```
{
    "errcode": 0,
    "errmsg": "ok"
}
```
参数 | 说明
---- | -----
errcode | 返回码
errmsg | 对返回码的文本描述内容

### 员工修改客户联系人

###### 请求说明

Https请求方式: POST

`https://oapi.dingtalk.com/crm/contact/create?access_token=ACCESS_TOKEN&user_id=USER_ID`

###### 请求包结构体

```
{
"contactid":"客户联系人id",
"name":"客户联系人名称",
"mobile":"客户联系人手机",
"attached":"客户联系人备注",
"modified_by":"修改时间"	  
}

```

###### 参数说明

参数 | 参数类型 | 必须 | 说明
---------- | ------- | ------- | ------
access_token |String | 是 | 调用接口凭证
user_id |String | 是 | 员工id
contactid |String | 是  |  客户id
name |String | 是  |  客户联系人名称
mobile  |String | 是 |  客户联系人手机
attached |String | 是   |  客户联系人备注
modified_by |String | 是   |  修改时间

###### 返回说明

```
{
    "errcode": 0,
    "errmsg": "ok"
}
```
参数 | 说明
---- | -----
errcode | 返回码
errmsg | 对返回码的文本描述内容

### 员工删除客户联系人

###### 请求说明

Https请求方式: POST

`https://oapi.dingtalk.com/crm/contact/delete?access_token=ACCESS_TOKEN&user_id=USER_ID`

###### 请求包结构体

```
{
"contactid[]":"客户联系人id1"
}

```

###### 参数说明

参数 | 参数类型 | 必须 | 说明
---------- | ------- | ------- | ------
access_token |String | 是 | 调用接口凭证
user_id |String | 是 | 员工id
contactid  |String[] | 是  |  客户id
###### 返回说明

```
{
    "errcode": 0,
    "errmsg": "ok"
}
```
参数 | 说明
---- | -----
errcode | 返回码
errmsg | 对返回码的文本描述内容

### 员工客户关系新增

###### 请求说明

Https请求方式: POST

`https://oapi.dingtalk.com/crm/empcustomer/create?access_token=ACCESS_TOKEN`

###### 请求包结构体

```
{
    "customerId":"客户id",
    "userId":"员工id",
    "create_by":"创建时间"
}

```

###### 参数说明

参数 | 参数类型 | 必须 | 说明
---------- | ------- | ------- | ------
access_token |String | 是 | 调用接口凭证
customerId |String | 是 | 客户id
userId  |String | 是  |  员工id
create_by  |String | 是  |  创建时间

###### 返回说明

```
{
    "errcode": 0,
    "errmsg": "ok"
}
```
参数 | 说明
---- | -----
errcode | 返回码
errmsg | 对返回码的文本描述内容

### 员工客户关系删除

###### 请求说明

Https请求方式: POST

`https://oapi.dingtalk.com/crm/empcustomer/delete?access_token=ACCESS_TOKEN`

###### 请求包结构体

```
{
"customerId":"客户id",
"userId":"员工id",
"modified_by":"修改时间"
}

```

###### 参数说明

参数 | 参数类型 | 必须 | 说明
---------- | ------- | ------- | ------
access_token |String | 是 | 调用接口凭证
customerId |String | 是 | 客户id
userId  |String | 是  |  员工id
modified_by  |String | 是  |  修改时间

###### 返回说明

```
{
    "errcode": 0,
    "errmsg": "ok"
}
```
参数 | 说明
---- | -----
errcode | 返回码
errmsg | 对返回码的文本描述内容

##通讯录及群会话变更事件回调接口

在使用回调接口之前您需要了解的是，

首先您需要准备好，

- URL:[<font color=red>注册事件回调接口</font>](#注册事件回调接口)填写的接收推送的地址

- Token:[<font color=red>注册事件回调接口</font>](#注册事件回调接口)中任意填写的，用来生成signature，用来和回调参数中的signature比对，校验消息的合法性

- 数据加密密钥(ENCODING_AES_KEY):[<font color=red>注册事件回调接口</font>](#注册事件回调接口)中填写的数据加密密钥。用于回调数据的加解密，长度固定为43个字符，从a-z, A-Z, 0-9共62个字符中选取,您可以随机生成。

钉钉服务器会向回调url推送事件变更。

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

除此之外，在接收到推送之后，**需要返回字符串success（代表了你收到了推送），返回的数据也需要做加密处理**，如果不返回，钉钉服务器将持续推送下去，达到一定阈值后将不再推送。

"Talk is cheap, show me the code."所以我们也为开发者提供了加解密的demo，目前提供Java/PHP等语言版本。
加解密库和demo的下载：[<font color=red >加解密库和demo下载</font>](#加解密库和demo下载)

如有需要，可以查看具体加解密步骤：[<font color=red >查看</font>](#12-加解密方案)

### 通讯录事件回调

当企业通讯录发生变化，并且事件类型包含在注册时填写的"call_back_tag"中时，比如call_back_tag字段为"["user_add_org","user_modify_org"]"，那么企业通讯录发生了"通讯录用户增加"和"讯录用户更改"，钉钉服务器会向url推送事件。

目前可以监听的事件类型分别为:

- user_add_org : 通讯录用户增加
- user_modify_org : 通讯录用户更改
- user_leave_org : 通讯录用户离职
- org_admin_add ：通讯录用户被设为管理员
- org_admin_remove ：通讯录用户被取消设置管理员
- org_dept_create ： 通讯录企业部门创建
- org_dept_modify ： 通讯录企业部门修改
- org_dept_remove ： 通讯录企业部门删除
- org_remove ： 企业被解散

POST数据解密后示例
接收到推送之后请务必返回经过加密的字符串"success"的json数据

```
{
    "EventType": "user_add_org",
    "TimeStamp": 43535463645,
    "UserId": ["efefef" , "111111"],
    "CorpId": "corpid"
}
```

###### 参数说明

参数 | 说明
----------  | ------
EventType | 事件类型，有八种，"user_add_org", "user_modify_org", "user_leave_org","org_admin_add", "org_admin_remove", "org_dept_create", "org_dept_modify", "org_dept_remove", "org_remove"
TimeStamp | 时间戳
UserId | 用户发生变更的userid列表
DeptId | 部门发生变更的userid列表
CorpId | 发生通讯录变更的企业

##### 返回说明

服务提供商在收到此事件推送后务必返回包含经过加密的字符串"success"的json数据

只有返回了对应的json数据，钉钉才会判断此事件推送成功，套件才能创建成功。

```

{
  "msg_signature":"111108bb8e6dbce3c9671d6fdb69d15066227608",
  "timeStamp":"1783610513",
  "nonce":"123456",
  "encrypt":"1ojQf0NSvw2WPvW7LijxS8UvISr8pdDP+rXpPbcLGOmIBNbWetRg7IP0vdhVgkVwSoZBJeQwY2zhROsJq/HJ+q6tp1qhl9L1+ccC9ZjKs1wV5bmA9NoAWQiZ+7MpzQVq+j74rJQljdVyBdI/dGOvsnBSCxCVW0ISWX0vn9lYTuuHSoaxwCGylH9xRhYHL9bRDskBc7bO0FseHQQasdfghjkl"
 }

```

参数      | 说明
-------   | -------------
msg_signature  | 消息体签名
timeStamp | 时间戳
nonce  | 随机字符串
encrypt  | "success"加密字符串

### 群会话事件回调

当企业群会话发生变化，并且事件类型包含在注册时填写的"call_back_tag"中时，比如call_back_tag字段为"["chat_add_member","chat_remove_member"]"，那么企业群会话发生了"群会话添加人员"和"群会话删除人员"，钉钉服务器会向url推送事件。

目前可以监听的事件类型分别为:

- chat_add_member : 群会话添加人员
- chat_remove_member : 群会话删除人员
- chat_quit : 群会话用户主动退群
- chat_update_owner ：群会话更换群主
- chat_update_title ：群会话更换群名称
- chat_disband ： 群会话解散群
- chat_disband_microapp ： 绑定了微应用的群会话，在解散时回调

POST数据解密后示例
接收到推送之后请务必返回经过加密的字符串"success"的json数据

```
{
    "EventType": "chat_add_member",
    "TimeStamp": 43535463645,
    "CorpId": "corpid",
    "ChatId": "chat90f29b737b56dc179df8w86t83d5f0f8",
    "UserId": ["efefef" , "111111"],
    "Operator": "manager0112",
}
```

###### 参数说明

参数 | 说明明
----------  | ------
EventType | 事件类型，有七种，"chat_add_member", "chat_remove_member", "chat_quit", "chat_update_owner", "chat_update_title", "chat_disband","chat_disband_microapp"
TimeStamp | 时间戳
CorpId | 发生群会话变更的企业
ChatId | 会话的ID
UserId | 用户发生变更的userid列表
Owner  | 已经更新的新的群主的userid
Title  | 已经更新的新的群标题
Operator | 操作人员的userid
agentId  | 群会话绑定的微应用agentId

##### 返回说明

服务提供商在收到此事件推送后务必返回包含经过加密的字符串"success"的json数据

只有返回了对应的json数据，钉钉才会判断此事件推送成功，套件才能创建成功。

```

{
  "msg_signature":"111108bb8e6dbce3c9671d6fdb69d15066227608",
  "timeStamp":"1783610513",
  "nonce":"123456",
  "encrypt":"1ojQf0NSvw2WPvW7LijxS8UvISr8pdDP+rXpPbcLGOmIBNbWetRg7IP0vdhVgkVwSoZBJeQwY2zhROsJq/HJ+q6tp1qhl9L1+ccC9ZjKs1wV5bmA9NoAWQiZ+7MpzQVq+j74rJQljdVyBdI/dGOvsnBSCxCVW0ISWX0vn9lYTuuHSoaxwCGylH9xRhYHL9bRDskBc7bO0FseHQQasdfghjkl"
 }

```

参数      | 说明
-------   | -------------
msg_signature  | 消息体签名
timeStamp | 时间戳
nonce  | 随机字符串
encrypt  | "success"加密字符串

###注册事件回调接口

注册回调接口的时候，钉钉服务器会回调[<font color=red>测试回调url</font>](#测试回调url)，来验证填写的url的合法性，需要您再接收到回调之后返回加密字符串"success"的json数据,才能完成注册。

<img src="https://img.alicdn.com/tps/TB10MOOJFXXXXbdXpXXXXXXXXXX-373-351.png" width = "373" height = "351" alt="图片名称" align=center />


###### 请求说明

Https请求方式: POST

`https://oapi.dingtalk.com/call_back/register_call_back?access_token=ACCESS_TOKEN`

###### 请求包结构体

```
{
    "call_back_tag": ["user_add_org", "user_modify_org", "user_leave_org"],
    "token": "123456",
    "aes_key": "1",
    "url":"www.dingtalk.com"
}
```
###### 参数说明

参数 | 参数类型 | 必须 | 说明
----------| ------- | ------- | ------
access_token | String | 是 | 调用接口凭证
call_back_tag | Array[String] | 是 |  需要监听的事件类型，有16种，"user_add_org", "user_modify_org", "user_leave_org","org_admin_add", "org_admin_remove", "org_dept_create", "org_dept_modify", "org_dept_remove", "org_remove", "chat_add_member", "chat_remove_member", "chat_quit", "chat_update_owner", "chat_update_title", "chat_disband", "chat_disband_microapp"
token | String | 是 | 加解密需要用到的token，ISV(服务提供商)推荐使用注册套件时填写的token，普通企业可以随机填写
aes_key  | String | 是 | 数据加密密钥。用于回调数据的加密，长度固定为43个字符，从a-z, A-Z, 0-9共62个字符中选取,您可以随机生成，ISV(服务提供商)推荐使用注册套件时填写的EncodingAESKey
url  | String | 是 | 接收事件回调的url

###### 返回结果

```
{
    "errcode": 0,
    "errmsg": "ok"
}
```

参数 | 说明
----------  | ------
errcode | 返回码
errmsg | 对返回码的文本描述内容



###查询事件回调接口

###### 请求说明

Https请求方式: get

`https://oapi.dingtalk.com/call_back/get_call_back?access_token=ACCESS_TOKEN`

###### 参数说明

参数 | 参数类型 | 必须 | 说明
----------| ------- | ------- | ------
access_token | String | 是 | 调用接口凭证

###### 返回结果

```
{   
    "errcode": 0,
    "errmsg": "ok",
    "call_back_tag": ["user_add_org", "user_modify_org", "user_leave_org"],
    "token": "123456",
    "aes_key": "",
    "url":"www.dingtalk.com"

}
```

参数 | 说明
----------  | ------
errcode | 返回码
errmsg | 对返回码的文本描述内容
access_token  | 调用接口凭证
call_back_tag |  需要监听的事件类型，有16种，"user_add_org", "user_modify_org", "user_leave_org","org_admin_add", "org_admin_remove", "org_dept_create", "org_dept_modify", "org_dept_remove", "org_remove", "chat_add_member", "chat_remove_member", "chat_quit", "chat_update_owner", "chat_update_title", "chat_disband", "chat_disband_microapp"
token | 加解密需要用到的token，ISV(服务提供商)推荐使用注册套件时填写的token，普通企业可以随机填写
aes_key  | 数据加密密钥。用于回调数据的加密，长度固定为43个字符，从a-z, A-Z, 0-9共62个字符中选取,您可以随机生成，ISV(服务提供商)推荐使用注册套件时填写的EncodingAESKey
url   | 接收事件回调的url



###更新事件回调接口

###### 请求说明

Https请求方式: POST

`https://oapi.dingtalk.com/call_back/update_call_back?access_token=ACCESS_TOKEN`

###### 请求包结构体

```
{
    "call_back_tag": ["user_add_org", "user_modify_org", "user_leave_org","org_admin_add", "org_admin_remove", "org_dept_create", "org_dept_modify", "org_dept_remove", "org_remove"],
    "token": "123456",
    "aes_key": "11111111lvdhntotr3x9qhlbytb18zyz5z111111111",
    "url": "www.dingtalk.com"
}
```
###### 参数说明

参数 | 参数类型 | 必须 | 说明
----------| ------- | ------- | ------
access_token | String | 是 | 调用接口凭证
call_back_tag | Array[String] | 是 |  需要监听的事件类型，有16种，"user_add_org", "user_modify_org", "user_leave_org","org_admin_add", "org_admin_remove", "org_dept_create", "org_dept_modify", "org_dept_remove", "org_remove", "chat_add_member", "chat_remove_member", "chat_quit", "chat_update_owner", "chat_update_title", "chat_disband","chat_disband_microapp"
token | String | 是 | 加解密需要用到的token，ISV(服务提供商)推荐使用注册套件时填写的token，普通企业可以随机填写
aes_key  | String | 是 | 数据加密密钥。用于回调数据的加密，长度固定为43个字符，从a-z, A-Z, 0-9共62个字符中选取,您可以随机生成，ISV(服务提供商)推荐使用注册套件时填写的EncodingAESKey
url  | String | 是 | 接收事件回调的url

###### 返回结果

```
{
    "errcode": 0,
    "errmsg": "ok"
}
```

参数 | 说明
----------  | ------
errcode | 返回码
errmsg | 对返回码的文本描述内容




###删除事件回调接口

###### 请求说明

Https请求方式: get

`https://oapi.dingtalk.com/call_back/delete_call_back?access_token=ACCESS_TOKEN`

###### 参数说明

参数 | 参数类型 | 必须 | 说明
----------| ------- | ------- | ------
access_token | String | 是 | 调用接口凭证

###### 返回结果
```
{
   "errcode": 0,
   "errmsg": "ok"

}
```

参数 | 说明
----------  | ------
errcode | 返回码
errmsg | 对返回码的文本描述内容



### 获取回调失败的结果

钉钉服务器给回调接口推送 通讯录变更事件的时候，有可能因为各种原因推送失败(比如网络异常)，此时钉钉服务器将保留此次变更事件。

用户可以通过此回调接口获取推送失败的变更事件。

###### 请求说明

Https请求方式: get

`https://oapi.dingtalk.com/call_back/get_call_back_failed_result?access_token=ACCESS_TOKEN`

###### 参数说明

参数 | 参数类型 | 必须 | 说明
----------| ------- | ------- | ------
access_token | String | 是 | 调用接口凭证


###### 返回结果
```
{
   "errcode": 0,
   "errmsg": "ok",
   "has_more": false,
   "failed_list": [
        {
            "event_time" : 32112412,
            "call_back_tag" : "user_add_org",
            "userid" : ["",""],
            "corpid" : ""
        },
        {
            "event_time" : 24431231,
            "call_back_tag" : "user_add_org",
            "userid" : ["",""],
            "corpid" : ""
        }
   ]

}
```

参数 | 说明
----------  | ------
errcode | 返回码
errmsg | 对返回码的文本描述内容
has_more | 是否还有推送失败的变更事件，若为true,则表示还有未回调的事件
failed_list | 事件列表，一次最多200个
event_time | 事件的时间戳
call_back_tag | 事件类型，有16种，"user_add_org", "user_modify_org", "user_leave_org","org_admin_add", "org_admin_remove", "org_dept_create", "org_dept_modify", "org_dept_remove", "org_remove", "chat_add_member", "chat_remove_member", "chat_quit", "chat_update_owner", "chat_update_title", "chat_disband","chat_disband_microapp"
userid | 相关员工列表
deptid | 相关部门列表
corpid | 相关企业id

### 测试回调url

在您注册事件回调接口的时候，钉钉服务器会向您”注册回调接口“时候上传的url(接收回调的url)推送一条消息，用来测试url的合法性。

收到消息需要返回经过加密后的字符串"success"的json数据，否则钉钉服务器将认为url不合法，从而不予推送。

POST数据解密后示例

```
{
    "EventType" : "check_url"
}
```
参数 | 说明
----------  | ------
EventType | "check_url"

##### 返回说明

服务提供商在收到此事件推送后务必返回包含经过加密的字符串"success"的json数据

只有返回了对应的json数据，钉钉才会判断此事件推送成功，套件才能创建成功。

```

{
  "msg_signature":"111108bb8e6dbce3c9671d6fdb69d15066227608",
  "timeStamp":"1783610513",
  "nonce":"123456",
  "encrypt":"1ojQf0NSvw2WPvW7LijxS8UvISr8pdDP+rXpPbcLGOmIBNbWetRg7IP0vdhVgkVwSoZBJeQwY2zhROsJq/HJ+q6tp1qhl9L1+ccC9ZjKs1wV5bmA9NoAWQiZ+7MpzQVq+j74rJQljdVyBdI/dGOvsnBSCxCVW0ISWX0vn9lYTuuHSoaxwCGylH9xRhYHL9bRDskBc7bO0FseHQQasdfghjkl"
  }

```

参数      | 说明
-------   | -------------
msg_signature  | 消息体签名
timeStamp | 时间戳
nonce  | 随机字符串
encrypt  | "success"加密字符串




## 发送普通会话消息

员工可以在微应用中把消息发送到同企业的人或群。

调用接口时，使用Https协议、JSON数据包格式。

目前支持文本、图片、语音、普通文件、OA消息以及link等消息类型，每个消息都由消息头和消息体组成，普通会话的消息头由sender,cid组成。消息体请参见以下各种[<font color=red >消息类型</font>](#消息类型及数据格式)。

###### 参数说明

参数 | 参数类型 | 必须 | 说明
---------- | ------- | ------- | ------
sender | String | 是 | 消息发送者员工ID
cid | String | 是 | 群消息或者个人聊天会话Id，(通过[<font color=red>JSAPI之pickConversation接口</font>](#获取会话信息)唤起联系人界面选择之后即可拿到会话ID，之后您可以使用获取到的cid调用此接口）

普通会话消息样例：

![msg1](https://img.alicdn.com/tps/TB1FVMvIFXXXXcnXXXXXXXXXXXX.jpg)

### 发送普通会话消息接口说明

###### 请求说明

Https请求方式: POST

`https://oapi.dingtalk.com/message/send_to_conversation?access_token=ACCESS_TOKEN`

###### 参数说明

参数 | 参数类型 | 必须 | 说明
---------- | ------- | ------- | ------
access_token |String | 是 | 调用接口凭证

###### 返回说明

如果是群，返回跟发送者同一家企业的一组工号；如果是个人聊天，只返回发送者同一家企业的一个工号；不在同一家企业，发送失败

```
{
    "errcode": 0,
    "errmsg": "ok",
    "receiver": "UserID1|UserID2"
}
```

## 发送企业会话消息

企业可以主动发消息给员工，消息量不受限制。

发送企业会话消息和发送普通会话消息的不同之处在于发送消息的主体不同
- 普通会话消息发送主体是普通员工，体现在接收方手机上的联系人是消息发送员工

- 企业会话消息发送主体是企业，体现在接收方手机上的联系人是你填写的agentid对应的微应用

调用接口时，使用Https协议、JSON数据包格式。

目前支持text、image、voice、file、link、OA消息类型。每个消息都由消息头和消息体组成，企业会话的消息头由touser,toparty,agentid组成。消息体请参见以下各种[<font color=red >消息类型</font>](#消息类型及数据格式)。

###### 参数说明

参数 | 参数类型 | 必须 | 说明
---------- | ------- | ------- | ------
touser |String | 否 | 员工ID列表（消息接收者，多个接收者用' &#124; '分隔）。特殊情况：指定为@all，则向该企业应用的全部成员发送
toparty |String | 否 | 部门id列表，多个接收者用' &#124; '分隔。当touser为@all时忽略本参数 <font color=red >touser或者toparty 二者有一个必填</font>
agentid | String | 是 |企业应用id，这个值代表以哪个应用的名义发送消息

企业会话消息样例：

![msg2](https://img.alicdn.com/tps/TB1PAQwIFXXXXXOXXXXXXXXXXXX.jpg)

### 发送企业消息接口说明

###### 请求说明

Https请求方式: POST

`https://oapi.dingtalk.com/message/send?access_token=ACCESS_TOKEN`

###### 参数说明

参数 | 参数类型 | 必须 | 说明
---------- | ------- | ------- | ------
access_token |String | 是 | 调用接口凭证

###### 返回说明

如果收件人、部门或标签不存在，发送仍然执行，但返回无效的部分。

```
{
    "errcode": 0,
    "errmsg": "ok",
    "invaliduser": "UserID1|UserID2",
    "invalidparty":"PartyID1"
}
```

## 消息类型及数据格式

### text消息

```
{
    "msgtype": "text",
    "text": {
        "content": "张三的请假申请"
    }
}
```

###### 参数说明

参数 | 参数类型 | 必须 | 说明
---------- | ------- | ------- | ------
msgtype |String | 是 | 消息类型，此时固定为：text
content |String | 是 | 消息内容

### image消息

```
{
    "msgtype": "image",
    "image": {
        "media_id": "MEDIA_ID"
    }
}
```

###### 参数说明

参数 | 参数类型 | 必须 | 说明
---------- | ------- | ------- | ------
msgtype |String | 是 | 消息类型，此时固定为：image
media_id | String | 是 | 图片媒体文件id，可以调用上传媒体文件接口获取。建议宽600像素 x 400像素，宽高比3：2

### voice消息

```
{
    "msgtype": "voice",
    "voice": {
       "media_id": "MEDIA_ID"
    }
}
```

###### 参数说明

参数 | 参数类型 | 必须 | 说明
---------- | ------- | ------- | ------
msgtype |String | 是 | 消息类型，此时固定为：voice
media_id |String | 是 | 语音媒体文件id，可以调用上传媒体文件接口获取。2MB，播放长度不超过60s，AMR格式

### file消息

```
{
    "msgtype": "file",
    "file": {
       "media_id": "MEDIA_ID"
    }
}
```

###### 参数说明

参数 | 参数类型 | 必须 | 说明
---------- | ------- | ------- | ------
msgtype | String| 是 | 消息类型，此时固定为：file
media_id |String | 是 | 媒体文件id，可以调用上传媒体文件接口获取。10MB


### link消息

```
{
    "msgtype": "link",
    "link": {
        "messageUrl": "http://s.dingtalk.com/market/dingtalk/error_code.php",
        "picUrl":"@lALOACZwe2Rk",
        "title": "测试",
        "text": "测试"
    }
}
```

###### 参数说明

参数 | 参数类型 | 必须 | 说明
---------- | ------- | ------- | ------
msgtype | String | 是 | 消息类型，此时固定为：link

##### link消息体格式

参数 | 参数类型 | 必须 | 说明
---------- | ------- | ------- | ------
link.messageUrl | String | 是 | 消息点击链接地址
link.picUrl | String | 是 | 图片媒体文件id，可以调用上传媒体文件接口获取
link.title | String | 是 | 消息标题
link.text | String | 是 | 消息描述

### OA消息

```
{
     "msgtype": "oa",
     "oa": {
        "message_url": "http://dingtalk.com",
        "head": {
            "bgcolor": "FFBBBBBB",
            "text": "头部标题"
        },
        "body": {
            "title": "正文标题",
            "form": [
                {
                    "key": "姓名:",
                    "value": "张三"
                },
                {
                    "key": "年龄:",
                    "value": "20"
                },
                {
                    "key": "身高:",
                    "value": "1.8米"
                },
                {
                    "key": "体重:",
                    "value": "130斤"
                },
                {
                    "key": "学历:",
                    "value": "本科"
                },
                {
                    "key": "爱好:",
                    "value": "打球、听音乐"
                }
            ],
            "rich": {
                "num": "15.6",
                "unit": "元"
            },
            "content": "大段文本大段文本大段文本大段文本大段文本大段文本大段文本大段文本大段文本大段文本大段文本大段文本",
            "image": "@lADOADmaWMzazQKA",
            "file_count": "3",
            "author": "李四 "
        }
    }
}
```

###### 参数说明

参数 | 参数类型 | 必须 | 说明
----- | ------- | ------- | ------
msgtype |String | 是 | 消息类型，此时固定为：oa

#### OA消息体内容

###### 参数说明

参数 | 参数类型 | 必须 | 说明
------ | ------- | ------- | ------
oa.message_url| String | 是 | 客户端点击消息时跳转到的H5地址
oa.pc_message_url| String | 否 | PC端点击消息时跳转到的H5地址
oa.head | String | 是 | 消息头部内容
oa.head.bgcolor | String | 是 | 消息头部的背景颜色。长度限制为8个英文字符，其中前2为表示透明度，后6位表示颜色值。不要添加0x
oa.head.text | String | 是 | 消息的头部标题
oa.body | Array[JSON Object] | 是 | 消息体
oa.body.title | String | 否 | 消息体的标题
oa.body.form | Array[JSON Object] | 否 | 消息体的表单，最多显示6个，超过会被隐藏
oa.body.form.key | String | 否 | 消息体的关键字
oa.body.form.value | String | 否 | 消息体的关键字对应的值
oa.body.rich | Array[JSON Object] | 否 | 单行富文本信息
oa.body.rich.num | String | 否 | 单行富文本信息的数目
oa.body.rich.unit | String | 否| 单行富文本信息的单位
oa.body.content | String | 否 | 消息体的内容，最多显示3行
oa.body.image | String | 否 | 消息体中的图片media_id
oa.body.file_count | String | 否 | 自定义的附件数目。此数字仅供显示，钉钉不作验证
oa.body.author | String | 否 | 自定义的作者名字

#### OA消息截图

![oames](https://img.alicdn.com/tps/TB1gVcFIFXXXXcGXXXXXXXXXXXX.jpg)

## 管理多媒体文件

企业在使用接口时，对多媒体文件、多媒体消息的获取和调用等操作，是通过media_id来进行的。通过本接口，企业可以上传或下载多媒体文件。

### 上传媒体文件

用于上传图片、语音等媒体资源文件以及普通文件（如doc，ppt），接口返回媒体资源标识ID：media_id。请注意，media_id是可复用的，同一个media_id可用于消息的多次发送。

###### 请求说明

Https请求方式: POST

`https://oapi.dingtalk.com/media/upload?access_token=ACCESS_TOKEN&type=TYPE`

###### 参数说明

参数 | 参数类型 | 必须 | 说明
---------- | ------- | ------- | ------
access_token | String | 是 | 调用接口凭证
type |String | 是 | 媒体文件类型，分别有图片（image）、语音（voice）、普通文件(file)
media |String | 是 | form-data中媒体文件标识，有filename、filelength、content-type等信息

###### 返回结果

```
{
    "errcode": 0,
    "errmsg": "ok",
    "type": "image",
    "media_id": "@dsa8d87y7c8d8c"
}
```

参数 |说明
---------- | ------
errcode | 错误码
errmsg | 错误信息
type | 媒体文件类型，分别有图片（image）、语音（voice）、普通文件(file)
media_id | 媒体文件上传后获取的唯一标识
created_at | 媒体文件上传时间戳

###### 上传的媒体文件限制

* 图片（image）:1MB，支持JPG格式
* 语音（voice）：2MB，播放长度不超过60s，AMR格式
* 普通文件（file）：10MB

### 获取媒体文件

通过media_id获取图片、语音等文件。



###### 请求说明

Https请求方式: GET

`https://oapi.dingtalk.com/media/get?access_token=ACCESS_TOKEN&media_id=MEDIA_ID`


###### 参数说明

```
  HTTP/1.1 200: OK
  Connection: close
  Content-Type: image/jpeg
  Content-disposition: attachment; filename="MEDIA_ID.jpg"
  Date: Sun, 04 Jan 2015 12:00:00 GMT
  Cache-Control: no-cache, must-revalidate
  Content-Length: 1234567
  ...
```

参数 |参数类型 | 必须 | 说明
---------- | ------- | ------- | ------
access_token |String | 是 | 调用接口凭证
media_id |String | 是 | 媒体文件的唯一标示


###### 返回说明


和普通的http下载相同，请根据http头做相应的处理。


a)正确时返回：

```
{
    "errcode": 40004,
    "errmsg": "invalid media_id"
}
```

b)错误时返回（这里省略了HTTP首部）：

## 免登

免登接口是关于用户无需输入用户名＋密码就可以实现登录，通过权限认证后获取用户身份的接口。

详细信息请查看[<font color=red >免登服务流程</font>](#免登服务)

### 通过CODE换取用户身份

企业应用的服务器在拿到CODE后，需要将CODE发送到钉钉开放平台接口，如果验证通过，则返回CODE对应的用户信息。**此接口只用于免登服务中用来换取用户信息**

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
    "is_sys": true,
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

### 通过CODE换取微应用管理员的身份信息

企业应用的服务器在拿到CODE后，需要将CODE发送到钉钉开放平台接口，如果验证通过，则返回CODE对应的管理员信息。**此接口只用于微应用后台管理员免登中用来换取管理员信息**

###### 请求说明

Https请求方式: GET

`https://oapi.dingtalk.com/sso/getuserinfo?access_token=ACCESS_TOKEN&code=CODE`

###### 参数说明

参数 | 参数类型 | 必须 | 说明
---------- | ------- | ------- | ------
access_token | String | 是 | 再次强调，此token不同于一般的accesstoken，需要调用[<font color=red >获取微应用管理员免登需要的AccessToken</font>](#获取管理员免登token)
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

##普通钉钉用户账号开放

###获取钉钉开放应用的ACCESS_TOKEN

第三方web服务提供商取得钉钉开放应用的appid及appsecret后，可以获取开放应用的ACCESS_TOKEN

###### 请求说明


Https请求方式: GET

`https://oapi.dingtalk.com/sns/gettoken?appid=APPID&appsecret=APPSECRET`


###### 参数说明

参数 | 参数类型 | 必须 | 说明
---------- | ------- | ------- | ------
appid | String | 是 | 由钉钉开放平台提供给开放应用的唯一标识
appsecret | String | 是 | 由钉钉开放平台提供的密钥

###### 返回结果

正确时返回示例如下

```
{
    "access_token": "070c171a26d633d1b631dxxxxxxxx", 
    "errcode": 0, 
    "errmsg": "ok"
}
```

参数 | 说明
---------- | ------
access_token | token的值


###获取用户授权的持久授权码

###### 请求说明

Https请求方式: POST

`https://oapi.dingtalk.com/sns/get_persistent_code?access_token=ACCESS_TOKEN`

POST 正文

```
{
    "tmp_auth_code": "23152698ea18304da4d0ce1xxxxx"
}
```

###### 参数说明

参数 | 参数类型 | 必须 | 说明
---------- | ------- | ------- | ------
access_token | String | 是 | 开放应用的token
tmp_auth_code | String | 是 | 用户授权给钉钉开放应用的临时授权码

###### 返回结果

正确时返回示例如下

```
{
    "errcode": 0, 
    "errmsg": "ok", 
    "openid": "liSii8KCxxxxx", 
    "persistent_code": "dsa-d-asdasdadHIBIinoninINIn-ssdasd", 
    "unionid": "7Huu46kk"
}
```

参数 | 说明
---------- | ------
openid | 用户在当前开放应用内的唯一标识
unionid | 用户在当前钉钉开放平台账号范围内的唯一标识，同一个钉钉开放平台账号可以包含多个开放应用，同时也包含ISV的套件应用及企业应用
persistent_code | 用户给开放应用授权的持久授权码，此码目前无过期时间


###获取用户授权的SNS_TOKEN

###### 请求说明

Https请求方式: POST

`https://oapi.dingtalk.com/sns/get_sns_token?access_token=ACCESS_TOKEN`

POST 正文

```
{
    "openid": "liSii8KCxxxxx", 
    "persistent_code": "dsa-d-asdasdadHIBIinoninINIn-ssdasd"
}
```

###### 参数说明

参数 | 参数类型 | 必须 | 说明
---------- | ------- | ------- | ------
access_token | String | 是 | 开放应用的token
openid | String | 是 | 用户的openid
persistent_code | String | 是 | 用户授权给钉钉开放应用的持久授权码

###### 返回结果

正确时返回示例如下

```
{
    "errcode": 0, 
    "errmsg": "ok", 
    "expires_in": 7200, 
    "sns_token": "c76dsc87ds6c876sd87csdcxxxxx"
}
```

参数 | 说明
---------- | ------
expires_in | sns_token的过期时间
sns_token | 用户授权的token

###获取用户授权的个人信息

###### 请求说明

Https请求方式: GET

`https://oapi.dingtalk.com/sns/getuserinfo?sns_token=SNS_TOKEN`

###### 参数说明

参数 | 参数类型 | 必须 | 说明
---------- | ------- | ------- | ------
sns_token | String | 是 | 用户授权给开放应用的token

###### 返回结果

正确时返回示例如下

```
{
    "corp_info": [
        {
            "corp_name": "阿里巴巴", 
            "is_auth": true, 
            "is_manager": false, 
            "rights_level": 100
        }, 
        {
            "corp_name": "DingTalk", 
            "is_auth": true, 
            "is_manager": false, 
            "rights_level": 200
        }
    ], 
    "errcode": 0, 
    "errmsg": "ok", 
    "user_info": {
        "maskedMobile": "130****1234", 
        "nick": "张三", 
        "openid": "liSii8KCxxxxx", 
        "unionid": "7Huu46kk"
    }
}
```

参数 | 说明
---------- | ------
corp_info | 企业信息
is_auth | 企业是否经过钉钉认证
is_manager | 当前用户是否为该企业的管理人员
rights_level | 该企业的权益等级
corp_name | 企业名称
maskedMobile | 经过处理的手机号
nick | 用户在钉钉上面的昵称

openid | 用户在当前开放应用内的唯一标识
unionid | 用户在当前开放应用所属的钉钉开放平台账号内的唯一标识


##统计数据

###记录统计数据

用户在使用微应用的时候，企业可以通过这个接口记录微应用使用的相关信息，比如调用时间，结束时间等等。钉钉的数据分析工具会对这些数据进行汇总。

###### 请求说明

Https请求方式：POST

`https://oapi.dingtalk.com/data/record?access_token=ACCESS_TOKEN`

###### 参数说明

参数 | 参数类型 | 必须 | 说明
---------- | ------- | ------- | ------
access_token | String | 是 | 调用接口凭证
startTimeMs | String | 是 | 事件发生时间，单位为距离1970的毫秒数
endTimeMs | String | 是 | 事件结束时间（瞬间结束的，该值和发生事件一致）
module | String | 否 | 微应用提供区分内部模块的标记
originId | String | 否 | 微应用中该记录的主键索引
userid | String | 是 | 员工在企业内的UserID，企业用来唯一标识用户的字段
agentId | String | 是 | 授权方应用id
callbackUrl | String | 是 | 针对该条数据的回调url
extension | JSONObject | 否 | 扩展字段，json格式,具体的业务数据模型的定义，请参考附录二，现只开放考勤类业务数据模型

######  返回结果

```
{
    "errcode": 0,
    "id":"$:LWCP_v1:$t3G6JuXLNr7pd0fWOQKS2w==",
    "errmsg": "ok"
}
```
参数 |  说明
---------- | -------
id      | 数据标识id
errcode | 返回码
errmsg | 对返回码的文本描述内容

###更新统计数据

isv企业可以通过这个接口更新微应用数据，所更新的数据必须是通过/data/record接口插入的，现在只能更新module，callbackUrl，extension三个字段。

###### 请求说明

Https请求方式：POST

`https://oapi.dingtalk.com/data/update?access_token=ACCESS_TOKEN`

###### 参数说明

参数 | 参数类型 | 必须 | 说明
---------- | ------- | ------- | ------
id| String| 是|使用/data/record接口插入数据时返回的id
access_token | String | 是 | 调用接口凭证
startTimeMs | String | 是 | 事件发生时间，单位为距离1970的毫秒数
endTimeMs | String | 是 | 事件结束时间（瞬间结束的，该值和发生事件一致）
module | String | 否 | 微应用提供区分内部模块的标记
originId | String | 否 | 微应用中该记录的主键索引
userid | String | 是 | 员工在企业内的UserID，企业用来唯一标识用户的字段
agentId | String | 是 | 授权方应用id
callbackUrl | String | 是 | 针对该条数据的回调url
extension | JSONObject | 否 | 扩展字段，json格式,具体的业务数据模型的定义，请参考附录二，现只开放考勤类业务数据模型
######  返回结果

```
{
"errcode": 0,
"errmsg": "ok"
}
```
参数 |  说明
---------- | -------
errcode | 返回码
errmsg | 对返回码的文本描述内容



## JS接口API

### 获取jsapi_ticket

企业在使用微应用中的JS API时，需要先从钉钉开放平台接口获取jsapi_ticket生成签名数据，并将最终签名用的部分字段及签名结果返回到H5中，JS API底层将通过这些数据判断H5是否有权限使用JS API。

###### 请求说明
Https请求方式：GET

`https://oapi.dingtalk.com/get_jsapi_ticket?access_token=ACCESS_TOKE`

###### 参数说明
参数 | 参数类型 | 必须 | 说明
---------- | ------- | ------- | ------
access_token | String | 是 | 调用接口凭证
type | String | 是 | 这里是固定值，jsapi

######  返回结果
正确时返回示例如下：

```
{
    "errcode": 0,
    "errmsg": "ok",
    "ticket": "dsf8sdf87sd7f87sd8v8ds0vs09dvu09sd8vy87dsv87",
    "expires_in": 7200
}
```

参数 | 说明
---------- | ------
errcode | 错误码
errmsg | 错误信息
ticket | 用于JS API的临时票据
expires_in | 票据过期时间

出错时返回示例如下：

```
{
    "errcode": 45009,
    "errmsg": "接口调用超过限制"
}
```

### JS-SDK

JS-SDK 为H5页面提供了一系列原生UI控件或者服务的JS接口，文档地址如下：

[<font color=red >客户端开发文档</font>](#客户端开发文档)


<!--## 管理日历接入指南
 钉钉提供微应用接入管理日历的能力。目前处于测试阶段，为了保证接入的质量以及良好的用户体验，接入方需要与钉钉管理日历团队协商接入方案。

由于不同接入方的业务不完全一致，如果接入方希望以与本文档不同的形式接入，可以向我们提出合作邀请，我们也提供定制化接入支持。（联系邮箱：pstar.zhangp@alibaba-inc.com）

管理日历目前已接入多个微应用，例如：签到、审批、考勤、日志、拜访计划等。
    
具体接入文档查看：[管理日历接入指南](http://download.taobaocdn.com/freedom/31112/pdf/p1a6htv7hq1o3p63g9ahpq51n5q4.pdf)
-->
## 附录
### 附录一 全局返回码说明

开发者每次调用接口时，可能获得正确或错误的返回码，企业可以根据返回码信息调试接口，排查错误。

###### 全局返回码说明如下：


参数 | 说明
 ---- | -----
 -1 | 系统繁忙
 0 | 请求成功
404 | 请求的URI地址不存在
33001 | 无效的企业ID
33002 | 无效的微应用的名称
33003 | 无效的微应用的描述
33004 | 无效的微应用的ICON
33005 | 无效的微应用的移动端主页
33006 | 无效的微应用的PC端主页
33007 | 微应用的移动端的主页与PC端主页不同
33008 | 无效的微应用OA后台的主页
34001 | 无效的会话id
34002 | 无效的会话消息的发送者
34003 | 无效的会话消息的发送者的企业Id
34004 | 无效的会话消息的类型
34005 | 无效的会话音频消息的播放时间
34006 | 发送者不在企业中
34007 | 发送者不在会话中
34008 | 图片不能为空
34009 | 链接内容不能为空
34010 | 文件不能为空
34011 | 音频文件不能为空
34012 | 找不到发送者的企业
34013 | 找不到群会话对象
34014 | 会话消息的json结构无效或不完整
40001 | 获取access_token时Secret错误，或者access_token无效
40002 | 不合法的凭证类型
40003 | 不合法的UserID
40004 | 不合法的媒体文件类型
40005 | 不合法的文件类型
40006 | 不合法的文件大小
40007 | 不合法的媒体文件id
40008 | 不合法的消息类型
40009 | 不合法的部门id
40010 | 不合法的父部门id
40011 | 不合法的排序order
40012 | 不合法的发送者
40013 | 不合法的corpid
40014 | 不合法的access_token
40015 | 发送者不在会话中
40016 | 不合法的会话ID
40017 | 在会话中没有找到与发送者在同一企业的人
40018 | 不允许以递归方式查询部门用户列表
40019 | 该手机号码对应的用户最多可以加入5个非认证企业
40020 | 当前团队人数已经达到上限,用电脑登录钉钉企业管理后台，升级成为认证企业
40021 | 更换的号码已注册过钉钉，无法使用该号码
40022 | 企业中的手机号码和登陆钉钉的手机号码不一致,暂时不支持修改用户信息,可以删除后重新添加
40023 | 部门人数达到上限
40025 | 无效的部门JSONArray对象,合法格式需要用中括号括起来,且如果属于多部门,部门id需要用逗号分隔
60107 | 使用该手机登录钉钉的用户已经在企业中
40029 | 不合法的oauth_code
40031 | 不合法的UserID列表
40032 | 不合法的UserID列表长度
40033 | 不合法的请求字符，不能包含\uxxxx格式的字符
40035 | 不合法的参数
40038 | 不合法的请求格式
40039 | 不合法的URL长度
40048 | url中包含不合法domain
40055 | 不合法的agent结构
40056 | 不合法的agentid
40057 | 不合法的callbackurl
40061 | 设置应用头像失败
40062 | 不合法的应用模式
40063 | 不合法的分机号	
40064 | 不合法的工作地址	
40065 | 不合法的备注	
40066 | 不合法的部门列表
40067 | 标题长度不合法
40068 | 不合法的偏移量
40069 | 不合法的分页大小
40070 | 不合法的排序参数
40073 | 不存在的openid
40077 | 不存在的预授权码
40078 | 不存在的临时授权码
40079 | 不存在的授权信息
40080 | 不合法的suitesecret
40082 | 不合法的suitetoken
40083 | 不合法的suiteid
40084 | 不合法的永久授权码
40085 | 不存在的suiteticket
40086 | 不合法的第三方应用appid
40087 | 创建永久授权码失败
40088 | 不合法的套件key或secret
40089 | 不合法的corpid或corpsecret
40090 | 套件已经不存在
40091 | 用户授权码创建失败,需要用户重新授权
41001 | 缺少access_token参数
41002 | 缺少corpid参数
41003 | 缺少refresh_token参数
41004 | 缺少secret参数
41005 | 缺少多媒体文件数据
41006 | 缺少media_id参数
41007 | 无效的ssocode
41008 | 缺少oauth
41009 | 缺少UserID
41010 | 缺少url
41011 | 缺少agentid
41012 | 缺少应用头像mediaid
41013 | 缺少应用名字
41014 | 缺少应用描述
41015 | 缺少Content
41016 | 缺少标题
41021 | 缺少suitekey
41022 | 缺少suitetoken
41023 | 缺少suiteticket
41024 | 缺少suitesecret
41025 | 缺少permanent_code
41026 | 缺少tmp_auth_code
41027 | 需要授权企业的corpid参数
41030 | 企业未对该套件授权
41031 | auth_corpid和permanent_code不匹配
41100 | 时间参数不合法
41101 | 数据内容过长
41102 | 参数值过大
42001 | access_token超时
42002 | refresh_token超时
42003 | oauth_code超时
42007 | 预授权码失效
42008 | 临时授权码失效
42009 | suitetoken失效
43001 | 需要GET请求
43002 | 需要POST请求
43003 | 需要HTTPS
43004 | 无效的HTTP HEADER Content-Type
43005 | 需要Content-Type为application/json;charset=UTF-8
43007 | 需要授权
43008 | 参数需要multipart类型
43009 | post参数需要json类型
43010 | 需要处于回调模式
43011 | 需要企业授权
44001 | 多媒体文件为空
44002 | POST的数据包为空
44003 | 图文消息内容为空
44004 | 文本消息内容为空
45001 | 多媒体文件大小超过限制
45002 | 消息内容超过限制
45003 | 标题字段超过限制
45004 | 描述字段超过限制
45005 | 链接字段超过限制
45006 | 图片链接字段超过限制
45007 | 语音播放时间超过限制
45008 | 图文消息超过限制
45009 | 接口调用超过限制
45016 | 系统分组，不允许修改
45017 | 分组名字过长
45018 | 分组数量超过上限
45024 | 账号数量超过上限
46001 | 不存在媒体数据
46004 | 不存在的员工
47001 | 解析JSON/XML内容错误
48002 | Api禁用
48003 | suitetoken无效
48004 | 授权关系无效
49000 | 缺少chatid
49001 | 绑定的微应用超过个数限制
49002 | 一个群只能被一个ISV套件绑定一次
49003 | 操作者必须为群主
49004 | 添加成员列表和删除成员列表不能有交集
49005 | 群人数超过人数限制
49006 | 群成员列表必须包含群主
49007 | 超过创建群的个数上限
50001 | redirect_uri未授权
50002 | 员工不在权限范围
50003 | 应用已停用
50005 | 企业已禁用
51000 | 跳转的域名未授权
51001 | 跳转的corpid未授权
51002 | 跳转请求不是来自钉钉客户端
51003 | 跳转找不到用户信息
51004 | 跳转找不到用户的企业信息
51005 | 跳转用户不是企业管理员
51006 | 跳转生成code失败
51007 | 跳转获取用户企业身份失败
51008 | 跳转url解码失败
51009 | 要跳转的地址不是标准url
52010 | 无效的corpid
52011 | jsapi ticket 读取失败
52012 | jsapi 签名生成失败
52013 | 签名校验失败
52014 | 无效的url参数
52015 | 无效的随机字符串参数
52016 | 无效的签名参数
52017 | 无效的jsapi列表参数
52018 | 无效的时间戳
52019 | 无效的agentid
60001 | 不合法的部门名称
60002 | 部门层级深度超过限制
60003 | 部门不存在
60004 | 父亲部门不存在
60005 | 不允许删除有成员的部门
60006 | 不允许删除有子部门的部门
60007 | 不允许删除根部门
60008 | 父部门下该部门名称已存在
60009 | 部门名称含有非法字符
60010 | 部门存在循环关系
60011 | 管理员权限不足，（user/department/agent）无权限
60012 | 不允许删除默认应用
60013 | 不允许关闭应用
60014 | 不允许开启应用
60015 | 不允许修改默认应用可见范围
60016 | 部门id已经存在
60017 | 不允许设置企业
60018 | 不允许更新根部门
60019 | 从部门查询人员失败
60020 | 访问ip不在白名单之中
60066 | 企业的设置不存在
60067 | 部门的企业群群主不存在
60068 | 部门的管理员不存在
60102 | UserID在公司中已存在
60103 | 手机号码不合法
60104 | 手机号码在公司中已存在
60105 | 邮箱不合法
60106 | 邮箱已存在
60107 | 使用该手机登录钉钉的用户已经在企业中
60110 | 部门个数超出限制
60111 | UserID不存在
60112 | 用户name不合法
60113 | 身份认证信息（手机/邮箱）不能同时为空
60114 | 性别不合法
60118 | 用户无有效邀请字段（邮箱，手机号）
60119 | 不合法的position
60120 | 用户已禁用
60121 | 找不到该用户
60122 | 不合法的extattr 
60123 | 不合法的jobnumber
60124 | 用户不在此群中
60125 | CRM配置信息创建失败
60126 | CRM配置信息更新失败
60127 | CRM人员配置信息删除失败
70001 | 企业不存在或者已经被解散
70002 | 获取套件下的微应用失败 
70003 | agentid对应微应用不存在
70004 | 企业下没有对应该agentid的微应用 
70005 | ISV激活套件失败 
71006 | 回调地址已经存在
71007 | 回调地址已不存在
71008 | 回调call_back_tag必须在指定的call_back_tag列表中
71009 | 返回文本非success
71010 | POST的JSON数据不包含所需要的参数字段或包含的参数格式非法
71011 | 传入的url参数不是合法的url格式
71012 | url地址访问异常,错误原因为:%s
71013 | 此域名或IP不能注册或者接收回调事件
72001 | 获取钉盘空间失败
72002 | 授权钉盘空间访问权限失败
80001 | 可信域名没有IPC备案，后续将不能在该域名下正常使用jssdk
81001 | 两个用户没有任何关系，请先相互成为好友
81002 | 用户拒收消息
88005 | 管理日历个人日历操作失败
89001 | 管理日历启动导出任务失败
89011 | 管理日历写入数据失败
89012 | 管理日历更新数据失败
90001 | 您的服务器调用钉钉开放平台所有接口的请求都被暂时禁用了
90002 | 您的服务器调用钉钉开放平台当前接口的所有请求都被暂时禁用了
90003 | 您的企业调用钉钉开放平台所有接口的请求都被暂时禁用了,仅对企业自己的Accesstoken有效
90004 | 您当前使用的CorpId及CorpSecret被暂时禁用了,仅对企业自己的Accesstoken有效
90005 | 您的企业调用当前接口次数过多,请求被暂时禁用了,仅对企业自己的Accesstoken有效
90006 | 您当前使用的CorpId及CorpSecret调用当前接口次数过多,请求被暂时禁用了,仅对企业自己的Accesstoken有效
90007 | 您当前要调用的企业的接口次数过多,对该企业的所有请求都被暂时禁用了,仅对企业授权给ISV的Accesstoken有效
90008 | 您当前要调用的企业的当前接口次数过多,对此企业下该接口的所有请求都被暂时禁用了,仅对企业授权给ISV的Accesstoken有效
90009 | 您调用企业接口超过了限制,对所有企业的所有接口的请求都被暂时禁用了,仅对企业授权给ISV的Accesstoken有效
90010 | 您调用企业当前接口超过了限制,对所有企业的该接口的请求都被暂时禁用了,仅对企业授权给ISV的Accesstoken有效
90011 | 您的套件调用企业接口超过了限制,该套件的所有请求都被暂时禁用了,仅对企业授权给ISV的Accesstoken有效
90012 | 您的套件调用企业当前接口超过了限制,该套件对此接口的所有请求都被暂时禁用了,仅对企业授权给ISV的Accesstoken有效
90013 | 您的套件调用当前企业的接口超过了限制,该套件对此企业的所有请求都被暂时禁用了,仅对企业授权给ISV的Accesstoken有效
90014 | 您的套件调用企业当前接口超过了限制,该套件对此企业该接口的所有请求都被暂时禁用了,仅对企业授权给ISV的Accesstoken有效
900001 | 加密明文文本非法
900002 | 加密时间戳参数非法
900003 | 加密随机字符串参数非法
900004 | 不合法的aeskey
900005 | 签名不匹配
900006 | 计算签名错误
900007 | 计算加密文字错误
900008 | 计算解密文字错误
900009 | 计算解密文字长度不匹配
900010 | 计算解密文字corpid不匹配


###附录二  微应用数据中心业务模型定义
######考勤业务数据模型

```

{
    "type": "attendance",
    "category": "类别，10-正常打卡，11-异常打卡，12-旷工，13-未设置考勤规则，14-范围外打卡，15-未到岗",
    "stdWorkingTime": "标准工作时长，格式为数字，单位毫秒",
    "actualWorkingTime": "实际工作时长，格式为数字，单位毫秒",
    "originUrl": "业务数据跳转url",
    "reportLocations":[
        {
            "id" : "上报位置标识",
            "address": "上报标识",
            "time": "上报时间，时间戳，格式为数字，单位毫秒"
        }
    ],

    "items":[
        "originId" : "业务数据标识",
        "originUrl" : "业务数据跳转url",
        "status": "考勤状态，20-正常，21-迟到，22-早退，23-未打卡，24-缺卡",
        "outOfScope": "是否范围外，0-否，1-是",
        "classId": "班次标识",
        "className": "班次名称",
        "periodId": "时段标识",
        "periodName": "时段名称",
        "periodStartTime": "考勤时间段开始时间，时间戳，格式为数字，单位毫秒",
        "periodEndTime": "考勤时间段结束时间，时间戳，格式为数字，单位毫秒",
        "checkStartTime" : "有效打卡开始时间，时间戳，格式为数字，单位毫秒",
        "checkEndTime" : "有效打卡结束时间，时间戳，格式为数字，单位毫秒",
        "checkTime": "设置的标准打卡时间，时间戳，格式为数字，单位毫秒",
        "signTime": "实际考勤打卡时间，时间戳，格式为数字，单位毫秒",
        "signPlace": "实际考勤地点",
        "signOffset": "实际偏移距离，单位米",
        "signWifi": "实际的考勤wifi",
        "signWifiMAC" : "实际的考勤wifiMAC",
        "checkPlace" : "设置的考勤地点",
        "checkOffset": "设置的偏移距离，单位米",
        "checkWifi" :"设置的考勤wifi",
        "checkWifiMAC" :"设置的考勤wifiMAC",
        "duty": "上下班,0-上班，1-下班",
        "absentTime": "迟到或早退的时长，格式为数字，单位毫秒",
        "supplement": "是否已补签，0-否，1-是"
    ]   

}

```
## Demo

提供了使用Java、PHP、Nodejs 接入钉钉开放平台API的代码示例，和在线调试工具

下面的代码示例展示了一些常用API的使用方式，在运行下面的示例前请先获取CorpID和CorpSecret，并按照示例下的说明配置到合适的位置。

### 调试工具

[<font color=red >钉钉服务端API调试工具</font>](https://debug.dingtalk.com)

### Java版本

```javascript
 public class Env {
  public static final String OAPI_HOST = "https://oapi.dingtalk.com";
    public static final String CORP_ID = "corpid";
    public static final String CORP_SECRET = "secret";
 }

```

1.将您的CorpID和CorpSecret配置在Env.java文件

2.启动您的服务器，如果配置正确，则会成功启动。

[<font color=red >Demo地址：</font>](https://github.com/ddtalk/HarleyCorp)
[<font color=red >https://github.com/ddtalk/HarleyCorp</font>](https://github.com/ddtalk/HarleyCorp)

### PHP版本

```javascript
 define("OAPI_HOST", "https://oapi.dingtalk.com");
 define("CORPID", "");
 define("SECRET", "");
```

1.将您的CorpID和CorpSecret配置在env.php文件

2.启动您的服务器，如果配置正确，则会成功启动。

[<font color=red >Demo地址：</font>](https://github.com/injekt/openapi-demo-php)
[<font color=red >https://github.com/injekt/openapi-demo-php</font>](https://github.com/injekt/openapi-demo-php)

### Node.js版本

```javascript
module.exports = {
    corpId: '',
    secret: ''
};
```

1.将您的CorpID和CorpSecret配置在env.js文件

2.启动您的服务器，如果配置正确，则会成功启动。

[<font color=red >Demo地址：</font>](https://github.com/injekt/openapi-demo-nodejs)
[<font color=red >https://github.com/injekt/openapi-demo-nodejs</font>](https://github.com/injekt/openapi-demo-nodejs)
