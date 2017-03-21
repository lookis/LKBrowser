//
//  LKTabCell.m
//  LKBrowser
//
//  Created by Lookis on 15/03/2017.
//  Copyright © 2017 Lookis. All rights reserved.
//

#import "LKTabCell.h"
@interface LKTabCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end


@implementation LKTabCell

- (instancetype)init{
    [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    return self;
}

-(void)prepareForReuse{
    [_imageView setImage:nil];
}

- (void)setImage:(UIImage *)image{
    [_imageView setImage:image];
}

@end
