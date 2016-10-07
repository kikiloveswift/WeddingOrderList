//
//  OrderDataBase.h
//  WeddingOrderList
//
//  Created by kong on 16/10/7.
//  Copyright © 2016年 kong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderDataBase : NSObject

/**
 名字
 */
@property (nonatomic, copy) NSString *name;

/**
 金额
 */
@property (nonatomic, assign) int money;


/**
 支付方式
 */
@property (nonatomic, copy) NSString *checkMethod;


/**
 是否出席
 */
@property (nonatomic, copy) NSString *isAbscent;


/**
 类别
 */
@property (nonatomic, copy) NSString *relationship;

@end
