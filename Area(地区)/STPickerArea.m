//
//  STPickerArea.m
//  STPickerView
//
//  Created by https://github.com/STShenZhaoliang/STPickerView on 16/2/15.
//  Copyright © 2016年 shentian. All rights reserved.
//

#import "STPickerArea.h"

@interface STPickerArea()<UIPickerViewDataSource, UIPickerViewDelegate>

/** 1.数据源数组 */
@property (nonatomic, strong, nullable)NSArray *arrayRoot;
@property (nonatomic, strong, nullable)NSArray *arrayRootJson;

/** 2.当前省数组 */
@property (nonatomic, strong, nullable)NSMutableArray *arrayProvince;
@property (nonatomic, strong, nullable)NSMutableArray *arrayProvinceId;

/** 3.当前城市数组 */
@property (nonatomic, strong, nullable)NSMutableArray *arrayCity;
@property (nonatomic, strong, nullable)NSMutableArray *arrayCityId;

/** 4.当前地区数组 */
@property (nonatomic, strong, nullable)NSMutableArray *arrayArea;
@property (nonatomic, strong, nullable)NSMutableArray *arrayAreaId;

/** 5.当前选中数组 */
@property (nonatomic, strong, nullable)NSMutableArray *arraySelected;

/** 6.省份 */
@property (nonatomic, strong, nullable)NSString *province;
@property (nonatomic, strong, nullable)NSString *provinceId;

/** 7.城市 */
@property (nonatomic, strong, nullable)NSString *city;
@property (nonatomic, strong, nullable)NSString *cityId;

/** 8.地区 */
@property (nonatomic, strong, nullable)NSString *area;
@property (nonatomic, strong, nullable)NSString *areaId;

@end

@implementation STPickerArea

#pragma mark - --- init 视图初始化 ---

- (void)setupUI
{
    //1.从本地读取 Jason 数据
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"ChinaCity" ofType:@"json"];
    NSData *data=[NSData dataWithContentsOfFile:jsonPath];
    NSError *error;
    NSArray *jsonObject=[NSJSONSerialization JSONObjectWithData:data
                                                  options:NSJSONReadingAllowFragments
                                                    error:&error];
    self.arrayRootJson = [NSArray arrayWithArray:jsonObject];
   // 2.读取省份
    [jsonObject enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.arrayProvince addObject:obj[@"areaName"]];
        [self.arrayProvinceId addObject:obj[@"areaId"]];
        if (idx == 0) {
            NSMutableArray *tempCityArr = [NSMutableArray arrayWithArray:jsonObject[idx][@"cities"]];
            [tempCityArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.arrayCity addObject:obj[@"areaName"]];
                [self.arrayCityId addObject:obj[@"areaId"]];
                if (idx == 0) {
                    NSMutableArray *tempContiesArr = [NSMutableArray arrayWithArray:tempCityArr[idx][@"counties"]];
                    [tempContiesArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [self.arrayArea addObject:obj[@"areaName"]];
                        [self.arrayAreaId addObject:obj[@"areaId"]];
                    }];
                }
            }];
        }
    }];

    self.province = self.arrayProvince[0];
    self.city = self.arrayCity[0];
    self.area = self.arrayArea[0];
    self.arrayProvinceId = self.arrayProvinceId[0];
    self.cityId = self.arrayCityId[0];
    self.areaId = self.arrayAreaId[0];
    // 2.设置视图的默认属性
    _heightPickerComponent = 32;
    [self setTitle:@"请选择城市地区"];
    [self.pickerView setDelegate:self];
    [self.pickerView setDataSource:self];

}
#pragma mark - --- delegate 视图委托 ---

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.arrayProvince.count;
    }else if (component == 1) {
        return self.arrayCity.count;
    }else{
        return self.arrayArea.count;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return self.heightPickerComponent;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        
        self.arraySelected = self.arrayRootJson[row][@"cities"];
        NSLog(@"self.arraySelected: %@",self.arraySelected);
        [self.arrayCity removeAllObjects];
        [self.arrayCityId removeAllObjects];
        [self.arrayArea removeAllObjects];
        [self.arrayAreaId removeAllObjects];
        [self.arraySelected  enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.arrayCity addObject:obj[@"areaName"]];
            [self.arrayCityId addObject:obj[@"areaId"]];
            NSMutableArray *tempContiesArr = [NSMutableArray arrayWithArray:obj[@"counties"]];
            [tempContiesArr enumerateObjectsUsingBlock:^(id  _Nonnull obj2, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.arrayArea addObject:obj2[@"areaName"]];
                [self.arrayAreaId addObject:obj2[@"areaId"]];
            }];
        }];
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView selectRow:0 inComponent:2 animated:YES];

    }else if (component == 1) {
        if (self.arraySelected.count == 0) {
            self.arraySelected = [self.arrayRootJson firstObject][@"cities"];
        }
        
        [self.arrayArea removeAllObjects];
        [self.arrayAreaId removeAllObjects];
        NSMutableArray *tempContiesArr = [NSMutableArray arrayWithArray:self.arraySelected[row][@"counties"]];
        [tempContiesArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.arrayArea addObject:obj[@"areaName"]];
            [self.arrayAreaId addObject:obj[@"areaId"]];
        }];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }else{
    }

    [self reloadData];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{

    NSString *text;
    if (component == 0) {
        text =  self.arrayProvince[row];
    }else if (component == 1){
        text =  self.arrayCity[row];
    }else{
        if (self.arrayArea.count > 0) {
            text = self.arrayArea[row];
        }else{
            text =  @"";
        }
    }


    UILabel *label = [[UILabel alloc]init];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:17]];
    [label setText:text];
    return label;


}
#pragma mark - --- event response 事件相应 ---

- (void)selectedOk
{
    [self.delegate pickerArea:self province:self.province city:self.city area:self.area provinceId:self.provinceId cityId:self.cityId areaId:self.areaId];
    [super selectedOk];
}

#pragma mark - --- private methods 私有方法 ---

- (void)reloadData
{
    NSInteger index0 = [self.pickerView selectedRowInComponent:0];
    NSInteger index1 = [self.pickerView selectedRowInComponent:1];
    NSInteger index2 = [self.pickerView selectedRowInComponent:2];
    self.province = self.arrayProvince[index0];
    self.provinceId = self.arrayProvinceId[index0];
    self.city = self.arrayCity[index1];
    self.cityId = self.arrayCityId[index1];

    if (self.arrayArea.count != 0) {
        self.area = self.arrayArea[index2];
        self.areaId = self.arrayAreaId[index2];
    }else{
        self.area = @"";
    }
    
    NSString *title = [NSString stringWithFormat:@"%@ %@ %@", self.province, self.city, self.area];
    [self setTitle:title];

}

#pragma mark - --- setters 属性 ---

#pragma mark - --- getters 属性 ---

- (NSMutableArray *)arrayProvince
{
    if (!_arrayProvince) {
        _arrayProvince = [NSMutableArray array];
    }
    return _arrayProvince;
}

- (NSMutableArray *)arrayProvinceId
{
    if (!_arrayProvinceId) {
        _arrayProvinceId = [NSMutableArray array];
    }
    return _arrayProvinceId;
}

- (NSMutableArray *)arrayCity
{
    if (!_arrayCity) {
        _arrayCity = [NSMutableArray array];
    }
    return _arrayCity;
}
- (NSMutableArray *)arrayCityId
{
    if (!_arrayCityId) {
        _arrayCityId = [NSMutableArray array];
    }
    return _arrayCityId;
}

- (NSMutableArray *)arrayArea
{
    if (!_arrayArea) {
        _arrayArea = [NSMutableArray array];
    }
    return _arrayArea;
}
- (NSMutableArray *)arrayAreaId
{
    if (!_arrayAreaId) {
        _arrayAreaId = [NSMutableArray array];
    }
    return _arrayAreaId;
}

- (NSMutableArray *)arraySelected
{
    if (!_arraySelected) {
        _arraySelected = [NSMutableArray array];
    }
    return _arraySelected;
}

@end


