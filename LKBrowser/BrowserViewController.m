//
//  ViewController.m
//  LKBrowser
//
//  Created by Lookis on 09/03/2017.
//  Copyright © 2017 Lookis. All rights reserved.
//

#import "BrowserViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

static float const PROGRESS_VIEW_INTERVAL = (float)1.0/60;
static float const PROGRESS_VIEW_MAX_BEFORE_LOADED = (float)0.95;
static float const PROGRESS_VIEW_SUPPOSED_FINISH = (float)2.0;

@interface BrowserViewController () <UIWebViewDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textAddress;
@property (weak, nonatomic) IBOutlet UIButton *cancel;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonGoBack;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonGoForward;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonReload;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonShare;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonTabs;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panRecognizer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewTopConstraint;

@end

@implementation BrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    [_panRecognizer setDelegate:self];
    [[_webView scrollView] addGestureRecognizer:_panRecognizer];
    [_webView loadRequest:request];
    [self renderButtons];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)renderButtons{
    //    [_buttonGoBack setEnabled:NO];
    //    [_buttonGoForward setEnabled:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 50 * NSEC_PER_MSEC), dispatch_get_main_queue(), ^{
        [_buttonGoBack setEnabled:[_webView canGoBack]];
        [_buttonGoForward setEnabled:[_webView canGoForward]];
    });
}


#pragma AddressBar

- (IBAction)cancel:(id)sender{
    [_textAddress resignFirstResponder];

}

- (IBAction)gotoUrl:(id)sender{
    NSLog(@"gotoUrl");
    NSString *url = nil;
    if([[_textAddress text] hasPrefix:@"http://"] || [[_textAddress text] hasPrefix:@"https://"]){
        url = [_textAddress text];
    }else{
        url = [NSString stringWithFormat:@"http://%@", [_textAddress text]];
    }
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    [_textAddress resignFirstResponder];
}

- (IBAction)startEditing:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_textAddress selectAll:nil];
    });
}

- (IBAction)endEditing:(id)sender{
    [_textAddress setText: [[[_webView request]URL] absoluteString]];
}

#pragma UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"webViewDidStartLoad");
    if(![_textAddress isFirstResponder]){
        [_textAddress setText: [[[_webView request]URL] absoluteString]];
    }
    [_progressBar setHidden:NO];
    [_progressBar setProgress:0.0 animated:NO];
    [NSTimer scheduledTimerWithTimeInterval:PROGRESS_VIEW_INTERVAL repeats:YES block:^(NSTimer *timer){
        if (_progressBar.progress < PROGRESS_VIEW_MAX_BEFORE_LOADED){
            [_progressBar setProgress: [_progressBar progress] + (PROGRESS_VIEW_MAX_BEFORE_LOADED/PROGRESS_VIEW_SUPPOSED_FINISH * PROGRESS_VIEW_INTERVAL) animated:YES];
        }
    }];
    [self renderButtons];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"webViewDidFinishLoad");
    if(![_textAddress isFirstResponder]){
        [_textAddress setText: [[[_webView request]URL] absoluteString]];
    }
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        [_progressBar setHidden:YES];
    }];
    [CATransaction setAnimationDuration:0.5];
    [_progressBar setProgress:1.0 animated:YES];
    [CATransaction commit];
}

#pragma UITab

- (IBAction)goBack:(id)sender{
    if ([_webView canGoBack]){
        [_webView goBack];
        [self renderButtons];
    }
}

- (IBAction)goForward:(id)sender{
    if([_webView canGoForward]){
        [_webView goForward];
        [self renderButtons];
    }
}

- (IBAction)reload:(id)sender{
    [_webView reload];
}

- (IBAction)share:(id)sender{
    NSDictionary *item = @{@"url_string" : _webView.request.URL.absoluteString};
    NSItemProvider *itemProvider = [[NSItemProvider alloc] initWithItem:item typeIdentifier:@"org.appextension.fill-browser-action"];
    NSExtensionItem *extensionItem = [[NSExtensionItem alloc] init];
    extensionItem.attachments = @[ itemProvider];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[ extensionItem, _webView.request.URL]  applicationActivities:nil];
    
    [self presentViewController:activityViewController animated:YES completion:nil];
    
}

- (IBAction)tabs:(id)sender{
    
}

#pragma UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
- (IBAction)panRecognizer:(UIPanGestureRecognizer *)sender {
    CGPoint velocity = [sender velocityInView:_webView];
    if (velocity.y > 100)   // panning down
    {
        if (_bottomViewBottomConstraint.constant > 0){
            [[self view] layoutIfNeeded];
            _bottomViewBottomConstraint.constant = 0;
            _topViewTopConstraint.constant = 0;
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                [[self view] layoutIfNeeded];
            } completion:nil];
        }
        
    }
    else if(velocity.y < -100)               // panning up
    {
        if (_bottomViewBottomConstraint.constant < _bottomView.frame.size.height){
            [[self view] layoutIfNeeded];
            _bottomViewBottomConstraint.constant = _bottomView.frame.size.height;
            _topViewTopConstraint.constant = - _topView.frame.size.height;
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                [[self view] layoutIfNeeded];
            } completion:nil];
        }
    }
}

@end
