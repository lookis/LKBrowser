//
//  LKTabExitTransitioning.m
//  LKBrowser
//
//  Created by Lookis on 21/03/2017.
//  Copyright © 2017 Lookis. All rights reserved.
//

#import "LKTabExitTransitioning.h"
#import "BrowserViewController.h"
#import "LKTabManagerViewController.h"
#import "LKTabCell.h"

@implementation LKTabExitTransitioning


- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.3f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    BrowserViewController *browserController   = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    LKTabManagerViewController *tabManagerViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    CGRect frame = [transitionContext finalFrameForViewController:tabManagerViewController];
    tabManagerViewController.view.frame = frame;
    [containerView addSubview:tabManagerViewController.view];
    
    UIView *snapShotView = [browserController.view snapshotViewAfterScreenUpdates:NO];
    snapShotView.frame = [containerView convertRect:browserController.view.frame fromView:browserController.view.superview];
    [containerView addSubview:snapShotView];
    
    [browserController.view setAlpha:0];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        snapShotView.frame = [containerView convertRect:tabManagerViewController.tabViewController.selectedFrame fromView:tabManagerViewController.tabViewController.collectionView];
    } completion:^(BOOL finish){
        browserController.view.alpha = 1;
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
    
}

@end
