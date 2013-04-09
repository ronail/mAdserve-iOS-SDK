//
//  MPInterstitialCustomEventAdapter.h
//  MoPub
//
//  Copyright (c) 2012 MoPub, Inc. All rights reserved.
//

#import "MP_MPBaseInterstitialAdapter.h"

#import "MP_MPInterstitialCustomEvent.h"
#import "MPInterstitialCustomEventDelegate.h"

@interface MP_MPInterstitialCustomEventAdapter : MP_MPBaseInterstitialAdapter
    <MPInterstitialCustomEventDelegate>
{
    MP_MPInterstitialCustomEvent *_interstitialCustomEvent;
}

@end
