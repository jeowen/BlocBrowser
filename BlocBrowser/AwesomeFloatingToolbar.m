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
@property (nonatomic, strong) NSMutableArray *colors;
@property (nonatomic, strong) NSMutableArray *labels;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, weak) UILabel *currentLabel;

// property to store the tap gesture recognizer
 @property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

// property to recognize a pan gesture
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

////add a long press gesture recognizer
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;

////add a pinch gesture recognizer
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGesture;

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
    UIColor *color1, *color2, *color3, *color4;
    color1 =[UIColor colorWithRed:199/255.0 green:158/255.0 blue:203/255.0 alpha:1];
    color2 =[UIColor colorWithRed:255/255.0 green:105/255.0 blue:97/255.0 alpha:1];
    color3 =[UIColor colorWithRed:222/255.0 green:165/255.0 blue:164/255.0 alpha:1] ;
    color4 =[UIColor colorWithRed:255/255.0 green:179/255.0 blue:71/255.0 alpha:1];
    
    if (self) {
        
        // Save the titles, and set the 4 colors
        self.currentTitles = titles;

        
//        self.colors = @[[UIColor colorWithRed:199/255.0 green:158/255.0 blue:203/255.0 alpha:1],
//                        [UIColor colorWithRed:255/255.0 green:105/255.0 blue:97/255.0 alpha:1],
//                        [UIColor colorWithRed:222/255.0 green:165/255.0 blue:164/255.0 alpha:1],
//                        [UIColor colorWithRed:255/255.0 green:179/255.0 blue:71/255.0 alpha:1]];

//        self.colors = @[color1, color2, color3, color4];
        self.colors = [[NSMutableArray alloc] init]; // what a bear!!!
        self.colors[0] = color1; //purple
        self.colors[1] = color2; //pink
        self.colors[2] = color3; //redish
        self.colors[3] = color4; //yellow
        
        
        
//        // Make the 4 labels
//        NSMutableArray *labelsArray = [[NSMutableArray alloc] init];
//        for (NSString *currentTitle in self.currentTitles) {
//            UILabel *label = [[UILabel alloc] init];
//            label.userInteractionEnabled = NO;
//            label.alpha = 0.25;
//            
//            NSUInteger currentTitleIndex = [self.currentTitles indexOfObject:currentTitle]; // 0 through 3
//            
//            NSString *titleForThisLabel = [self.currentTitles objectAtIndex:currentTitleIndex];
//            UIColor *colorForThisLabel = [self.colors objectAtIndex:currentTitleIndex];
//            NSLog(@"color = %@", colorForThisLabel);
//            label.textAlignment = NSTextAlignmentCenter;
//            label.font = [UIFont systemFontOfSize:10];
//            label.text = titleForThisLabel;
//            label.backgroundColor = colorForThisLabel;
//            label.textColor = [UIColor whiteColor];
//            
//            [labelsArray addObject:label];
//        }
//        
//        self.labels = labelsArray;
//        
//        for (UILabel *thisLabel in self.labels) {
//            [self addSubview:thisLabel];
//        }
        
        // Make the 4 buttons
        #pragma mark replacing labels with buttons
        NSMutableArray *buttonsArray = [[NSMutableArray alloc] init];
        for (NSString *currentTitle in self.currentTitles){
            UIButton *button = [[UIButton alloc] init];
            // set button properties:
            // - button enabled = NO
//            - button alpha (transparency) = 0.25
//            - button text = button titles
//            - button backgroundColor
//            - button textColor
            button.enabled = NO;
            button.alpha = 0.25;
            
            // set button text
            NSUInteger currentTitleIndex = [self.currentTitles indexOfObject:currentTitle]; // 0 through 3
            NSString *titleForThisLabel = [self.currentTitles objectAtIndex:currentTitleIndex];
            UIColor *colorForThisLabel = [self.colors objectAtIndex:currentTitleIndex];
            
            [button setTitle:titleForThisLabel forState:UIControlStateNormal];
            button.backgroundColor = colorForThisLabel;
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            // create highlighting on button press
            [button setTitleColor:[UIColor blackColor]
                               forState:UIControlStateHighlighted];
           // do something when the button is pressed...
            
//            if (currentTitleIndex == 0){
//               [button addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//            }
//            else if (currentTitleIndex == 1){
//                [button addTarget:self action:@selector(forwardButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//            }
//            else if (currentTitleIndex == 2){
//                [button addTarget:self action:@selector(stopButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//            }
//            else if (currentTitleIndex == 3){
//                [button addTarget:self action:@selector(refreshButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//            }
            [button addTarget:self action:@selector(buttonPressedAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [buttonsArray addObject:button];
        }
        self.buttons = buttonsArray;
        NSLog(@"buttons array = %@", self.buttons);
        
        for (UIButton *thisButton in self.buttons) {
            [self addSubview:thisButton];
        }
        
    } // END if (self)
    
    // initialize TAP GESTURE RECOGNIZER
    // #1
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFired:)];
    // #2
    NSLog(@"attempting to add tap Gesture recognizer\n\n");
    [self addGestureRecognizer:self.tapGesture];
    
    // initialize a PAN GESTURE RECOGNIZER from property panGesture declared above
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panFired:)];
    [self addGestureRecognizer:self.panGesture];
    
    // initial a LONG PRESS GESTURE REGONIZER from longPressGesture property declared above
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressFired:)];
    longPress.minimumPressDuration = 1.0f;
    self.longPressGesture = longPress;
   [self addGestureRecognizer:self.longPressGesture];
    
    // initialize a PINCHGESTURE RECOGNIZER from property pinchGesture declared above
    self.pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchFired:)];
    [self addGestureRecognizer:self.pinchGesture];
    
    return self;
}
//-------------->
#pragma mark DETECT BUTTON PRESS
- (void)buttonPressedAction:(id)sender{
    UIButton *buttonPressed = (UIButton *)sender;
    // int row = buttonPressed.tag;
    NSString *buttonTitle = buttonPressed.titleLabel.text;
    if ([buttonTitle isEqualToString:@"Back"]){
        NSLog(@"BACK button press detected\n");
    }
    else if ([buttonTitle isEqualToString:@"Refresh"]){
        NSLog(@"REFRESH button press detected\n");
    }
    else if ([buttonTitle isEqualToString:@"Stop"]){
        NSLog(@"STOP button press detected\n");
    }
    else if ([buttonTitle isEqualToString:@"Forward"]){
        NSLog(@"FORWARD button press detected\n");
    }
    if ([self.delegate respondsToSelector:@selector(floatingToolbar:didSelectButtonWithTitle:)]) {
        [self.delegate floatingToolbar:self didSelectButtonWithTitle:buttonTitle];
    }
    //NSLog(@"detected a button press\n");
}
//-------------->

#pragma mark TAP GESTURE RECOGNIZER
//IMPLEMENT TAP GESTURE RECOGNIZER (TAP FIRED METHOD) (in self, which is a UIView object)
- (void) tapFired:(UITapGestureRecognizer *)recognizer {
    NSLog(@"Tap Gesture Detected\n");
    // The first thing we do is check for the proper state.  A gesture recognizer has several states it can be in, and UIGestureRecognizerStateRecognized is the state in which the type of gesture it recognizes has been detected. In our case, a tap has been completed and the recognizer's state was switched to UIGestureRecognizerStateRecognized. If the gesture recognizer is in any other state, the gesture hasn't been detected.
    
    if (recognizer.state == UIGestureRecognizerStateRecognized) { // #3
        //  calculates and stores an x-y coordinate of the gesture's location, with respect to self's bounds. For example, a tap detected in the top-left corner of the toolbar will register as (0,0).
        
        CGPoint location = [recognizer locationInView:self]; // #4
        ///we invoke hitTest:withEvent: to determine which view received the tap
        
        UIView *tappedView = [self hitTest:location withEvent:nil]; // #5
        
        //we check if the view that was tapped was in fact one of our toolbar labels and if so, we verify our delegate for compatibility before performing the appropriate method call.
        
//        if ([self.labels containsObject:tappedView]) { // #6
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
    NSLog(@"Pan Gesture detected\n");
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
# pragma mark PINCH GESTURE RECOGNIZER
- (void) pinchFired:(UIPinchGestureRecognizer *)recognizer {
    // capture the state of the recognizer... if it changes, you've recognized a pan gesture
    NSLog(@"Pinch Gesture detected in AwesomeFloatingToolbar.m\n");
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat pinchscale = recognizer.scale;
        NSLog(@"sPINCH GESTURE RECOGNIZER TRIGGERED in awesomefloatingtoolbar.m with scale = %f", pinchscale);
        if ([self.delegate respondsToSelector:@selector(floatingToolbar:didTryToPinchWithScale:)]) {
            [self.delegate floatingToolbar:self didTryToPinchWithScale: pinchscale];
        }

    }
}
//--------------------->
#pragma mark LONG PRESS GESTURE RECOGNIZER
- (void) longPressFired:(UILongPressGestureRecognizer *) recognizer{

    if (recognizer.state == UIGestureRecognizerStateBegan){
        NSLog(@",,,,OOOOGAAAAAA:  LONG PRESS DETECTED\n");
        // GET CURRENT COLOR WHEEL AND THEN SPIN IT!
//        self.colors = @[[UIColor colorWithRed:199/255.0 green:158/255.0 blue:203/255.0 alpha:1],
//                        [UIColor colorWithRed:255/255.0 green:105/255.0 blue:97/255.0 alpha:1],
//                        [UIColor colorWithRed:222/255.0 green:165/255.0 blue:164/255.0 alpha:1],
//                        [UIColor colorWithRed:255/255.0 green:179/255.0 blue:71/255.0 alpha:1]];
        
        
        NSArray *colorSpin = [NSMutableArray arrayWithArray:self.colors];
        

        int i = 1;
        int j = 0;
        for (UILabel *label in self.labels){
            //replace label.backgroundColor in self.labels
            UIColor *colorForThisLabel = [[UIColor alloc] init];
            if (j==0){
                colorForThisLabel = [colorSpin objectAtIndex:2];
            }
            else if (j == 1){
                colorForThisLabel = [colorSpin objectAtIndex:0];
            }
            else if (j == 2){
                colorForThisLabel = [colorSpin objectAtIndex:3];
            }
            else if (j == 3){
                colorForThisLabel = [colorSpin objectAtIndex:1];
            }
            
            // UIColor *colorForThisLabel = [colorSpin objectAtIndex:i];
            [self.colors replaceObjectAtIndex:j withObject:colorForThisLabel];
            label.backgroundColor = colorForThisLabel;
            NSLog(@"i = %d, color = %@", i, label.backgroundColor);
            [self addSubview:label];
            if (i < 3){i++;}
            else{i = 0;}
            j++;
        }

        //-------------------->
    }
}
//-------------------------->
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
    
    for (UIButton *thisButton in self.buttons) {
        NSUInteger currentButtonIndex = [self.buttons indexOfObject:thisButton];
        
        CGFloat buttonHeight = CGRectGetHeight(self.bounds) / 2;
        CGFloat buttonWidth = CGRectGetWidth(self.bounds) / 2;
        CGFloat buttonX = 0;
        CGFloat buttonY = 0;
        
        // adjust buttonX and buttonY for each button
        if (currentButtonIndex < 2) {
            // 0 or 1, so on top
            buttonY = 0;
        } else {
            // 2 or 3, so on bottom
            buttonY = CGRectGetHeight(self.bounds) / 2;
        }
        
        if (currentButtonIndex % 2 == 0) { // is currentbuttonIndex evenly divisible by 2?
            // 0 or 2, so on the left
            buttonX = 0;
        } else {
            // 1 or 3, so on the right
            buttonX = CGRectGetWidth(self.bounds) / 2;
        }
        
        thisButton.frame = CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight);
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
//        UILabel *label = [self.labels objectAtIndex:index];
//        label.userInteractionEnabled = enabled;
//        label.alpha = enabled ? 1.0 : 0.25;
        UIButton *button = [self.buttons objectAtIndex:index];
        button.enabled = YES;
        button.alpha = enabled ? 1.0 : 0.25;
    }
}
//----------------->
@end
