//
//  CXFlowLayout.h
//  Cx －瀑布流简单实现
//
//  Created by Mac on 16/3/17.
//  Copyright © 2016年 Mac－Cx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CXFlowLayout;

@protocol CYXWaterFlowLayoutDelegate <NSObject>
@required
- (CGFloat)waterflowLayout:(CXFlowLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth;

@optional
- (CGFloat)columnCountInWaterflowLayout:(CXFlowLayout *)waterflowLayout;
- (CGFloat)columnMarginInWaterflowLayout:(CXFlowLayout *)waterflowLayout;
- (CGFloat)rowMarginInWaterflowLayout:(CXFlowLayout *)waterflowLayout;
- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(CXFlowLayout *)waterflowLayout;
@end


@interface CXFlowLayout : UICollectionViewLayout

@property (nonatomic, weak) id<CYXWaterFlowLayoutDelegate> delegate;


@end
