//
//  FoundationExtensions.m
//  GameTimer
//
//  Created by Rolf Hendriks on 3/2/17.
//
//

#import "FoundationExtensions.h"

@implementation NSDictionary (Utilities)

- (BOOL) boolForKey:(NSString*)key
{
    return [self boolForKey:key withDefaultValue:0];
}
- (BOOL) boolForKey:(NSString*)key withDefaultValue:(BOOL)defaultValue
{
    NSNumber* object = self[key];
    return [object isKindOfClass:NSNumber.class] ? object.boolValue : defaultValue;
}

- (int) intForKey:(NSString*)key
{
    return [self intForKey:key withDefaultValue:0];
}
- (int) intForKey:(NSString*)key withDefaultValue:(int)defaultValue
{
    NSNumber* object = self[key];
    return [object isKindOfClass:NSNumber.class] ? object.intValue : defaultValue;
}



- (float) floatForKey:(NSString*)key
{
    return [self floatForKey:key withDefaultValue:0];
}
- (float) floatForKey:(NSString*)key withDefaultValue:(float)defaultValue
{
    NSNumber* object = self[key];
    return [object isKindOfClass:NSNumber.class] ? object.floatValue : defaultValue;
}



- (NSString*) stringForKey:(NSString*)key
{
    return [self stringForKey:key withDefaultValue:nil];
}
- (NSString*) stringForKey:(NSString*)key withDefaultValue:(NSString*)defaultValue
{
    NSString* object = self[key];
    return [object isKindOfClass:NSString.class] ? object : defaultValue;
}
@end

@implementation NSMutableDictionary (Utilities)

- (void) setNullableObject:(id)obj forKey:(NSString*)key
{
    if (obj != nil) self[key] = obj;
    else [self removeObjectForKey:key];
}

@end

@implementation NSNotificationCenter (Utlities)
+ (void) post:(NSString*)name
{
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil];
}
@end
@implementation NSObject (NSNotification)
- (void) observeNotificationName:(NSString*)notification withAction:(SEL)action
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:action name:notification object:nil];
}
- (void) stopObservingNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

@implementation NSTimer (Utilities)

+ (NSTimer*) beginRepeatingTimerWithTarget:(id)target action:(SEL)action interval:(NSTimeInterval)interval fireImmediately:(BOOL)fireImmediately
{
    return [self beginRepeatingTimerWithTarget:target action:action interval:interval initialDelay:fireImmediately ? 0 : interval];
}

+ (NSTimer*) beginRepeatingTimerWithTarget:(id)target action:(SEL)action interval:(NSTimeInterval)interval initialDelay:(NSTimeInterval)delay
{
    // Note: if delay=0, may want to fire the action immediately instead of in the next run loop iteration like we are doing now
    NSDate* fireTime = [NSDate dateWithTimeIntervalSinceNow:delay];
    NSTimer* result = [[NSTimer alloc] initWithFireDate:fireTime interval:interval target:target selector:action userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:result forMode:NSRunLoopCommonModes];
    return result;
}

@end
