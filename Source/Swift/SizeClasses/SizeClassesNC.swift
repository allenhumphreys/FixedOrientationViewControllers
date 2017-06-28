//
//  ViewController.swift
//  SizeClassesRotationTester
//
//  Created by Allen Humphreys on 10/28/16.
//  Copyright © 2016 Allen, Inc. All rights reserved.
//

import UIKit

class SizeClassesNC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { [unowned self] (context) in
            let orientation = UIDevice.current.orientation

            switch orientation {
            case .landscapeRight:
                let traits = [self.traitCollection,
                              UITraitCollection.init(verticalSizeClass: .compact),
                              UITraitCollection.init(horizontalSizeClass: .regular)]
                let traitCollection = UITraitCollection.init(traitsFrom: traits)
                self.setOverrideTraitCollection(traitCollection, forChildViewController: self.viewControllers[0]);
                break;
            default:
                self.setOverrideTraitCollection(self.traitCollection, forChildViewController: self.viewControllers[0])
            }
        }, completion:nil)
    }
}
