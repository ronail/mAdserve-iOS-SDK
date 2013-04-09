//
//  MRAdViewBrowsingController.m
//  MoPub
//
//  Created by Andrew He on 12/22/11.
//  Copyright (c) 2011 MoPub, Inc. All rights reserved.
//

#import "MR_MRAdViewBrowsingController.h"
#import "MR_MRAdView.h"
#import "MRAdView+Controllers.h"

@implementation MR_MRAdViewBrowsingController
@synthesize viewControllerForPresentingModalView = _viewControllerForPresentingModalView;

- (id)initWithAdView:(MR_MRAdView *)adView {
    self = [super init];
    if (self) {
        _view = adView;
    }
    return self;
}

- (void)openBrowserWithUrlString:(NSString *)urlString enableBack:(BOOL)back
                   enableForward:(BOOL)forward enableRefresh:(BOOL)refresh {
    NSURL *url = [NSURL URLWithString:urlString];
    MP_MPAdBrowserController *controller = [[MP_MPAdBrowserController alloc] initWithURL:url 
                                                                          delegate:self];

    [_view adWillPresentModalView];
    [self.viewControllerForPresentingModalView presentModalViewController:controller animated:YES];
    [controller startLoading];
    [controller release];
}

#pragma mark -
#pragma mark MPAdBrowserControllerDelegate

- (void)dismissBrowserController:(MP_MPAdBrowserController *)browserController {
    [self dismissBrowserController:browserController animated:YES];
}

- (void)dismissBrowserController:(MP_MPAdBrowserController *)browserController 
                        animated:(BOOL)animated {
    [self.viewControllerForPresentingModalView dismissModalViewControllerAnimated:animated];
    //[_view adWillShow];
    [_view adDidDismissModalView];
    //[_view adDidShow];
}

@end
