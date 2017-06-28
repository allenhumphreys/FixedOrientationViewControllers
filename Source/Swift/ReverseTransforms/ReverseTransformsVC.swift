//
//  ReverseTransformsVC.swift
//  FixedOrientationSwift
//
//  Created by Allen Humphreys on 10/29/16.
//  Copyright © 2016 Allen, Inc. All rights reserved.
//

// Adapted from https://developer.apple.com/library/content/qa/qa1890/_index.html

import UIKit

class ReverseTransformVC: CameraViewController {

    override class var needsPreviewRotations: Bool {
        return false
    }

    @IBOutlet var viewsToBeRotated: [UIView]!

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        let newIsLandscape = size.width > size.height
        let previousBounds = self.view.bounds;
        coordinator.animate(alongsideTransition: { (context) in
            
            // Switch the height and width when change from a portrait to a landscape orientation or vice versa
            var newBounds = previousBounds;
            let oldIsLandscape = previousBounds.size.width > previousBounds.size.height;

            if (newIsLandscape != oldIsLandscape) {
                newBounds.size = CGSize.init(width: size.height, height: size.width)
            }
            self.view.bounds = newBounds;

            // Apply an oposing transoform to the view to keep it in place
            let deltaTransform = coordinator.targetTransform
            let deltaAngle = atan2f(Float(deltaTransform.b), Float(deltaTransform.a))
            var currentRotation: Float? = self.view.layer.value(forKeyPath: "transform.rotation.z") as? Float

            if currentRotation != nil {
                currentRotation = currentRotation! + -1 * deltaAngle + 0.0001;
                self.view.layer.setValue(NSNumber.init(value: currentRotation!), forKeyPath: "transform.rotation.z")
            }

            // Explicity apply transforms to subviews that we'd like to see rotate
            let orientation = UIApplication.shared.statusBarOrientation
            var transform = CGAffineTransform.identity

            switch orientation {
            case .landscapeLeft:
                transform = CGAffineTransform.init(rotationAngle: CGFloat(-.halfpi))
            case .landscapeRight:
                transform = CGAffineTransform.init(rotationAngle: CGFloat(.halfpi))
            default:
                break
            }
            for view in self.viewsToBeRotated {
                view.transform = transform
            }
        }, completion: { context in
            var currentTransform = self.view.transform;
            currentTransform.a = round(currentTransform.a)
            currentTransform.b = round(currentTransform.b)
            currentTransform.c = round(currentTransform.c)
            currentTransform.d = round(currentTransform.d)
            self.view.transform = currentTransform
        })
    }

    override public var prefersStatusBarHidden: Bool {
        return true
    }
}
