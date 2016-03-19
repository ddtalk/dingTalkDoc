# 调试工具和性能优化
## 调试工具
- [<font color=red >钉钉服务端API调试工具</font>](https://debug.dingtalk.com)

- [<font color=red >ISV接入调试工具</font>](https://debug.dingtalk.com/isv.html)

- [<font color=red >JSAPI调试工具</font>](http://wsdebug.dingtalk.com/)（打开页面后，手机扫描二维码，然后在页面上配置参数，即可调试）

## H5性能优化方案

在钉钉移动客户端上的微应用通过H5来实现，当前H5的渲染性能相较native的app有一定差距，为了提升H5的性能，从体验上与native app缩短差距，我们提供了一份H5性能优化的方案，详细内容见blog中的[<font color=red> H5性能优化方案</font>](http://ddtalk.github.io/blog/2015/09/07/dingding-first/)。

## 微应用性能评测

微应用的性能测验主要是对微应用的整体性能进行评分，这其中包括但不仅限于首屏打开时间等指标。<br>

流程如下：<br>

1、微应用进行性能评测前首先需要确保我们的测试帐号被加入到将要测验的企业里。目前的测试帐号有以下几个：<font color=blue > 13291824394, 15210137915，15810497158。 </font> <br>

2、<a href="http://mqc.aliyun.com/hfive.htm?from=dingtalk">点击打开测验页面</a> <br>

3、然后，按照提示，输入要测试的H5应用地址，下一步选择手机即可开始测验。<br>

4、测验完成之后，就可以看到测试报告了。测试报告会给出被测试的微应用的整体打分。（打分机制还在不断优化，欢迎大家针对特殊的case提出建议）。测试报告同时会给出被测验的微应用需要优化的内容，开发者可以根据测试报告的优化建议进行相关优化，待优化完成可以再次发起测验流程，并查看报告。<br>



## CDN服务

钉钉开放平台为常用的js库提供了CDN加速服务，这样做不仅可以为您节省流量，还可以获得更快的访问速度。

###  backbone

[http://g.alicdn.com/ilw/cdnjs/backbone/1.2.1/backbone-min.js](http://g.alicdn.com/ilw/cdnjs/backbone/1.2.1/backbone-min.js)

[http://g.alicdn.com/ilw/cdnjs/backbone/1.2.1/backbone.js](http://g.alicdn.com/ilw/cdnjs/backbone/1.2.1/backbone.js)
   
### jquery

[http://g.alicdn.com/ilw/cdnjs/jquery/2.1.4/jquery.min.js](http://g.alicdn.com/ilw/cdnjs/jquery/2.1.4/jquery.min.js)

[http://g.alicdn.com/ilw/cdnjs/jquery/2.1.4/jquery.js](http://g.alicdn.com/ilw/cdnjs/jquery/2.1.4/jquery.js)

[http://g.alicdn.com/ilw/cdnjs/jquery/1.8.3/jquery.min.js](http://g.alicdn.com/ilw/cdnjs/jquery/1.8.3/jquery.min.js)

[http://g.alicdn.com/ilw/cdnjs/jquery/1.8.3/jquery.js](http://g.alicdn.com/ilw/cdnjs/jquery/1.8.3/jquery.js)

### underscore

[http://g.alicdn.com/ilw/cdnjs/underscore/1.8.3/underscore-min.js](http://g.alicdn.com/ilw/cdnjs/underscore/1.8.3/underscore-min.js)

[http://g.alicdn.com/ilw/cdnjs/underscore/1.8.3/underscore.js](http://g.alicdn.com/ilw/cdnjs/underscore/1.8.3/underscore.js)

### zepto

[http://g.alicdn.com/ilw/cdnjs/zepto/1.1.6/zepto.min.js](http://g.alicdn.com/ilw/cdnjs/zepto/1.1.6/zepto.min.js)

[http://g.alicdn.com/ilw/cdnjs/zepto/1.1.6/zepto.js](http://g.alicdn.com/ilw/cdnjs/zepto/1.1.6/zepto.js)