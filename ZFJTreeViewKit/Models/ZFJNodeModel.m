//
//  ZFJNodeModel.m
//  ZFJTreeViewDemo
//
//  Created by 张福杰 on 2019/6/27.
//  Copyright © 2019 张福杰. All rights reserved.
//

#import "ZFJNodeModel.h"
#import "ZFJNodeTool.h"
#import "ZFJNodeModel.h"

@implementation ZFJNodeModel

- (instancetype)initWithParentNodeModel:(nullable ZFJNodeModel *)parentNodeModel{
    if(self == [super init]){
        [self dataConfig:parentNodeModel];
    }
    return self;
}

- (void)dataConfig:(ZFJNodeModel *)parentNodeModel{
    _parentNodeModel = parentNodeModel;
    if(_parentNodeModel == nil){
        //父级节点
        _level = 0;
        _nodeKey = [ZFJNodeTool createNodeKey];
    }else{
        //子节点
        _level = parentNodeModel.level + 1;
        _nodeKey = [NSString stringWithFormat:@"%@_%@", parentNodeModel.nodeKey, [ZFJNodeTool createNodeKey]];
    }
    _childNodesCount = 0;
    _height = 50;
    _expand = YES;
}

- (void)updateChildNodesCount:(NSInteger)childNodesCount{
    _childNodesCount = childNodesCount;
}

- (void)upDateTreeViewIndex:(NSInteger)treeViewIndex{
    _treeViewIndex = treeViewIndex;
}

- (void)upDateExpand:(BOOL)expand{
    _expand = expand;
}

@end
