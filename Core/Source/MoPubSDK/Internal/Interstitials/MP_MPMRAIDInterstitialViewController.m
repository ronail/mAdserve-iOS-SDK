//
//  MPMRAIDInterstitialViewController.m
//  MoPub
//
//  Copyright (c) 2012 MoPub, Inc. All rights reserved.
//

#import "MP_MPMRAIDInterstitialViewController.h"

#import "MP_MPAdConfiguration.h"

@interface MP_MPMRAIDInterstitialViewController ()

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation MP_MPMRAIDInterstitialViewController

@synthesize delegate = _delegate;

- (id)initWithAdConfiguration:(MP_MPAdConfiguration *)configuration
{
    self = [super init];
    if (self) {
        CGFloat width = MAX(configuration.preferredSize.width, 1);
        CGFloat height = MAX(configuration.preferredSize.height, 1);
        CGRect frame = CGRectMake(0, 0, width, height);
        _interstitialView = [[MR_MRAdView alloc] initWithFrame:frame
                                            allowsExpansion:NO
                                           closeButtonStyle:MRAdViewCloseButtonStyleAdControlled
                                              placementType:MRAdViewPlacementTypeInterstitial];
        _interstitialView.delegate = self;
        _configuration = [configuration retain];
        _orientationType = [_configuration orientationType];
        _advertisementHasCustomCloseButton = NO;
    }
    return self;
}

- (void)dealloc
{
    _interstitialView.delegate = nil;
    [_interstitialView release];
    [_configuration release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _interstitialView.frame = self.view.bounds;
    _interstitialView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_interstitialView];
}

#pragma mark - Public

- (void)startLoading
{
    [_interstitialView loadCreativeWithHTMLString:[_configuration adResponseHTMLString]
                                          baseURL:nil];
}

- (BOOL)shouldDisplayCloseButton
{
    return !_advertisementHasCustomCloseButton;
}

- (void)willPresentInterstitial
{
    if ([self.delegate respondsToSelector:@selector(interstitialWillAppear:)]) {
        [self.delegate interstitialWillAppear:self];
    }
}

- (void)didPresentInterstitial
{
    if ([self.delegate respondsToSelector:@selector(interstitialDidAppear:)]) {
        [self.delegate interstitialDidAppear:self];
    }
}

- (void)willDismissInterstitial
{
    if ([self.delegate respondsToSelector:@selector(interstitialWillDisappear:)]) {
        [self.delegate interstitialWillDisappear:self];
    }
}

- (void)didDismissInterstitial
{
    if ([self.delegate respondsToSelector:@selector(interstitialDidDisappear:)]) {
        [self.delegate interstitialDidDisappear:self];
    }
}

#pragma mark - MRAdViewDelegate

- (UIViewController *)viewControllerForPresentingModalView
{
    return self;
}

- (void)adDidLoad:(MR_MRAdView *)adView
{
    if ([self.delegate respondsToSelector:@selector(interstitialDidLoadAd:)]) {
        [self.delegate interstitialDidLoadAd:self];
    }
}

- (void)adDidFailToLoad:(MR_MRAdView *)adView
{
    if ([self.delegate respondsToSelector:@selector(interstitialDidFailToLoadAd:)]) {
        [self.delegate interstitialDidFailToLoadAd:self];
    }
}

- (void)adWillClose:(MR_MRAdView *)adView
{
    [self dismissInterstitialAnimated:YES];
}

- (void)adDidClose:(MR_MRAdView *)adView
{
    // TODO:
}

- (void)ad:(MR_MRAdView *)adView didRequestCustomCloseEnabled:(BOOL)enabled
{
    _advertisementHasCustomCloseButton = enabled;
    [self layoutCloseButton];
}

#pragma mark - Low-Memory Conditions

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
