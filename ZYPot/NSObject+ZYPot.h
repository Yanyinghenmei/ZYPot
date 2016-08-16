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

// 所有属性名
+ (NSArray *)allPropertyNames;

// 属性名––>SEL
+ (SEL)setterWithPropertyName:(NSString *)propertyName;

// 给模型的属性赋值
- (void)setValuesWithDic:(NSDictionary *)dic;

// 模型––>字典
- (NSDictionary *)keyValues;

@end
