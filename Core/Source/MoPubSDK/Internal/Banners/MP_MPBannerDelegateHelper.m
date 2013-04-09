//
//  MPBannerDelegateHelper.m
//  MoPub
//
//  Copyright (c) 2012 MoPub. All rights reserved.
//

#import "MP_MPBannerDelegateHelper.h"

@implementation MP_MPBannerDelegateHelper

@synthesize adView = _adView;
@synthesize adViewDelegate;
@synthesize rootViewController;

- (id)initWithAdView:(MP_MPAdView *)adView
{
    self = [super init];
    if (self) {
        _adView = adView;
    }
    return self;
}

- (void)dealloc
{
    _adView = nil;
    [super dealloc];
}

- (MP_MPAdView *)adView
{
    return _adView;
}

- (id<MPAdViewDelegate>)adViewDelegate
{
    return [_adView delegate];
}

- (UIViewController *)rootViewController
{
    return [[self adViewDelegate] viewControllerForPresentingModalView];
}

@end
