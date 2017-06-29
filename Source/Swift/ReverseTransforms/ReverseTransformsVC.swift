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
        let previousBounds = self.view.bounds
        coordinator.animate(alongsideTransition: { [weak self] (context) in
            guard let strongSelf = self, let view = strongSelf.view else {
                return
            }
            
            // Switch the height and width when change from a portrait to a landscape orientation or vice versa
            var newBounds = previousBounds
            let oldIsLandscape = previousBounds.size.width > previousBounds.size.height

            if newIsLandscape != oldIsLandscape {
                newBounds.size = CGSize(width: size.height, height: size.width)
            }

            view.bounds = newBounds

            // Apply an oposing transoform to the view to keep it in place
            let deltaTransform = coordinator.targetTransform
            let deltaAngle = Double(atan2(deltaTransform.b, deltaTransform.a))

            // In Swift 3.2/4 Coercing to a Float will fail if the underlying value is a double
            if var currentRotation: Double = view.layer.value(forKeyPath: "transform.rotation.z") as? Double {
                currentRotation = currentRotation + -1 * deltaAngle + 0.0001
                view.layer.setValue(NSNumber(value: currentRotation), forKeyPath: "transform.rotation.z")
            } else {
                print("This would be a great example of NSNumber bridging failure in the Swift3.2/4 system")
            }

            // Explicity apply transforms to subviews that we'd like to see rotate
            let orientation = UIApplication.shared.statusBarOrientation
            var transform = CGAffineTransform.identity

            switch orientation {
            case .landscapeLeft:
                transform = CGAffineTransform(rotationAngle: CGFloat(-.halfpi))
            case .landscapeRight:
                transform = CGAffineTransform(rotationAngle: CGFloat(.halfpi))
            default:
                break
            }
            for view in strongSelf.viewsToBeRotated {
                view.transform = transform
            }
        }, completion: { [weak self] (context) in
            guard var currentTransform = self?.view?.transform else {
                return
            }
            currentTransform.a = round(currentTransform.a)
            currentTransform.b = round(currentTransform.b)
            currentTransform.c = round(currentTransform.c)
            currentTransform.d = round(currentTransform.d)
            self?.view?.transform = currentTransform
        })
    }

    override public var prefersStatusBarHidden: Bool {
        return true
    }
}
