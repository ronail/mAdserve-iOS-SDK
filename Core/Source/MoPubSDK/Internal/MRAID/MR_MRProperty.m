//
//  MRProperty.m
//  MoPub
//
//  Created by Andrew He on 12/13/11.
//  Copyright (c) 2011 MoPub, Inc. All rights reserved.
//

#import "MR_MRProperty.h"

@implementation MR_MRProperty

- (NSString *)description {
    return @"";
}

- (NSString *)jsonString {
    return @"{}";
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation MR_MRPlacementTypeProperty : MR_MRProperty

@synthesize placementType = _placementType;

+ (MR_MRPlacementTypeProperty *)propertyWithType:(MRAdViewPlacementType)type {
    MR_MRPlacementTypeProperty *property = [[[self alloc] init] autorelease];
    property.placementType = type;
    return property;
}

- (NSString *)description {
    NSString *placementTypeString = @"unknown";
    switch (_placementType) {
        case MRAdViewPlacementTypeInline: placementTypeString = @"inline"; break;
        case MRAdViewPlacementTypeInterstitial: placementTypeString = @"interstitial"; break;
        default: break;
    }

    return [NSString stringWithFormat:@"placementType: '%@'", placementTypeString]; 
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation MR_MRStateProperty

@synthesize state = _state;

+ (MR_MRStateProperty *)propertyWithState:(MRAdViewState)state {
    MR_MRStateProperty *property = [[[self alloc] init] autorelease];
    property.state = state;
    return property;
}

- (NSString *)description {
    NSString *stateString;
    switch (_state) {
        case MRAdViewStateHidden:      stateString = @"hidden"; break;
        case MRAdViewStateDefault:     stateString = @"default"; break;
        case MRAdViewStateExpanded:    stateString = @"expanded"; break;
        default:                       stateString = @"loading"; break;
    }
    return [NSString stringWithFormat:@"state: '%@'", stateString];
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation MR_MRScreenSizeProperty : MR_MRProperty

@synthesize screenSize = _screenSize;

+ (MR_MRScreenSizeProperty *)propertyWithSize:(CGSize)size {
    MR_MRScreenSizeProperty *property = [[[self alloc] init] autorelease];
    property.screenSize = size;
    return property;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"screenSize: {width: %f, height: %f}", 
            _screenSize.width, 
            _screenSize.height];
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation MR_MRViewableProperty : MR_MRProperty

@synthesize isViewable = _isViewable;

+ (MR_MRViewableProperty *)propertyWithViewable:(BOOL)viewable {
    MR_MRViewableProperty *property = [[[self alloc] init] autorelease];
    property.isViewable = viewable;
    return property;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"viewable: '%@'", _isViewable ? @"true" : @"false"];
}

@end
