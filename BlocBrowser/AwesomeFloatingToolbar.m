//
//  AwesomeFloatingToolbar.m
//  BlocBrowser
//
//  Created by Jason Owen on 2/8/16.
//  Copyright © 2016 Jason Owen. All rights reserved.
//

#import "AwesomeFloatingToolbar.h"

#define kWebBrowserBackString NSLocalizedString(@"Back", @"Back command")
#define kWebBrowserForwardString NSLocalizedString(@"Forward", @"Forward command")
#define kWebBrowserStopString NSLocalizedString(@"Stop", @"Stop command")
#define kWebBrowserRefreshString NSLocalizedString(@"Refresh", @"Reload command")

@interface AwesomeFloatingToolbar ()

@property (nonatomic, strong) NSArray *currentTitles;
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) NSArray *labels;
@property (nonatomic, weak) UILabel *currentLabel;

// property to store the tap gesture recognizer
 @property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

// property to recognize a pan gesture
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@end






@implementation AwesomeFloatingToolbar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark INIT (OVERRIDE)
- (instancetype) initWithFourTitles:(NSArray *)titles {
    // First, call the superclass (UIView)'s initializer, to make sure we do all that setup first.
    self = [super init];
    
    if (self) {
        
        // Save the titles, and set the 4 colors
        self.currentTitles = titles;
        self.colors = @[[UIColor colorWithRed:199/255.0 green:158/255.0 blue:203/255.0 alpha:1],
                        [UIColor colorWithRed:255/255.0 green:105/255.0 blue:97/255.0 alpha:1],
                        [UIColor colorWithRed:222/255.0 green:165/255.0 blue:164/255.0 alpha:1],
                        [UIColor colorWithRed:255/255.0 green:179/255.0 blue:71/255.0 alpha:1]];
        
        NSMutableArray *labelsArray = [[NSMutableArray alloc] init];
        
        // Make the 4 labels
        for (NSString *currentTitle in self.currentTitles) {
            UILabel *label = [[UILabel alloc] init];
            label.userInteractionEnabled = NO;
            label.alpha = 0.25;
            
            NSUInteger currentTitleIndex = [self.currentTitles indexOfObject:currentTitle]; // 0 through 3
            NSString *titleForThisLabel = [self.currentTitles objectAtIndex:currentTitleIndex];
            UIColor *colorForThisLabel = [self.colors objectAtIndex:currentTitleIndex];
            
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:10];
            label.text = titleForThisLabel;
            label.backgroundColor = colorForThisLabel;
            label.textColor = [UIColor whiteColor];
            
            [labelsArray addObject:label];
        }
        
        self.labels = labelsArray;
        
        for (UILabel *thisLabel in self.labels) {
            [self addSubview:thisLabel];
        }
    }
    
    // initialize TAP GESTURE RECOGNIZER
    // #1
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFired:)];
    // #2
    [self addGestureRecognizer:self.tapGesture];
    
    // initialize a PAN GESTURE RECOGNIZER from property panGesture declared above
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panFired:)];
    [self addGestureRecognizer:self.panGesture];
    
    return self;
}
//-------------->
#pragma mark TAP GESTURE RECOGNIZER
//IMPLEMENT TAP GESTURE RECOGNIZER (TAP FIRED METHOD) (in self, which is a UIView object)
- (void) tapFired:(UITapGestureRecognizer *)recognizer {
    
    // The first thing we do is check for the proper state.  A gesture recognizer has several states it can be in, and UIGestureRecognizerStateRecognized is the state in which the type of gesture it recognizes has been detected. In our case, a tap has been completed and the recognizer's state was switched to UIGestureRecognizerStateRecognized. If the gesture recognizer is in any other state, the gesture hasn't been detected.
    
    if (recognizer.state == UIGestureRecognizerStateRecognized) { // #3
        //  calculates and stores an x-y coordinate of the gesture's location, with respect to self's bounds. For example, a tap detected in the top-left corner of the toolbar will register as (0,0).
        
        CGPoint location = [recognizer locationInView:self]; // #4
        ///we invoke hitTest:withEvent: to determine which view received the tap
        
        UIView *tappedView = [self hitTest:location withEvent:nil]; // #5
        
        //we check if the view that was tapped was in fact one of our toolbar labels and if so, we verify our delegate for compatibility before performing the appropriate method call.
        
        if ([self.labels containsObject:tappedView]) { // #6
            if ([self.delegate respondsToSelector:@selector(floatingToolbar:didSelectButtonWithTitle:)]) {
                [self.delegate floatingToolbar:self didSelectButtonWithTitle:((UILabel *)tappedView).text];
            }
        }
    }
}
//----------------->
# pragma mark PAN GESTURE RECOGNIZER
- (void) panFired:(UIPanGestureRecognizer *)recognizer { ///??? how do these method calls work??? ///
    // capture the state of the recognizer... if it changes, you've recognized a pan gesture
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:self];
        //we no longer care where the gesture occurred. What's important now is which direction it travelled in. A pan gesture recognizer's translation is how far the user's finger has moved in each direction since the touch event began. This method is called often during a pan gesture because a “full” pan as we perceive it is actually a linear collection of small pans traveling a few pixels at a time.
        
        NSLog(@"New translation: %@", NSStringFromCGPoint(translation));
        
        if ([self.delegate respondsToSelector:@selector(floatingToolbar:didTryToPanWithOffset:)]) {
            [self.delegate floatingToolbar:self didTryToPanWithOffset:translation];
        }
        
        //At the end, we reset this translation to zero (CGPointZero) so that we can get the difference of each mini-pan every time the method is called.
        
        [recognizer setTranslation:CGPointZero inView:self];
    }
}
//--------------------->
- (void) layoutSubviews {
    // set the frames for the 4 labels
    
    for (UILabel *thisLabel in self.labels) {
        NSUInteger currentLabelIndex = [self.labels indexOfObject:thisLabel];
        
        CGFloat labelHeight = CGRectGetHeight(self.bounds) / 2;
        CGFloat labelWidth = CGRectGetWidth(self.bounds) / 2;
        CGFloat labelX = 0;
        CGFloat labelY = 0;
        
        // adjust labelX and labelY for each label
        if (currentLabelIndex < 2) {
            // 0 or 1, so on top
            labelY = 0;
        } else {
            // 2 or 3, so on bottom
            labelY = CGRectGetHeight(self.bounds) / 2;
        }
        
        if (currentLabelIndex % 2 == 0) { // is currentLabelIndex evenly divisible by 2?
            // 0 or 2, so on the left
            labelX = 0;
        } else {
            // 1 or 3, so on the right
            labelX = CGRectGetWidth(self.bounds) / 2;
        }
        
        thisLabel.frame = CGRectMake(labelX, labelY, labelWidth, labelHeight);
    }
}
//----------->
#pragma mark - Touch Handling

- (UILabel *) labelFromTouches:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    UIView *subview = [self hitTest:location withEvent:event];
    
    if ([subview isKindOfClass:[UILabel class]]) {
        return (UILabel *)subview;
    } else {
        return nil;
    }
}
//----------->
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    UILabel *label = [self labelFromTouches:touches withEvent:event];
//    
//    self.currentLabel = label;
//    self.currentLabel.alpha = 0.5;
//}
//-------->
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//    UILabel *label = [self labelFromTouches:touches withEvent:event];
//    
//    if (self.currentLabel != label) {
//        // The label being touched is no longer the initial label
//        self.currentLabel.alpha = 1;
//    } else {
//        // The label being touched is the initial label
//        self.currentLabel.alpha = 0.5;
//    }
//}
//------------->
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    UILabel *label = [self labelFromTouches:touches withEvent:event];
//    
//    if (self.currentLabel == label) {
//        NSLog(@"Label tapped: %@", self.currentLabel.text);
//        
//        NSString *preDefinedLabel = [[NSString alloc] init];
//        if ([self.currentLabel.text  isEqual: @"Back"]){
//           NSLog(@"testing %@", kWebBrowserBackString);
//            preDefinedLabel = kWebBrowserBackString;
//        }
//        else if ([self.currentLabel.text isEqual: @"Stop"]){
//            NSLog(@"testing %@", kWebBrowserStopString);
//            preDefinedLabel = kWebBrowserStopString;
//        }
//        else if ([self.currentLabel.text isEqual: @"Refresh"]){
//            NSLog(@"testing %@", kWebBrowserBackString);
//            preDefinedLabel = kWebBrowserRefreshString;
//        }
//        else if ([self.currentLabel.text isEqual: @"Forward"]){
//            NSLog(@"testing %@", kWebBrowserForwardString);
//            preDefinedLabel = kWebBrowserForwardString;
//        }
//        if ([self.delegate respondsToSelector:@selector(floatingToolbar:didSelectButtonWithTitle:)]) {
//            [self.delegate floatingToolbar:self didSelectButtonWithTitle:preDefinedLabel];
//        }
//    }
//    
//    self.currentLabel.alpha = 1;
//    self.currentLabel = nil;
//}
//------->
//- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
//    self.currentLabel.alpha = 1;
//    self.currentLabel = nil;
//}
//------>
#pragma mark - Button Enabling

- (void) setEnabled:(BOOL)enabled forButtonWithTitle:(NSString *)title {
    NSUInteger index = [self.currentTitles indexOfObject:title];
    
    if (index != NSNotFound) {
        UILabel *label = [self.labels objectAtIndex:index];
        label.userInteractionEnabled = enabled;
        label.alpha = enabled ? 1.0 : 0.25;
    }
}
//----------------->
@end
