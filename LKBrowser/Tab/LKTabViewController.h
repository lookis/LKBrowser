//
//  LKTabViewController.h
//  LKBrowser
//
//  Created by Lookis on 16/03/2017.
//  Copyright © 2017 Lookis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

@interface LKTabViewController : UICollectionViewController
@property (nonatomic) CGRect selectedFrame;

- (void)addEmptyTabWithURL:(NSURL * _Nullable)url;

@end
