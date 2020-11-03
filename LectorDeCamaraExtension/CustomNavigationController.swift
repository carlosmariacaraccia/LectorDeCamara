//
//  CustomNavigationController.swift
//  ExternalFilesOpener
//
//  Created by Carlos Caraccia on 10/6/20.
//  Copyright © 2020 Carlos Caraccia. All rights reserved.
//

import Foundation
import UIKit


@objc(CustomShareNavigationController)
class CustomShareNavigationController: UINavigationController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        self.setViewControllers([CustomShareViewController()], animated: false)
        self.navigationBar.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
