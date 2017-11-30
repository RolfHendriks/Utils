//
//  FoundationExtensions.h
//  GameTimer
//
//  Created by Rolf Hendriks on 3/2/17.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// Add support for getting/setting bool/int/etc data structures from NSDictionary.
// Automatically adds type checking of underlying data to prevent crashes.
// Adds support for elegant handling of nil data.
@interface NSDictionary (Utilities)

- (BOOL) boolForKey:(NSString*)key;
- (BOOL) boolForKey:(NSString*)key withDefaultValue:(BOOL)defaultValue;

- (int) intForKey:(NSString*)key;
- (int) intForKey:(NSString*)key withDefaultValue:(int)defaultValue;

- (float) floatForKey:(NSString*)key;
- (float) floatForKey:(NSString*)key withDefaultValue:(float)defaultValue;

- (NSString*) stringForKey:(NSString*)key;
- (NSString*) stringForKey:(NSString*)key withDefaultValue:(nullable NSString*)defaultValue;

@end

@interface NSMutableDictionary (Utilities)
/// Sets a value, or clears the value if setting to nil
- (void) setNullableObject:(nullable id)object forKey:(NSString*)key;
@end

@interface NSNotificationCenter (Utilities)
+ (void) post:(NSString*)name;
@end
@interface NSObject (NSNotification)
- (void) observeNotificationName:(NSString*)notificationName withAction:(SEL)action;
- (void) stopObservingNotifications;
@end


@interface NSTimer (Utilities)

/**
 begins a timer that calls an action repeatedly in a specified time interval.
 @param fireImmediately if YES, the first timer action triggers immediately. Otherwise the first action is triggered after the specified time interval.
 */
+ (NSTimer*) beginRepeatingTimerWithTarget:(id)target action:(SEL)action interval:(NSTimeInterval)interval fireImmediately:(BOOL)fireImmediately;

/**
 Begins a timer that fires an action at a regular interval, but with configurable delay 
 for the initial action.
 */
+ (NSTimer*) beginRepeatingTimerWithTarget:(id)target action:(SEL)action interval:(NSTimeInterval)interval initialDelay:(NSTimeInterval)delay;

@end

// to do:
//  components from date
//  formatted date/time/datecomponents strings

NS_ASSUME_NONNULL_END
