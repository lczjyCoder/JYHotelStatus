//
//  HotelStatusViewController.m
//  Lvmm
//
//  Created by zjy on 2017/3/20.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "JYHotelStatusViewController.h"
#import "HotelStatusDateCell.h"
#import "JYCollectionViewFlowLayout.h"
#import "SelectWeekCell.h"
#import "JYGroupedCellBgView.h"
#import "HotelChangeStatusCell.h"
#import "TotalStockCell.h"
#import "RemainStockCell.h"
#import "HotelStatusModel.h"
#import "JYDateTool.h"

@interface JYHotelStatusViewController () <UICollectionViewDelegate,UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource> {
    NSInteger cellWidth;
    BOOL isSingleDate;
    NSInteger currentSection;
    NSInteger tvNumOfSections;
    NSDate *todayDate;
    NSInteger currentMonthDays;
    NSInteger currentFirstWeekday;
    BOOL selectedSingleDate;

    NSMutableArray *allModelArr;
    NSMutableArray *selectedWeekdaysArr;
}

@property (nonatomic, strong) NSMutableArray *selectedModelArr;

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) UIView *yearMonthView;
@property (nonatomic, strong) UIView *weekView;
@property (nonatomic, strong) UIButton *commitBtn;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *calendarView;
@property (nonatomic, strong) UIView *hotelStatusNoteView;

@property (nonatomic, strong) HotelChangeStatusCell *hotelChangeStatusCell;
@property (nonatomic, strong) SelectWeekCell *selectWeekCell;
@property (nonatomic, strong) RemainStockCell *remainStockCell;
@property (nonatomic, strong) TotalStockCell *totalStockCell;

@property (nonatomic, strong) UIButton *coverView;
@property (nonatomic, strong) UIView *hotelStatusSelectView;
@end

static NSString *kHotelStatusCellId = @"hotelStatusCellId";

@implementation JYHotelStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initParams];
    [self initUI];
    [self initMasonry];
}

- (void)initParams {
    currentSection = 0;
    tvNumOfSections = 12;
    cellWidth = MAINSCREEN_SIZE.width / 7;
    todayDate = [NSDate date];
    currentMonthDays = [[JYDateTool shareJYDateTool] totaldaysInMonth:todayDate];
    currentFirstWeekday = [[JYDateTool shareJYDateTool] firstWeekdayInThisMonth:todayDate];
    
    selectedSingleDate = YES;
    allModelArr = [NSMutableArray array];
    self.selectedModelArr = [NSMutableArray array];
    selectedWeekdaysArr = [NSMutableArray array];
    for (int i = 0; i < tvNumOfSections; i++) {
        NSMutableArray *arr = [NSMutableArray array];
        for (int j = 0; j < 42; j ++) {
            HotelStatusModel *model = [[HotelStatusModel alloc] init];
            model.indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            model.date = [[JYDateTool shareJYDateTool] dateWithIndexPath:model.indexPath];
            model.status = @"正常";
            model.selected = NO;
            model.remainNum = @"50";
            [arr addObject:model];
        }
        [allModelArr addObject:arr];
    }
}

- (void)initUI {
    self.navigationController.navigationBar.hidden = YES;
    [self.view addSubview:self.topView];
    [self.view addSubview:self.yearMonthView];
    [self.view addSubview:self.weekView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.commitBtn];
    [self.view addSubview:self.coverView];
    [self.view addSubview:self.hotelStatusSelectView];
}

#pragma mark - action

-(void)lastMonthAction:(UIButton *)sender {
    if (currentSection <= 0) {
        return;
    }
    currentSection --;
    [self scrollCollectionViewWithSecion:currentSection];
}

-(void)nextMonthAction:(UIButton *)sender {
    if (currentSection >= tvNumOfSections - 1) {
        return;
    }
    currentSection ++;
    [self scrollCollectionViewWithSecion:currentSection];
}

- (void)scrollCollectionViewWithSecion:(NSInteger)section {
    NSIndexPath* cellIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
    UICollectionViewLayoutAttributes* attr = [self.collectionView.collectionViewLayout layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:cellIndexPath];
    UIEdgeInsets insets = self.collectionView.scrollIndicatorInsets;
    
    CGRect rect = attr.frame;
    rect.size = self.collectionView.frame.size;
    rect.size.height -= insets.top + insets.bottom;
    CGFloat offset = (rect.origin.y + rect.size.height) - self.collectionView.contentSize.height;
    if ( offset > 0.0 ) rect = CGRectOffset(rect, 0, -offset);
    
    [self.collectionView scrollRectToVisible:rect animated:YES];
}

- (void)cancelSearchAction {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)hiddenCoverView:(UIButton *)sender {
    self.hotelStatusSelectView.hidden = YES;
    self.coverView.hidden = YES;
}

- (void)selectStatusAction:(UIButton *)sender {
    for (int i = 0; i < 3; i ++) {
        UILabel *label = [self.view viewWithTag:i + 10];
        UIImageView *imageView = [self.view viewWithTag:i + 20];
        if (label.tag == sender.tag - 20) {
            label.textColor = [JYConfig JYColorWithHexadecimal:kColorMainRed];
            self.hotelChangeStatusCell.statusLabel.text = label.text;
        } else {
            label.textColor = [JYConfig JYColorWithHexadecimal:kColorTextDarkGray];
        }
        if (imageView.tag == sender.tag - 10) {
            imageView.hidden = NO;
        } else {
            imageView.hidden = YES;
        }
    }
    UILabel *label = [self.view viewWithTag:sender.tag - 20];
    for (HotelStatusModel *hotel in self.selectedModelArr) {
        if (hotel.selected) {
            hotel.status = label.text;
        }
    }
    [self.collectionView reloadData];
    [self hiddenCoverView:nil];
}

- (void)commitAction:(UIButton *)sender {
    
}

- (void)changeSelectedDateWithWeekDays:(UIButton *)selectedBtn {
    if ([selectedBtn.titleLabel.textColor isEqual:[JYConfig JYColorWithHexadecimal:kColorTextDarkDarkGray]]) {
        if ([selectedBtn.titleLabel.text isEqualToString:@"全部"]) {
            selectedWeekdaysArr = [NSMutableArray array];
        } else {
            [selectedWeekdaysArr removeObject:selectedBtn.titleLabel.text];
        }
    } else {
        if ([selectedBtn.titleLabel.text isEqualToString:@"全部"]) {
            selectedWeekdaysArr = [NSMutableArray arrayWithArray:@[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"]];
        } else {
            if (selectedWeekdaysArr.count == 7) {
                selectedWeekdaysArr = [NSMutableArray array];
            }
            [selectedWeekdaysArr addObject:selectedBtn.titleLabel.text];
        }
    }
    for (HotelStatusModel *model in self.selectedModelArr) {
        if ([selectedWeekdaysArr containsObject:model.weekday]) {
            model.selected = YES;
        } else {
            model.selected = NO;
        }
    }
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource/UICollectionViewDelegateFlowLayout

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([scrollView isEqual:self.collectionView]) {
        CGRect visibleRect = (CGRect){.origin = self.collectionView.contentOffset, .size = self.collectionView.bounds.size};
        CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
        NSIndexPath *visibleIndexPath = [self.collectionView indexPathForItemAtPoint:visiblePoint];
        if (currentSection == visibleIndexPath.section || visibleIndexPath == nil) {
            return;
        }
        currentSection = visibleIndexPath.section;
        if (currentSection == 0) {
            UIButton *btn = [self.view viewWithTag:1];
            [btn setImage:[UIImage imageNamed:@"lastGreyIcon"] forState:UIControlStateNormal];
        } else if (currentSection == tvNumOfSections - 1) {
            UIButton *btn = [self.view viewWithTag:2];
            [btn setImage:[UIImage imageNamed:@"nextGreyIcon"] forState:UIControlStateNormal];
        } else {
            UIButton *lastBtn = [self.view viewWithTag:1];
            [lastBtn setImage:[UIImage imageNamed:@"lastRedIcon"] forState:UIControlStateNormal];
            UIButton *nextBtn = [self.view viewWithTag:2];
            [nextBtn setImage:[UIImage imageNamed:@"nextRedIcon"] forState:UIControlStateNormal];
        }
        UILabel *label = [self.view viewWithTag:3];
        NSDateComponents *comp = [[JYDateTool shareJYDateTool] currentComponents:currentSection];
        NSLog(@"张九阳");
        label.text = [NSString stringWithFormat:@"%ld年%02ld月",comp.year,comp.month];
    }
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return tvNumOfSections;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 42;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    NSDate *showDate = [[JYDateTool shareJYDateTool].gregorian dateFromComponents:[[JYDateTool shareJYDateTool] currentComponents:indexPath.section]];
    currentMonthDays = [[JYDateTool shareJYDateTool] totaldaysInMonth:showDate];
    currentFirstWeekday = [[JYDateTool shareJYDateTool] firstWeekdayInThisMonth:showDate];
    NSLog(@"%ld  %ld",indexPath.section,indexPath.row);

    if (indexPath.row < currentFirstWeekday || (indexPath.row > currentFirstWeekday + currentMonthDays - 1)) {
        return [collectionView dequeueReusableCellWithReuseIdentifier:kHotelStatusCellId forIndexPath:indexPath];
    } else {
        HotelStatusDateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHotelStatusCellId forIndexPath:indexPath];
        [cell resetCell:(HotelStatusModel *)(allModelArr[indexPath.section])[indexPath.row]];
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return (CGSize){cellWidth, cellWidth};
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, (MAINSCREEN_SIZE.width - cellWidth * 7) / 2, 5, (MAINSCREEN_SIZE.width - cellWidth * 7) / 2);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDate *showDate = [[JYDateTool shareJYDateTool].gregorian dateFromComponents:[[JYDateTool shareJYDateTool] currentComponents:indexPath.section]];
    currentMonthDays = [[JYDateTool shareJYDateTool] totaldaysInMonth:showDate];
    currentFirstWeekday = [[JYDateTool shareJYDateTool] firstWeekdayInThisMonth:showDate];
    if (indexPath.row < currentFirstWeekday || (indexPath.row > currentFirstWeekday + currentMonthDays - 1)) {
    } else {
        for (int i = 0; i < tvNumOfSections; i++) {
            NSMutableArray *arr = allModelArr[i];
            for (HotelStatusModel *model in arr) {
                model.selected = NO;
            }
        }
        HotelStatusModel *model = (HotelStatusModel *)allModelArr[indexPath.section][indexPath.row];
        self.totalStockCell.stockTextField.text = model.remainNum;
        selectedSingleDate = YES;
        if (self.selectedModelArr.count == 0) { // 没选日期
            model.selected = YES;
            [self.selectedModelArr addObject:model];
        } else if (self.selectedModelArr.count == 1) {// 已选一个日期
            HotelStatusModel *selectedModel = [self.selectedModelArr firstObject];
            self.selectedModelArr = [NSMutableArray array];
            if ([model.indexPath isEqual:selectedModel.indexPath]) {//同一日期
                model.selected = NO;
            } else {
                if (model.indexPath.section < selectedModel.indexPath.section || (model.indexPath.section == selectedModel.indexPath.section && model.indexPath.row < selectedModel.indexPath.row)) {//点击日期在已选日期前
                    model.selected = YES;
                    [self.selectedModelArr addObject:model];
                } else {
                    selectedSingleDate = NO;
                    NSInteger numOfMonth = model.indexPath.section - selectedModel.indexPath.section;
                    if (numOfMonth == 0) {//相同月份
                        for (HotelStatusModel *model1 in allModelArr[model.indexPath.section]) {
                            if (model1.indexPath.row <= model.indexPath.row && model1.indexPath.row >= selectedModel.indexPath.row) {
                                model1.selected = YES;
                                [self.selectedModelArr addObject:model1];
                            }
                        }
                    } else {//间隔月份
                        NSInteger selectedFirstWeekDay = [[JYDateTool shareJYDateTool] firstWeekdayInSection:selectedModel.indexPath.section];
                        NSInteger selectedTotalDays = [[JYDateTool shareJYDateTool] totaldaysInMonth:selectedModel.date];
                        NSInteger lastRow = selectedFirstWeekDay + selectedTotalDays - 1;
                        for (HotelStatusModel *model1 in allModelArr[selectedModel.indexPath.section]) {
                            if (model1.indexPath.row >= selectedModel.indexPath.row && model1.indexPath.row <= lastRow) {
                                model1.selected = YES;
                                [self.selectedModelArr addObject:model1];
                                
                            }
                        }
                        
                        if (numOfMonth > 1) {
                            for (NSInteger i = selectedModel.indexPath.section + 1; i < model.indexPath.section; i ++) {
                                for (HotelStatusModel *model1 in allModelArr[i]) {
                                    model1.selected = YES;
                                    [self.selectedModelArr addObject:model1];
                                }
                            }
                        }
                        
                        for (HotelStatusModel *model1 in allModelArr[model.indexPath.section]) {
                            if (model1.indexPath.row >= model.firstWeekday && model1.indexPath.row <= model.indexPath.row) {
                                model1.selected = YES;
                                [self.selectedModelArr addObject:model1];
                            }
                        }
                    }
                }
            }
        } else {// 已选多个日期
            selectedSingleDate = YES;
            self.selectedModelArr = [NSMutableArray array];
            model.selected = YES;
            [self.selectedModelArr addObject:model];
        }
    }
    [self.tableView reloadData];
    [self.collectionView reloadData];
}

#pragma mark - UITableViewDelegate/UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (selectedSingleDate) {
        if (indexPath.row == 0) {
            static NSString *hotelChangeStatusCellId = @"hotelChangeStatusCellId";
            self.hotelChangeStatusCell = [tableView dequeueReusableCellWithIdentifier:hotelChangeStatusCellId];
            if (!self.hotelChangeStatusCell) {
                self.hotelChangeStatusCell = [[HotelChangeStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hotelChangeStatusCellId];
            }
            self.hotelChangeStatusCell.backgroundView = [[JYGroupedCellBgView alloc] initWithFrame:self.hotelChangeStatusCell.bounds withDataSourceCount:3 withIndex:indexPath.row isPlain:YES needArrow:NO isSelected:NO];
            return self.hotelChangeStatusCell;
        } else if (indexPath.row == 1) {
            static NSString *totalStockCellId = @"totalStockCellId";
            self.totalStockCell = [tableView dequeueReusableCellWithIdentifier:totalStockCellId];
            if (!self.totalStockCell) {
                self.totalStockCell = [[TotalStockCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:totalStockCellId];
                __weak typeof(self) weakSelf = self;
                self.totalStockCell.changeStockBlock = ^(NSString *stock){
                    if (weakSelf.selectedModelArr.count > 0) {
                        for (HotelStatusModel *hotel in weakSelf.selectedModelArr) {
                            if (hotel.selected) {
                                hotel.remainNum = stock;
                            }
                        }
                        [weakSelf.collectionView reloadData];
                    }
                };
            }
            self.totalStockCell.backgroundView = [[JYGroupedCellBgView alloc] initWithFrame:self.totalStockCell.bounds withDataSourceCount:3 withIndex:indexPath.row isPlain:YES needArrow:NO isSelected:NO];
            return self.totalStockCell;
        } else {
            static NSString *remainStockCellId = @"remainStockCellId";
            self.remainStockCell = [tableView dequeueReusableCellWithIdentifier:remainStockCellId];
            if (!self.remainStockCell) {
                self.remainStockCell = [[RemainStockCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:remainStockCellId];
            }
            self.remainStockCell.backgroundView = [[JYGroupedCellBgView alloc] initWithFrame:self.remainStockCell.bounds withDataSourceCount:3 withIndex:indexPath.row isPlain:YES needArrow:NO isSelected:NO];
            if (self.selectedModelArr.count == 0) {
                [self.remainStockCell resetCell:@"0"];
            } else {
                HotelStatusModel *model = [self.selectedModelArr firstObject];
                [self.remainStockCell resetCell:model.remainNum];
            }
            return self.remainStockCell;
        }
    } else {
        if (indexPath.row == 0) {
            static NSString *selectWeekCellId = @"selectWeekCellId";
            self.selectWeekCell = [tableView dequeueReusableCellWithIdentifier:selectWeekCellId];
            if (!self.selectWeekCell) {
                self.selectWeekCell = [[SelectWeekCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:selectWeekCellId];
                __weak typeof(self) weakSelf = self;
                self.selectWeekCell.selectWeekDayBlock = ^(UIButton *selectedBtn){
                    [weakSelf changeSelectedDateWithWeekDays:selectedBtn];
                };
            }
            self.selectWeekCell.backgroundView = [[JYGroupedCellBgView alloc] initWithFrame:self.selectWeekCell.bounds withDataSourceCount:3 withIndex:indexPath.row isPlain:YES needArrow:NO isSelected:NO];
            return self.selectWeekCell;
        } else if (indexPath.row == 1) {
            static NSString *hotelChangeStatusCellId = @"hotelChangeStatusCellId";
            self.hotelChangeStatusCell = [tableView dequeueReusableCellWithIdentifier:hotelChangeStatusCellId];
            if (!self.hotelChangeStatusCell) {
                self.hotelChangeStatusCell = [[HotelChangeStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hotelChangeStatusCellId];
            }
            self.hotelChangeStatusCell.backgroundView = [[JYGroupedCellBgView alloc] initWithFrame:self.hotelChangeStatusCell.bounds withDataSourceCount:3 withIndex:indexPath.row isPlain:YES needArrow:NO isSelected:NO];
            return self.hotelChangeStatusCell;
        } else {
            static NSString *totalStockCellId = @"totalStockCellId";
            self.totalStockCell = [tableView dequeueReusableCellWithIdentifier:totalStockCellId];
            if (!self.totalStockCell) {
                self.totalStockCell = [[TotalStockCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:totalStockCellId];
                __weak typeof(self) weakSelf = self;
                self.totalStockCell.changeStockBlock = ^(NSString *stock){
                    if (weakSelf.selectedModelArr.count > 0) {
                        for (HotelStatusModel *hotel in weakSelf.selectedModelArr) {
                            if (hotel.selected) {
                                hotel.remainNum = stock;
                            }
                        }
                        [weakSelf.collectionView reloadData];
                    }
                };
            }
            self.totalStockCell.backgroundView = [[JYGroupedCellBgView alloc] initWithFrame:self.totalStockCell.bounds withDataSourceCount:3 withIndex:indexPath.row isPlain:YES needArrow:NO isSelected:NO];
            return self.totalStockCell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (selectedSingleDate) {
        if (indexPath.row == 0) {
            return 50;
        } else if (indexPath.row == 1){
            return 55;
        } else {
            return 50;
        }
    } else {
        if (indexPath.row == 0) {
            return 80;
        } else if (indexPath.row == 1){
            return 50;
        } else {
            return 55;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger i;
    if (selectedSingleDate) {
        i = 0;
    } else {
        i = 1;
    }
    if (indexPath.row == i) {
        if (self.selectedModelArr.count == 0) {
            return;
        }
        self.hotelStatusSelectView.hidden = NO;
        self.coverView.hidden = NO;
    }
}


#pragma mark - initUI

- (void)initMasonry {
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30,30));
        make.bottom.mas_equalTo(self.topView).offset(-5);
        make.left.mas_equalTo(self.topView).offset(15);
    }];
    [self.yearMonthView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(35);
        make.top.mas_equalTo(self.topView.mas_bottom);
        make.left.right.mas_equalTo(self.topView);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).offset(-45);
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.yearMonthView.mas_bottom);
    }];
    [self.hotelStatusSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(@135);
    }];
    [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(@45);
    }];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [JYConfig JYColorWithHexadecimal:kColorMainBackground];
        _tableView.hidden = NO;
        _tableView.tableHeaderView = self.calendarView;
        _tableView.tableFooterView = self.hotelStatusNoteView;
    }
    return _tableView;
}

- (UIView *)calendarView {
    if (!_calendarView) {
        _calendarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_SIZE.width, self.weekView.bounds.size.height + self.collectionView.bounds.size.height)];
        [_calendarView addSubview:self.weekView];
        [_calendarView addSubview:self.collectionView];
        [_calendarView addSubview:[JYConfig makeLineViewWithFrame:CGRectMake(0, _calendarView.bounds.size.height - 0.5, MAINSCREEN_SIZE.width, 0.5)]];
    }
    return _calendarView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        JYCollectionViewFlowLayout *layout = [[JYCollectionViewFlowLayout alloc] init];
        layout.itemCountPerRow = 7;
        layout.rowCount = 6;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, self.weekView.bounds.size.height, MAINSCREEN_SIZE.width, cellWidth * 6 + 10) collectionViewLayout:layout];
        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollsToTop = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[HotelStatusDateCell class] forCellWithReuseIdentifier:kHotelStatusCellId];
    }
    return _collectionView;
}

- (UIView *)hotelStatusNoteView {
    if (!_hotelStatusNoteView) {
        _hotelStatusNoteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_SIZE.width, 55)];
        _hotelStatusNoteView.backgroundColor = [JYConfig JYColorWithHexadecimal:kColorMainBackground];
        UIImageView *noteImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noteIcon.png"]];
        UILabel *noteLabel = [[UILabel alloc] init];
        noteLabel.textColor = [JYConfig JYColorWithHexadecimal:kColorTextDarkGray];
        noteLabel.font = [UIFont systemFontOfSize:12];
        noteLabel.text = @"总库存 = 剩余库存 + 销售库存";
        [_hotelStatusNoteView addSubview:noteLabel];
        [_hotelStatusNoteView addSubview:noteImageView];
        
        [noteImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(14, 14));
            make.top.equalTo(_hotelStatusNoteView).offset(5);
            make.left.equalTo(_hotelStatusNoteView).offset(15);
        }];
        [noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_hotelStatusNoteView);
            make.top.equalTo(_hotelStatusNoteView).offset(5);
            make.left.equalTo(noteImageView.mas_right).offset(2);
            make.height.mas_equalTo(14);
        }];
    }
    return _hotelStatusNoteView;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_SIZE.width, 64)];
        _topView.backgroundColor = [JYConfig JYColorWithHexadecimal:@"3d5065"];
        UILabel *titlleLable = [[UILabel alloc] init];
        titlleLable.text = @"房态库存信息";
        titlleLable.textAlignment = NSTextAlignmentCenter;
        titlleLable.font = [UIFont systemFontOfSize:19];
        titlleLable.textColor = [JYConfig JYColorWithHexadecimal:kColorTextWhite];
        [_topView addSubview:titlleLable];
        [_topView addSubview:self.backButton];
        [titlleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_topView);
            make.bottom.mas_equalTo(_topView).offset(-10);
            make.size.mas_equalTo(CGSizeMake(200, 20));
        }];
    }
    return _topView;
}

- (UIButton *)commitBtn {
    if (!_commitBtn) {
        _commitBtn = [[UIButton alloc] init];
        _commitBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_commitBtn setBackgroundColor:[JYConfig JYColorWithHexadecimal:kColorMainRed]];
        [_commitBtn setTitle:@"提交审核" forState:UIControlStateNormal];
        [_commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_commitBtn addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitBtn;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [[UIButton alloc] init];
        [_backButton setImage:[UIImage imageNamed:@"navigationBackItem"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(cancelSearchAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIView *)yearMonthView {
    if (!_yearMonthView) {
        _yearMonthView = [[UIView alloc] init];
        _yearMonthView.backgroundColor = [JYConfig JYColorWithHexadecimal:kColorMainBackground];
        
        UIButton *lastMonthBtn = [[UIButton alloc] init];
        lastMonthBtn.tag = 1;
        [lastMonthBtn setImage:[UIImage imageNamed:@"lastGreyIcon.png"] forState:UIControlStateNormal];
        [lastMonthBtn addTarget:self action:@selector(lastMonthAction:) forControlEvents:UIControlEventTouchUpInside];
        UIButton *nextMonthBtn = [[UIButton alloc] init];
        nextMonthBtn.tag = 2;
        [nextMonthBtn setImage:[UIImage imageNamed:@"nextRedIcon.png"] forState:UIControlStateNormal];
        [nextMonthBtn addTarget:self action:@selector(nextMonthAction:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *yearMonthLabel = [[UILabel alloc] init];
        yearMonthLabel.tag = 3;
        yearMonthLabel.textAlignment = NSTextAlignmentCenter;
        yearMonthLabel.textColor = [JYConfig JYColorWithHexadecimal:kColorTextDarkDarkGray];
        yearMonthLabel.font = [UIFont systemFontOfSize:12];
        NSDateComponents *comp = [[JYDateTool shareJYDateTool] todayComponents];
        yearMonthLabel.text = [NSString stringWithFormat:@"%ld年%02ld月",comp.year,comp.month];
        
        [_yearMonthView addSubview:[JYConfig makeLineViewWithFrame:CGRectMake(0, 34.5, MAINSCREEN_SIZE.width, 0.5)]];
        [_yearMonthView addSubview:yearMonthLabel];
        [_yearMonthView addSubview:lastMonthBtn];
        [_yearMonthView addSubview:nextMonthBtn];
        
        [yearMonthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(75,13));
            make.centerY.mas_equalTo(_yearMonthView);
            make.centerX.mas_equalTo(_yearMonthView);
        }];
        [lastMonthBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30,30));
            make.centerY.mas_equalTo(_yearMonthView);
            make.right.mas_equalTo(yearMonthLabel.mas_left).offset(-10);
        }];
        [nextMonthBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30,30));
            make.centerY.mas_equalTo(_yearMonthView);
            make.left.mas_equalTo(yearMonthLabel.mas_right).offset(10);
        }];
    }
    return _yearMonthView;
}

- (UIView *)weekView {
    if (!_weekView) {
        _weekView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_SIZE.width, 30)];
        _weekView.backgroundColor = [UIColor whiteColor];
        NSArray *arr = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
        for (int i = 0; i < 7; i ++) {
            UILabel *weekLabel = [[UILabel alloc] initWithFrame:CGRectMake(i * MAINSCREEN_SIZE.width / 7, 0, MAINSCREEN_SIZE.width / 7, 30)];
            weekLabel.font = [UIFont systemFontOfSize:12];
            weekLabel.text = arr[i];
            weekLabel.textAlignment = NSTextAlignmentCenter;
            if (i == 0 || i == 6) {
                weekLabel.textColor = [JYConfig JYColorWithHexadecimal:kColorMainRed];
            } else {
                weekLabel.textColor = [JYConfig JYColorWithHexadecimal:kColorTextDarkGray];
            }
            [_weekView addSubview:weekLabel];
        }
        [_weekView addSubview:[JYConfig makeLineViewWithFrame:CGRectMake(10, 29.5, MAINSCREEN_SIZE.width - 20, 0.5)]];
    }
    return _weekView;
}

- (UIView *)hotelStatusSelectView {
    if (!_hotelStatusSelectView) {
        _hotelStatusSelectView = [[UIView alloc] init];
        _hotelStatusSelectView.backgroundColor = [UIColor whiteColor];
        _hotelStatusSelectView.hidden = YES;
        NSArray *arr = @[@"正常",@"紧张",@"满房"];
        for (NSInteger i = 0; i < 3; i ++) {
            UIView *statusSelectedView = [self statusSelectedViewWithStatus:arr[i] tag:i];
            [_hotelStatusSelectView addSubview:statusSelectedView];
            [statusSelectedView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_hotelStatusSelectView).offset(i * 45);
                make.left.right.equalTo(_hotelStatusSelectView);
                make.height.mas_equalTo(45);
            }];
        }
        [_hotelStatusSelectView addSubview:[JYConfig makeLineViewWithFrame:CGRectMake(0, 45, MAINSCREEN_SIZE.width, 0.5)]];
        [_hotelStatusSelectView addSubview:[JYConfig makeLineViewWithFrame:CGRectMake(0, 90, MAINSCREEN_SIZE.width, 0.5)]];
    }
    return _hotelStatusSelectView;
}

- (UIView *)statusSelectedViewWithStatus:(NSString *)status tag:(NSInteger)tag {
    
    UIView *statusSelectedView = [[UIView alloc] init];
    UILabel *statusLabel = [[UILabel alloc] init];
    statusLabel.text = status;
    statusLabel.font = [UIFont systemFontOfSize:13];
    statusLabel.textColor = [JYConfig JYColorWithHexadecimal:kColorTextDarkGray];
    statusLabel.tag = 10 + tag;
    UIImageView *selectedIamgeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chooseIcon.png"]];
    selectedIamgeView.hidden = YES;
    selectedIamgeView.tag = 20 + tag;
    UIButton *btn = [[UIButton alloc] init];
    btn.tag = 30 + tag;
    [btn addTarget:self action:@selector(selectStatusAction:) forControlEvents:UIControlEventTouchUpInside];
    [statusSelectedView addSubview:statusLabel];
    [statusSelectedView addSubview:selectedIamgeView];
    [statusSelectedView addSubview:btn];
    
    [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(statusSelectedView).offset(15);
        make.centerY.equalTo(statusSelectedView);
        make.size.mas_equalTo(CGSizeMake(28, 15));
    }];
    [selectedIamgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(statusSelectedView).offset(-15);
        make.centerY.equalTo(statusSelectedView);
        make.size.mas_equalTo(CGSizeMake(12, 9));
    }];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.top.bottom.equalTo(statusSelectedView);
    }];
    
    return statusSelectedView;
}

- (UIButton *)coverView {
    if (!_coverView) {
        _coverView = [[UIButton alloc] initWithFrame:self.view.bounds];
        _coverView.backgroundColor = [JYConfig JYColorWithHexadecimal:kColorMainBlack];
        [_coverView addTarget:self action:@selector(hiddenCoverView:) forControlEvents:UIControlEventTouchUpInside];
        _coverView.alpha = 0.6;
        _coverView.hidden = YES;
    }
    return _coverView;
}

@end
