# CitySelector-(三级城市选择器-加强版)

## 使用方法:(联系我:qq->1648305422--亲测可用,好用的话记得给星)
1.将文件夹拖入项目(删去图片)
<div></div>
2.导入头文件 STPickerArea.h
<pre><code>
     //一行代码就行
 [STPickerArea shareWithMode:STPickerContentModeBottom].block = ^(NSString *province,NSString *city, 
 NSString *area, NSString *provinceId ,
 NSString *cityId ,NSString *areaId){ // eg:在此读取需要的城市名称和codeID  
   NSLog(@"province:%@,city:%@,area:%@",province,city,area); 
       };
</code></pre>
       
 <div>图片效果如下:</div>  
![Alt text](/img.png)

### 改写自如下开源库(增加了读取城市Id的功能)

    Created by https://github.com/STShenZhaoliang/STPickerView on 16/2/15.
    Copyright © 2016年 shentian. All rights reserved.
