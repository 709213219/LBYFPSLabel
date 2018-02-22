#import "LBYProxy.h"

@interface LBYProxy ()

@property (nonatomic, weak) id target;

@end

@implementation LBYProxy

+ (instancetype)proxyWithTarget:(id)target {
    return [[LBYProxy alloc] initWithTarget:target];
}

- (instancetype)initWithTarget:(id)target {
    _target = target;
    return self;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    [invocation invokeWithTarget:_target];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [_target methodSignatureForSelector:sel];
}

@end
