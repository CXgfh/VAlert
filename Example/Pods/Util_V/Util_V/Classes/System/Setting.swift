//
//  Setting.swift
//  VSystem
//
//  Created by Vick on 2022/9/22.
//

import UIKit


public func openSettings(parent: UIViewController,
                         title: String?,
                         message: String?,
                         cancel: String,
                         confirm: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title:  cancel, style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: confirm, style: .default, handler: { (_) in
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }))
    findTopViewController(parent)?.present(alert, animated: true)
}
