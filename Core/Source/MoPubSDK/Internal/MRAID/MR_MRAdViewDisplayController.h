//
//  MRAdViewDisplayController.h
//  MoPub
//
//  Created by Andrew He on 12/22/11.
//  Copyright (c) 2011 MoPub, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MR_MRAdView.h"

@class MR_MRAdView, MP_MPTimer, MP_MPTimerTarget, MR_MRDimmingView;

@interface MR_MRAdViewDisplayController : NSObject <MRAdViewDelegate> {
    MR_MRAdView *_view;
    MR_MRAdView *_expansionContentView;
    MR_MRAdView *_twoPartExpansionView;

    // Timer to periodically update the value of _isViewable.
    MP_MPTimer *_viewabilityTimer;
    MP_MPTimerTarget *_viewabilityTimerTarget;

    MR_MRDimmingView *_dimmingView;

    BOOL _allowsExpansion;
    MRAdViewCloseButtonStyle _closeButtonStyle;
    MRAdViewState _currentState;

    // Indicates whether any part of the ad is visible on-screen.
    BOOL _isViewable;

    // Variables for resizable ads.
    CGSize _maxSize;

    // Variables for expandable ads.
    CGRect _defaultFrame;
    CGRect _defaultFrameInKeyWindow;
    CGRect _expandedFrame;
    NSInteger _originalTag;
    NSInteger _parentTag;
    CGAffineTransform _originalTransform;
}

@property (nonatomic, assign) MR_MRAdView *view;
@property (nonatomic, readonly) MRAdViewState currentState;

- (id)initWithAdView:(MR_MRAdView *)adView
     allowsExpansion:(BOOL)allowsExpansion
    closeButtonStyle:(MRAdViewCloseButtonStyle)closeButtonStyle;
- (void)initializeJavascriptState;
- (void)rotateToOrientation:(UIInterfaceOrientation)newOrientation;
- (void)revertViewToDefaultState;
- (void)close;
- (void)expandToFrame:(CGRect)frame withURL:(NSURL *)url 
       useCustomClose:(BOOL)shouldUseCustomClose isModal:(BOOL)isModal 
shouldLockOrientation:(BOOL)shouldLockOrientation;
- (void)expandToFrame:(CGRect)frame withURL:(NSURL *)url blockingColor:(UIColor *)blockingColor
      blockingOpacity:(CGFloat)blockingOpacity shouldLockOrientation:(BOOL)shouldLockOrientation;
- (void)useCustomClose:(BOOL)shouldUseCustomClose;
- (void)additionalModalViewWillPresent;
- (void)additionalModalViewDidDismiss;

@end
