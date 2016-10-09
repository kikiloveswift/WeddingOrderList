//
//  OrderListTableViewCell.m
//  WeddingOrderList
//
//  Created by kong on 16/10/8.
//  Copyright © 2016年 kong. All rights reserved.
//

#import "OrderListTableViewCell.h"

@implementation OrderListTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setDataModel:(OrderDataBase *)dataModel
{
    if (_dataModel != dataModel) {
        _dataModel = dataModel;
    }
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _name.text = _dataModel.name;
    _money.text = [NSString stringWithFormat:@"%d",_dataModel.money];
    _checkMethod.text = _dataModel.checkMethod;
    _isAbscent.text = _dataModel.isAbscent;
    _relationShip.text = _dataModel.relationship;
}
@end
