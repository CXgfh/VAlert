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
    
    private let style: UIAlertController.Style
    
    //MARK: ----- layout -------
    public var contentInsets: UIEdgeInsets = .init(top: 8, left: 0, bottom: 0, right: 0) {
        didSet {
            headerTopLayout?.constant = contentInsets.top
            actionBottomLayout?.constant = -contentInsets.bottom
        }
    }
    
    private var alertWidth: CGFloat
    
    private var headerHeight: CGFloat
    
    private var bottomHeight: CGFloat
    
    //MARK: ------ separator ------
    public var contextSeparatorHeight: CGFloat = 1 {
        didSet {
            contextSeparatorHeigtLayout?.constant = contextSeparatorHeight
        }
    }
    
    public var actionSeparatorHeight: CGFloat = 1
    public var actionSeparatorBackgroundColor: UIColor = .black.withAlphaComponent(0.5)
    
    //MARK: ------ public view ------
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    public lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black.withAlphaComponent(0.8)
        label.textAlignment = .center
        return label
    }()
    
    private var contextSeparatorHeigtLayout: NSLayoutConstraint?
    public lazy var contextSeparatorView: UIView = {
        let object = UIView()
        object.backgroundColor = .black.withAlphaComponent(0.5)
        return object
    }()
    
    //MARK: ------ private view ------
    private lazy var dimingView: ContentSizeOfView = {
        let object = ContentSizeOfView()
        object.backgroundColor = .white
        object.maxCornerRadius = 15
        return object
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.addArrangedSubviews(messageView, contextSeparatorView, actionView)
        
        contextSeparatorHeigtLayout = NSLayoutConstraint(item: contextSeparatorView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: contextSeparatorHeight)
        contextSeparatorHeigtLayout?.isActive = true
        return stack
    }()
    
    private lazy var messageView = ContentSizeOfScrollView(maximumDisplayHeight: headerHeight, maximumDisplayWidth: alertWidth-30)
    
    private var headerTopLayout: NSLayoutConstraint?
    private lazy var headerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 4
        return stack
    }()
    
    private lazy var actionView = ContentSizeOfScrollView(maximumDisplayHeight: bottomHeight, maximumDisplayWidth: alertWidth-30)
    
    private var actionCount = 0
    private var actionBottomLayout: NSLayoutConstraint?
    private lazy var actionStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.backgroundColor = .clear
        return stack
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateBottomUI(by: actionStackView.arrangedSubviews.count)
    }
    
    public init(haveTitle: Bool,
                haveMessage: Bool,
                style: UIAlertController.Style,
                alertWidth: CGFloat = 270,
                headerHeight: CGFloat = 270,
                bottomHeight: CGFloat = 200) {
        self.alertWidth = alertWidth
        self.headerHeight = headerHeight
        self.bottomHeight = bottomHeight
        self.style = style
        super.init(nibName: nil, bundle: nil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .custom
        if haveTitle {
            headerStackView.addArrangedSubview(titleLabel)
        }
        if haveMessage {
            headerStackView.addArrangedSubview(messageLabel)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        headerStackView.addArrangedSubview(action)
        action.snp.makeConstraints { make in
            make.height.equalTo(action.actionHeight)
        }
    }
}

extension VAlertViewController {
    @objc private func actionTap(_ sender: UIButton) {
        if let action = sender as? VAlertAction {
            dismiss(animated: false) {
                var data = [String: String]()
                for element in self.headerStackView.arrangedSubviews {
                    if let text = element as? VAlertText {
                        data[text.title] = text.content
                    }
                }
                action.handler?(action, data)
            }
        }
    }
}

extension VAlertViewController {
    private func setupUI() {
        self.view.backgroundColor = .black.withAlphaComponent(0.2)
        self.view.addSubviews(dimingView)
        switch style {
        case .alert:
            setupAlertUI()
        case .actionSheet:
            setupSheetUI()
        default:
            break
        }
        setContentUI()
        updateUI()
    }
    
    private func setupAlertUI() {
        dimingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(alertWidth)
        }
    }
    
    private func setupSheetUI() {
        dimingView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.width.equalTo(alertWidth)
        }
    }
    
    private func setContentUI() {
        dimingView.addSubviews(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        setupHeaderUI()
        setupActionUI()
    }
    
    private func setupHeaderUI() {
        messageView.addSubviews(headerStackView)
        NSLayoutConstraint(item: headerStackView, attribute: .left, relatedBy: .equal, toItem: messageView, attribute: .left, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: headerStackView, attribute: .bottom, relatedBy: .equal, toItem: messageView, attribute: .bottom, multiplier: 1, constant: -4).isActive = true
        NSLayoutConstraint(item: headerStackView, attribute: .width, relatedBy: .equal, toItem: dimingView, attribute: .width, multiplier: 1, constant: -30).isActive = true
        
        headerTopLayout = NSLayoutConstraint(item: headerStackView, attribute: .top, relatedBy: .equal, toItem: messageView, attribute: .top, multiplier: 1, constant: contentInsets.top)
        headerTopLayout?.isActive = true
    }
    
    private func setupActionUI() {
        actionView.addSubviews(actionStackView)
        NSLayoutConstraint(item: actionStackView, attribute: .left, relatedBy: .equal, toItem: actionView, attribute: .left, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: actionStackView, attribute: .top, relatedBy: .equal, toItem: actionView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: actionStackView, attribute: .width, relatedBy: .equal, toItem: dimingView, attribute: .width, multiplier: 1, constant: -30).isActive = true
        
        actionBottomLayout = NSLayoutConstraint(item: actionStackView, attribute: .bottom, relatedBy: .equal, toItem: actionView, attribute: .bottom, multiplier: 1, constant: -contentInsets.bottom)
        actionBottomLayout?.isActive = true
    }
    
    private func updateBottomUI(by count: Int) {
        if count != actionCount {
            actionCount = count
            if count == 3, style == .alert {
                actionStackView.axis = .horizontal
                for index in actionStackView.arrangedSubviews {
                    index.constraints.forEach{ index.removeConstraint($0) }
                    if let action = index as? VAlertAction {
                        NSLayoutConstraint(item: index, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: (dimingView.frame.width-30-actionSeparatorHeight)/2).isActive = true
                        NSLayoutConstraint(item: index, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: action.actionHeight).isActive = true
                    } else {
                        NSLayoutConstraint(item: index, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: actionSeparatorHeight).isActive = true
                    }
                }
            } else {
                actionStackView.axis = .vertical
                for index in actionStackView.arrangedSubviews {
                    index.constraints.forEach{ index.removeConstraint($0) }
                    if let action = index as? VAlertAction {
                        NSLayoutConstraint(item: index, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: action.actionHeight).isActive = true
                    } else {
                        NSLayoutConstraint(item: index, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: actionSeparatorHeight).isActive = true
                    }
                }
            }
            updateUI()
        }
    }
    
    private func updateUI() {
        messageView.isHidden = headerStackView.arrangedSubviews.count == 0
        actionView.isHidden = actionStackView.arrangedSubviews.count == 0
        contextSeparatorView.isHidden = messageView.isHidden || actionView.isHidden
    }
}
