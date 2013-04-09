//
//  MPBannerDelegateHelper.h
//  MoPub
//
//  Copyright (c) 2012 MoPub. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MP_MPAdView.h"

@interface MP_MPBannerDelegateHelper : NSObject
{
    MP_MPAdView *_adView;
}

@property (nonatomic, readonly) MP_MPAdView *adView;
@property (nonatomic, readonly) id<MPAdViewDelegate> adViewDelegate;
@property (nonatomic, readonly) UIViewController *rootViewController;

- (id)initWithAdView:(MP_MPAdView *)adView;

@end
