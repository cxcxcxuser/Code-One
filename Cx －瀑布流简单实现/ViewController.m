//
//  ViewController.m
//  Cx －瀑布流简单实现
//
//  Created by Mac on 16/3/17.
//  Copyright © 2016年 Mac－Cx. All rights reserved.
//

#import "ViewController.h"
#import "CXFlowLayout.h"
#define CYXRandomColor CYXColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))


@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,CYXWaterFlowLayoutDelegate>
@property (nonatomic, weak) UICollectionView *collectionView;
@end

@implementation ViewController
static NSString * const CXCellId = @"test";
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"瀑布流";
    
    CXFlowLayout *layout = [[CXFlowLayout alloc]init];
    layout.delegate = self;
    
    // 创建CollectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor colorWithRed:237.0/255.5 green:237.0/255.5 blue:237.0/255.5 alpha:1];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    // 注册
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CXCellId];
    
//    [self setupRefresh];

}
#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 50;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CXCellId forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor blueColor];
    
    NSInteger tag = 10;
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:tag];
    if (label == nil) {
        label = [[UILabel alloc] init];
        label.tag = tag;
        [cell.contentView addSubview:label];
    }
    
    label.text = [NSString stringWithFormat:@"%zd", indexPath.item];
    [label sizeToFit];
    
    return cell;
}
#pragma mark - <CYXWaterFlowLayoutDelegate>
- (CGFloat)waterflowLayout:(CXFlowLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth
{
    return 100 + arc4random_uniform(150);
}

- (CGFloat)rowMarginInWaterflowLayout:(CXFlowLayout *)waterflowLayout
{
    return 10;
}

- (CGFloat)columnCountInWaterflowLayout:(CXFlowLayout *)waterflowLayout
{
    return 2;
}

- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(CXFlowLayout *)waterflowLayout
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
