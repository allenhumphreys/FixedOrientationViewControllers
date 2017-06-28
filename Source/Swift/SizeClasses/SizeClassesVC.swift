//
//  ViewController.swift
//  SizeClassesRotationTester
//
//  Created by Allen Humphreys on 10/28/16.
//  Copyright © 2016 Allen, Inc. All rights reserved.
//

import UIKit

class SizeClassesVC: CameraViewController {

    @IBOutlet var viewsToBeRotated: [UIView]!

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        CATransaction.begin()
        CATransaction.setDisableActions(true)

        coordinator.animate(alongsideTransition: { (context) in
            var preRotationTransform = CGAffineTransform.identity
            let targetTransform = context.targetTransform
            let angle = atan2(targetTransform.b, targetTransform.a)

            preRotationTransform = targetTransform.rotated(by: -angle*2)
            for view in self.viewsToBeRotated {
                view.transform = preRotationTransform
            }

        }, completion: { context in
            CATransaction.commit() // Reenable animations

            UIView.animate(withDuration: UIApplication.shared.statusBarOrientationAnimationDuration, animations: {
                for view in self.viewsToBeRotated {
                    view.transform = .identity
                }

                self.view.layoutIfNeeded()
            })
        })
    }

    override public var prefersStatusBarHidden: Bool {
        return true
    }
}
