//
//  ViewController.m
//  BlocBrowser
//
//  Created by Jason Owen on 2/1/16.
//  Copyright © 2016 Jason Owen. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import "AwesomeFloatingToolbar.h"

#define kWebBrowserBackString NSLocalizedString(@"Back", @"Back command")
#define kWebBrowserForwardString NSLocalizedString(@"Forward", @"Forward command")
#define kWebBrowserStopString NSLocalizedString(@"Stop", @"Stop command")
#define kWebBrowserRefreshString NSLocalizedString(@"Refresh", @"Reload command")


// In order to use our view controller as the delegate for the WKWebView we need to declare that our controller conforms to the WKNavigationDelegate protocol:

@interface ViewController () <WKNavigationDelegate, UITextFieldDelegate, AwesomeFloatingToolbarDelegate>

@property (nonatomic, strong) WKWebView *webView;

// add a textfield to enter an URL in code
@property (nonatomic, strong) UITextField *textField;

// build the navigation bar
@property (nonatomic, strong) AwesomeFloatingToolbar *awesomeToolbar;

// add activity indicator spinner animation (subview)
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;



@end

@implementation ViewController


// create the main view
- (void)loadView {
    UIView *mainView = [UIView new];
    
    
    // WKWebView is a UIView subclass that is designed to display web content,
    self.webView = [[WKWebView alloc] init];
    self.webView.navigationDelegate = self;
    
    // Finally build the text field and add it as a subview of the main view:
    self.textField = [[UITextField alloc] init];
    self.textField.keyboardType = UIKeyboardTypeWebSearch;
    self.textField.returnKeyType = UIReturnKeyDone;
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField.placeholder = NSLocalizedString(@"Website URL or SEARCH", @"Placeholder text for web browser URL field");
    self.textField.backgroundColor = [UIColor colorWithWhite:220/255.0f alpha:1];
    self.textField.delegate = self;
    
    // create buttons, default = OFF
    self.awesomeToolbar = [[AwesomeFloatingToolbar alloc] initWithFourTitles:@[kWebBrowserBackString, kWebBrowserForwardString, kWebBrowserStopString, kWebBrowserRefreshString]];
    self.awesomeToolbar.delegate = self;
    
//    
//    NSString *urlString = @"http://wikipedia.org";
//    NSURL *url = [NSURL URLWithString:urlString];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [self.webView loadRequest:request];
    
    
//    // add web view and textField for URL to main view
//    [mainView addSubview:self.webView];
//    [mainView addSubview:self.textField];
//    
//    // add buttons to main view
//    [mainView addSubview:self.backButton];
//    [mainView addSubview:self.forwardButton];
//    [mainView addSubview:self.stopButton];
//    [mainView addSubview:self.reloadButton];
    
    // we can make above code shorter with this loop:
for (UIView *viewToAdd in @[self.webView, self.textField, self.awesomeToolbar]) {
        [mainView addSubview:viewToAdd];
   }
    
    self.view = mainView;
}

- (void) viewWillLayoutSubviews {  // over-rides some kind of layout method & handles positioning of each subview in the main view
    [super viewWillLayoutSubviews];
    
    //make the webview fill the main view
    // Before we can show anything in our web view we must first give it a size. For now we'll set its frame to be the same as the main view frame which will make it fill the main view.
    // self.webView.frame = self.view.frame;
    
    // replaced above to adjust layout to show textfield for URL on screen
    // First, calculate some dimensions.
    static const CGFloat itemHeight = 50;
    CGFloat width = CGRectGetWidth(self.view.bounds);
CGFloat browserHeight = CGRectGetHeight(self.view.bounds) - itemHeight;

    
    // Now, assign the frames
    self.textField.frame = CGRectMake(0, 0, width, itemHeight);
    self.webView.frame = CGRectMake(0, CGRectGetMaxY(self.textField.frame), width, browserHeight);

    // add a loop to handle positioning of each button
self.awesomeToolbar.frame = CGRectMake(20, 100, 280, 60);
    
}
#pragma mark - AwesomeFloatingToolbarDelegate

- (void) floatingToolbar:(AwesomeFloatingToolbar *)toolbar didSelectButtonWithTitle:(NSString *)title {
    if ([title isEqual:NSLocalizedString(@"Back", @"Back command")]) {
        [self.webView goBack];
    } else if ([title isEqual:NSLocalizedString(@"Forward", @"Forward command")]) {
        [self.webView goForward];
    } else if ([title isEqual:NSLocalizedString(@"Stop", @"Stop command")]) {
        [self.webView stopLoading];
    } else if ([title isEqual:NSLocalizedString(@"Refresh", @"Reload command")]) {
        [self.webView reload];
    }
}
 #pragma mark - UITextFieldDelegate
//process text input for URL
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    NSString *URLString = textField.text;
    
    // see if the URLString contains any spaces, if so- capture the search terms
    // ----------------------

    NSMutableString *string2 = [NSMutableString stringWithString: URLString];
    NSString *searchPreamble = @"http://google.com/search?q=";

    NSString *returnURL;
    
    NSRange whiteSpaceRange = [string2 rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];
    if (whiteSpaceRange.location != NSNotFound) {
        NSLog(@"Found whitespace");
        // replace whitespace with +
       // [string2 stringByReplacingOccurrencesOfString:@"\s" withString:@"+"];
        NSString *stringCastBack = [NSString stringWithFormat:@"%@", string2];
        stringCastBack = [stringCastBack stringByReplacingOccurrencesOfString:@" "
                                             withString:@"+"];
        NSLog(@"in whitespace FOUND, stringCastBack after replacement = %@", stringCastBack);
        // add search query to searchPreamble and return returnURL
        returnURL = [NSString stringWithFormat:@"%@%@", searchPreamble, stringCastBack];
        NSLog(@"in whitespace FOUND, return URL = %@", returnURL);
        
    }
    else{
        NSLog(@"Did NOT find whitespace");
        returnURL = [NSString stringWithFormat:@"%@", URLString];
        NSLog(@"in whitespace NOTNOTNOT FOUND, return URL = %@", returnURL);
    }
    
    // ----------------------
    // replace URLString with http://www.google.com/search?q=charlie+bit+my+finger
    
    NSURL *URL = [NSURL URLWithString:returnURL];
    
    // process missing http://
    if (!URL.scheme) {
        // The user didn't type http: or https:
        URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", URLString]];
    }
    
    

    
    if (URL) {
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        [self.webView loadRequest:request];
    }
    
    return NO;
}

#pragma mark - WKNavigationDelegate

// We need to call this method (to update UI) whenever a page starts or stops loading. We'll use the WKNavigationDelegate methods didStartProvisionalNavigation, and didFinishNavigation: to do this:
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [self updateButtonsAndTitle];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self updateButtonsAndTitle];
}


//handling failed webpage loads
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *) navigation withError:(NSError *)error {
    [self webView:webView didFailNavigation:navigation withError:error];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    if (error.code != NSURLErrorCancelled) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error", @"Error")
                                                                       message:[error localizedDescription]
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil)
                                                           style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:okAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    // creates a new method to handle updating UI updates, e.g., to show title in navigation bar
    [self updateButtonsAndTitle];
}
#pragma mark - update UI (updateButtonsAndTitle method)

- (void) updateButtonsAndTitle {
    // Next we'll update the UINavigationBar title to reflect whatever page is loaded in the web view. We'll use the WKWebView property title.
    NSString *webpageTitle = [self.webView.title copy];
    // if the webpage has a title, show it; otherwise use the URL
    if ([webpageTitle length]) {
        self.title = webpageTitle;
    } else {
        self.title = self.webView.URL.absoluteString;
    }
    
    // turn on activity indicator when loading

    if (self.webView.isLoading) {
        [self.activityIndicator startAnimating];
    } else {
        [self.activityIndicator stopAnimating];
    }
    
    
    // update forward & back buttons
    // The logic for these is pretty simple. The enabled state for the forward and back buttons is entirely dependent on whether or not the web view can go forward or back.
    [self.awesomeToolbar setEnabled:[self.webView canGoBack] forButtonWithTitle:kWebBrowserBackString];
    [self.awesomeToolbar setEnabled:[self.webView canGoForward] forButtonWithTitle:kWebBrowserForwardString];
    [self.awesomeToolbar setEnabled:[self.webView isLoading] forButtonWithTitle:kWebBrowserStopString];
    [self.awesomeToolbar setEnabled:![self.webView isLoading] && self.webView.URL forButtonWithTitle:kWebBrowserRefreshString];

}


 #pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // set activity indicator animation
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicator];
    

    
    // Do any additional setup after loading the view.
}

#pragma mark - resetWebView
- (void) resetWebView {
    // PURPOSE: clears the web browser history.
    //1 . remove the old web view from the web hierarchy
    [self.webView removeFromSuperview];
    
    //2. create a new, empty web view and add it back into the view
    WKWebView *newWebView = [[WKWebView alloc] init];
    newWebView.navigationDelegate = self;
    [self.view addSubview:newWebView];
    
    //3. clears the url field
    self.webView = newWebView;
    
    //4. point the buttons to the new WebView!!  done in a new method
    //  requires declaring new method, addButtonTargets, below

    
    //5. update buttons and nav title to current state
    self.textField.text = nil;
   
    
    
}


#pragma mark - show alert on launch
- (void) welcomeMessage {
    // set up and create an NSError object
    // 1. declare the error domain
    NSString *domain = @"com.MyCompany.MyApplication.ErrorDomain";
    NSLog(@"hullooo!\n");
    // 2. create a dictionary of possible user info, including but not limited to simple error message
    

    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: NSLocalizedString(@"Welcome back to the simplicity of the past!  Sit back, relax, and enjoy a hassle-free browsing experience.", nil),
                               NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The operation timed out.", nil),
                               NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Have you tried turning it off and on again?", nil)
                               };
    NSError *error = [NSError errorWithDomain:domain
                                         code:-57
                                     userInfo:userInfo];
    
    // FINALLY, display the ALERT to display :)
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Netscape 1.0", @"Netscape 1.0")
                                                                   message:[error localizedDescription]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil)
                                                       style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:okAction];
    
    
    // [self.window presentViewController:alert animated:YES completion:nil];
//    
//    ViewController *myView = [[ViewController alloc] init];
//    [myView presentViewController:alert animated:YES completion:nil ];


    
    [self presentViewController:alert animated:YES completion:nil];
NSLog(@"haaallooo!\n");
}

@end
