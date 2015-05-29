//
//  CJWebView.m
//  CJWebView
//
//  Created by cjfire on 15/5/29.
//  Copyright (c) 2015年 Gozap. All rights reserved.
//

#import "CJWebView.h"

@interface CJWebView() <UIGestureRecognizerDelegate>

@end

@implementation CJWebView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    
    return self;
}

// setup
- (void)setup {
    
    UILongPressGestureRecognizer* longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(contextualMenuAction:)];
    [self addGestureRecognizer:longPressGesture];
    longPressGesture.delegate = self;
    longPressGesture.minimumPressDuration = 0.4;
}

- (void)contextualMenuAction:(UILongPressGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        CGPoint pt = [gesture locationInView:self];
        
        // convert point from view to HTML coordinate system
        CGPoint offset  = [self scrollOffset];
        CGSize viewSize = [self frame].size;
        CGSize windowSize = [self windowSize];
        
        CGFloat f = windowSize.width / viewSize.width;
        pt.x = pt.x * f + offset.x;
        pt.y = pt.y * f + offset.y;
        
        // Load the JavaScript code from the Resources and inject it into the web page
        NSString *path = [[NSBundle mainBundle] pathForResource:@"JSTools" ofType:@"js"];
        NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        [self stringByEvaluatingJavaScriptFromString: jsCode];
        
        // get the Tags at the touch location
        NSString *imagePath = [self stringByEvaluatingJavaScriptFromString:
                               [NSString stringWithFormat:@"GetHTMLEleAtPoint(%li,%li);",(long)pt.x,(long)pt.y]];
        
        if ([_dataSource respondsToSelector:@selector(webView:catchImagePath:)]) {
            [_dataSource webView:self catchImagePath:imagePath];
        }
    }
}

#pragma mark - private function
- (CGSize)windowSize
{
    CGSize size;
    size.width = [[self stringByEvaluatingJavaScriptFromString:@"window.innerWidth"] integerValue];
    size.height = [[self stringByEvaluatingJavaScriptFromString:@"window.innerHeight"] integerValue];
    return size;
}

- (CGPoint)scrollOffset
{
    CGPoint pt;
    pt.x = [[self stringByEvaluatingJavaScriptFromString:@"window.pageXOffset"] integerValue];
    pt.y = [[self stringByEvaluatingJavaScriptFromString:@"window.pageYOffset"] integerValue];
    return pt;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return NO;
}

@end
