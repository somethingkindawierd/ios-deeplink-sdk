//
//  DPLProductDeepRouteHandler.m
//  DeepLinkSDK
//
//  Created by Jon Beebe on 3/25/15.
//  Copyright (c) 2015 Button, Inc. All rights reserved.
//

#import "DPLProductDeepRouteHandler.h"
#import "DPLProductDetailViewController.h"

@implementation DPLProductDeepRouteHandler

- (BOOL)shouldAnimate {
	return YES;
}

- (BOOL)rendersMultipleTargets {
	return YES;
}

- (NSArray <DPLTargetViewController> *)targetViewControllersForDeepLink:(DPLDeepLink *)deepLink {
	UIStoryboard *storyboard = [UIApplication sharedApplication].keyWindow.rootViewController.storyboard;

	return @[
	    [storyboard instantiateViewControllerWithIdentifier:@"shop"],
	    [storyboard instantiateViewControllerWithIdentifier:@"beers"],
	    [storyboard instantiateViewControllerWithIdentifier:@"detail"]
	];
}

@end
