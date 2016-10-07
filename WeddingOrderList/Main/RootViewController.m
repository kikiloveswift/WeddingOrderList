//
//  RootViewController.m
//  WeddingOrderList
//
//  Created by kong on 16/10/6.
//  Copyright © 2016年 kong. All rights reserved.
//

#import "RootViewController.h"
#import "AllOrderListViewController.h"
#import "AddOrderViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)allOrderListReview:(UIButton *)sender
{
    AllOrderListViewController *orderListVC = [[AllOrderListViewController alloc] init];
    [self.navigationController pushViewController:orderListVC animated:YES];
}


- (IBAction)addOrderAction:(UIButton *)sender
{
    AddOrderViewController *addVC = [[AddOrderViewController alloc] init];
    [self.navigationController pushViewController:addVC animated:YES];
}


@end
