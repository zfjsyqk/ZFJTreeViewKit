//
//  ZFJTreeView.m
//  ZFJTreeViewDemo
//
//  Created by 张福杰 on 2019/6/27.
//  Copyright © 2019 张福杰. All rights reserved.
//

#import "ZFJTreeView.h"
#import "ZFJTreeViewCell.h"
#import "ZFJNodeModel.h"
#import "ZFJTreeViewConfig.h"
#import "ZFJError.h"

@interface ZFJTreeView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,retain) ZFJTreeViewConfig *configModel;
@property (nonatomic,strong) NSMutableArray<ZFJNodeModel *> *dataArray;
@property (nonatomic,strong) NSMutableDictionary *nodeKeysDict;
@property (nonatomic,strong) NSMutableDictionary *cellheightDic;

@end

@implementation ZFJTreeView

- (instancetype)initWithFrame:(CGRect)frame config:(ZFJTreeViewConfig *)config{
    if(self == [super initWithFrame:frame]){
        _configModel = config;
        [self uiConfig];
    }
    return self;
}

- (void)uiConfig{
    [self addSubview:self.tableView];
    self.tableView.frame = self.bounds;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZFJNodeModel *model = [self.dataArray objectAtIndex:indexPath.row];
    if(model.parentNodeModel == nil || (model.parentNodeModel != nil && model.expand == YES)){
        ZFJTreeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([model.nodeCellCls class])];
        if (!cell){
            cell = [[[model.nodeCellCls class] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([model.nodeCellCls class])];
            cell.selectionStyle = _configModel.selectionStyle;
        }
        [cell updateTreeCellWithModel:model];
        return cell;
    }else{
        static NSString *identifier = @"defineCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(cell == nil){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = _configModel.selectionStyle;
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZFJNodeModel *model = [self.dataArray objectAtIndex:indexPath.row];
    NSString *key = [NSString stringWithFormat:@"%ld",indexPath.row];
    if(model.parentNodeModel == nil || (model.parentNodeModel != nil && model.expand == YES)){
        [self.cellheightDic setValue:@(model.height) forKey:key];
        return model.height;
    }else{
        [self.cellheightDic setValue:@(0.0000001) forKey:key];
        return 0.0000001;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *key = [NSString stringWithFormat:@"%ld",indexPath.row];
    NSNumber *heigt = self.cellheightDic[key];
    if (heigt == nil) {
        heigt = @(50);
    }
    return heigt.floatValue;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZFJNodeModel *model = [self.dataArray objectAtIndex:indexPath.row];
    if([self.delegate respondsToSelector:@selector(treeListView:didSelectNodeModel:indexPath:)]){
        [self.delegate treeListView:self didSelectNodeModel:model indexPath:indexPath];
    }
}

#pragma mark - Public Fun
- (void)insertNode:(ZFJNodeModel *)model completed:(void(^)(ZFJError *error))completed{
    NSAssert([ZFJNodeTool verifyAddNodeModel:model nodeKeysDict:self.nodeKeysDict completed:completed] != NO, @"🙅‍♂️验证不通过🙅‍♂️");
    if(model.parentNodeModel == nil){
        //一级节点
        [self.dataArray insertObject:model atIndex:self.dataArray.count];
    }else{
        //有父节点
        NSInteger index_f = -1;//父级节点的下标数值
        NSInteger index_all = -1;//总的下标数
        for (ZFJNodeModel *model_part in self.dataArray) {
            if(model_part == model.parentNodeModel){
                //找到父级别节点
                index_f = [self.dataArray indexOfObject:model_part];
                //再看看父级节点下面的子节点有多少
                index_all = index_f + model_part.childNodesCount + 1;
                [model_part updateChildNodesCount:model_part.childNodesCount + 1];
                break;
            }
        }
        index_all = index_all == -1 ? 0 : index_all;
        [self.dataArray insertObject:model atIndex:index_all];
    }
    for (int i = 0; i<self.dataArray.count; i++) {
        ZFJNodeModel *model = [self.dataArray objectAtIndex:i];
        [model upDateTreeViewIndex:i];
    }
    [self.nodeKeysDict setObject:model.nodeName forKey:model.nodeKey];
    [self.tableView reloadData];
}

- (void)deleteNode:(ZFJNodeModel *)model completed:(void(^)(ZFJError *error))completed{
    NSAssert([ZFJNodeTool verifyExtNodeModel:model nodeKeysDict:self.nodeKeysDict completed:completed] != NO, @"🙅‍♂️验证不通过🙅‍♂️");
    NSMutableArray *paths = [[NSMutableArray alloc] init];
    NSMutableArray *models = [[NSMutableArray alloc] init];
    for (ZFJNodeModel *model_part in self.dataArray) {
        if([model_part.nodeKey containsString:model.nodeKey] || [model_part.nodeKey isEqualToString:model.nodeKey]){
            NSInteger index = [self.dataArray indexOfObject:model_part];
            [models addObject:model_part];
            [paths addObject:[NSIndexPath indexPathForRow:index inSection:0]];
        }
    }
    [self.dataArray removeObjectsInArray:models];
    [self.tableView deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
}

- (void)expandAllNodes:(ZFJNodeModel *)model completed:(void(^)(ZFJError *error))completed{
    NSAssert([ZFJNodeTool verifyExtNodeModel:model nodeKeysDict:self.nodeKeysDict completed:completed] != NO, @"🙅‍♂️验证不通过🙅‍♂️");
    if([self.dataArray containsObject:model]){
        //先判断有没有子节点
        if(model.childNodesCount == 0){
            if(completed){
                completed([[ZFJError alloc] initWithCode:10003]);
            }
            return;
        }
        BOOL expand = [self getchildNodesExpandState:model];
        NSMutableArray *paths = [[NSMutableArray alloc] init];
        NSString *_parentNodeKey = [NSString stringWithFormat:@"%@_",model.nodeKey];
        [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ZFJNodeModel *model_part = (ZFJNodeModel *)obj;
            if([model_part.nodeKey containsString:_parentNodeKey]){
                [model_part upDateExpand:!expand];
                [self.dataArray replaceObjectAtIndex:idx withObject:model_part];
                [paths addObject:[NSIndexPath indexPathForRow:idx inSection:0]];
            }
        }];
        [self.tableView reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
    }else{
        if(completed){
            completed([[ZFJError alloc] initWithCode:10002]);
        }
    }
}

- (void)expandChildNodes:(ZFJNodeModel *)model completed:(void(^)(ZFJError *error))completed{
    NSAssert([ZFJNodeTool verifyExtNodeModel:model nodeKeysDict:self.nodeKeysDict completed:completed] != NO, @"🙅‍♂️验证不通过🙅‍♂️");
    if([self.dataArray containsObject:model]){
        //先判断有没有子节点
        if(model.childNodesCount == 0){
            if(completed){
                completed([[ZFJError alloc] initWithCode:10003]);
            }
            return;
        }
        BOOL expand = [self getchildNodesExpandState:model];
        NSMutableArray *paths = [[NSMutableArray alloc] init];
        NSString *_parentNodeKey = [NSString stringWithFormat:@"%@_",model.nodeKey];
        [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ZFJNodeModel *model_part = (ZFJNodeModel *)obj;
            if([model_part.nodeKey containsString:_parentNodeKey]){
                NSString *footer_str = [model_part.nodeKey substringFromIndex:_parentNodeKey.length];
                if([footer_str containsString:@"_"]){
                    [model_part upDateExpand:NO];
                }else{
                    [model_part upDateExpand:!expand];
                }
                [self.dataArray replaceObjectAtIndex:idx withObject:model_part];
                [paths addObject:[NSIndexPath indexPathForRow:idx inSection:0]];
            }
        }];
        [self.tableView reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
    }else{
        if(completed){
            completed([[ZFJError alloc] initWithCode:10002]);
        }
    }
}

- (void)expandAllNodes:(BOOL)expand{
    [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZFJNodeModel *model_part = (ZFJNodeModel *)obj;
        [model_part upDateExpand:expand];
        [self.dataArray replaceObjectAtIndex:idx withObject:model_part];
    }];
    [self.tableView reloadData];
}

/**
 获取子节点是否全部展开

 @param nodeModel 节点model
 @return YES:全部展开 || NO:没有全部展开
 */
- (BOOL)getchildNodesExpandState:(ZFJNodeModel *)nodeModel{
    __block BOOL isExpand = YES;
    NSString *_parentNodeKey = [NSString stringWithFormat:@"%@_",nodeModel.nodeKey];
    [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZFJNodeModel *model_part = (ZFJNodeModel *)obj;
        if([model_part.nodeKey containsString:_parentNodeKey]){
            NSString *childKey_type = [[model_part.nodeKey componentsSeparatedByString:_parentNodeKey] lastObject];
            if(![childKey_type containsString:@"_"] && model_part.expand == NO){
                isExpand = NO;
            }
        }
    }];
    return isExpand;
}

- (ZFJNodeModel *)getNodeModelWithNodeKey:(NSString *)nodeKey{
    for (ZFJNodeModel *model in self.dataArray) {
        if([model.nodeKey isEqualToString:nodeKey]){
            return model;
        }
    }
    return nil;
}

- (NSInteger)getIndexFromParentNode:(ZFJNodeModel *)nodeModel{
    NSInteger index = -1;
    for (ZFJNodeModel *model in self.dataArray) {
        if(model.parentNodeModel == nodeModel.parentNodeModel){
            index ++;
        }
        if(model == nodeModel){
            break;
        }
    }
    return index;
}

- (void)setHeaderView:(UIView *)headerView{
    self.tableView.tableHeaderView = headerView;
}

- (void)setFooterView:(UIView *)footerView{
    self.tableView.tableFooterView = footerView;
}

- (UITableView *)tableView{
    if(_tableView == nil){
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView setSeparatorStyle:_configModel.separatorStyle];
        _tableView.backgroundColor = self.backgroundColor;
        if (@available(iOS 11.0, *)){
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

- (NSMutableArray<ZFJNodeModel *> *)dataArray{
    if(_dataArray == nil){
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (NSMutableDictionary *)nodeKeysDict{
    if(_nodeKeysDict == nil){
        _nodeKeysDict = [[NSMutableDictionary alloc] init];
    }
    return _nodeKeysDict;
}

- (NSMutableDictionary *)cellheightDic{
    if(_cellheightDic == nil){
        _cellheightDic = [[NSMutableDictionary alloc] init];
    }
    return _cellheightDic;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    [super setBackgroundColor:backgroundColor];
    self.tableView.backgroundColor = backgroundColor;
}

@end
