//
//  MPBaseInterstitialAdapter.m
//  MoPub
//
//  Created by Nafis Jamal on 4/27/11.
//  Copyright 2011 MoPub. All rights reserved.
//

#import "MP_MPBaseInterstitialAdapter.h"

@implementation MP_MPBaseInterstitialAdapter

@synthesize interstitialAdController = _interstitialAdController;

- (id)initWithInterstitialAdController:(MP_MPInterstitialAdController *)interstitialAdController
{
	if (self = [super init])
	{
		_interstitialAdController = interstitialAdController;
	}
	return self;
}

- (void)dealloc
{
	[self unregisterDelegate];
	[super dealloc];
}

- (void)unregisterDelegate
{
	_interstitialAdController = nil;
    _manager = nil;
}

- (void)getAd
{
	[self getAdWithParams:nil];
}

- (void)getAdWithParams:(NSDictionary *)params
{
	[self doesNotRecognizeSelector:_cmd];
}

- (void)_getAdWithParams:(NSDictionary *)params 
{
  [self retain];
  [self getAdWithParams:params];
  [self release];
}

- (void)getAdWithConfiguration:(MP_MPAdConfiguration *)configuration
{
    // To be implemented by subclasses.
    [self doesNotRecognizeSelector:_cmd];
}

- (void)_getAdWithConfiguration:(MP_MPAdConfiguration *)configuration
{
    [self retain];
    [self getAdWithConfiguration:configuration];
    [self release];
}

- (void)showInterstitialFromViewController:(UIViewController *)controller
{
	[self doesNotRecognizeSelector:_cmd];
}

@end

