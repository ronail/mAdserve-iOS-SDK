//
//  MPBannerCustomEventAdapter.h
//  MoPub
//
//  Copyright (c) 2012 MoPub, Inc. All rights reserved.
//

#import "MP_MPBaseAdapter.h"

#import "MPBannerCustomEventDelegate.h"

@class MP_MPBannerCustomEvent;

@interface MP_MPBannerCustomEventAdapter : MP_MPBaseAdapter <MPBannerCustomEventDelegate>
{
    MP_MPBannerCustomEvent *_bannerCustomEvent;
}

@end
