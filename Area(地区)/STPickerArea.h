//
//  STPickerArea.h
//  STPickerView
//
//  Created by https://github.com/STShenZhaoliang/STPickerView on 16/2/15.
//  Copyright © 2016年 shentian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STPickerView.h"
NS_ASSUME_NONNULL_BEGIN


typedef void(^passValueBlock)(NSString *province ,NSString *city, NSString *area, NSString *provinceId ,NSString *cityId ,NSString *areaId);

@class STPickerArea;
@protocol  STPickerAreaDelegate<NSObject>

- (void)pickerArea:(STPickerArea *)pickerArea province:(NSString *)province city:(NSString *)city area:(NSString *)area provinceId:(NSString *)provinceId cityId:(NSString *)cityId areaId:(NSString *)areaId;

@end
@interface STPickerArea : STPickerView
/** 1.中间选择框的高度，default is 32*/
@property (nonatomic, assign)CGFloat heightPickerComponent;

@property(nonatomic, weak)id <STPickerAreaDelegate>delegate ;
@property(nonatomic, copy) passValueBlock block;
+(instancetype)shareWithMode:(STPickerContentMode)mode;//初始化方法

@end
NS_ASSUME_NONNULL_END
