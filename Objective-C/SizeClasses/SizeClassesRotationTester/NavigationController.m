//
//  NavigationController.m
//  RotationTester
//
//  Created by Allen Humphreys on 9/7/16.
//  Copyright © 2016 360fly, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NavigationController.h"

@interface NavigationController () <UINavigationControllerDelegate>
@property (atomic) BOOL needsStatusBarHidden;
@end

@implementation NavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (UIInterfaceOrientation)navigationControllerPreferredInterfaceOrientationForPresentation:(UINavigationController *)navigationController {
    return self.visibleViewController.preferredInterfaceOrientationForPresentation;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.visibleViewController.supportedInterfaceOrientations;
}

- (BOOL)prefersStatusBarHidden
{
    return self.needsStatusBarHidden;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];


    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        BOOL isLandscape = UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation]);
        if (isLandscape) {
            [self setNavigationBarHidden:YES];
        } else {
            [self setNavigationBarHidden:NO];
        }

        // Setting an override trait collection here fixes the issue of going from landscape left to landscape right
        // If the device is flipped 180° quickly, trait collections won't actually change on their own
        UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
        switch (orientation) {

            case UIDeviceOrientationLandscapeRight: {
                NSArray *traits = @[[super traitCollection],
                                    [UITraitCollection traitCollectionWithVerticalSizeClass:UIUserInterfaceSizeClassCompact],
                                    [UITraitCollection traitCollectionWithHorizontalSizeClass:UIUserInterfaceSizeClassRegular]];
                UITraitCollection *traitCollection = [UITraitCollection traitCollectionWithTraitsFromCollections:traits];
                [self setOverrideTraitCollection:traitCollection forChildViewController:self.viewControllers[0]];
                break;
            }
            case UIDeviceOrientationPortrait:
            case UIDeviceOrientationLandscapeLeft:
            case UIDeviceOrientationFaceUp:
            case UIDeviceOrientationFaceDown:
            case UIDeviceOrientationUnknown:
            case UIDeviceOrientationPortraitUpsideDown:
                [self setOverrideTraitCollection:[self traitCollection] forChildViewController:self.viewControllers[0]];
                break;
        }

    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        NSLog(@"Completion Block 1");
    }];

}

@end
