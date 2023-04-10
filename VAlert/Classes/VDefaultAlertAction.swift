//
//  VDefaultAlertAction.swift
//  Vick_Custom
//
//  Created by Vick on 2022/10/19.
//

import UIKit

public protocol VAlertAction: UIButton {
    var actionHeight: CGFloat { get }
    var handler: VActionHandler? { get set }
}

public typealias VActionHandler = (_ action: VAlertAction, _ data: [String: String])->Void

public class VDefaultAlertAction: UIButton, VAlertAction {
    public var actionHeight: CGFloat = 44
    
    public var handler: VActionHandler?
    
    public init(title: String,
                handler: VActionHandler? = nil) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        layer.cornerRadius = 12
        setTitleColor(.black, for: .normal)
        backgroundColor = .white
        self.handler = handler
    }
    
    override init(frame: CGRect) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
