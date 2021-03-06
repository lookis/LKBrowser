//
//  LKTabViewController.m
//  LKBrowser
//
//  Created by Lookis on 16/03/2017.
//  Copyright © 2017 Lookis. All rights reserved.
//

#import "LKTabViewController.h"
#import "LKTabCell.h"
#import "LKTabTransitioning.h"
#import "LKTabExitTransitioning.h"
#import "BrowserViewController.h"
#import <CoreImage/CoreImage.h>
#import "LKCellFlowLayout.h"

@interface LKTabViewController () <UIViewControllerTransitioningDelegate>
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *cellLayout;
@property (nonatomic, strong) NSMutableArray<BrowserViewController *> *browserArray;
@property (nonatomic) BOOL firstLoading;
@property (nonatomic, strong) LKTabTransitioning *presentTransitioning;
@property (nonatomic, strong) LKTabExitTransitioning *dismissTransitioning;
@property (nonatomic, strong) NSTimer *refreshTimer;
@end

static NSString * const reuseIdentifier = @"LKCell";

@implementation LKTabViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    _browserArray = [[NSMutableArray alloc] init];
    _presentTransitioning = [[LKTabTransitioning alloc] init];
    _dismissTransitioning = [[LKTabExitTransitioning alloc] init];
    _firstLoading = YES;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = CGSizeMake(rect.size.width/4, rect.size.height/4);
    [_cellLayout setItemSize:size];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [[self collectionView] reloadData];
}


-(void)viewDidAppear:(BOOL)animated{
    if(_firstLoading){
        _firstLoading = NO;
        [self createDefaultTabAndPresent];
    }
}

- (void)createDefaultTabAndPresent{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    BrowserViewController *browserController = [storyboard instantiateViewControllerWithIdentifier:@"browserViewController"];
    [browserController setTransitioningDelegate:self];
    [_browserArray addObject:browserController];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_browserArray count] - 1 inSection:0];
    [self setSelectedFrame:[self.collectionView cellForItemAtIndexPath:indexPath].frame];
    [self presentViewController:[_browserArray lastObject] animated:YES completion:nil];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_browserArray count] + 1;
}

- (LKTabCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LKTabCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if (indexPath.row >= [_browserArray count]) {
        CGFloat length = cell.contentView.frame.size.height > cell.contentView.frame.size.width? cell.contentView.frame.size.width: cell.contentView.frame.size.height;
        UIImageView *addButton = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, length/2, length/2)];
        [addButton setImage:[UIImage imageNamed:@"Add"]];
        [addButton setCenter:CGPointMake(cell.contentView.center.x, cell.contentView.center.x)];
        [[cell contentView] addSubview:addButton];
        
    }else{
        BrowserViewController *browserController = _browserArray[indexPath.row];
        UIView *snapshot = nil;
        if (browserController.cover){
            snapshot = browserController.cover;
        }else{
            snapshot = [[UIView alloc] init];
            [snapshot setBackgroundColor:[UIColor whiteColor]];
        }
        [snapshot setContentMode:UIViewContentModeScaleAspectFit];
        [snapshot setFrame:cell.contentView.frame];
        [[cell contentView] addSubview:snapshot];
    }
    //shadow and corner
    
    cell.contentView.layer.borderWidth = 1.0f;
    cell.contentView.layer.borderColor = [UIColor clearColor].CGColor;
    cell.contentView.layer.masksToBounds = YES;
    
    cell.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    cell.layer.shadowOffset = CGSizeMake(0, 5.0f);
    cell.layer.shadowRadius = 10.0f;
    cell.layer.shadowOpacity = 0.2f;
    cell.layer.masksToBounds = NO;
    cell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:cell.contentView.layer.cornerRadius].CGPath;
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row >= [_browserArray count]) {
        [self createDefaultTabAndPresent];
    }else{
        [self setSelectedFrame:[self.collectionView cellForItemAtIndexPath:indexPath].frame];
        BrowserViewController *browserController = [_browserArray objectAtIndex:indexPath.row];
        [self presentViewController:browserController animated:YES completion:nil];
    }
}


#pragma mark <UIViewControllerAnimatedTransitioning>

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return _presentTransitioning;
}


- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return _dismissTransitioning;
}

@end

