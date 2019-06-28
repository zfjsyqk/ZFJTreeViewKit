//
//  ZFJError.m
//  ZFJTreeViewDemo
//
//  Created by 张福杰 on 2019/6/27.
//  Copyright © 2019 张福杰. All rights reserved.
//

#import "ZFJError.h"

@implementation ZFJError

- (instancetype)initWithCode:(NSInteger)code{
    if(self == [super init]){
        _code = code;
        [self updateMessage:code];
    }
    return self;
}

- (void)setCode:(NSInteger)code{
    _code = code;
    [self updateMessage:code];
}

- (void)updateMessage:(NSInteger)code{
    if(code == 1000){
        _message = @"该节点Key已存在";
    }else if (code == 10001){
        _message = @"该节点Key为nil";
    }else if (code == 10002){
        _message = @"该节点不存在";
    }else if (code == 10003){
        _message = @"该节点不存在子节点";
    }
}


@end
