//
//  LKTabCell.m
//  LKBrowser
//
//  Created by Lookis on 15/03/2017.
//  Copyright © 2017 Lookis. All rights reserved.
//

#import "LKTabCell.h"
@interface LKTabCell ()
@end


@implementation LKTabCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    return self;
}

- (void)prepareForReuse{
    [[[self contentView] subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

@end
