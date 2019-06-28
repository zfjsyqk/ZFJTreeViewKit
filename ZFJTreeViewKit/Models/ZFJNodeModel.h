//
//  ZFJNodeModel.h
//  ZFJTreeViewDemo
//
//  Created by 张福杰 on 2019/6/27.
//  Copyright © 2019 张福杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ZFJNodeModel;
@class ZFJNodeTool;

NS_ASSUME_NONNULL_BEGIN

/**
 节点Model
 */
@interface ZFJNodeModel : NSObject

- (instancetype)initWithParentNodeModel:(nullable ZFJNodeModel *)parentNodeModel;

/**
 父节点
 */
@property (nonatomic,readonly) ZFJNodeModel *parentNodeModel;

/**
 节点Name(便于阅读识别，没有实际意义)
 */
@property (nonatomic,  copy) NSString *nodeName;

/**
 节点的KEY(⚠️节点唯一标识符⚠️自动生成,无需自己生成)
 */
@property (nonatomic,readonly) NSString *nodeKey;

/**
 节点的高度(默认50)
 */
@property (nonatomic,assign) CGFloat height;

/**
 子节点总数
 */
@property (nonatomic,readonly) NSInteger childNodesCount;

/**
 分页页码（第一页 ⚠️ pageIndex = 0 ⚠️）
 */
@property (nonatomic,assign) NSInteger pageIndex;

/**
 当前节点CELL的数据源model
 */
@property (nonatomic,strong) NSObject *sourceModel;

/**
 当前节点对应的CELL
 */
@property (nonatomic,  copy) Class nodeCellCls;

/**
 节点是否展开（展开 YES || 折叠 NO || 默认YES，若level=0固定展开，设置无效）
 */
@property (nonatomic,readonly) BOOL expand;

/**
 当前节点所处层级（第一节点为0，子节点依次累加， 不需要手动设置）
 */
@property (nonatomic,readonly) NSInteger level;

/**
 该节点在UITreeView中的位置
 */
@property (nonatomic,readonly) NSInteger treeViewIndex;

/**
 更新子节点数(⚠️用户不可调用⚠️)

 @param childNodesCount 子节点数
 */
- (void)updateChildNodesCount:(NSInteger)childNodesCount;

/**
 更新在数据源中的位置(⚠️用户不可调用⚠️)

 @param treeViewIndex 数据源中的位置
 */
- (void)upDateTreeViewIndex:(NSInteger)treeViewIndex;

/**
 更新展开折叠状态(⚠️用户不可调用⚠️)

 @param expand expand
 */
- (void)upDateExpand:(BOOL)expand;

#pragma mark ----------NS_UNAVAILABLE----------

+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
