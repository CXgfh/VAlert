//
//  ViewController.swift
//  VAlert
//
//  Created by oauth2 on 04/10/2023.
//  Copyright (c) 2023 oauth2. All rights reserved.
//

import UIKit
import Util_V
import VAlert

class ViewController: UIViewController {
    
    private lazy var button: UIButton = {
        let button = UIButton(title: "test", titleColor: .blue, font: .systemFont(ofSize: 16, weight: .semibold))
        button.addTarget(self, action: #selector(Tap), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(button)
        button.frame = view.frame
    }

}

extension ViewController {
    @objc private func Tap() {
        
        let alert = VAlertViewController(style: .alert)
        alert.titleLabel.text = "1123175712587125375127835182538125738"
        alert.messageLabel.attributedText = NSAttributedString(string: "1123175712587125375127835182538125738123123123123123123")
        alert.headerInsets = .init(top: 8, left: 0, bottom: 8, right: 0)
        alert.messageSpacing = 8
        alert.textInsets = .init(top: 8, left: 0, bottom: 8, right: 0)
        alert.textSpacing = 4
        alert.bottomInsets = .init(top: 4, left: 0, bottom: 0, right: 0)
        
        //context separator
        alert.separatorView.backgroundColor = .random
        alert.separatorHeight = 1
        //action separator
        alert.actionSeparatorHeight = 20
        alert.actionSeparatorWidth = 1
        alert.actionSeparatorBackgroundColor = .random
        
        
        alert.addText(VDefaultAlertText(title: "1", placeholder: "2"))
        alert.addText(VDefaultAlertText(title: "1", placeholder: "2"))
        alert.addText(VDefaultAlertText(title: "1", placeholder: "2"))
        alert.addText(VDefaultAlertText(title: "1", placeholder: "2"))
        alert.addText(VDefaultAlertText(title: "1", placeholder: "2"))
        alert.addAction(VDefaultAlertAction(title: "1", handler: { action in
            for text in alert.textFields {
                print(text.title, text.content)
            }
        }))
        alert.addAction(VDefaultAlertAction(title: "2"))
        alert.addAction(VDefaultAlertAction(title: "3"))
        
        alert.modalTransitionStyle = .crossDissolve
        alert.modalPresentationStyle = .custom
        self.present(alert, animated: true)
    }
}
