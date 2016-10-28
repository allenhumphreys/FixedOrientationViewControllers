//
//  ViewController.m
//  RotationTester
//
//  Created by Allen Humphreys on 9/6/16.
//  Copyright © 2016 360fly, Inc. All rights reserved.
//

#import "TabBarController.h"

//@interface FLYModalAnimationController : NSObject<UIViewControllerAnimatedTransitioning>
//@property (nonatomic) BOOL presenting;
//@end

@interface TabBarController () <UITabBarControllerDelegate>
@property UINavigationController *dummyVC;
@end

@implementation TabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.delegate = self;

    self.tabBar.barStyle = UIBarStyleBlack;

    self.dummyVC = [[UINavigationController alloc] initWithRootViewController:[[UIViewController alloc] init]];
    [self addChildViewController:self.dummyVC];

    UITabBarItem *barItem = [[UITabBarItem alloc] initWithTitle:@"rotation" image:nil selectedImage:nil];
    [self.dummyVC setTabBarItem:barItem];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (UIInterfaceOrientationMask)tabBarControllerSupportedInterfaceOrientations:(UITabBarController *)tabBarController
{
    UITraitCollection *traits = self.traitCollection;
    if (traits.userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskPortrait;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if (viewController == self.dummyVC) {
        UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController *cameraNavigationController = [mainSB instantiateViewControllerWithIdentifier:@"rotationNavigationController"];
        [self presentViewController:cameraNavigationController animated:YES completion:nil];

        return NO;
    }

    return YES;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationNone;
}

@end

