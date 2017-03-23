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
    [self layoutSubviews];
    return self;
}

- (void)prepareForReuse{
    [[[self contentView] subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    BOOL contentViewIsAutoresized = CGSizeEqualToSize(self.frame.size, self.contentView.frame.size);
    if( !contentViewIsAutoresized) {
        CGRect contentViewFrame = self.contentView.frame;
        contentViewFrame.size = self.frame.size;
        self.contentView.frame = contentViewFrame;
    }
}

@end
