//
//  LKTabTransitioning.m
//  LKBrowser
//
//  Created by Lookis on 21/03/2017.
//  Copyright © 2017 Lookis. All rights reserved.
//

#import "LKTabTransitioning.h"
#import "LKTabManagerViewController.h"
#import "BrowserViewController.h"
#import "LKTabCell.h"
#import <UIKit/UIKit.h>

@interface LKTabTransitioning() <UIViewControllerAnimatedTransitioning>

@end


@implementation LKTabTransitioning

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.5f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    BrowserViewController *browserController   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    LKTabManagerViewController *tabManagerViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    LKTabViewController *tabViewController = [tabManagerViewController tabViewController];
    UIView *containerView = [transitionContext containerView];
    
    
    LKTabCell *cell = (LKTabCell *)[tabViewController.collectionView cellForItemAtIndexPath:[[[tabViewController collectionView] indexPathsForSelectedItems] firstObject]];
    UIView * snapShotView = [[cell contentView] snapshotViewAfterScreenUpdates:NO];
    snapShotView.frame = [containerView convertRect:cell.contentView.frame fromView:cell.contentView.superview];
    cell.contentView.hidden = YES;
    
    browserController.view.frame = [transitionContext finalFrameForViewController:browserController];
    browserController.view.alpha = 0;
    
    [containerView addSubview:snapShotView];
    [containerView addSubview:browserController.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        snapShotView.frame = browserController.view.frame;
    } completion:^(BOOL finish){
        cell.contentView.hidden = NO;
        browserController.view.alpha = 1;
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
    
}

@end
