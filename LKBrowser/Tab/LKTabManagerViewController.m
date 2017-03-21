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
    NSLog(@"initWithCoder in LKTabManagerViewController");
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"viewDidLoad in LKTabManagerViewController");
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
