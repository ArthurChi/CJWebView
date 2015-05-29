//
//  CJWebView.h
//  CJWebView
//
//  Created by cjfire on 15/5/29.
//  Copyright (c) 2015年 Gozap. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CJWebView;
@protocol CJWebViewDataSource <NSObject>

- (void)webView:(CJWebView*)webView catchImagePath:(NSString*)imagePath;

@end

@interface CJWebView : UIWebView

@property (nonatomic, weak) id<CJWebViewDataSource> dataSource;

@end
