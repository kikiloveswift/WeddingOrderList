//
//  AddOrderViewController.m
//  WeddingOrderList
//
//  Created by kong on 16/10/6.
//  Copyright © 2016年 kong. All rights reserved.
//

#import "AddOrderViewController.h"
#import "OrderDataBase.h"

@interface AddOrderViewController ()
{
    FMDatabase *_dataBase;
}

/**
 数据库Model
 */
@property (nonatomic, strong) OrderDataBase *dataModel;

/**
 主View
 */
@property (weak, nonatomic) IBOutlet UIView *placeView;

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

/**
 支付方式Pick
 */
@property (weak, nonatomic) IBOutlet UIPickerView *checkPick;


/**
 是否出席pick
 */
@property (weak, nonatomic) IBOutlet UIPickerView *absentPick;


/**
 关系Pick
 */
@property (weak, nonatomic) IBOutlet UIPickerView *relationPick;

@property (nonatomic, strong) NSArray *checkArr;

@property (nonatomic, strong) NSArray *absentArr;

@property (nonatomic, strong) NSArray * relationArr;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;


@end

@implementation AddOrderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _checkArr = @[@"QQ钱包",@"支付宝",@"微信",@"现金"];
    
    _absentArr = @[@"是",@"否"];
    
    _relationArr = @[@"FromYL",@"FromKL"];
    
    [self initUI];
    
    [self openDB];
}


/**
 初始化UI
 */
- (void)initUI
{
    _checkPick.dataSource = self;
    _checkPick.delegate = self;
    
    _absentPick.dataSource = self;
    _absentPick.delegate = self;
    
    _relationPick.dataSource = self;
    _relationPick.delegate = self;
    
    _nameTextField.delegate = self;
    _moneyTextField.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_placeView addGestureRecognizer:tap];
    
    _saveBtn.userInteractionEnabled = NO;
    [_saveBtn setBackgroundColor:[UIColor lightGrayColor]];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardShow) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardHide) name:UIKeyboardWillHideNotification object:nil];
    
    if (_dataModel == nil)
    {
        _dataModel = [[OrderDataBase alloc] init];
    }
}


/**
 创建数据库 如果没有 就新建一个数据库
 */
- (void)openDB
{
    //获取数据库对象
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    path = [path stringByAppendingString:@"/weddingorderlist.sqlite"];
    NSLog(@"path is %@",path);
    _dataBase = [FMDatabase databaseWithPath:path];
    
    //打开数据库
    BOOL open = [_dataBase open];
    if (open)
    {
        NSLog(@"数据库打开成功");
        //创表
        BOOL result = [_dataBase executeUpdate:@"CREATE TABLE IF NOT EXISTS t_orderlist (idKey integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL,money integer NOT NULL, checkMethod text NOT NULL, isAbscent text NOT NULL, relationship text NOT NULL);"];
        if (result)
        {
            NSLog(@"创建表成功");
        }
    }
}

- (void)keyBoardHide
{
    if (_dataModel)
    {
        _dataModel.name = _nameTextField.text;
        _dataModel.money = [_moneyTextField.text intValue];
    }
    _relationPick.userInteractionEnabled = YES;
    _absentPick.userInteractionEnabled = YES;
    _checkPick.userInteractionEnabled = YES;
    
    if (_moneyTextField.text.length > 0 && _nameTextField.text.length > 0)
    {
        _saveBtn.userInteractionEnabled = YES;
        [_saveBtn setBackgroundColor:[UIColor redColor]];
    }else{
        _saveBtn.userInteractionEnabled = NO;
        [_saveBtn setBackgroundColor:[UIColor lightGrayColor]];
    }
}

- (void)keyBoardShow
{
    _saveBtn.userInteractionEnabled = NO;
    _relationPick.userInteractionEnabled = NO;
    _absentPick.userInteractionEnabled = NO;
    _checkPick.userInteractionEnabled = NO;
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    [_moneyTextField resignFirstResponder];
    
    [_nameTextField resignFirstResponder];
}

#pragma mark--UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == _checkPick){
        
        return _checkArr.count;
    }else if (pickerView == _absentPick){
        
        return _absentArr.count;
    }else if (pickerView == _relationPick){
        return _relationArr.count;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == _checkPick){
        if (_dataModel)
        {
            _dataModel.checkMethod = _checkArr[row];
        }
        return _checkArr[row];
        
    }else if (pickerView == _absentPick){
        if (_dataModel)
        {
            _dataModel.isAbscent = _absentArr[row];
        }
        return _absentArr[row];
        
    }else if (pickerView == _relationPick){
        
        if (_dataModel)
        {
            _dataModel.relationship = _relationArr[row];
        }
        return _relationArr[row];
    }
    
    return 0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0)
    {
        [pickerView selectedRowInComponent:0];
    }
    NSInteger result = [pickerView selectedRowInComponent:0];
    
    if (pickerView == _checkPick){
        if (_dataModel)
        {
            _dataModel.checkMethod = _checkArr[result];
        }
        
        
    }else if (pickerView == _absentPick){
        if (_dataModel)
        {
            _dataModel.isAbscent = _absentArr[result];
        }
        
        
    }else if (pickerView == _relationPick){
        
        if (_dataModel)
        {
            _dataModel.relationship = _relationArr[result];
        }
        
    }
    
}

#pragma mark--UITextFieldDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)saveAction:(id)sender
{
    [self openDBSaveData];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)openDBSaveData
{
    //name, money, checkMethod, isAbscent, relationship
    if ([_dataBase open]) {
        NSString *insertSql= [NSString stringWithFormat:
                               @"INSERT INTO '%@' ('%@', '%@', '%@', '%@', '%@') VALUES ('%@', '%@', '%@', '%@', '%@')",
                               @"t_orderlist", @"name", @"money", @"checkMethod", @"isAbscent", @"relationship",_dataModel.name, @(_dataModel.money), _dataModel.checkMethod, _dataModel.isAbscent, _dataModel.relationship];
        BOOL res = [_dataBase executeUpdate:insertSql];
        
        if (!res) {
            NSLog(@"出错");
        } else {
            NSLog(@"成功");
        }
        [_dataBase close];
    }
}

@end
