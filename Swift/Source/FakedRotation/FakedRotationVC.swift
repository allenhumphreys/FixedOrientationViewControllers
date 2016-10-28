//
//  FakedRotationVC.swift
//  FixedOrientationSwift
//
//  Created by Allen Humphreys on 10/29/16.
//  Copyright © 2016 Allen, Inc. All rights reserved.
//

import Foundation
import UIKit

class FakedRotationVC: CameraViewController {

    override class var needsPreviewRotations: Bool {
        return false
    }

    @IBOutlet var viewsToBeRotated: [UIView]!

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(FakedRotationVC.orientationDidChange(_:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
    }

    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    public override var prefersStatusBarHidden: Bool {
        return true
    }

    func orientationDidChange(_ notification: NSNotification) -> Void {
        // Explicity apply transforms to subviews that we'd like to see rotate
        let orientation = UIDevice.current.orientation
        var transform : CGAffineTransform = .identity

        switch orientation {
        case .landscapeRight:
            transform = .init(rotationAngle: CGFloat(-.halfpi))
        case .landscapeLeft:
            transform = .init(rotationAngle: CGFloat(.halfpi))
        default:
            break
        }

        UIView.animate(withDuration: UIApplication.shared.statusBarOrientationAnimationDuration, animations: {
            for view in self.viewsToBeRotated {
                view.transform = transform
            }
        })
    }
}
