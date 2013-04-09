//
//  MPMraidInterstitialAdapter.h
//  MoPub
//
//  Created by Andrew He on 12/11/11.
//  Copyright (c) 2012 MoPub, Inc. All rights reserved.
//

#import "MP_MPBaseInterstitialAdapter.h"

#import "MP_MPMRAIDInterstitialViewController.h"

@interface MP_MPMRAIDInterstitialAdapter : MP_MPBaseInterstitialAdapter
    <MPMRAIDInterstitialViewControllerDelegate>
{
    MP_MPMRAIDInterstitialViewController *_interstitial;
}

@end
