//
//  ViewController.m
//  FakedRotation
//
//  Created by Allen Humphreys on 6/28/17.
//  Copyright © 2017 Allen Humphreys. All rights reserved.
//

#import "FRViewController.h"

@interface FRViewController ()

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *viewsToBeRotated;

@end

@implementation FRViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [UIDevice.currentDevice beginGeneratingDeviceOrientationNotifications];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [UIDevice.currentDevice endGeneratingDeviceOrientationNotifications];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)orientationDidChange:(NSNotification *)notification {
    // Explicity apply transforms to subviews that we'd like to see rotate
    UIDeviceOrientation orientation = UIDevice.currentDevice.orientation;
    CGAffineTransform transform = CGAffineTransformIdentity;

    switch (orientation) {
        case UIDeviceOrientationLandscapeRight:
            transform = CGAffineTransformMakeRotation(-M_PI_2);
            break;
        case UIDeviceOrientationLandscapeLeft:
            transform = CGAffineTransformMakeRotation(M_PI_2);
            break;
        default:
            break;
    }

    [UIView animateWithDuration:UIApplication.sharedApplication.statusBarOrientationAnimationDuration animations:^{
        for (UIView *view in self.viewsToBeRotated) {
            view.transform = transform;
        }
    }];
}

@end
