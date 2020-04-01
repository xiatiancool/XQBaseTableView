//
//  HMBaseTableView.h
//  HMUIEngine
//
//  Created by bruce on 2019/8/6.
//  Copyright © 2019 wangzf. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HMBaseTableView : UITableView

@property(nonatomic, strong) NSArray *cellArray;
@property(nonatomic, strong) NSString *notDataTipText;
@property(nonatomic, strong) UIColor *tipColor;
@property(nonatomic, strong) UIFont *tipFont;
@property(nonatomic, assign) BOOL emptyDataSetShouldDisplay;
@property(nonatomic, strong) NSString *imageForEmpty;
@property(nonatomic, assign) BOOL emptyDataIsTap;//空数据时是否支持点击重试
@property(nonatomic, strong) NSString *buttonTipTitle;//无数据时按钮文字

/**
 cell 编辑相关
 */
@property(nonatomic, copy) BOOL (^canEditRowAtIndexPathBlock)(NSIndexPath *indexPath,HMBaseTableView *tableView);
@property(nonatomic, copy) UITableViewCellEditingStyle (^editingStyleForRowAtIndexPathBlock)(NSIndexPath *indexPath,HMBaseTableView *tableView);
@property(nonatomic, copy) void (^commitEditingStyleBlock)(UITableViewCellEditingStyle editingStyle,NSIndexPath *indexPath,HMBaseTableView *tableView);

/**
 cell点击事件
 */
@property(nonatomic, copy) void (^clickCellActionBlock)(NSIndexPath *indexPath,id paramterModel);
@property(nonatomic, copy) void (^didSelectRowAtIndexPathBlock)(NSIndexPath *indexPath,HMBaseTableView *tableView);
/**
 点击重试事件
 */
@property(nonatomic, copy) void (^clickRetryActionBlock)(void);
/**
 点击空白按钮事件
 */
@property(nonatomic, copy) void (^clickBlankButtonBlock)(void);

/**
 外部重写 numberOfRowsInSectionBlock
 */
@property(nonatomic, copy) NSInteger (^numberOfRowsInSectionBlock)(HMBaseTableView *tableView,NSInteger section);

/**
 外部重写 numberOfSectionsInTableViewBlock
 */
@property(nonatomic, copy) NSInteger (^numberOfSectionsInTableViewBlock)(HMBaseTableView *tableView);

/**
 外部重写 cellForRowAtIndexPath
 */
@property(nonatomic, copy) UITableViewCell *(^cellForRowBlock)(HMBaseTableView *tableView,NSIndexPath *indexPath);

/**
 外部重写 heightForRowAtIndexPath
 */
@property(nonatomic, copy) CGFloat (^heightForRowBlock)(HMBaseTableView *tableView,NSIndexPath *indexPath);

/**
 外部重写 viewForHeaderInSection
 */
@property(nonatomic, copy) UIView *(^viewForHeaderBlock)(HMBaseTableView *tableView,NSInteger section);

/**
 外部重写 heightForHeaderInSection
 */
@property(nonatomic, copy) CGFloat (^heightForHeaderBlock)(HMBaseTableView *tableView,NSInteger section);

@property(nonatomic, copy) void (^willDisplayHeaderViewBlock)(HMBaseTableView *tableView,UIView *view,NSInteger section);

/**
 外部重写 viewForFooterInSection
 */
@property(nonatomic, copy) UIView *(^viewForFooterBlock)(HMBaseTableView *tableView,NSInteger section);

/**
 外部重写 heightForFooterInSection
 */
@property(nonatomic, copy) CGFloat (^heightForFooterBlock)(HMBaseTableView *tableView,NSInteger section);

@property(nonatomic, copy) void (^willDisplayFooterViewBlock)(HMBaseTableView *tableView,UIView *view,NSInteger section);

/**
 刷新数据
 @param cellList 数据源
 @param emptyDataIsTap 空数据是否支持点击
 */
- (void)refreshDataShow:(NSArray *)cellList emptyDataIsTap:(BOOL)emptyDataIsTap;

//delegate 事件
@property(nonatomic, copy) void (^scrollTableViewBlock)(UIScrollView *scrollView);
@property(nonatomic, copy) void (^scrollViewWillBeginDraggingBlock)(UIScrollView *scrollView);
@property(nonatomic, copy) void (^scrollViewDidEndDraggingWillDecelerateBlock)(UIScrollView *scrollView,BOOL decelerate);
@property(nonatomic, copy) void (^scrollViewWillBeginDeceleratingBlock)(UIScrollView *scrollView);
@property(nonatomic, copy) void (^scrollViewDidEndDeceleratingBlock)(UIScrollView *scrollView);
@property(nonatomic, copy) void (^scrollViewDidEndScrollingAnimationBlock)(UIScrollView *scrollView);

//初始化
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;

@end

NS_ASSUME_NONNULL_END
