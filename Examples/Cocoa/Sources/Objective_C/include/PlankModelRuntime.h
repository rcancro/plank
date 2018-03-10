//
// PlankModelRuntime.h
// Autogenerated by plank
//
// DO NOT EDIT - EDITS WILL BE OVERWRITTEN
// @generated
//

#import <Foundation/Foundation.h>

#if __has_attribute(noescape)
   #define PLANK_NOESCAPE __attribute__((noescape))
#else
   #define PLANK_NOESCAPE
#endif

typedef NS_OPTIONS(NSUInteger, PlankModelInitType) {
    PlankModelInitTypeDefault = 1 << 0,
    PlankModelInitTypeFromMerge = 1 << 1,
    PlankModelInitTypeFromSubmerge = 1 << 2
};

NS_ASSUME_NONNULL_BEGIN

static NSString *const kPlankDateValueTransformerKey = @"kPlankDateValueTransformerKey";

static NSString *const kPlankDidInitializeNotification = @"kPlankDidInitializeNotification";

static NSString *const kPlankInitTypeKey = @"kPlankInitTypeKey";

id _Nullable valueOrNil(NSDictionary *dict, NSString *key);

NSString *debugDescriptionForFields(NSArray *descriptionFields);

NSUInteger PINIntegerArrayHash(const NSUInteger *subhashes, NSUInteger count);

NS_ASSUME_NONNULL_END
