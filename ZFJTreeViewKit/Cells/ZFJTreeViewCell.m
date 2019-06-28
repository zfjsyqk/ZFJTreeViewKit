//
//  ZFJTreeViewCell.m
//  ZFJTreeViewDemo
//
//  Created by 张福杰 on 2019/6/27.
//  Copyright © 2019 张福杰. All rights reserved.
//

#import "ZFJTreeViewCell.h"
#import "ZFJNodeModel.h"

@interface ZFJTreeViewCell ()

@end

@implementation ZFJTreeViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self dataConfig];
        [self uiConfig];
    }
    return self;
}

- (void)uiConfig{
    //NSLog(@"。。。uiConfig 父类方法。。。");
}

- (void)dataConfig{
    //NSLog(@"。。。dataConfig 父类方法。。。");
}

- (void)updateTreeCellWithModel:(ZFJNodeModel *)model{
    _nodeModel = model;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
