//
//  LKCellFlowLayout.m
//  LKBrowser
//
//  Created by Lookis on 23/03/2017.
//  Copyright © 2017 Lookis. All rights reserved.
//

#import "LKCellFlowLayout.h"

@implementation LKCellFlowLayout


- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
    attributes.alpha = 0.0;
    return attributes;
}

@end
