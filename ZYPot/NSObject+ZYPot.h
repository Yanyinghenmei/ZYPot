//
//  NSObject+ZYPot.h
//  ZYPotDemo
//
//  Created by Daniel on 16/2/16.
//  Copyright © 2016年 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ZYPot)
// 数组––>模型数组
+ (NSArray *)modelsWithArr:(NSArray *)arr;

// 字典––>模型
+ (id)modelWithDic:(NSDictionary *)dic;

// 映射字典  {@"int":@"int_"}
+ (void)setPropertyMapDictionary:(NSDictionary *)dictionary;

+ (NSArray *)allPropertyNames;
+ (SEL)setterWithPropertyName:(NSString *)propertyName;

- (void)setValuesWithDic:(NSDictionary *)dic;

@end
