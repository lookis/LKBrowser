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
    return 0.3f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    BrowserViewController *browserController   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    LKTabManagerViewController *tabManagerViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    UIView *snapShotView = nil;
    if(browserController.cover){
        snapShotView = browserController.cover;
    }else{
        snapShotView = [[UIView alloc] init];
        [snapShotView setBackgroundColor:[UIColor whiteColor]];
    }
    snapShotView.frame = [containerView convertRect:tabManagerViewController.tabViewController.selectedFrame fromView:tabManagerViewController.tabViewController.collectionView];
    browserController.view.alpha = 0;
    [containerView addSubview:snapShotView];
    [containerView addSubview:browserController.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        snapShotView.frame = browserController.view.frame;
    } completion:^(BOOL finish){
        browserController.view.alpha = 1;
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
    
}

@end
