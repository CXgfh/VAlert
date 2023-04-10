//
//  Util+Screen.swift
//  Util
//
//  Created by Vick on 2022/9/29.
//

import UIKit

public extension Util {
    static var screen: UIScreen {
        if #available(iOS 13.0, *) {
            return (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.screen ?? .init()
        } else {
            return UIScreen.main
        }
    }
}
