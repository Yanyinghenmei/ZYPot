//
//  NSObject+ZYPot.m
//  ZYPotDemo
//
//  Created by Daniel on 16/2/16.
//  Copyright © 2016年 Daniel. All rights reserved.
//

#import "NSObject+ZYPot.h"
#import <objc/runtime.h>
#import <objc/message.h>


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
    
    [model setValuesWithDic:dic];
    
    return model;
}

+ (NSDictionary *)propertyMapDictionary {
    NSDictionary *dic = objc_getAssociatedObject(self, "propertyMapDic");
    return dic;
}

// 给模型类添加一个属性
// 关联 参考资料:http://blog.csdn.net/onlyou930/article/details/9299169
+ (void)setPropertyMapDictionary:(NSDictionary *)dictionary {
    objc_setAssociatedObject(self, "propertyMapDic", dictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// 根据属性名生成setter方法
+ (SEL)setterWithPropertyName:(NSString *)propertyName {
    
    // 首字母大写
    // 不能直接使用 capitalizedString 方法
    NSString *header = [propertyName substringWithRange:NSMakeRange(0, 1)];
    
    NSString *str = [NSString stringWithFormat:@"%@%@",
                     [header capitalizedString],
                     [propertyName substringWithRange:NSMakeRange(1, propertyName.length-1)]];
    
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

- (void)setValuesWithDic:(NSDictionary *)dic {
    
    NSArray *propertyNames = [[self class] allPropertyNames];
    
    for (int i = 0; i < propertyNames.count; i++) {
        // 属性名
        NSString *propertyName = propertyNames[i];
        
        SEL setSel = [[self class] setterWithPropertyName:propertyName];
        
        // 属性值
        NSObject *obj =  dic[propertyName];
        
        // 当字典中的键和属性名不一致时
        if ([[NSString stringWithFormat:@"%@", obj] isEqualToString:@"(null)"] || !obj) {
            NSDictionary *propertyMapDictionary = [[self class] propertyMapDictionary];
            NSString *newPropertyName = propertyMapDictionary[propertyName];
            obj = dic[newPropertyName];
        }
        
        if (obj&&[self respondsToSelector:setSel]) {
            // 函数指针
            IMP setterImp = [self methodForSelector:setSel];
            void (*func)(id, SEL, id) = (void *)setterImp;
            func(self,setSel,obj);
            
            // 有警报
            // id result = [model performSelector:setSel withObject:str];
            
            // 使用本函数 需要引入  <objc/message>
            // 需要设置 Enable Strict Checking of objc_msgSend Calls  为 NO
            // objc_msgSend(model,setSel,str);
        } else {
            IMP setterImp = [self methodForSelector:setSel];
            void (*func)(id, SEL, id) = (void *)setterImp;
            func(self,setSel,nil);
        }
    }
}

// 使用|class_addProperty| 和 |class_getProperty| 添加和读取属性

//+ (void)propertyMapDictionary {
//    objc_property_t property = class_getProperty(self, "propertyMapDic");
//    NSString* propertyAttributes = [NSString stringWithUTF8String:property_getAttributes(property)];
//    NSArray* splitPropertyAttributes = [propertyAttributes componentsSeparatedByString:@"\""];
//    if ([splitPropertyAttributes count] >= 2)
//    {
//        NSLog(@"Class of property: %@", [splitPropertyAttributes objectAtIndex:1]);
//    }
//}
//
//// 给模型类添加一个属性
//+ (BOOL)setPropertyMapDictionary:(NSDictionary *)dictionary {
//    objc_property_attribute_t backingivar  = { "Vaasdf", "_privateName" };
//    objc_property_attribute_t attributes[] = {backingivar};
//    class_addProperty(self, "propertyMapDic", attributes, 1);
//    return YES;
//}

@end
