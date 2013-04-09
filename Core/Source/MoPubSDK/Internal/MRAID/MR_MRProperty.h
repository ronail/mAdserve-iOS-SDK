//
//  MRProperty.h
//  MoPub
//
//  Created by Andrew He on 12/13/11.
//  Copyright (c) 2011 MoPub, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MR_MRAdView.h"

@interface MR_MRProperty : NSObject

- (NSString *)description;
- (NSString *)jsonString;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface MR_MRPlacementTypeProperty : MR_MRProperty {
    MRAdViewPlacementType _placementType;
}

@property (nonatomic, assign) MRAdViewPlacementType placementType;

+ (MR_MRPlacementTypeProperty *)propertyWithType:(MRAdViewPlacementType)type;

@end
////////////////////////////////////////////////////////////////////////////////////////////////////

@interface MR_MRStateProperty : MR_MRProperty {
    MRAdViewState _state;
}

@property (nonatomic, assign) MRAdViewState state;

+ (MR_MRStateProperty *)propertyWithState:(MRAdViewState)state;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface MR_MRScreenSizeProperty : MR_MRProperty {
    CGSize _screenSize;
}

@property (nonatomic, assign) CGSize screenSize;

+ (MR_MRScreenSizeProperty *)propertyWithSize:(CGSize)size;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface MR_MRViewableProperty : MR_MRProperty {
    BOOL _isViewable;
}

@property (nonatomic, assign) BOOL isViewable;

+ (MR_MRViewableProperty *)propertyWithViewable:(BOOL)viewable;

@end
