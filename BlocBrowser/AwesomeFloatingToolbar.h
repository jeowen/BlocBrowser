//
//  AwesomeFloatingToolbar.h
//  BlocBrowser
//
//  Created by Jason Owen on 2/8/16.
//  Copyright © 2016 Jason Owen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AwesomeFloatingToolbar;

@protocol AwesomeFloatingToolbarDelegate <NSObject>

@optional

- (void) floatingToolbar:(AwesomeFloatingToolbar *)toolbar didSelectButtonWithTitle:(NSString *)title;
- (void) floatingToolbar:(AwesomeFloatingToolbar *)toolbar didTryToPanWithOffset:(CGPoint)offset;

@end

@interface AwesomeFloatingToolbar : UIView

- (instancetype) initWithFourTitles:(NSArray *)titles;

- (void) setEnabled:(BOOL)enabled forButtonWithTitle:(NSString *)title;
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
//- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;


@property (nonatomic, weak) id <AwesomeFloatingToolbarDelegate> delegate;


@end