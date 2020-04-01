//
//  ViewController.m
//  XQBaseTableView
//
//  Created by linlin on 2020/4/1.
//  Copyright © 2020 bruce. All rights reserved.
//

#import "ViewController.h"
#import "HMBaseTableView.h"

@interface ViewController ()

/** tableView*/
@property(nonatomic,strong) HMBaseTableView *tableView;
/** 数据源*/
@property(nonatomic,strong) NSArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //1.初始化数据
    self.dataArray = @[@"第1行",@"第2行",@"第3行",@"第4行",@"第5行",@"第6行",];
    //1.初始化UI
    [self layoutUI];
}

#pragma mark - 创建tableview
- (void)layoutUI
{
    /////////初始化tableview//////////////
    self.tableView = [[HMBaseTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    //设置tableview无数据的显示文字和图片
    self.tableView.notDataTipText = @"搜索暂无相关内容";
    self.tableView.imageForEmpty = @"ic_table_nothing";
    
    typeof(self) weakSelf = self;
    self.tableView.numberOfSectionsInTableViewBlock = ^NSInteger(HMBaseTableView * _Nonnull tableView) {
        return 1;
    };
    self.tableView.numberOfRowsInSectionBlock = ^NSInteger(HMBaseTableView * _Nonnull tableView, NSInteger section) {
        return weakSelf.dataArray.count;
    };
    self.tableView.heightForRowBlock = ^CGFloat(HMBaseTableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath) {
        return 55;
    };
    self.tableView.cellForRowBlock = ^UITableViewCell * _Nonnull(HMBaseTableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        if (weakSelf.dataArray.count > 0) {
            cell.textLabel.text = weakSelf.dataArray[indexPath.row];
        }
        return cell;
    };
    //选中行点击事件
    self.tableView.didSelectRowAtIndexPathBlock = ^(NSIndexPath * _Nonnull indexPath, HMBaseTableView * _Nonnull tableView) {
    };
    //设置头部高度
    self.tableView.heightForHeaderBlock = ^CGFloat(HMBaseTableView * _Nonnull tableView, NSInteger section) {
        return 10;
    };
    //设置头部视图
    self.tableView.viewForHeaderBlock = ^UIView * _Nonnull(HMBaseTableView * _Nonnull tableView, NSInteger section) {
        return [UIView new];
    };
}

@end
