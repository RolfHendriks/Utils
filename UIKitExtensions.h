//
//  UIKitExtensions.h
//  GameTimer
//
//  Created by Rolf Hendriks on 2/27/17.
//
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*
 UIKIT EXTENSIONS
 
 This utility collects common extensions to core UIKit functionality.
 Only common functionality that applies to every application (ex: layout, animation)
 should be included here. Special case utilities that an application may or may not need, 
 or utilities that include additional frameworks, should be implemented as standalone 
 utilities instead. Throughout the framework, simplicity of the API should take priority 
 over comprehensive coverage of use cases. So when in doubt, leave it out.
 
 The decision to collect multiple extensions into a single file is deliberate. The nature of 
 these utilities is that they are simple and save only a small amount of work, but do so
 very frequently. If they were implemented independently, then the overhead of importing an
 additional header just to save a small amount of work would likely outweigh the benefits.
 
 As much as possible, UIKit extensions should stick with UIKit conventions rather than 
 abstract away from them.
*/

@interface UIView (LayoutUtilities)

/*
FRAME BASED LAYOUT UTILITIES

 Greatly simplifies working with frame based layouts.
 
 Example: vertical alignment
 Before:
 self.frame = CGRectMake ( other.frame.origin.x, CGRectGetMaxY (other.frame) + margin, self.frame.size.width, self.frame.size.height );
 After:
 self.top = other.bottom + margin;
 
 Example: horizontal alignment
 Before:
 self.frame = CGRectMake ( CGRectGetMaxX (other.frame), other.frame.origin.y, screen.bounds.size.width - margin - CGRectGetMaxX (other.frame), other.frame.size.height );
 After:
 [self setLeft:other.right width:screen.width - margin - other.right];
 
*/


// properties
@property (assign, nonatomic) CGFloat left, right, top, bottom, width, height;
@property (assign, nonatomic) CGFloat centerX, centerY;
@property (assign, nonatomic) CGPoint origin;
@property (readonly) CGPoint centerBounds;  // ex: view.center = parent.centerBounds centers a view


// mutators
- (void) setLeft:(CGFloat)left width:(CGFloat)width;
- (void) setTop:(CGFloat)top height:(CGFloat)height;
- (void) moveBy:(CGPoint)offset;

// CGAffineTransform utilities
@property (assign, nonatomic) CGPoint translation;
/// Caution: Setting a scale factor resets rotation + translation back to zero
- (void) setScale:(CGFloat)scale;
/// Caution: setting a rotation resets translation + scale factor
- (void) setRotation:(CGFloat)radians;

@end

@interface UIView (AutolayoutUtilies)

// AUTOLAYOUT MARGIN CONSTRAINTS
// API note: prioritizing simplicity of this API over comprehensive coverage of Autolayout

/**
 Applies leading, trailing, top, and bottom margins between a view and one of its children.
 Tip: use [view addMargins:UIEdgeInsetsZero toSubview:subview] to make a subview fill its parent.
 
 @returns the top, leading, bottom, and trailing margin constraints added to the view
 */
- (NSArray<NSLayoutConstraint*>*) addMargins:(UIEdgeInsets)margins toSubview:(UIView*)child;
- (NSLayoutConstraint*) addTopMargin:(CGFloat)margin toSubview:(UIView*)child;
- (NSLayoutConstraint*) addBottomMargin:(CGFloat)margin toSubview:(UIView*)child;
- (NSLayoutConstraint*) addLeadingMargin:(CGFloat)margin toSubview:(UIView*)child;
- (NSLayoutConstraint*) addTrailingMargin:(CGFloat)margin toSubview:(UIView*)child;

// AUTOLAYOUT SPACING CONSTRAINTS
- (NSLayoutConstraint*) addVerticalSpacing:(CGFloat)spacing betweenTopView:(UIView*)top andBottomView:(UIView*)bottom;
- (NSLayoutConstraint*) addHorizontalSpacing:(CGFloat)spacing betweenLeadingView:(UIView*)leading andTrailingView:(UIView*)trailing;

// AUTOLAYOUT SIZE CONSTRAINTS
- (NSLayoutConstraint*) addWidthConstraint:(CGFloat)w;
- (NSLayoutConstraint*) addHeightConstraint:(CGFloat)h;

// AUTOLAYOUT CENTER ALIGNMENT CONSTRAINTS
- (NSLayoutConstraint*) addCenterXAlignmentToSubview:(UIView*)v;
- (NSLayoutConstraint*) addCenterYAlignmentToSubview:(UIView*)v;

// AUTOLAYOUT GENERAL PURPOSE UTILITIES
- (NSLayoutConstraint*) addConstraintWithItem:(UIView*)item attribute:(NSLayoutAttribute)attribute equalToItem:(nullable UIView*)item attribute:(NSLayoutAttribute)attribute;
- (NSLayoutConstraint*) addConstraintWithItem:(UIView*)item attribute:(NSLayoutAttribute)attribute equalToItem:(nullable UIView*)item attribute:(NSLayoutAttribute)attribute constant:(CGFloat)constant;
- (NSArray<NSLayoutConstraint*>*) alignViews:(NSArray<UIView*>*)views byAttribute:(NSLayoutAttribute)att;

@end

@interface UIView(HierarchyUtilities)

/**
 Debug logs the view's entire hierarchy. Very similar to -recursiveDescription, except that
 this method is not private and is easier to type into a console.
 */
- (void) log;

/// Debug logs the entire screen
+ (void) log;

/** 
 Logs a recursive description from the root view down to this view, including the subview index at each step down the hierarchy.
 Ex: (root view description)
        [5] -> (description of subview at index 5)
            [0] -> (description of subview at index 0)
 */
- (NSString*) ancestryDescription;


// subview tree queries
- (NSArray<UIView*>*) subviewsPassingTest:(BOOL(^)(UIView* v))test recursive:(BOOL)recursive;
- (NSArray<UIView*>*) subviewsOfType:(Class)type; // non-recursive

@end

@interface UIView(AnimationUtilities)

// general purpose animation utilities
+ (void) animateWithDuration:(NSTimeInterval)duration curve:(UIViewAnimationCurve)curve animations:(void(^)())animations;
+ (void) animateWithDuration:(NSTimeInterval)duration springDamping:(CGFloat)springDamping animations:(void(^)())animations;

// fade in/out an object
- (void) fadeOutWithDuration:(NSTimeInterval)duration;
- (void) fadeInWithDuration:(NSTimeInterval)duration;
- (void) fadeOutWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay;
- (void) fadeInWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay;

/// Adds a specified subview, then immediately fades it in
- (void) addSubview:(UIView*)view withDuration:(NSTimeInterval)duration;
/// Fades out a subview and removes it from the view hierarchy after completion (assuming the animation was not interrupted)
- (void) removeFromSuperviewWithDuration:(NSTimeInterval)duration;

// cross fade transition:
//  to animate otherwise inanimate properties (like a label's text or a button's image, for example),
//  just attach a cross fade transition!
- (void) addCrossfadeTransition;
- (void) removeCrossfadeTransition;

@end

@interface UIView (NibLoading)
+ (instancetype) loadFromNibName:(NSString*)nibName;
@end

@interface UILabel (Utilities)
- (void) changeTextTo:(NSString*)text duration:(NSTimeInterval)duration;
@end

@interface UIButton (Utilities)

@property (copy, nonatomic, nullable) NSString* title;
@property (strong, nonatomic, nullable) UIImage* image, *backgroundImage;
- (void) setBackgroundImage:(UIImage*)bg highlighted:(nullable UIImage*)highlighted disabled:(nullable UIImage*)disabled;
- (void) setTextColor:(UIColor*)color;
@end

@interface UIImage (Utilities)
// just like imageNamed:, except that it fails with an assertion error if the image is not found
+ (UIImage*) assertingImageNamed:(NSString*)name;
#define IMAGE(name) [UIImage assertingImageNamed:name]

@end

@interface UIViewController (Utilities)
- (UITapGestureRecognizer*) addTapGestureForView:(UIView*)view withAction:(SEL)action;
@end

@interface UIFont (Utilities)
- (UIFont*) monospacedDigitFont;
@end

@interface UITableView (Utilities)
- (void) reloadRowAtIndex:(NSInteger)i;
- (void) reloadRowAtIndexPath:(NSIndexPath*)path;
@end

NS_ASSUME_NONNULL_END

// TODO: merge all other essential UIKit extensions here. Want:
//  UIColor rgb components
//  UIImage tinting
//  touch padding
//  button touch down tinting
//  buttonWithImage, buttonWithText
//  UITableViewCell with custom highlight color
