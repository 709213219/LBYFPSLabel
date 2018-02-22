#import <Foundation/Foundation.h>

@interface LBYProxy : NSProxy

+ (instancetype)proxyWithTarget:(id)target;

- (instancetype)initWithTarget:(id)target;

@end
