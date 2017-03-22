//
//  ViewController.m
//  LKBrowser
//
//  Created by Lookis on 09/03/2017.
//  Copyright © 2017 Lookis. All rights reserved.
//

#import "BrowserViewController.h"
#import "LKHTTPProtocol.h"
#import "LKAddressBarViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

#define HOMEPAGE @"http://www.google.com"

static float const PROGRESS_VIEW_INTERVAL = (float)1.0/60;
static float const PROGRESS_VIEW_MAX_BEFORE_LOADED = (float)0.95;
static float const PROGRESS_VIEW_SUPPOSED_FINISH = (float)2.0;

@interface BrowserViewController () <UIWebViewDelegate, UIGestureRecognizerDelegate, NSURLSessionDataDelegate, LKAddressBarDelegate, LKAddressBarDataSource>
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

@property (nonatomic, strong) NSURL *addressInLoading;
@property (strong, nonatomic) LKAddressBarViewController* addressBarController;
@end


@implementation BrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [_panRecognizer setDelegate:self];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:HOMEPAGE]];
//    _startupPage = nil;
    [_webView loadRequest:request];
    [[_webView scrollView] addGestureRecognizer:_panRecognizer];
    [self renderButtons];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"didReceiveMemoryWarning");
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"addressBarEmbed"]) {
        LKAddressBarViewController * childViewController = (LKAddressBarViewController *) [segue destinationViewController];
        _addressBarController = childViewController;
        childViewController.dataSource = self;
        childViewController.delegate = self;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    _cover = [self.view snapshotViewAfterScreenUpdates:NO];
}

- (void)renderButtons{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 50 * NSEC_PER_MSEC), dispatch_get_main_queue(), ^{
        [_buttonGoBack setEnabled:[_webView canGoBack]];
        [_buttonGoForward setEnabled:[_webView canGoForward]];
    });
}


#pragma mark UIWebViewDelegate

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSLog(@"webView shouldStartLoadWithRequest %@", request.URL.absoluteString);
    _addressInLoading = request.URL;
    [_addressBarController reloadData];
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"webView webViewDidStartLoad %@", webView.request.URL.absoluteString);
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [_progressBar setHidden:NO];
    [_progressBar setProgress:0.0 animated:NO];
    [NSTimer scheduledTimerWithTimeInterval:PROGRESS_VIEW_INTERVAL repeats:YES block:^(NSTimer *timer){
        if (_progressBar.progress < PROGRESS_VIEW_MAX_BEFORE_LOADED){
            [_progressBar setProgress: [_progressBar progress] + (PROGRESS_VIEW_MAX_BEFORE_LOADED/PROGRESS_VIEW_SUPPOSED_FINISH * PROGRESS_VIEW_INTERVAL) animated:YES];
        }else{
            [timer invalidate];
        }
    }];
    [self renderButtons];
    [_addressBarController reloadData];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    _cover = [self.view snapshotViewAfterScreenUpdates:NO];
    _addressInLoading = nil;
    [_addressBarController reloadData];
    NSLog(@"webView webViewDidFinishLoad:%@", [[[webView request] URL] absoluteString]);
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        [_progressBar setHidden:YES];
    }];
    [CATransaction setAnimationDuration:0.5];
    [_progressBar setProgress:1.0 animated:YES];
    [CATransaction commit];
}

#pragma mark UITab

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

- (IBAction)tab:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UIGestureRecognizerDelegate
- (IBAction)panFromLeftEdge:(UIScreenEdgePanGestureRecognizer *)sender {
    if([sender state] == UIGestureRecognizerStateEnded){
        [self goBack:sender];
    }
}
- (IBAction)panFromRightEdge:(UIScreenEdgePanGestureRecognizer *)sender {
    if([sender state] == UIGestureRecognizerStateEnded){
        [self goForward:sender];
    }
}

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

#pragma mark LKAddressBarDelegate
- (void)addressChangeTo:(NSString *)text{
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:text]]];
}

#pragma mark LKAddressBarDataSource
- (NSString *)addressBarDisplayData{
    if(_webView && [_webView isLoading] && _addressInLoading){
        return [_addressInLoading host];
    }else if(_webView){
        return [[[_webView request] URL] host];
    }
    return @"";
}

- (NSString *)addressBarValue{
    if (_webView && [_webView isLoading] && _addressInLoading){
        return [_addressInLoading absoluteString];
    }else if (_webView && [_webView request] && [[_webView request] URL]){
        return [[[_webView request]URL] absoluteString];
    }
    return @"";
}

@end
