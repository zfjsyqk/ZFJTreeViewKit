//
//  ZFJNodeTool.m
//  ZFJTreeViewDemo
//
//  Created by 张福杰 on 2019/6/27.
//  Copyright © 2019 张福杰. All rights reserved.
//

#import "ZFJNodeTool.h"
#import "ZFJNodeModel.h"
#import "ZFJError.h"

@interface ZFJNodeTool ()

@end

@implementation ZFJNodeTool

+ (BOOL)verifyAddNodeModel:(ZFJNodeModel *)model nodeKeysDict:(NSDictionary *)nodeKeysDict completed:(void(^)(ZFJError *error))completed{
    ZFJError *error = [[ZFJError alloc] init];
    if(model.nodeKey == nil || model.nodeKey.length == 0){
        error.code = 10001;
        if(completed){
            completed(error);
        }
        return NO;
    }else if ([nodeKeysDict.allKeys containsObject:model.nodeKey]){
        error.code = 1000;
        if(completed){
            completed(error);
        }
        return NO;
    }
    
    return YES;
}

+ (BOOL)verifyExtNodeModel:(ZFJNodeModel *)model nodeKeysDict:(NSDictionary *)nodeKeysDict completed:(void(^)(ZFJError *error))completed{
    ZFJError *error = [[ZFJError alloc] init];
    if (![nodeKeysDict.allKeys containsObject:model.nodeKey]){
        error.code = 1002;
        if(completed){
            completed(error);
        }
        return NO;
    }
    
    return YES;
}

+ (NSString *)createNodeKey{
    int random_num = arc4random() % 100000000;
    NSString *timestamp = [ZFJNodeTool getTheTimestamp];
    return [NSString stringWithFormat:@"KEY%@&%d",timestamp,random_num];
}

+ (NSString *)getTheTimestamp{
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [dat timeIntervalSince1970] * 1000;
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
    return timeString;
}

@end
