//
//  UIKitExtensions.m
//  GameTimer
//
//  Created by Rolf Hendriks on 2/27/17.
//
//

#import "UIKitExtensions.h"
#import "CoreText/SFNTLayoutTypes.h"    // for advanced font variations, including monospaced digits

#pragma mark - UIView (Layout)

@implementation UIView (Layout)

- (void) addFlexibleSubview:(UIView *)subview withMargins:(UIEdgeInsets)margins
{
    // only need to set view frame for frame based layout. But for easier
    // debugging, let's set the frame even for Autolayout:
    CGRect frame = CGRectMake(margins.left, margins.top, self.bounds.size.width - margins.left - margins.right, self.bounds.size.height - margins.top - margins.bottom);
    subview.frame = frame;
    if (subview.translatesAutoresizingMaskIntoConstraints)
    {
        subview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:subview];
    }
    else
    {
        [self addSubview:subview];
        [self addMargins:margins toSubview:subview];
    }
}

- (CGFloat) right   { return self.frame.origin.x + self.frame.size.width; }
- (CGFloat) left    { return self.frame.origin.x; }
- (CGFloat) top     { return self.frame.origin.y; }
- (CGFloat) bottom  { return self.frame.origin.y + self.frame.size.height; }

- (CGFloat) width   { return self.bounds.size.width; }
- (CGFloat) height  { return self.bounds.size.height; }

- (CGFloat) centerX { return self.center.x; }
- (CGFloat) centerY { return self.center.y; }
- (CGPoint) origin  { return self.frame.origin; }

- (CGPoint) centerBounds { return CGPointMake(.5 * self.width, .5 * self.height); }


////////////////////
// MUTATORS
//////////////////

- (void) setLeft:(CGFloat)l     { self.frame = CGRectMake (l, self.frame.origin.y, self.frame.size.width, self.frame.size.height); }
- (void) setRight:(CGFloat)r    { self.frame = CGRectMake (r - self.frame.size.width, self.frame.origin.y, self.frame.size.width, self.frame.size.height); }
- (void) setTop:(CGFloat)t      { self.frame = CGRectMake (self.frame.origin.x, t, self.frame.size.width, self.frame.size.height); }
- (void) setBottom:(CGFloat)b   { self.frame = CGRectMake (self.frame.origin.x, b - self.frame.size.height, self.frame.size.width, self.frame.size.height); }

- (void) setWidth:(CGFloat)w    { self.frame = CGRectMake (self.frame.origin.x, self.frame.origin.y, w, self.frame.size.height); }
- (void) setHeight:(CGFloat)h   { self.frame = CGRectMake (self.frame.origin.x, self.frame.origin.y, self.frame.size.width, h); }

- (void) setCenterX:(CGFloat)cx { self.center = CGPointMake (cx, self.center.y); }
- (void) setCenterY:(CGFloat)cy { self.center = CGPointMake (self.center.x, cy); }
- (void) setOrigin:(CGPoint)point   { self.center = CGPointMake (point.x + self.bounds.size.width * 0.5f, point.y + self.bounds.size.height * 0.5f); }

- (void) moveBy:(CGPoint)point  { self.center = CGPointMake (self.center.x + point.x, self.center.y + point.y); }
- (void) setLeft:(CGFloat)left width:(CGFloat)width { self.frame = CGRectMake(left, self.top, width, self.height); }
- (void) setTop:(CGFloat)top height:(CGFloat)height { self.frame = CGRectMake(self.left, top, self.width, height); }


////////////////////////
// TRANSFORMS
////////////////////////
- (CGPoint) translation { return CGPointMake (self.transform.tx, self.transform.ty); }
- (void) setTranslation:(CGPoint)translation
{
    CGAffineTransform t = self.transform;
    t.tx = translation.x;
    t.ty = translation.y;
    self.transform = t;
}
- (void) setScale:(CGFloat)scale
{
    self.transform = CGAffineTransformMakeScale(scale, scale);
}
- (void) setRotation:(CGFloat)radians
{
    self.transform = CGAffineTransformMakeRotation(radians);
}

@end



#pragma mark - UIView (Autolayout)
@implementation UIView (Autolayout)

- (NSArray<NSLayoutConstraint*>*) addMargins:(UIEdgeInsets)margins toSubview:(UIView*)child
{
    NSMutableArray* result = [NSMutableArray arrayWithCapacity:4];
    [result addObject:[self addTopMargin:margins.top toSubview:child]];
    [result addObject:[self addLeadingMargin:margins.left toSubview:child]];
    [result addObject:[self addBottomMargin:margins.bottom toSubview:child]];
    [result addObject:[self addTrailingMargin:margins.right toSubview:child]];
    return result;
}

- (NSLayoutConstraint*) addTopMargin:(CGFloat)margin toSubview:(UIView*)child
{
    return [self addConstraintWithItem:child attribute:NSLayoutAttributeTop equalToItem:self attribute:NSLayoutAttributeTop constant:margin];
}

- (NSLayoutConstraint*) addBottomMargin:(CGFloat)margin toSubview:(UIView*)child
{
    return [self addConstraintWithItem:self attribute:NSLayoutAttributeBottom equalToItem:child attribute:NSLayoutAttributeBottom constant:margin];
}

- (NSLayoutConstraint*) addLeadingMargin:(CGFloat)margin toSubview:(UIView*)child
{
    return [self addConstraintWithItem:child attribute:NSLayoutAttributeLeading equalToItem:self attribute:NSLayoutAttributeLeading constant:margin];
}

- (NSLayoutConstraint*) addTrailingMargin:(CGFloat)margin toSubview:(UIView*)child
{
    return [self addConstraintWithItem:self attribute:NSLayoutAttributeTrailing equalToItem:child attribute:NSLayoutAttributeTrailing constant:margin];
}

// AUTOLAYOUT SPACING CONSTRAINTS
- (NSLayoutConstraint*) addVerticalSpacing:(CGFloat)spacing betweenTopView:(UIView*)top andBottomView:(UIView*)bottom
{
    return [self addConstraintWithItem:bottom attribute:NSLayoutAttributeTop equalToItem:top attribute:NSLayoutAttributeBottom constant:spacing];
}

- (NSLayoutConstraint*) addHorizontalSpacing:(CGFloat)spacing betweenLeadingView:(UIView*)leading andTrailingView:(UIView*)trailing
{
    return [self addConstraintWithItem:trailing attribute:NSLayoutAttributeLeading equalToItem:leading attribute:NSLayoutAttributeTrailing constant:spacing];
}

// AUTOLAYOUT SIZE CONSTRAINTS
- (NSLayoutConstraint*) addWidthConstraint:(CGFloat)w
{
    return [self addConstraintWithItem:self attribute:NSLayoutAttributeWidth equalToItem:nil attribute:NSLayoutAttributeNotAnAttribute constant:w];
}

- (NSLayoutConstraint*) addHeightConstraint:(CGFloat)h
{
    return [self addConstraintWithItem:self attribute:NSLayoutAttributeHeight equalToItem:nil attribute:NSLayoutAttributeNotAnAttribute constant:h];
}


// AUTOLAYOUT CENTER ALIGNMENT
- (NSLayoutConstraint*) addCenterXAlignmentToSubview:(UIView*)v
{
    return [self addConstraintWithItem:v attribute:NSLayoutAttributeCenterX equalToItem:self attribute:NSLayoutAttributeCenterX];
}

- (NSLayoutConstraint*) addCenterYAlignmentToSubview:(UIView*)v
{
    return [self addConstraintWithItem:v attribute:NSLayoutAttributeCenterY equalToItem:self attribute:NSLayoutAttributeCenterY];
}

// AUTOLAYOUT GENERAL PURPOSE UTILITIES
- (NSLayoutConstraint*) addConstraintWithItem:(UIView*)item attribute:(NSLayoutAttribute)attribute equalToItem:(nullable UIView*)item2 attribute:(NSLayoutAttribute)attribute2
{
    return [self addConstraintWithItem:item attribute:attribute equalToItem:item2 attribute:attribute2 constant:0];
}
- (NSLayoutConstraint*) addConstraintWithItem:(UIView*)item attribute:(NSLayoutAttribute)attribute equalToItem:(nullable UIView*)item2 attribute:(NSLayoutAttribute)attribute2 constant:(CGFloat)constant
{
    NSLayoutConstraint* constraint  = [NSLayoutConstraint constraintWithItem:item attribute:attribute relatedBy:NSLayoutRelationEqual toItem:item2 attribute:attribute2 multiplier:1 constant:constant];
    [self addConstraint:constraint];
    return constraint;
}
- (NSArray<NSLayoutConstraint*>*) alignViews:(NSArray<UIView*>*)views byAttribute:(NSLayoutAttribute)att
{
    if (views.count < 2) return nil;
    
    NSMutableArray<NSLayoutConstraint*>* result = [NSMutableArray arrayWithCapacity:views.count-1];
    for (int i=0; i < views.count - 1; ++i)
    {
        UIView* view = views[i];
        UIView* nextView = views[i+1];
        NSLayoutConstraint* equalAttributes = [self addConstraintWithItem:view attribute:att equalToItem:nextView attribute:att];
        [result addObject:equalAttributes];
    }
    return result;
}

@end

#pragma mark - UIView (Hierarchy)
@implementation UIView (HierarchyUtilities)

////////////////////////
// VIEW HIERARCHY
////////////////////////

- (void) log
{
    NSLog(@"\n%@", [self hierarchy]);
}

+ (void) log
{
    [[[UIApplication sharedApplication] keyWindow] log];
}

- (UIView*) rootView
{
    for (UIView* result = self; ; result = result.superview)
    {
        if (result.superview == nil) return result;
    }
    return nil; // should never happen
}

- (NSString*) ancestryDescription
{
    // get list of views + indices from this view upwards
    NSMutableArray<UIView*>* views = [NSMutableArray new];
    NSMutableArray<NSObject*>* indices = [NSMutableArray new];
    for (UIView* view = self; view != nil; view = view.superview)
    {
        [views addObject:view];
        NSUInteger i = view.superview ? [view.superview.subviews indexOfObject:view] : NSNotFound;
        [indices addObject:i == NSNotFound ? [NSNull null] : @(i)];
    }
    
    // log list in reverse order (from top of hierarchy down to view)
    NSMutableString* result = [NSMutableString new];
    for (int i=0; i < views.count; ++i)
    {
        NSObject* index = indices[views.count-1-i];
        UIView* view = views[views.count-1-i];
        
        // add recursive indents
        for (int j=0; j<i; ++j)
        {
            [result appendString:@"\t"];
        }
        
        if ([index isKindOfClass:NSNumber.class])
        {
            [result appendFormat:@"[%d] -> ", ((NSNumber*)index).intValue];
        }
        [result appendString:view.description];
        [result appendString:@"\n"];
    }
    return result;
}


- (NSString*) hierarchy
{
    return [self.class hierarchyWithView:self indentations:0];
}

+ (NSMutableString*) hierarchyWithView:(UIView*)view indentations:(int)indentations
{
    // indentations
    NSMutableString* result = [NSMutableString string];
    for (int i = 0; i < indentations; ++i){
        [result appendString:@"|\t"];
    }
    ++indentations;
    
    // view
    [result appendFormat:@"%@\n", view];
    
    // subviews
    for (UIView* subview in view.subviews)
    {
        [result appendString:[self hierarchyWithView:subview indentations:indentations]];
    }
    return result;
}

- (NSArray<UIView*>*) subviewsPassingTest:(BOOL(^)(UIView* v))test recursive:(BOOL)recursive
{
    if (!self.subviews.count) return nil;
    
    NSMutableArray* result = [NSMutableArray arrayWithCapacity:self.subviews.count];
    for (UIView* view in self.subviews)
    {
        BOOL pass = test(view);
        if (pass) { [result addObject:view]; }
    }
    
    if (recursive)
    {
        for (UIView* view in self.subviews)
        {
            NSArray* recursiveResult = [view subviewsPassingTest:test recursive:YES];
            [result addObjectsFromArray:recursiveResult];
        }
    }
    return result;
}

- (NSArray<UIView*>*) subviewsOfType:(Class)type
{
    return [self subviewsPassingTest:^BOOL(UIView* view)
    {
        return [view isKindOfClass:type];
    } recursive:NO];
}

@end


#pragma mark - UIView (Animation)

@implementation UIView (AnimationUtilities)
// GENERAL PURPOSE
+ (UIViewAnimationOptions) animationOptionWithCurve:(UIViewAnimationCurve)curve
{
    switch (curve)
    {
        case UIViewAnimationCurveEaseIn: return UIViewAnimationOptionCurveEaseIn;
        case UIViewAnimationCurveEaseOut: return UIViewAnimationOptionCurveEaseOut;
        case UIViewAnimationCurveEaseInOut: return UIViewAnimationOptionCurveEaseInOut;
        case UIViewAnimationCurveLinear: return UIViewAnimationOptionCurveLinear;
    }
    return 0;
}

+ (void) animateWithDuration:(NSTimeInterval)duration curve:(UIViewAnimationCurve)curve animations:(void(^)())animations
{
    [UIView animateWithDuration:duration delay:0 options:[self animationOptionWithCurve:curve] animations:animations completion:NULL];
}

+ (void) animateWithDuration:(NSTimeInterval)duration springDamping:(CGFloat)springDamping animations:(void(^)())animations
{
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:springDamping initialSpringVelocity:0 options:0 animations:animations completion:NULL];
}

/////////////////
// FADE IN/OUT
//////////////////
- (void) fadeOutWithDuration:(NSTimeInterval)duration
{
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 0;
    }];
}

- (void) fadeInWithDuration:(NSTimeInterval)duration
{
    self.alpha = 0;
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 1;
    }];
}

- (void) fadeOutWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay
{
    [UIView animateWithDuration:duration delay:delay options:0 animations:^{
        self.alpha = 0;
    } completion:nil];
}

- (void) fadeInWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay
{
    self.alpha = 0;
    [UIView animateWithDuration:duration delay:delay options:0 animations:^{
        self.alpha = 1;
    } completion:nil];
}

/////////////////////
// ADD/REMOVE SUBVIEWS
/////////////////////

- (void) addSubview:(UIView*)view withDuration:(NSTimeInterval)duration{
    view.alpha = 0;
    //view.userInteractionEnabled = false;
    if (![view isDescendantOfView:self])
        [self addSubview:view];
    [view fadeInWithDuration:duration];
}

- (void) removeFromSuperviewWithDuration:(NSTimeInterval)duration
{
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished){
        if (finished)
        {
            [self removeFromSuperview];
            self.alpha = 1;
        }
    }];
}

////////////////////////////
// CROSSFADE
///////////////////////////

#define UIViewCrossFadeTransitionAnimationKey @"crossfade"

- (void) addCrossfadeTransition{
    CATransition* transition = [CATransition new];
    transition.type = kCATransitionFade;
    [self.layer addAnimation:transition forKey:UIViewCrossFadeTransitionAnimationKey];
}
- (void) removeCrossfadeTransition
{
    [self.layer removeAnimationForKey:UIViewCrossFadeTransitionAnimationKey];
}

@end

@implementation UIView (NibLoading)
+ (instancetype) loadFromNibName:(NSString*)nibName
{
    NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
    for (NSObject* object in nibContents){
        if ([object isKindOfClass:self.class]){
            return (UIView*)object;
        }
    }
    [NSException raise:NSInternalInconsistencyException format:@"Failed to load view from nib '%@'", nibName];
    return nil;
}
@end

#pragma mark - UILabel

@implementation UILabel (Utilities)

- (void) changeTextTo:(NSString*)to duration:(NSTimeInterval)duration
{
    [UIView animateWithDuration:duration*.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished){
        self.text = to;
        [UIView animateWithDuration:duration*.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.alpha = 1;
        } completion:NULL];
    }];
}

@end

#pragma mark - UIButton

@implementation UIButton (Utilities)

- (NSString*) title { return self.titleLabel.text; }
- (void) setTitle:(NSString *)title { [self setTitle:title forState:UIControlStateNormal]; }

- (UIImage*) image { return [self imageForState:UIControlStateNormal]; }
- (void) setImage:(UIImage*)image { [self setImage:image forState:UIControlStateNormal]; }

- (UIImage*) backgroundImage { return [self backgroundImageForState:UIControlStateNormal];  }
- (void) setBackgroundImage:(UIImage*)image { [self setBackgroundImage:image forState:UIControlStateNormal]; }

- (void) setBackgroundImage:(UIImage*)bg highlighted:(nullable UIImage*)highlighted disabled:(nullable UIImage*)disabled
{
    self.backgroundImage = bg;
    if (highlighted)
    {
        [self setBackgroundImage:highlighted forState:UIControlStateHighlighted];
    }
    if (disabled)
    {
        [self setBackgroundImage:disabled forState:UIControlStateDisabled];
    }
}

- (void) setTextColor:(UIColor *)color
{
    [self setTitleColor:color forState:UIControlStateNormal];
}

@end

#pragma mark - UIImage

@implementation UIImage (Utilities)

+ (UIImage*) assertingImageNamed:(NSString*)name
{
    if (name == nil) return nil;
    UIImage* result = [UIImage imageNamed:name];
    NSAssert (result != nil, @"MISSING IMAGE NAMED '%@'", name);
    return result;
}

@end

#pragma mark - UIViewController

@implementation UIViewController (Utilties)

- (UITapGestureRecognizer*) addTapGestureForView:(UIView*)view withAction:(SEL)action
{
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:action];
    [view addGestureRecognizer:tap];
    return tap;
}
@end

#pragma mark - UIFont
@implementation UIFont (Utilities)
- (UIFont*) monospacedDigitFont
{
    return [UIFont fontWithDescriptor:[self.fontDescriptor fontDescriptorByAddingAttributes:@{ UIFontDescriptorFeatureSettingsAttribute:@[@{
            UIFontFeatureTypeIdentifierKey:@(kNumberSpacingType), UIFontFeatureSelectorIdentifierKey:@(kMonospacedNumbersSelector)
        }]}] size:0];
}
@end

#pragma mark - UITableView
@implementation UITableView (Utilities)
- (void) reloadRowAtIndex:(NSInteger)i
{
    [self reloadRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
}

- (void) reloadRowAtIndexPath:(NSIndexPath*)path
{
    [self reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
}

@end
