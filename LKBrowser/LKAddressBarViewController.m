//
//  AddressBarViewController.m
//  LKBrowser
//
//  Created by Lookis on 19/03/2017.
//  Copyright © 2017 Lookis. All rights reserved.
//

#import "LKAddressBarViewController.h"

@interface LKAddressBarViewController ()
@property (weak, nonatomic) IBOutlet UITextField *addressBar;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelTrailingConstraint;

@end

@implementation LKAddressBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark AddressBar

- (void)reloadData{
    if (_dataSource){
        if(![_addressBar isFirstResponder]){
            [_addressBar setTextAlignment:NSTextAlignmentCenter];
            [_addressBar setText:[_dataSource addressBarDisplayData]];
        }else if ([_addressBar textAlignment] != NSTextAlignmentLeft){
            [_addressBar setTextAlignment:NSTextAlignmentLeft];
            [_addressBar setText: [_dataSource addressBarValue]];
        }
    }
}

- (IBAction)cancel:(id)sender{
    [_addressBar resignFirstResponder];
    
}

- (IBAction)gotoUrl:(id)sender{
    NSLog(@"gotoUrl");
    NSURL *url = nil;
    if([[_addressBar text] hasPrefix:@"http://"] || [[_addressBar text] hasPrefix:@"https://"]){
        url = [NSURL URLWithString:[_addressBar text]];
    }else{
        long dotPosition = [[_addressBar text] rangeOfString:@"."].location;
        if(dotPosition != NSNotFound && dotPosition !=0 && dotPosition != [[_addressBar text] length] - 1){
            url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", [_addressBar text]]];
        };
    }
    if(!url){
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.google.com/search?q=%@", [[_addressBar text]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]]];
    }
    [_addressBar resignFirstResponder];
    if(_delegate){
        [_delegate addressChangeTo:[url absoluteString]];
    }
}

- (IBAction)startEditing:(id)sender{
    [[self view] layoutIfNeeded];
    [self reloadData];
    _cancelTrailingConstraint.constant = 0;
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [[self view] layoutIfNeeded];
    } completion:^(BOOL finished){
        if(finished){
            dispatch_async(dispatch_get_main_queue(), ^{
                [_addressBar selectAll:nil];
            });
        }
    }];
    
}

- (IBAction)endEditing:(id)sender{
    [[self view] layoutIfNeeded];
    [self reloadData];
    _cancelTrailingConstraint.constant = _btnCancel.frame.size.width - 8;
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [[self view] layoutIfNeeded];
    } completion:nil];
}


@end
