//
//  VAlertViewController.swift
//  Vick_Custom
//
//  Created by Vick on 2022/10/18.
//

import UIKit
import Util_V
import ContentSizeView
import SnapKit

public class VAlertViewController: UIViewController {
    
    public var textFields: [VAlertText] {
        textStackView.arrangedSubviews as! [VAlertText]
    }
    
    private var keyboardShowing = false
    
    private var textRect = CGRect.zero
    
    private var keyboardFrame = CGRect.zero
    
    public var cornerRadius: CGFloat = 15
    
    private let style: UIAlertController.Style
    
    private let alertWidth: CGFloat
    
    private let contentHeight: CGFloat
    
    private let bottomHeight: CGFloat
    
    public init(style: UIAlertController.Style,
                alertWidth: CGFloat = 270,
                contentHeight: CGFloat = 300,
                bottomHeight: CGFloat = 200) {
        self.style = style
        self.alertWidth =  alertWidth
        self.contentHeight = contentHeight
        self.bottomHeight = bottomHeight
        super.init(nibName: nil, bundle: nil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .custom
    }
    
    //MARK: ------ content view ------
    private var dimingCenterYLayout: NSLayoutConstraint?
    
    private var dimingWidth: CGFloat {
        switch style {
        case .actionSheet:
            return view.width - 36
        default:
            return alertWidth
        }
    }
    
    private lazy var dimingView: ContentSizeOfView = {
        let object = ContentSizeOfView()
        object.backgroundColor = .white
        object.maxCornerRadius = cornerRadius
        
        object.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return object
    }()
    
    private lazy var contentView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.addArrangedSubviews(headerView, textView, separatorView, bottomView)
        return stack
    }()
    
    //MARK: ------ header view  ------
    public var headerInsets: UIEdgeInsets = .init(top: 8, left: 0, bottom: 8, right: 0)
    private lazy var headerView: UIView = {
        let object = UIView()
        object.addSubviews(headerStackView)
        headerStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(headerInsets.top).priority(750)
            make.bottom.equalToSuperview().inset(headerInsets.bottom).priority(750)
            make.left.right.equalToSuperview().inset(cornerRadius).priority(750)
        }
        return object
    }()
    
    ///标题和内容的间距
    public var messageSpacing: CGFloat = 4
    private lazy var headerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = messageSpacing
        stack.addArrangedSubviews(titleLabel, headerContentView)
        return stack
    }()
    
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingMiddle
        return label
    }()
    
    private lazy var headerContentView: ContentSizeOfScrollView = {
        let header = ContentSizeOfScrollView(maximumDisplayHeight: contentHeight, maximumDisplayWidth: dimingWidth-cornerRadius*2)
        header.addSubviews(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalTo(dimingWidth-cornerRadius*2)
        }
        return header
    }()
    
    public lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black.withAlphaComponent(0.8)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    //MARK: ------ text View -----
    public var textInsets: UIEdgeInsets = .init(top: 4, left: 0, bottom: 8, right: 0)
    private lazy var textView: UIView = {
        let object = UIView()
        object.addSubviews(textStackView)
        textStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(textInsets.top).priority(750)
            make.bottom.equalToSuperview().inset(textInsets.bottom).priority(750)
            make.left.right.equalToSuperview().inset(cornerRadius).priority(750)
        }
        return object
    }()
    
    public var textSpacing: CGFloat = 4
    private lazy var textStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = textSpacing
        return stack
    }()
    
    //MARK: ------ separator view------
    public var separatorHeight: CGFloat = 1
    public lazy var separatorView: UIView = {
        let object = UIView()
        object.backgroundColor = .black.withAlphaComponent(0.5)
        return object
    }()
    
    //MARK: ------ bottom view  ------
    public var bottomInsets: UIEdgeInsets = .init(top: 4, left: 0, bottom: 8, right: 0)
    private lazy var bottomView: UIView = {
        let object = UIView()
        object.addSubviews(bottomContentView)
        bottomContentView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(bottomInsets.top).priority(750)
            make.bottom.equalToSuperview().inset(bottomInsets.bottom).priority(750)
            make.left.right.equalToSuperview().priority(750)
        }
        return object
    }()
    
    private lazy var bottomContentView: ContentSizeOfScrollView = {
        let bottom = ContentSizeOfScrollView(maximumDisplayHeight: bottomHeight, maximumDisplayWidth: dimingWidth-2*cornerRadius)
        
        bottom.addSubviews(actionStackView)
        actionStackView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalTo(dimingWidth)
        }
        return bottom
    }()
    
    private lazy var actionStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fill
        stack.backgroundColor = .clear
        return stack
    }()
    
    public var actionSeparatorHeight: CGFloat = 20
    public var actionSeparatorWidth: CGFloat = 1
    public var actionSeparatorBackgroundColor: UIColor = .black.withAlphaComponent(0.5)

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidBeginEditing),
                                               name: UITextField.textDidBeginEditingNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension VAlertViewController {
    @objc private func textDidBeginEditing(notification: NSNotification) {
        guard let object = notification.object as? UIView, let isKeyWindow = object.window?.isKeyWindow, isKeyWindow else {
            return
        }
        
        if object.viewController == self {
            self.view.layoutIfNeeded()
            self.textRect = object.convert(object.frame, to: self.view)
            adjustPosition()
        }
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        keyboardShowing = true
        if let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.keyboardFrame = keyboardFrame
            adjustPosition()
        }
    }
    
    private func adjustPosition() {
        guard keyboardShowing else {
            return
        }
        var offset = view.height - textRect.maxY  - keyboardFrame.height-10
        if offset > 0 {
            offset = 0
        }
        switch self.style {
        case .alert:
            self.dimingCenterYLayout?.constant = offset
        default:
            break
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide() {
        keyboardShowing = false
        switch style {
        case .alert:
            dimingCenterYLayout?.constant = 0
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        default:
            break
        }
    }
}

extension VAlertViewController {
    public func addAction(_ action: VAlertAction) {
        if actionStackView.arrangedSubviews.count > 0 {
            let separator = UIView()
            separator.backgroundColor = actionSeparatorBackgroundColor
            actionStackView.addArrangedSubview(separator)
        }
        actionStackView.addArrangedSubview(action)
        action.addTarget(self, action: #selector(actionTap), for: .touchUpInside)
    }
    
    public func addText(_ action: VAlertText) {
        textStackView.addArrangedSubview(action)
        action.snp.makeConstraints { make in
            make.height.equalTo(action.actionHeight)
        }
    }
}

extension VAlertViewController {
    @objc private func actionTap(_ sender: UIButton) {
        if let action = sender as? VAlertAction {
            dismiss(animated: false) {
                action.handler?(action)
            }
        }
    }
}

extension VAlertViewController {
    private func setupUI() {
        self.view.backgroundColor = .black.withAlphaComponent(0.2)
        setupContentUI()
        setupHeaderUI()
        setupTextUI()
        setupBottomUI()
        setupSeparator()
    }
    
    private func setupContentUI() {
        self.view.addSubviews(dimingView)
        
        NSLayoutConstraint(item: dimingView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        switch style {
        case .alert:
            NSLayoutConstraint(item: dimingView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: alertWidth).isActive = true
            dimingCenterYLayout = NSLayoutConstraint(item: dimingView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
            dimingCenterYLayout?.isActive = true
        case .actionSheet:
            NSLayoutConstraint(item: dimingView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: -36).isActive = true
            NSLayoutConstraint(item: dimingView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottomMargin, multiplier: 1, constant: 0).isActive = true
        default:
            break
        }
    }
    
    private func setupHeaderUI() {
        titleLabel.isHidden = (titleLabel.text == "" || titleLabel.text == nil)
        
        if messageLabel.text == "" || messageLabel.text == nil {
            headerContentView.isHidden = true
        } else {
            messageLabel.layoutIfNeeded()
            headerContentView.contentSize = messageLabel.frame.size
        }
        
        headerView.isHidden = headerStackView.arrangedSubviews.filter{ !$0.isHidden }.count == 0
    }
    
    private func setupTextUI() {
        textView.isHidden = textStackView.arrangedSubviews.count == 0
    }
    
    private func setupBottomUI() {
        let count = actionStackView.arrangedSubviews.count
        if count > 0, count <= 3, style == .alert {
            actionStackView.axis = .horizontal
            if count == 1 {
                if let action = actionStackView.arrangedSubviews[0] as? VAlertAction {
                    action.snp.makeConstraints { make in
                        make.height.equalTo(action.actionHeight)
                    }
                }
            } else {
                for index in actionStackView.arrangedSubviews {
                    if let action = index as? VAlertAction {
                        action.snp.makeConstraints { make in
                            make.width.equalTo((dimingWidth-actionSeparatorHeight)/2)
                            make.height.equalTo(action.actionHeight)
                        }
                    } else {
                        index.snp.makeConstraints { make in
                            make.width.equalTo(actionSeparatorWidth)
                            make.height.equalTo(actionSeparatorHeight)
                        }
                    }
                }
            }
        } else if count > 3 {
            actionStackView.axis = .vertical
            for index in actionStackView.arrangedSubviews {
                if let action = index as? VAlertAction {
                    action.snp.makeConstraints { make in
                        make.height.equalTo(action.actionHeight)
                        make.width.equalTo(dimingWidth)
                    }
                } else {
                    index.snp.makeConstraints { make in
                        make.height.equalTo(actionSeparatorWidth)
                        make.width.equalTo(dimingWidth-36)
                    }
                }
            }
        }
        
        if count == 0 {
            bottomView.isHidden = true
        } else {
            actionStackView.layoutIfNeeded()
            bottomContentView.contentSize = actionStackView.frame.size
        }
    }
    
    private func setupSeparator() {
        NSLayoutConstraint(item: separatorView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: separatorHeight).isActive = true
        separatorView.isHidden = (headerView.isHidden || textStackView.isHidden) || bottomView.isHidden
    }
}
