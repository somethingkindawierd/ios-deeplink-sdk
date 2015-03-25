//
//  NSArray+DPLTargetViewController.m
//  Pods
//
//  Created by Jon Beebe on 3/24/15.
//
//

#import "NSArray+DPLTargetViewController.h"

@class DPLDeepLink;

@implementation NSArray (DPLTargetViewController)

- (void)configureWithDeepLink:(DPLDeepLink *)deepLink {
	for (UIViewController <DPLTargetViewController> *vc in self) {
		if ([vc respondsToSelector:@selector(configureWithDeepLink:)]) {
			[vc configureWithDeepLink:deepLink];
		}
	}
}

@end
