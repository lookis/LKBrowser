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

@interface LKTabViewController () <UIViewControllerTransitioningDelegate>
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *cellLayout;
@property (nonatomic, strong) NSMutableArray<BrowserViewController *> *browserArray;
@property (nonatomic) BOOL firstLoading;
@property (nonatomic, strong) LKTabTransitioning *presentTransitioning;
@property (nonatomic, strong) LKTabExitTransitioning *dismissTransitioning;
@end

static NSString * const reuseIdentifier = @"LKCell";

@implementation LKTabViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    NSLog(@"LKTabViewController init");
    _browserArray = [[NSMutableArray alloc] init];
    _presentTransitioning = [[LKTabTransitioning alloc] init];
    _dismissTransitioning = [[LKTabExitTransitioning alloc] init];
    _firstLoading = YES;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad in LKTabViewController");
    // Do any additional setup after loading the view.
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = CGSizeMake(rect.size.width/4, rect.size.height/4);
    [_cellLayout setItemSize:size];
    if([_browserArray count] == 0){
        [self addEmptyTabWithURL:@"http://www.ip138.com"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BrowserViewController *)addEmptyTabWithURL:(NSString *)url{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    BrowserViewController *browserController = [storyboard instantiateViewControllerWithIdentifier:@"browserViewController"];
    [browserController setTransitioningDelegate:self];
    if(!url){
        [browserController setUrl:@"http://www.google.com"];
    }else{
        [browserController setUrl:url];
    }
    [_browserArray addObject:browserController];
    return browserController;
}

-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"appear");
    [[self collectionView] reloadData];
    
}

-(void)viewDidAppear:(BOOL)animated{
    if(_firstLoading){
        _firstLoading = NO;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self setSelectedFrame:[self.collectionView cellForItemAtIndexPath:indexPath].frame];
        [self presentViewController:[_browserArray firstObject] animated:NO completion:nil];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"browser count: %lu", (unsigned long)[_browserArray count]);
    return [_browserArray count];
}

- (LKTabCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"show tab cell");
    // Configure the cell
    LKTabCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    BrowserViewController *browserController = _browserArray[indexPath.row];
    UIGraphicsBeginImageContextWithOptions(browserController.view.bounds.size, NO, 0);
    [browserController.view drawViewHierarchyInRect:browserController.view.bounds afterScreenUpdates:YES];
    UIImage *copied = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *imageView = [[UIImageView alloc] initWithImage:copied];
    [[cell contentView] addSubview:imageView];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [imageView setFrame:cell.contentView.frame];
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self setSelectedFrame:[self.collectionView cellForItemAtIndexPath:indexPath].frame];
    BrowserViewController *browserController = [_browserArray objectAtIndex:indexPath.row];
    [self presentViewController:browserController animated:YES completion:nil];
}


#pragma mark <UIViewControllerAnimatedTransitioning>

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return _presentTransitioning;
}


- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return _dismissTransitioning;
}

/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
 }
 */

@end

