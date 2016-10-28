//
//  ViewController.m
//  RotationTester
//
//  Created by Allen Humphreys on 9/6/16.
//  Copyright © 2016 360fly, Inc. All rights reserved.
//

#import "ViewController.h"
#import "OnMyCameraVC.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *viewsThatNeedRotated;
@property (strong, nonatomic) IBOutlet UIView *mainMenu;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *mainMenuConstraintToAnimateIn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationNone;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    //Disabling animations here make it look like things don't move, but they do
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        CGAffineTransform preRotationTransform = CGAffineTransformIdentity;
        CGAffineTransform targetTransform = [context targetTransform];
        float angle = atan2(targetTransform.b, targetTransform.a);
        // negative angle indicates rotating right

        preRotationTransform = CGAffineTransformRotate(targetTransform, -angle*2);

        for (UIView *view in self.viewsThatNeedRotated) {
            view.transform = preRotationTransform;
        }

        for (NSLayoutConstraint *constraint in self.mainMenuConstraintToAnimateIn) {
            constraint.constant = -20;
        }
//        [self.view layoutIfNeeded];// Convince the autolayout system to change as we "rotate"
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [CATransaction commit]; // Reenable animations


        // Animate views, such as buttons, to their final orientation
        [UIView animateWithDuration:0.5f animations:^{

            //Remove rotation applied in the animation block
            for (UIView *view in self.viewsThatNeedRotated) {
                view.transform = CGAffineTransformIdentity;
            }

//            for (NSLayoutConstraint *constraint in self.mainMenuConstraintToAnimateIn) {
//                constraint.constant = -20;
//            }
            [self.view layoutIfNeeded];// Convince the autolayout system to change as we "rotate"
        }];
        NSLog(@"Completion Block 2");
    }];

//    NSLog(@"transitioning to size %f x %f", size.width, size.height);
}
- (IBAction)SideBarBackTapped:(id)sender {
    [self exit];
}

- (IBAction)backTapped:(UIBarButtonItem *)sender {
    [self exit];
}

- (void)exit {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
