//
//  AddressBarViewController.h
//  LKBrowser
//
//  Created by Lookis on 19/03/2017.
//  Copyright © 2017 Lookis. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LKAddressBarDataSource <NSObject>
- (NSString * _Nonnull)addressBarDisplayData;
- (NSString * _Nonnull)addressBarValue;
@end

@protocol LKAddressBarDelegate <NSObject>
- (void)addressChangeTo:(NSString * _Nonnull)text;
@end

@interface LKAddressBarViewController : UIViewController
@property (weak, nonatomic, readwrite, nullable) id<LKAddressBarDelegate> delegate;
@property (weak, nonatomic, readwrite, nullable) id<LKAddressBarDataSource> dataSource;
- (void)reloadData;
@end
