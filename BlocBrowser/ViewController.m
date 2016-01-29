//
//  ViewController.m
//  BlocBrowser
//
//  Created by Jason Owen on 1/29/16.
//  Copyright © 2016 Jason Owen. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>


@interface ViewController () <WKNavigationDelegate>
 @property (nonatomic, strong) WKWebView *webView;
@end



@implementation ViewController
- (void)loadView {
    UIView *mainView = [UIView new];
    
    self.webView = [[WKWebView alloc] init];
    self.webView.navigationDelegate = self;
    
    // add a web page to the web view
    NSString *urlString = @"http://wikipedia.org";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    NSLog(@"urlstring = %@", urlString);
    [mainView addSubview:self.webView];
    
    
    self.view = mainView;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    //make the webview fill the main view
    self.webView.frame = self.view.frame;
    
}
@end
