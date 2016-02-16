//
//  NSObject+ZYPot.m
//  ZYPotDemo
//
//  Created by Daniel on 16/2/16.
//  Copyright © 2016年 Daniel. All rights reserved.
//

#import "NSObject+ZYPot.h"
#import <objc/runtime.h>

@implementation NSObject (ZYPot)
+ (NSArray *)modelsWithArr:(NSArray *)arr {
    
    NSMutableArray *models = @[].mutableCopy;
    for (int i = 0; i < arr.count; i++) {
        NSDictionary *dic = arr[i];
        [models addObject:[self modelWithDic:dic]];
    }
    return models;
}

+ (id)modelWithDic:(NSDictionary *)dic {
    NSObject *model = self.new;
    NSArray *propertyNames = [self allPropertyNames];
    
    for (int i = 0; i < propertyNames.count; i++) {
        SEL setSel = [self setterWithPropertyName:propertyNames[i]];
        
        //属性值
        NSString *str = [NSString stringWithFormat:@"%@", dic[propertyNames[i]]];
        
        if (str.length&&[model respondsToSelector:setSel]) {
            IMP setterImp = [model methodForSelector:setSel];
            void (*func)(id, SEL, NSString *) = (void *)setterImp;
            func(model,setSel,str);
            // id result = [model performSelector:setSel withObject:str];
        }
    }
    return model;
}

// 根据属性名生成setter方法
+ (SEL)setterWithPropertyName:(NSString *)propertyName {
    
    // 首字母大写
    // 不能直接使用 capitalizedString 方法
    NSString *header = [propertyName substringWithRange:NSMakeRange(0, 1)];
    
    NSString *str = [NSString stringWithFormat:@"%@%@", [header capitalizedString], [propertyName substringWithRange:NSMakeRange(1, propertyName.length-1)]];
    
    NSString *setterName = [NSString stringWithFormat:@"set%@:", str];

    return NSSelectorFromString(setterName);
}

// 获取所有属性名
+ (NSArray *)allPropertyNames {
    NSMutableArray *allNames = @[].mutableCopy;
    
    unsigned int propertyCount = 0;
    
    objc_property_t *propertyList = class_copyPropertyList(self, &propertyCount);
    
    for (int i = 0; i < propertyCount; i++) {
        objc_property_t property = propertyList[i];
        const char *propertyName = property_getName(property);
        [allNames addObject:[NSString stringWithUTF8String:propertyName]];
    }
    free(propertyList);
    return allNames;
}
@end
