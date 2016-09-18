# CitySelector-(三级城市选择器-加强版)

##使用方法:
1.将文件夹拖入项目

2.导入头文件 STPickerArea.h, 按照如下方式初始化,设置代理遵守协议STPickerAreaDelegate
<pre><code>
     eg:
        STPickerArea *pickerArea = [[STPickerArea alloc]init];
        [pickerArea setDelegate:self]; //设置代理
        [pickerArea setContentMode:STPickerContentModeCenter]; //选择器出现在屏幕的位置
        [pickerArea show];
</code></pre>
       
3.实现代理方法:
<pre><code>
- (void)pickerArea:(STPickerArea *)pickerArea province:(NSString *)province city:(NSString *)city 
  area:(NSString *)area provinceId:(NSString *)provinceId cityId:(NSString *)cityId areaId:(NSString *)areaId{

    //在此读取需要的城市名称和codeID
    
}
</code></pre>
 
##改写自如下开源库(增加了读取城市Id的功能)

//  Created by https://github.com/STShenZhaoliang/STPickerView on 16/2/15.

//  Copyright © 2016年 shentian. All rights reserved.
