//
//  LKTabViewController.h
//  LKBrowser
//
//  Created by Lookis on 16/03/2017.
//  Copyright © 2017 Lookis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import "BrowserViewController.h"

@interface LKTabViewController : UICollectionViewController
@property (nonatomic) CGRect selectedFrame;

- (BrowserViewController * _Nonnull)addEmptyTabWithURL:(NSString * _Nullable)url;

@end
