//
//  ZFJNodeTool.h
//  ZFJTreeViewDemo
//
//  Created by 张福杰 on 2019/6/27.
//  Copyright © 2019 张福杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZFJNodeModel;
@class ZFJError;

NS_ASSUME_NONNULL_BEGIN

@interface ZFJNodeTool : NSObject

/**
 验证节点是否合法

 @param model 节点Model
 @param nodeKeysDict 已存在的所有节点KEY
 @param completed 验证回调
 @return 是否合法(YES || NO)
 */
+ (BOOL)verifyAddNodeModel:(ZFJNodeModel *)model nodeKeysDict:(NSDictionary *)nodeKeysDict completed:(void(^)(ZFJError *error))completed;

/**
 验证节点是否存在

 @param model 节点Model
 @param nodeKeysDict 已存在的所有节点KEY
 @param completed 验证回调
 @return 是否存在(YES || NO)
 */
+ (BOOL)verifyExtNodeModel:(ZFJNodeModel *)model nodeKeysDict:(NSDictionary *)nodeKeysDict completed:(void(^)(ZFJError *error))completed;

/**
 创建节点Key

 @return nodeKey
 */
+ (NSString *)createNodeKey;

/**
 获取时间戳
 
 @return 获取时间戳
 */
+ (NSString *)getTheTimestamp;

@end

NS_ASSUME_NONNULL_END
