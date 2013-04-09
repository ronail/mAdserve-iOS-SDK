//
//  MRCommand.h
//  MoPub
//
//  Created by Andrew He on 12/19/11.
//  Copyright (c) 2011 MoPub, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MR_MRAdView.h"

@interface MR_MRAdView (MRCommand)

@property (nonatomic, retain, readonly) MR_MRAdViewBrowsingController *browsingController;
@property (nonatomic, retain, readonly) MR_MRAdViewDisplayController *displayController;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface MR_MRCommand : NSObject {
    MR_MRAdView *_view;
    NSDictionary *_parameters;
}

@property (nonatomic, assign) MR_MRAdView *view;
@property (nonatomic, retain) NSDictionary *parameters;

+ (NSMutableDictionary *)sharedCommandClassMap;
+ (void)registerCommand:(Class)commandClass;
+ (NSString *)commandType;
+ (id)commandForString:(NSString *)string;

- (BOOL)execute;

- (CGFloat)floatFromParametersForKey:(NSString *)key;
- (CGFloat)floatFromParametersForKey:(NSString *)key withDefault:(CGFloat)defaultValue;
- (BOOL)boolFromParametersForKey:(NSString *)key;
- (int)intFromParametersForKey:(NSString *)key;
- (NSString *)stringFromParametersForKey:(NSString *)key;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface MR_MRCloseCommand : MR_MRCommand
@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface MR_MRExpandCommand : MR_MRCommand
@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface MR_MRUseCustomCloseCommand : MR_MRCommand
@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface MR_MROpenCommand : MR_MRCommand
@end
