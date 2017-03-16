//
//  LKTabViewController.m
//  LKBrowser
//
//  Created by Lookis on 16/03/2017.
//  Copyright © 2017 Lookis. All rights reserved.
//

#import "LKTabViewController.h"
#import "LKTabCell.h"
#import "BrowserViewController.h"

@interface LKTabViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) NSMutableArray<BrowserViewController *> *browserArray;
@property (nonatomic) NSInteger currentTab;
@end

static NSString * const reuseIdentifier = @"LKCell";

@implementation LKTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    if(!_browserArray){
//        _browserArray = [[NSMutableArray alloc] init];
//    }
    
    // create first tab;
//    BrowserViewController *browserController = [[BrowserViewController alloc] init];
//    [_browserArray addObject:browserController];
//    [[self view] addSubview:browserController.view];
//    _currentTab = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [_browserArray count];;
}

- (LKTabCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell
    LKTabCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    BrowserViewController *browserController = _browserArray[indexPath.row];
    UIGraphicsBeginImageContextWithOptions(browserController.view.bounds.size, NO, 0);
    [browserController.view drawViewHierarchyInRect:browserController.view.bounds afterScreenUpdates:YES];
    UIImage *copied = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *imageView = [[UIImageView alloc] initWithImage:copied];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [[cell backgroundView] addSubview:imageView];
    return cell;
}

#pragma mark <UICollectionViewDelegate>

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"select %li/%li", (long)indexPath.section, (long)indexPath.row);
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

