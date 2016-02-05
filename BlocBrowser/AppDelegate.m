//
//  AppDelegate.m
//  BlocBrowser
//
//  Created by Jason Owen on 2/1/16.
//  Copyright © 2016 Jason Owen. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // display a welcome message when the app is launched
    
    NSLog(@"*** APPLICATION LAUNCHED *** \n^\n||\n||\n||\n||\n||\n||\n||\n||\n||\n****\n****\n****\n****\n****\n****\n****\n****\n***\n***\n***\n***\n");
    
    // set up and create an NSError object
    // 1. declare the error domain
    NSString *domain = @"com.MyCompany.MyApplication.ErrorDomain";
    
    // 2. create a dictionary of possible user info, including but not limited to simple error message
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: NSLocalizedString(@"Operation was unsuccessful- you launched the app and somehow managed to display an alert message- bravo!!!.", nil),
                               NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The operation timed out.", nil),
                               NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Have you tried turning it off and on again?", nil)
                               };
    NSError *error = [NSError errorWithDomain:domain
                                         code:-57
                                     userInfo:userInfo];
    
    // FINALLY, display the ALERT to display :)
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error", @"Error")
                                                                   message:[error localizedDescription]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil)
                                                       style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:okAction];

    
    // [self.window presentViewController:alert animated:YES completion:nil];
    
    ViewController *myView = [[ViewController alloc] init];
    [myView presentViewController:alert animated:YES completion:nil ];
     
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:myView];
    [self.window makeKeyAndVisible];

    

    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    // for BlocBrowser, reset the URL & webview to clear history
    //1. obtains a reference to the navigation controller (we know it's the root view controller),
    UINavigationController *navigationVC = (UINavigationController *)self.window.rootViewController;
    
    //2. obtains a reference to that its first view controller (which is a ViewController instance),
    ViewController *browserVC = [[navigationVC viewControllers] firstObject];
    
    //3. sends it the resetWebView message.
    [browserVC resetWebView];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
