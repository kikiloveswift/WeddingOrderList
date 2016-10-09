//
//  AllOrderListViewController.m
//  WeddingOrderList
//
//  Created by kong on 16/10/6.
//  Copyright © 2016年 kong. All rights reserved.
//

#import "AllOrderListViewController.h"
#import "OrderDataBase.h"
#import "OrderListTableViewCell.h"

@interface AllOrderListViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating>
{
    FMDatabase *_dataBase;
    NSMutableArray *_mArr;
    NSMutableArray *_nameArr;
    UITableView *_tableView;
    UISearchController *_searchVC;
    NSMutableArray *_searchList;
}

@end

@implementation AllOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"总账单";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initDataSource];
    if (_mArr != nil && _mArr.count > 0)
    {
        [self initTableView];
        
    }
    
}

- (void)initDataSource
{
    //获取数据库对象
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    path = [path stringByAppendingString:@"/weddingorderlist.sqlite"];
    NSLog(@"path is %@",path);
    _dataBase = [FMDatabase databaseWithPath:path];
    [_dataBase open];
    FMResultSet *rs = [_dataBase executeQuery:@"select * from t_orderlist"];
    if (_mArr == nil)
    {
        _mArr = [NSMutableArray array];
    }
    [_mArr removeAllObjects];
    if (_nameArr == nil)
    {
        _nameArr = [NSMutableArray array];
    }
    [_nameArr removeAllObjects];
    
    while ([rs next])
    {
        OrderDataBase *dataModel = [[OrderDataBase alloc] init];
        dataModel.name = [rs stringForColumn:@"name"];
        dataModel.money = [[rs stringForColumn:@"money"] intValue];
        dataModel.checkMethod = [rs stringForColumn:@"checkMethod"];
        dataModel.isAbscent = [rs stringForColumn:@"isAbscent"];
        dataModel.relationship = [rs stringForColumn:@"relationship"];
        dataModel.idKey = [[rs stringForColumn:@"idKey"] intValue];
        [_mArr addObject:dataModel];
        [_nameArr addObject:dataModel.name];
    }
    [_dataBase close];
    NSLog(@"_mArr is %@",_mArr);
    
}


/**
 初始化UI
 */
- (void)initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KWidth, KHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    //添加搜索框
    _searchVC = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchVC.searchResultsUpdater = self;
    _searchVC.dimsBackgroundDuringPresentation = NO;
    _searchVC.searchBar.placeholder = @"输入搜索内容";
    _tableView.tableHeaderView = _searchVC.searchBar;
    
}
#pragma Mark--UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_searchVC.active)
    {
        return _searchList.count;
    }else{
        return _mArr.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifuer = @"ORDERCELL";
    OrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifuer];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"OrderListTableViewCell" owner:nil options:nil]lastObject];
    }
    if (_searchVC.active)
    {
        cell.dataModel = _searchList[indexPath.row];
    }else{
        cell.dataModel = _mArr[indexPath.row];
    }
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 57;
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = _searchVC.searchBar.text;
    if (_searchList != nil)
    {
        [_searchList removeAllObjects];
    }else{
        _searchList = [NSMutableArray array];
    }
    for (OrderDataBase *dataModel in _mArr) {
        if ([dataModel.name containsString:searchString]) {
            [_searchList addObject:dataModel];
        }
    }
    [_tableView reloadData];
    
}

#pragma Mark-DelegateStyle
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellEditingStyle result = UITableViewCellEditingStyleNone;
    if ([tableView isEqual:_tableView])
    {
        result = UITableViewCellEditingStyleDelete;
    }
    return result;
}
//设置是否显示一个可编辑视图的视图控制器。
-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    [_tableView setEditing:editing animated:animated];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle ==UITableViewCellEditingStyleDelete)
    {
        if ([tableView isEqual:_tableView])
        {
            
            BOOL result = [_dataBase open];
            if (result)
            {
                OrderDataBase *dataModel = _mArr[indexPath.row];
                [_dataBase executeUpdate:@"DELETE FROM t_orderlist WHERE idKey = ?",@(dataModel.idKey)];
                [_dataBase close];
                //清除_mArr的数据和_nameArr的数据
                [_mArr removeObjectAtIndex:indexPath.row];
                [_nameArr removeObjectAtIndex:indexPath.row];
                [_tableView beginUpdates];
                [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [_tableView endUpdates];
            }
        }
    }
}




@end
