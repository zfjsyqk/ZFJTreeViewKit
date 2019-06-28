//
//  ZFJError.h
//  ZFJTreeViewDemo
//
//  Created by 张福杰 on 2019/6/27.
//  Copyright © 2019 张福杰. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZFJError : NSObject

/**
 初始化错误类

 @param code 错误码
 @return 错误信息
 */
- (instancetype)initWithCode:(NSInteger)code;

/**
 错误码
 */
@property (nonatomic,assign) NSInteger code;

/**
 错误信息
 */
@property (nonatomic,readonly) NSString *message;

@end

NS_ASSUME_NONNULL_END
