#import "DPLRouteHandler.h"

@implementation DPLRouteHandler

- (BOOL)shouldHandleDeepLink:(DPLDeepLink *)deepLink {
    return YES;
}


- (BOOL)preferModalPresentation {
    return NO;
}

- (BOOL)shouldAnimate
{
    return NO;
}

- (BOOL)rendersMultipleTargets
{
    return NO;
}

- (UIViewController <DPLTargetViewController> *)targetViewController
{
    return nil;
}

- (NSArray <DPLTargetViewController> *)targetViewControllersForDeepLink:(DPLDeepLink *)deepLink {
    return nil;
}


- (UIViewController *)viewControllerForPresentingDeepLink:(DPLDeepLink *)deepLink {
    return [UIApplication sharedApplication].keyWindow.rootViewController;
}

- (void)presentTargetViewController:(UIViewController <DPLTargetViewController> *)targetViewController
                   inViewController:(UIViewController *)presentingViewController
{
    [self presentTargetViewControllers:@[targetViewController] inViewController:presentingViewController];
}

- (void)presentTargetViewControllers:(NSArray <DPLTargetViewController> *)targetViewControllers
                   inViewController:(UIViewController *)presentingViewController {
    
    if ([self preferModalPresentation] ||
        ![presentingViewController isKindOfClass:[UINavigationController class]]) {
        
        if(targetViewControllers.count == 1) {
            [presentingViewController presentViewController:targetViewControllers.firstObject animated:NO completion:NULL];
        }
    }
    else if ([presentingViewController isKindOfClass:[UINavigationController class]]) {
        
        if(targetViewControllers.count == 1) {
            [self placeTargetViewController:targetViewControllers.firstObject
                     inNavigationController:(UINavigationController *)presentingViewController];
        }
        else if(targetViewControllers.count > 1) {
            [self placeTargetViewControllers:targetViewControllers
                      inNavigationController:(UINavigationController *)presentingViewController];
        }
    }
}


#pragma mark - Private

- (void)placeTargetViewController:(UIViewController *)targetViewController
           inNavigationController:(UINavigationController *)navigationController {
    
    if ([navigationController.viewControllers containsObject:targetViewController]) {
        [navigationController popToViewController:targetViewController animated:NO];
    }
    else {
        
        for (UIViewController *controller in navigationController.viewControllers) {
            if ([controller isMemberOfClass:[targetViewController class]]) {
                
                [navigationController popToViewController:controller animated:NO];
                [navigationController popViewControllerAnimated:NO];
                
                if ([controller isEqual:navigationController.topViewController]) {
                    [navigationController setViewControllers:@[targetViewController] animated:[self shouldAnimate]];
                }
                
                break;
            }
        }
        
        if (![navigationController.topViewController isEqual:targetViewController]) {
            [navigationController pushViewController:targetViewController animated:[self shouldAnimate]];
        }
    }
}

- (void)placeTargetViewControllers:(NSArray <DPLTargetViewController> *)targetViewControllers
           inNavigationController:(UINavigationController *)navigationController {
    
    // If a modal is currently being presented, dismiss it.
    if(navigationController.presentedViewController) {
        [navigationController dismissViewControllerAnimated:[self shouldAnimate] completion:nil];
    }
    
    // Remove all view controllers currently on the stack up to and until we find a matching view controller.
    // This ensures any sibling view controllers that appear below the desired base still remain on the stack.
    UIViewController* baseController = targetViewControllers.firstObject;
    NSMutableArray* viewControllers = [navigationController.viewControllers mutableCopy];
    NSMutableIndexSet* discardedViewControllers = [NSMutableIndexSet indexSet];
    
    // Loop from the top of the stack towards the bottom. Stop when we find a matching base class
    // or we reach the end.
    for (NSInteger i = viewControllers.count - 1; i >= 0; i--) {
        UIViewController* controller = viewControllers[i];
        [discardedViewControllers addIndex:i];
        if ([controller isMemberOfClass:[baseController class]]) {
            break;
        }
    }
    
    [viewControllers removeObjectsAtIndexes:discardedViewControllers];
    [viewControllers addObjectsFromArray:targetViewControllers];
    [navigationController setViewControllers:viewControllers animated:[self shouldAnimate]];
}

@end
