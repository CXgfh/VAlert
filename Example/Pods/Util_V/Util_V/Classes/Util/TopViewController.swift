//
//  Util+TopViewController.swift
//  Util
//
//  Created by V on 2023/2/19.
//

import UIKit

public func findTopViewController(_ viewController: UIViewController?) -> UIViewController? {
    var top: UIViewController?
    if viewController == nil {
        if #available(iOS 13, *) {
            top = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController
        } else {
            top = UIApplication.shared.keyWindow?.rootViewController
        }
    } else {
        top = viewController
    }
    while true {
        if let presented = top?.presentedViewController {
            top = presented
        } else if let nav = top as? UINavigationController {
            top = nav.visibleViewController
        } else if let tab = top as? UITabBarController {
            top = tab.selectedViewController
        } else {
            break
        }
    }
    return top
}
