//
//  ViewController.m
//  CJWebView
//
//  Created by cjfire on 15/5/29.
//  Copyright (c) 2015年 Gozap. All rights reserved.
//

#import "ViewController.h"
#import "CJWebView.h"

@interface ViewController () <UIWebViewDelegate, UIActionSheetDelegate, CJWebViewDataSource>

@property (weak, nonatomic) IBOutlet CJWebView *webView;
@property (nonatomic, copy) NSString* imagePath;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CJWebView* webView = [[CJWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:webView];
    _webView = webView;
    _webView.delegate = self;
    _webView.dataSource = self;
    
    NSURL* url = [NSURL URLWithString:@"http://image.baidu.com/"];
    NSURLRequest* req = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:req];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.webkitTouchCallout='none';"];
}

- (void)webView:(CJWebView *)webView catchImagePath:(NSString *)imagePath {
    
    // create the UIActionSheet and populate it with buttons related to the tags
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Contextual Menu"
                                                       delegate:self cancelButtonTitle:@"Cancel"
                                         destructiveButtonTitle:nil otherButtonTitles:nil];
    
    if (imagePath.length > 0) {
        [sheet addButtonWithTitle:@"Save Picture"];
        _imagePath = imagePath;
    }
    
    // Add buttons which should be always available
    [sheet addButtonWithTitle:@"Save Page as Bookmark"];
    [sheet addButtonWithTitle:@"Open Page in Safari"];
    
    [sheet showInView:self.view];
}

#pragma mark - actionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
        NSLog(@"%@", _imagePath);
    }
}

@end
