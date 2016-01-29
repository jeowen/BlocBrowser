//
//  ViewController.m
//  BlocBrowser
//
//  Created by Jason Owen on 1/29/16.
//  Copyright © 2016 Jason Owen. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>


 @interface ViewController () <WKNavigationDelegate, UITextFieldDelegate>
 @property (nonatomic, strong) WKWebView *webView;

// add a textField for the navigation bar
@property(nonatomic, strong) UITextField *textField;


@end



@implementation ViewController
- (void)loadView {
    UIView *mainView = [UIView new];
    
    self.webView = [[WKWebView alloc] init];
    self.webView.navigationDelegate = self;
    
    // add a textField for the url
    self.textField = [[UITextField alloc] init];
    self.textField.keyboardType = UIKeyboardTypeURL;
    self.textField.returnKeyType = UIReturnKeyDone;
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField.placeholder = NSLocalizedString(@"Website URL", @"Placeholder text for web browser URL field");
    self.textField.backgroundColor = [UIColor colorWithWhite:220/255.0f alpha:1];
    self.textField.delegate = self;
    
    
    // add a web page to the web view
//    NSString *urlString = @"http://ptsd.va.gov";
//    NSURL *url = [NSURL URLWithString:urlString];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [self.webView loadRequest:request];
//    
//    NSLog(@"urlstring = %@", urlString);
 
    
    [mainView addSubview:self.webView];
    
    [mainView addSubview:self.textField];
    self.view = mainView;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // make the bottom edge scrollable
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    //make the webview fill the main view
    // AND ADD A TEXTFIELD FOR The URL at the top
    
    // First, calculate some dimensions.
    static const CGFloat itemHeight = 50;
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat browserHeight = CGRectGetHeight(self.view.bounds) - itemHeight;
    
    // Now, assign the frames
    self.textField.frame = CGRectMake(0, 0, width, itemHeight);
    self.webView.frame = CGRectMake(0, CGRectGetMaxY(self.textField.frame), width, browserHeight);
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    NSString *URLString = textField.text;
    
    NSURL *URL = [NSURL URLWithString:URLString];
    
    if (URL) {
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        [self.webView loadRequest:request];
    }
    
    return NO;
}

@end
