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
        let alert = VAlertViewController(haveTitle: true, haveMessage: true, style: .alert)
        alert.titleLabel.text = "1"
        alert.messageLabel.text = "2"
        //只生效top、bottom
        alert.contentInsets = .init(top: 10, left: 0, bottom: 0, right: 0)
        //context separator
        alert.contextSeparatorView.backgroundColor = .random
        alert.contextSeparatorHeight = 1
        //action separator
        alert.actionSeparatorHeight = 1
        alert.actionSeparatorBackgroundColor = .random
        
        alert.addText(VDefaultAlertText(title: "1", placeholder: "2"))
        alert.addAction(VDefaultAlertAction(title: "1", handler: { action, data in
            print(data)
        }))
        alert.addAction(VDefaultAlertAction(title: "2"))
        
        alert.modalTransitionStyle = .crossDissolve
        alert.modalPresentationStyle = .custom
        self.present(alert, animated: true)
    }
}
