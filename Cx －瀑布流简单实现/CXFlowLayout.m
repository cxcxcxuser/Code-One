//
//  CXFlowLayout.m
//  Cx －瀑布流简单实现
//
//  Created by Mac on 16/3/17.
//  Copyright © 2016年 Mac－Cx. All rights reserved.
//

#import "CXFlowLayout.h"
/*   默认的数据  */
/** 默认的列数*/
static const NSInteger CXDefaultColumnCount = 3;
/** 每一列的间距*/
static const CGFloat CXDefaultColumnMargin = 10;
/** 每一行的间距*/
static const CGFloat CXDefaultRowMargin = 10;
/** 边缘间距*/
static const UIEdgeInsets CXDefaultEdgeInsets = {10, 10, 10, 10};

@interface CXFlowLayout()
/** 存放所有cell的布局属性*/
@property (nonatomic, strong) NSMutableArray *cellsLayoutArray;
/** 存放所有列的高度*/
@property (nonatomic, strong) NSMutableArray *columnHeights;
/** 内容的高度*/
@property (nonatomic, assign) CGFloat contentHeight;
// 每一行的间距
-(CGFloat)rowMargin;
// 每一列的间距
-(CGFloat)columnMargin;
// 总共多少列
-(NSInteger)columnCount;
// Item间的Margin
-(UIEdgeInsets)edgeInsets;


@end

@implementation CXFlowLayout
- (CGFloat)rowMargin{
    if ([self.delegate respondsToSelector:@selector(rowMarginInWaterflowLayout:)]) {
        return [self.delegate rowMarginInWaterflowLayout:self];
    }else{
        return CXDefaultRowMargin;
    }
}
// 每一列的间距
- (CGFloat)columnMargin{
    if ([self.delegate respondsToSelector:@selector(columnMarginInWaterflowLayout:)]) {
        return [self.delegate columnMarginInWaterflowLayout:self];
    } else {
        return CXDefaultColumnMargin;
    }
}
// 总共多少列
- (NSInteger)columnCount{
    if ([self.delegate respondsToSelector:@selector(columnCountInWaterflowLayout:)]) {
        return [self.delegate columnCountInWaterflowLayout:self];
    } else {
        return CXDefaultColumnCount;
    }
}
// Item间的Margin
- (UIEdgeInsets)edgeInsets{
    if ([self.delegate respondsToSelector:@selector(edgeInsetsInWaterflowLayout:)]) {
        return [self.delegate edgeInsetsInWaterflowLayout:self];
    } else {
        return CXDefaultEdgeInsets;
    }
}

-(NSMutableArray *)columnHeights{
    if (!_columnHeights) {
        _columnHeights = [NSMutableArray array];
    }
    return _columnHeights;
}

-(NSMutableArray *)cellsLayoutArray{
    if (!_cellsLayoutArray) {
        _cellsLayoutArray = [NSMutableArray array];
    }
    return _cellsLayoutArray;
}

- (void)prepareLayout{
    [super prepareLayout];
    self.contentHeight = 0;
    // 清除以前计算的所有高度
    [self.columnHeights removeAllObjects];
    for (NSInteger i = 0; i < self.columnCount; i++) {
        [self.columnHeights addObject:@(self.edgeInsets.top)];
    }
    // 清除以前所有的布局属性
    [self.cellsLayoutArray removeAllObjects];
    // 开始创建每一个cell对应的布局属性
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i < count; i++) {
        // 创建位置
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        // 获取indexPath位置cell对应的布局属性
        UICollectionViewLayoutAttributes * attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.cellsLayoutArray addObject:attrs];
                                   
    }
}
/**
 * 决定cell的排布
 */
-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{

    return self.cellsLayoutArray;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{

    // 创建布局属性
    UICollectionViewLayoutAttributes * atts = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    // collectionView 的宽度
    CGFloat collectionViewWigth = self.collectionView.frame.size.width;
    // 设置布局属性的Frame
    // 设置每一个Item的宽
    CGFloat w = (collectionViewWigth - self.edgeInsets.left - self.edgeInsets.right - (self.columnCount - 1) * self.columnMargin) / self.columnCount;
    // 设置每一个Item的高
    CGFloat height = [self.delegate waterflowLayout:self heightForItemAtIndex:indexPath.item itemWidth:w];
    // 找出高度最短的那一列
    NSInteger destColumn = 0;
    
    CGFloat minColumnHeight = [self.columnHeights[0] doubleValue];
    for (NSInteger i =1 ; i< self.columnCount; i++) {
        // 取得第i 列的高度
        CGFloat columnheight = [self.columnHeights[i] doubleValue];
        
        if (minColumnHeight > columnheight) {
            minColumnHeight = columnheight;
            destColumn = i;
        }
    }
    
    CGFloat x = self.edgeInsets.left + destColumn * (w + self.columnMargin);
    CGFloat y = minColumnHeight;
    if (y != self.edgeInsets.top) {
        y += self.rowMargin;
    }
    atts.frame = CGRectMake(x, y, w, height);
     // 更新最短那列的高度
    self.columnHeights[destColumn] = @(CGRectGetMaxY(atts.frame));
    // 记录内容的高度
    CGFloat columnHeight = [self.columnHeights[destColumn] doubleValue];
    if (self.contentHeight < columnHeight) {
        self.contentHeight = columnHeight;
    }
    return atts;
}
- (CGSize)collectionViewContentSize{
    return CGSizeMake(0, self.contentHeight + self.edgeInsets.bottom);
}

@end
