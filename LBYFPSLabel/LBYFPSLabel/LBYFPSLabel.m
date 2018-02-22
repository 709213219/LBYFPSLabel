#import "LBYFPSLabel.h"
#import "LBYProxy.h"

#define kSize CGSizeMake(55, 20)

@implementation LBYFPSLabel {
    CADisplayLink *_link;
    NSUInteger _count;
    NSTimeInterval _lastTime;
}

- (instancetype)init {
    return [self initWithFrame:CGRectMake(10, 30, kSize.width, kSize.height)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size = kSize;
    }
    
    self = [super initWithFrame:frame];
    
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    self.textAlignment = NSTextAlignmentCenter;
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
    
    UIFont *font = [UIFont fontWithName:@"Menlo" size:14];
    if (!font) {
        font = [UIFont fontWithName:@"Courier" size:14];
    }
    self.font = font;
    
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGes:)];
    [self addGestureRecognizer:panGes];
    
    _link = [CADisplayLink displayLinkWithTarget:[LBYProxy proxyWithTarget:self] selector:@selector(tick:)];
    [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    return self;
}

- (void)dealloc {
    [_link invalidate];
    NSLog(@"timer release");
}

- (CGSize)sizeThatFits:(CGSize)size {
    return kSize;
}

- (void)panGes:(UIPanGestureRecognizer *)ges {
    if (!ges.view.superview) return;
    
    CGPoint translation = [ges translationInView:ges.view.superview];
    ges.view.center = CGPointMake(ges.view.center.x + translation.x, ges.view.center.y + translation.y);
    [ges setTranslation:CGPointZero inView:ges.view.superview];
}

- (void)tick:(CADisplayLink *)link {
    if (_lastTime == 0) {
        _lastTime = link.timestamp;
        return;
    }
    
    ++_count;
    NSTimeInterval delta = link.timestamp - _lastTime;
    if (delta < 1) return;
    _lastTime = link.timestamp;
    float fps = _count / delta;
    _count = 0;
    
    CGFloat progress = fps / 60.0;
    UIColor *color = [UIColor colorWithHue:0.27 * (progress - 0.2) saturation:1 brightness:0.9 alpha:1];

    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d FPS", (int)round(fps)]];
    [text addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, text.length - 3)];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(text.length - 3, 3)];
    self.attributedText = text;
}

__attribute__((constructor)) static void LBYFPSLabelConstructor(void) {
#ifdef DEBUG
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if (keyWindow) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            LBYFPSLabel *label = [[LBYFPSLabel alloc] init];
            [keyWindow addSubview:label];
        });
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            LBYFPSLabelConstructor();
        });
    }
#endif
}

@end
