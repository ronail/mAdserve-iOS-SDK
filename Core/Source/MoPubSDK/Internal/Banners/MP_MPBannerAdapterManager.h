//
//  MPBannerAdapterManager.h
//  MoPub
//
//  Copyright (c) 2012 MoPub. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MP_MPAdConfiguration.h"
#import "MPBannerAdapterManagerDelegate.h"
#import "MP_MPBaseAdapter.h"

@interface MP_MPBannerAdapterManager : NSObject <MPAdapterDelegate>
{
    id<MPBannerAdapterManagerDelegate> _delegate;
    MP_MPBaseAdapter *_requestingAdapter;
    MP_MPBaseAdapter *_currentOnscreenAdapter;
}

@property (nonatomic, assign) id<MPBannerAdapterManagerDelegate> delegate;
@property (nonatomic, readonly, retain) MP_MPBaseAdapter *requestingAdapter;
@property (nonatomic, readonly, retain) MP_MPBaseAdapter *currentOnscreenAdapter;

- (id)initWithDelegate:(id<MPBannerAdapterManagerDelegate>)delegate;
- (void)loadAdapterForConfig:(MP_MPAdConfiguration *)config;
- (void)requestedAdDidBecomeVisible;

- (void)rotateToOrientation:(UIInterfaceOrientation)orientation;

- (void)customEventDidLoadAd;
- (void)customEventDidFailToLoadAd;
- (void)customEventActionWillBegin;
- (void)customEventActionDidEnd;

@end
