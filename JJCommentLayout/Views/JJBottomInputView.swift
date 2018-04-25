//
//  JJBottomInputView.swift
//  JJCommentLayout
//
//  Created by Michael Lu on 4/22/18.
//  Copyright © 2018 Michael Lu. All rights reserved.
//

import Foundation
import UIKit

class JJBottomInputView: UIView {
    let imageView = UIImageView(frame: .zero)
    let inputArea = UIStackView(frame: .zero)
    let listButton = UIButton(frame: .zero)
    let line = UIView(frame: .zero)
    let replyLabel = UILabel(frame: .zero)
    
    var listButtonEvent : (() -> Void)?

    init(event:(()->Void)?){
        listButtonEvent = event
        super.init(frame:.zero)
        setUpUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setUpUI() {
        backgroundColor = RGB(245, 245,245)
        
        line.backgroundColor = RGB(202, 202, 202)
        line.translatesAutoresizingMaskIntoConstraints = false
        addSubview(line)
        
        inputArea.backgroundColor = .white
        inputArea.translatesAutoresizingMaskIntoConstraints = false
        inputArea.layer.cornerRadius = 15.5
        inputArea.layer.borderWidth = 0.5
        inputArea.layer.masksToBounds = true
        inputArea.layer.borderColor = RGB(202, 202, 202).cgColor
        addSubview(inputArea)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "pen")
        imageView.contentMode = .center
        inputArea.addSubview(imageView)
        
        replyLabel.translatesAutoresizingMaskIntoConstraints = false
        replyLabel.text = "Write a comment"
        replyLabel.textAlignment = .left
        replyLabel.font = UIFont.systemFont(ofSize: 16)
        replyLabel.textColor = RGB(139, 139, 139)
        inputArea.addSubview(replyLabel)
        
        var allViews = ["imageView":imageView,"replyLabel":replyLabel]
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[imageView]|", options: [], metrics: nil, views: allViews))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[replyLabel]|", options: [], metrics: nil, views: allViews))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[imageView(15)]-7-[replyLabel]|", options: [], metrics: nil, views: allViews))
        
        listButton.translatesAutoresizingMaskIntoConstraints = false
        listButton.setTitle("213", for: .normal)
        listButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        listButton.setTitleColor(RGB(239, 45, 54), for: .normal)
        listButton.setImage(UIImage(named: "dialoge"), for: .normal)
        listButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        listButton .addTarget(self, action: #selector(showCommentList) , for:.touchUpInside)
        addSubview(listButton)
        
        allViews = ["line":line,"inputArea":inputArea,"listButton":listButton]
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[line]|", options: [], metrics: nil, views: allViews))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[line(0.5)][listButton]|", options: [], metrics: nil, views: allViews))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[inputArea]-5-[listButton]-2-|", options: [], metrics: nil, views: allViews))
        inputArea.heightAnchor.constraint(equalToConstant: 31).isActive = true
        inputArea.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -0.5).isActive = true
        listButton.widthAnchor.constraint(equalToConstant: 68).isActive = true
    }
    
    @objc func showCommentList() {
        if let execute = listButtonEvent {
            execute()
        }
    }
    
    
}
