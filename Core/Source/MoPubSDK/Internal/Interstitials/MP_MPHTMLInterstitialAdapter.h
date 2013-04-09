//
//  MPHTMLInterstitialAdapter.h
//  MoPub
//
//  Copyright (c) 2012 MoPub, Inc. All rights reserved.
//

#import "MP_MPBaseInterstitialAdapter.h"

#import "MP_MPHTMLInterstitialViewController.h"

@interface MP_MPHTMLInterstitialAdapter : MP_MPBaseInterstitialAdapter
    <MPHTMLInterstitialViewControllerDelegate>
{
    MP_MPHTMLInterstitialViewController *_interstitial;
}

@end
