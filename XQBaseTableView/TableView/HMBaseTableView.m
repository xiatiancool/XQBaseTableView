//
//  HMBaseTableView.m
//  HMUIEngine
//
//  Created by bruce on 2019/8/6.
//  Copyright © 2019 wangzf. All rights reserved.
//

#import "HMBaseTableView.h"
#import "UIScrollView+EmptyDataSet.h"

#define HMTrim(str) [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
#define HMIsEmptyString(str) (!str || [HMTrim(str) isEqualToString:@""] || [str isEqualToString:@"<null>"])
#define RGBCOLOR16(rgbValue) \
[UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:1.0]

@interface HMBaseTableView()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@end

@implementation HMBaseTableView

- (void)dealloc
{
    NSLog(@"");
}
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initialize];
}

- (void)initialize
{
    self.delegate = self.delegate?self.delegate:self;
    self.dataSource = self.dataSource?self.dataSource:self;
    self.emptyDataSetSource = self;
    self.emptyDataSetDelegate = self;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.emptyDataSetShouldDisplay = YES;
    self.backgroundColor = [UIColor clearColor];
    self.showsVerticalScrollIndicator = NO;
}

- (void)refreshDataShow:(NSArray *)cellList emptyDataIsTap:(BOOL)emptyDataIsTap
{
    _emptyDataIsTap = emptyDataIsTap;
    
    self.cellArray = cellList;
    [self reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.numberOfRowsInSectionBlock) {
        return self.numberOfRowsInSectionBlock((HMBaseTableView *)tableView,section);
    }
    return self.cellArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.numberOfSectionsInTableViewBlock) {
        return self.numberOfSectionsInTableViewBlock((HMBaseTableView *)tableView);
    }
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.viewForHeaderBlock) {
        return self.viewForHeaderBlock((HMBaseTableView *)tableView, section);
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section
{
    !self.willDisplayHeaderViewBlock? :self.willDisplayHeaderViewBlock((HMBaseTableView *)tableView,view,section);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.heightForHeaderBlock) {
        return self.heightForHeaderBlock((HMBaseTableView *)tableView,section);
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (self.viewForFooterBlock) {
        return self.viewForFooterBlock((HMBaseTableView *)tableView, section);
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section
{
    !self.willDisplayFooterViewBlock? :self.willDisplayFooterViewBlock((HMBaseTableView *)tableView,view,section);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.heightForFooterBlock) {
        return self.heightForFooterBlock((HMBaseTableView *)tableView,section);
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.cellForRowBlock){
        return self.cellForRowBlock((HMBaseTableView *)tableView, indexPath);
    }
    static NSString *ClanListTbViewCellIdentifier = @"ClanListTbViewCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: ClanListTbViewCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ClanListTbViewCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.heightForRowBlock) {
        return self.heightForRowBlock((HMBaseTableView *)tableView,indexPath);
    }
    return 55;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.clickCellActionBlock) {
        if (indexPath.row < self.cellArray.count) {
            self.clickCellActionBlock(indexPath, self.cellArray[indexPath.row]);
        }
    }else if (self.didSelectRowAtIndexPathBlock) {
        self.didSelectRowAtIndexPathBlock(indexPath,(HMBaseTableView *)tableView);
    }
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.canEditRowAtIndexPathBlock != nil) {
        return self.canEditRowAtIndexPathBlock(indexPath,(HMBaseTableView *)tableView);
    }
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.commitEditingStyleBlock != nil) {
        return self.editingStyleForRowAtIndexPathBlock(indexPath,(HMBaseTableView *)tableView);
    }
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    !self.commitEditingStyleBlock ?: self.commitEditingStyleBlock(editingStyle,indexPath,(HMBaseTableView *)tableView);
}

#pragma mark - DZNEmptyDataSetSource Methods
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    if (HMIsEmptyString(self.notDataTipText)) {
        return nil;
    }
    NSString *text = self.notDataTipText;
    UIFont *font = self.tipFont?self.tipFont:[UIFont systemFontOfSize:14];
    
    UIColor *textColor = self.tipColor ? self.tipColor : RGBCOLOR16(0xC6C6C6);
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    return attributedString;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    if (self.emptyDataIsTap) {
        if (self.clickRetryActionBlock) {
            self.clickRetryActionBlock();
        }
    }
}

//设置空白按钮
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    // 设置按钮标题
    NSString *buttonTitle = self.buttonTipTitle.length > 0 ? self.buttonTipTitle : @"";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName:RGBCOLOR16(0x8996A6)
                                 };
    return [[NSAttributedString alloc] initWithString:buttonTitle attributes:attributes];
}

//设置空白按钮点击事件
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    if (self.clickBlankButtonBlock) {
        self.clickBlankButtonBlock();
    }
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor clearColor];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.emptyDataIsTap) {
        return [UIImage imageNamed:@"loadFailPlaceImage"];
    }
    return [UIImage imageNamed:self.imageForEmpty];
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return self.emptyDataSetShouldDisplay;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.scrollTableViewBlock) {
        self.scrollTableViewBlock(scrollView);
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    !self.scrollViewWillBeginDraggingBlock? :self.scrollViewWillBeginDraggingBlock(scrollView);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    !self.scrollViewDidEndDraggingWillDecelerateBlock? :self.scrollViewDidEndDraggingWillDecelerateBlock(scrollView,decelerate);
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    !self.scrollViewWillBeginDeceleratingBlock? :self.scrollViewWillBeginDeceleratingBlock(scrollView);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    !self.scrollViewDidEndDeceleratingBlock? :self.scrollViewDidEndDeceleratingBlock(scrollView);
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    !self.scrollViewDidEndScrollingAnimationBlock? :self.scrollViewDidEndScrollingAnimationBlock(scrollView);
}

@end
