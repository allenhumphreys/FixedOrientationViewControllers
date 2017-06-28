//
//  SCNavigationController.m
//  FixedOrientationObjC
//
//  Created by Allen Humphreys on 6/28/17.
//  Copyright © 2017 Allen Humphreys. All rights reserved.
//

#import "SCNavigationController.h"

@implementation SCNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    __weak typeof(self) weakSelf = self;
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {

        typeof(self) strongSelf = weakSelf;
        UIDeviceOrientation orientation = UIDevice.currentDevice.orientation;

        switch (orientation) {
            case UIDeviceOrientationLandscapeRight: {
                NSArray<UITraitCollection *> *traits = @[strongSelf.traitCollection,
                                                         [UITraitCollection traitCollectionWithVerticalSizeClass:UIUserInterfaceSizeClassCompact],
                                                         [UITraitCollection traitCollectionWithHorizontalSizeClass:UIUserInterfaceSizeClassRegular]];
                UITraitCollection *traitCollection = [UITraitCollection traitCollectionWithTraitsFromCollections:traits];
                [strongSelf setOverrideTraitCollection:traitCollection forChildViewController:strongSelf.viewControllers[0]];
                break;
            }
            default:
                [strongSelf setOverrideTraitCollection:strongSelf.traitCollection forChildViewController:strongSelf.viewControllers[0]];
        }
    } completion:nil];
}

@end
