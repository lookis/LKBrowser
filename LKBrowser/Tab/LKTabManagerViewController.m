//
//  LKTabManagerViewController.m
//  LKBrowser
//
//  Created by Lookis on 21/03/2017.
//  Copyright © 2017 Lookis. All rights reserved.
//

#import "LKTabManagerViewController.h"
#import "LKTabViewController.h"

@interface LKTabManagerViewController ()
@end

@implementation LKTabManagerViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"tabViewEmbed"]) {
        _tabViewController = (LKTabViewController *) [segue destinationViewController];
    }
}


@end
