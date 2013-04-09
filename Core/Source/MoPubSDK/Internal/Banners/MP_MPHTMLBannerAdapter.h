//
//  MPHTMLBannerAdapter.h
//  MoPub
//
//  Copyright (c) 2012 MoPub, Inc. All rights reserved.
//

#import "MP_MPBaseAdapter.h"

#import "MP_MPAdWebView.h"

@interface MP_MPHTMLBannerAdapter : MP_MPBaseAdapter <MPAdWebViewDelegate>
{
    MP_MPAdWebView *_banner;
}

@end
