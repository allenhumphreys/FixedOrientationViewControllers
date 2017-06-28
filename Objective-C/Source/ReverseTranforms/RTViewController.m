//
//  ViewController.m
//  FixedOrientationObjC
//
//  Created by Allen Humphreys on 6/28/17.
//  Copyright © 2017 Allen Humphreys. All rights reserved.
//

#import "RTViewController.h"

@interface RTViewController ()

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *viewsToBeRotated;

@end

@implementation RTViewController

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    bool newIsLandscape = size.width > size.height;
    CGRect previousBounds = self.view.bounds;

    __weak typeof(self) weakSelf = self;
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {

        typeof(self) strongSelf = weakSelf;

        // Switch the height and width when change from a portrait to a landscape orientation or vice versa
        CGRect newBounds = previousBounds;
        bool oldIsLandscape = CGRectGetWidth(previousBounds) > CGRectGetHeight(previousBounds);

        if (newIsLandscape != oldIsLandscape) {
            newBounds.size = CGSizeMake(size.height, size.width);
        }
        strongSelf.view.bounds = newBounds;

        // Apply an oposing transoform to the view to keep it in place
        CGAffineTransform deltaTransform = coordinator.targetTransform;
        float deltaAngle = atan2f(deltaTransform.b, deltaTransform.a);
        NSNumber *rotation = [strongSelf.view.layer valueForKey:@"transform.rotation.z"];
        if (rotation && [rotation isKindOfClass:[NSNumber class]]) {
            float currentRotation = rotation.floatValue;
            currentRotation = currentRotation + -1 * deltaAngle + 0.0001;
            [strongSelf.view.layer setValue:[NSNumber numberWithFloat:currentRotation] forKeyPath:@"transform.rotation.z"];
        }
        
        // Explicity apply transforms to subviews that we'd like to see rotate
        UIInterfaceOrientation orientation = UIApplication.sharedApplication.statusBarOrientation;
        CGAffineTransform transform = CGAffineTransformIdentity;

        switch (orientation) {
        case UIInterfaceOrientationLandscapeLeft:
            transform = CGAffineTransformMakeRotation(-M_PI_2);
            break;
        case UIInterfaceOrientationLandscapeRight:
            transform = CGAffineTransformMakeRotation(M_PI_2);
            break;
        default:
            break;
        }

        for (UIView *view in strongSelf.viewsToBeRotated) {
            view.transform = transform;
        }

    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {

        typeof(self) strongSelf = weakSelf;

        CGAffineTransform currentTransform = strongSelf.view.transform;
        currentTransform.a = round(currentTransform.a);
        currentTransform.b = round(currentTransform.b);
        currentTransform.c = round(currentTransform.c);
        currentTransform.d = round(currentTransform.d);
        strongSelf.view.transform = currentTransform;
    }];
}

- (BOOL)prefersStatusBarHidden {
    return true;
}

@end
