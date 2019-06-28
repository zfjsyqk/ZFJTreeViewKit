//
//  ZFJTreeView.h
//  ZFJTreeViewDemo
//
//  Created by 张福杰 on 2019/6/27.
//  Copyright © 2019 张福杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFJError.h"

@class ZFJTreeView;
@class ZFJTreeViewConfig;
@class ZFJNodeModel;

NS_ASSUME_NONNULL_BEGIN

@protocol ZFJTreeViewDelegate <NSObject>

- (void)treeListView:(ZFJTreeView *)listView didSelectNodeModel:(ZFJNodeModel *)model indexPath:(NSIndexPath *)indexPath;

@end

@interface ZFJTreeView : UIView

- (instancetype)initWithFrame:(CGRect)frame config:(ZFJTreeViewConfig *)config;

/**
 代理方法
 */
@property (nonatomic, weak) id<ZFJTreeViewDelegate> delegate;

/**
 ZFJTreeView头部视图
 */
@property (nonatomic,strong) UIView *headerView;

/**
 ZFJTreeView尾部视图
 */
@property (nonatomic,strong) UIView *footerView;

/**
 插入某个节点

 @param model 节点model
 */
- (void)insertNode:(ZFJNodeModel *)model completed:(void(^)(ZFJError *error))completed;

/**
 删除某个节点（删除父节点，则子节点全部删除）

 @param model 节点model
 */
- (void)deleteNode:(ZFJNodeModel *)model completed:(void(^)(ZFJError *error))completed;

/**
 展开/折叠某个节点

 @param model 节点model（需要展开/折叠的父节点）
 @param completed 错误信息回调
 */
- (void)expandNode:(ZFJNodeModel *)model completed:(void(^)(ZFJError *error))completed;

/**
 展开/折叠全部节点

 @param expand YES:全部展开||NO:全部关闭
 */
- (void)expandAllNodes:(BOOL)expand;

/**
 通过节点Key获取节点model

 @param nodeKey 节点Key
 @return 节点model
 */
- (ZFJNodeModel *)getNodeModelWithNodeKey:(NSString *)nodeKey;

/**
 获取子节点是否全部展开(用于设置Cell样式)
 
 @param nodeModel 节点model
 @return YES:全部展开 || NO:没有全部展开
 */
- (BOOL)getchildNodesExpandState:(ZFJNodeModel *)nodeModel;

/**
 获取节点在父节点中的位置

 @param nodeModel 当前节点model
 @return 在父节点中的下标(-1 未找到)
 */
- (NSInteger)getIndexFromParentNode:(ZFJNodeModel *)nodeModel;

#pragma mark ----------NS_UNAVAILABLE----------

+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
