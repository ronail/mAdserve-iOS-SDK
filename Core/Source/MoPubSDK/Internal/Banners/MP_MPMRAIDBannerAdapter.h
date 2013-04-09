//
//  MPMRAIDBannerAdapter.h
//  MoPub
//
//  Copyright (c) 2012 MoPub, Inc. All rights reserved.
//

#import "MP_MPBaseAdapter.h"

#import "MR_MRAdView.h"

@interface MP_MPMRAIDBannerAdapter : MP_MPBaseAdapter <MRAdViewDelegate>
{
    MR_MRAdView *_adView;
}

@property(nonatomic,retain) MR_MRAdView* _adView;

@end
