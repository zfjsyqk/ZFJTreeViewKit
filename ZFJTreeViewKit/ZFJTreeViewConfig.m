//
//  ZFJTreeViewConfig.m
//  ZFJTreeViewDemo
//
//  Created by 张福杰 on 2019/6/27.
//  Copyright © 2019 张福杰. All rights reserved.
//

#import "ZFJTreeViewConfig.h"

@implementation ZFJTreeViewConfig

- (instancetype)init{
    if(self == [super init]){
        _separatorStyle = UITableViewCellSeparatorStyleNone;
        _selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

@end
