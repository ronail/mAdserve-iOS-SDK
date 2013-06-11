//
//  MRAdViewBrowsingController.h
//  MoPub
//
//  Created by Andrew He on 12/22/11.
//  Copyright (c) 2011 MoPub, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MP_MPAdBrowserController.h"

@class MR_MRAdView;

@interface MR_MRAdViewBrowsingController : NSObject <MPAdBrowserControllerDelegate> {
    MR_MRAdView *_view;
    UIViewController *__weak _viewControllerForPresentingModalView;
}

@property (nonatomic, weak) UIViewController *viewControllerForPresentingModalView;

- (id)initWithAdView:(MR_MRAdView *)adView;
- (void)openBrowserWithUrlString:(NSString *)urlString enableBack:(BOOL)back
                   enableForward:(BOOL)forward enableRefresh:(BOOL)refresh;

@end
