//
//  OrderListTableViewCell.h
//  WeddingOrderList
//
//  Created by kong on 16/10/8.
//  Copyright © 2016年 kong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDataBase.h"

@interface OrderListTableViewCell : UITableViewCell

@property (nonatomic, strong) OrderDataBase *dataModel;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *checkMethod;
@property (weak, nonatomic) IBOutlet UILabel *isAbscent;
@property (weak, nonatomic) IBOutlet UILabel *relationShip;

@end
