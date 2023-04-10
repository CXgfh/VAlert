//
//  VDefaultTextAction.swift
//  VAlert
//
//  Created by V on 2023/4/10.
//

import UIKit
import SnapKit
import Util_V

public protocol VAlertText: UIView {
    var actionHeight: CGFloat { get }
    var title: String { get }
    var content: String { get }
}

public class VDefaultAlertText: UIView, VAlertText {
    
    public var title: String {
        return titleLabel.text ?? ""
    }
    
    public var content: String {
        return textFiled.text ?? ""
    }
    
    public var actionHeight: CGFloat = 44
    
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    public lazy var contenView: UIView = {
        let content = UIView()
        content.backgroundColor = .init(hex: 0xf5f5f5)
        content.layer.cornerRadius = 4
        return content
    }()
    
    public lazy var textFiled: UITextField = {
        let textFiled = UITextField()
        textFiled.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textFiled.textColor = .black
        textFiled.keyboardType = .default
        textFiled.returnKeyType = .default
        textFiled.spellCheckingType = .no
        textFiled.autocorrectionType = .no
        textFiled.keyboardAppearance = .light
        textFiled.clearsOnBeginEditing = false
        textFiled.clearsOnInsertion = false
        textFiled.backgroundColor = .clear
        return textFiled
    }()

    
    public init(title: String, placeholder: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        textFiled.placeholder = placeholder
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension VDefaultAlertText {
    private func setupUI() {
        self.addSubviews(titleLabel, contenView)
        titleLabel.snp.makeConstraints { make in
            make.left.centerY.equalToSuperview()
        }
        
        contenView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(2)
            make.height.equalTo(40)
            make.left.equalTo(titleLabel.snp.right).offset(8)
            make.right.equalToSuperview()
        }
        
        contenView.addSubview(textFiled)
        textFiled.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
        }
    }
}
