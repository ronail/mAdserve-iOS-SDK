//
//  MPAdapterMap.m
//  MoPub
//
//  Created by Andrew He on 1/26/11.
//  Copyright 2011 MoPub, Inc. All rights reserved.
//

#import "MP_MPAdapterMap.h"

@interface MP_MPAdapterMap ()

@property (nonatomic, retain) NSDictionary *bannerAdapterMap;
@property (nonatomic, retain) NSDictionary *interstitialAdapterMap;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation MP_MPAdapterMap

@synthesize bannerAdapterMap;
@synthesize interstitialAdapterMap;

+ (id)sharedAdapterMap
{
    static MP_MPAdapterMap *sharedAdapterMap = nil;
	@synchronized(self)
	{
		if (sharedAdapterMap == nil)
			sharedAdapterMap = [[self alloc] init];
	}
	return sharedAdapterMap;
}

- (id)init
{
	if (self = [super init])
	{
        bannerAdapterMap = [[NSDictionary dictionaryWithObjectsAndKeys:
                             @"MP_MPHTMLBannerAdapter",        @"html",
                             @"MP_MPMRAIDBannerAdapter",       @"mraid",
                             @"MP_MPIAdAdapter",               @"iAd",
                             @"MP_MPGoogleAdSenseAdapter",     @"adsense",
                             @"MP_MPGoogleAdMobAdapter",       @"admob_native",
                             @"MP_MPMillennialAdapter",        @"millennial_native",
                             @"MP_MPBannerCustomEventAdapter", @"custom",
                             nil] retain];

        interstitialAdapterMap = [[NSDictionary dictionaryWithObjectsAndKeys:
                                   @"MP_MPHTMLInterstitialAdapter",        @"html",
                                   @"MP_MPMRAIDInterstitialAdapter",       @"mraid",
                                   @"MP_MPIAdInterstitialAdapter",         @"iAd_full",
                                   @"MP_MPGoogleAdMobInterstitialAdapter", @"admob_full",
                                   @"MP_MPMillennialInterstitialAdapter",  @"millennial_full",
                                   @"MP_MPInterstitialCustomEventAdapter", @"custom",
                                   nil] retain];
	}
	return self;
}

- (void)dealloc
{
    self.bannerAdapterMap = nil;
	self.interstitialAdapterMap = nil;
	[super dealloc];
}

- (Class)bannerAdapterClassForNetworkType:(NSString *)networkType
{
    return NSClassFromString([self.bannerAdapterMap objectForKey:networkType]);
}

- (Class)interstitialAdapterClassForNetworkType:(NSString *)networkType
{
    return NSClassFromString([self.interstitialAdapterMap objectForKey:networkType]);
}

@end
