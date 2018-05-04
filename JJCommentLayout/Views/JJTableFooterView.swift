//
//  JJTableFooterView.swift
//  JJCommentLayout
//
//  Created by Michael Lu on 4/29/18.
//  Copyright © 2018 Michael Lu. All rights reserved.
//

import Foundation
import UIKit

enum FooterStatus {
    case idle, busy, end
}


class JJTableFooterView: UIView {
    
    fileprivate var status = FooterStatus.idle
    
    var loadMoreBtn:UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpUI()
    }
    
    fileprivate func setUpUI() {
        loadMoreBtn = UIButton(frame: CGRect(x: 12, y: 35/2, width:0, height: 35)) //width:frame.size.width-12*2
        loadMoreBtn.autoresizingMask = [.flexibleWidth]
        loadMoreBtn.layer.masksToBounds = true
        loadMoreBtn.layer.cornerRadius = 8
        loadMoreBtn.layer.borderColor = RGB(202, 202, 202).cgColor
        loadMoreBtn.setTitleColor(RGB(153, 153, 153), for: .normal)
        loadMoreBtn.layer.borderWidth = 0.5
        loadMoreBtn.imageView?.contentMode = .center
        loadMoreBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        loadMoreBtn.setImage(UIImage(named: "load"), for: .normal)
        loadMoreBtn.setTitle("", for: .normal)
        loadMoreBtn.backgroundColor = RGB(252, 252, 252)
        loadMoreBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -3, bottom: 0, right: 3)
        loadMoreBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: -3)
        addSubview(loadMoreBtn)
    }
    
    func getStatus() -> FooterStatus {
        return status
    }
    
    fileprivate func setStatus(status:FooterStatus) {
        self.status = status
        if (status == .busy) {
            startLoading()
        }
        else
        {
            stopLoading()
        }
    }
    
    func change(to status:FooterStatus, with title:String ) {
        setStatus(status: status)
        loadMoreBtn.setTitle(title, for: .normal)
    }
    
    fileprivate func startLoading() {
        loadMoreBtn.setImage(UIImage(named: "load"), for: .normal)
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = Double.pi*2
        rotation.duration = 1
        rotation.isCumulative = true
        rotation.repeatCount = Float.infinity
        loadMoreBtn.imageView?.layer.add(rotation, forKey: "rotationAnimation")
    }
    
    fileprivate func stopLoading() {
        loadMoreBtn.imageView?.layer.removeAnimation(forKey: "rotationAnimation")
        loadMoreBtn.setImage(nil, for: .normal)
    }
}

class JJTableSectionFooterView: JJTableFooterView {
    override func setUpUI() {
        loadMoreBtn = UIButton(frame: CGRect(x: 12, y: 35/2, width:frame.size.width-12*2 , height: 35))
        loadMoreBtn.setTitleColor(.black, for: .normal)
        loadMoreBtn.imageView?.contentMode = .left
        loadMoreBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        loadMoreBtn.setImage(UIImage(named: "load"), for: .normal)
        loadMoreBtn.setTitle("", for: .normal)
        loadMoreBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -3, bottom: 0, right: 3)
        loadMoreBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: -3)
        addSubview(loadMoreBtn)
    }
}
