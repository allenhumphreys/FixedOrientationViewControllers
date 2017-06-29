//
//  ViewController.m
//  SizeClasses
//
//  Created by Allen Humphreys on 6/28/17.
//  Copyright © 2017 Allen Humphreys. All rights reserved.
//

#import "SCViewController.h"

@interface SCViewController ()

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *viewsToBeRotated;

@end

@implementation SCViewController

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    [CATransaction begin];
    [CATransaction setDisableActions:YES];

    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        CGAffineTransform preRotationTransform = CGAffineTransformIdentity;
        CGAffineTransform targetTransform = context.targetTransform;
        float angle = atan2(targetTransform.b, targetTransform.a);

        preRotationTransform = CGAffineTransformRotate(targetTransform, -angle*2);
        for (UIView *view in self.viewsToBeRotated) {
            view.transform = preRotationTransform;
        }
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [CATransaction commit]; // Reenable animations

        [UIView animateWithDuration:UIApplication.sharedApplication.statusBarOrientationAnimationDuration animations:^{
            for (UIView *view in self.viewsToBeRotated) {
                view.transform = CGAffineTransformIdentity;
            }

            [self.view layoutIfNeeded];
        }];
    }];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
