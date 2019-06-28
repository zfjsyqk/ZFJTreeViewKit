//
//  ZFJTreeViewCell.h
//  ZFJTreeViewDemo
//
//  Created by 张福杰 on 2019/6/27.
//  Copyright © 2019 张福杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZFJNodeModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZFJTreeViewCell : UITableViewCell

/**
 节点model
 */
@property (nonatomic,readonly) ZFJNodeModel *nodeModel;

/**
 更新节点数据

 @param model 节点model
 */
- (void)updateTreeCellWithModel:(ZFJNodeModel *)model;

/**
 数据配置函数
 */
- (void)dataConfig;

/**
 UI配置函数
 */
- (void)uiConfig;

@end

NS_ASSUME_NONNULL_END
