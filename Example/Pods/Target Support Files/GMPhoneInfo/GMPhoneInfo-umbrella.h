#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "GMAppInfoTool.h"
#import "UIDevice+GMAdd.h"
#import "GMPhoneInfo_Header.h"
#import "GMAppInfoTool.h"

FOUNDATION_EXPORT double GMPhoneInfoVersionNumber;
FOUNDATION_EXPORT const unsigned char GMPhoneInfoVersionString[];

