//
//  JJCommentTableViewCell.swift
//  JJCommentLayout
//
//  Created by Michael Lu on 4/24/18.
//  Copyright © 2018 Michael Lu. All rights reserved.
//

import Foundation
import UIKit

let kBaseRightMargin:CGFloat = 11
let kBaseLeftMargin:CGFloat = 43
let kBaseHorizonMarginDiff:CGFloat = 3
let kVerticalSpaceHeight1:CGFloat = 5
let kVerticalSpaceHeight2:CGFloat = 13.0
let kVerticalTopMarginHeight:CGFloat = 18.0
let kVerticalBottomMarginHeight:CGFloat = 16.0
let kVerticalCiteTopMarginHeight:CGFloat = 10.0
let kVerticalCiteBottomMarginHeight:CGFloat = 16.0

let kUserNameLabelHeight:CGFloat = 13
let kUserFromLabelHeight:CGFloat = 10
let kCommentLabelMaxlHeight:CGFloat = 126

let kCommentFont = UIFont.systemFont(ofSize: 17.5)

let kBackgroundColor = RGB(246, 246, 246)
let kCiteBackgroundColor = RGB(255, 255, 255)
let kLineColor = RGB(202, 202, 202)
let kUserFromFontColor = RGB(149, 149, 149)
let kUserNameFontColor = RGB(81, 180, 218)
let kCommentFontColor = RGB(34, 34, 33)
let kSubviewBackgroundColor = UIColor.clear

protocol JJCommentTableViewCellDelegate:AnyObject {
//    func commentTableViewCellVoteUp(_ locationModel:JJCommentLocationModel)
    func commentTableViewCellUnfold(_ locationModel:JJCommentLocationModel)
//    func commentTableViewCellVoteDown(_ locationModel:JJCommentLocationModel)
//    func commentTableViewCellShare(_ locationModel:JJCommentLocationModel)
//    func commentTableViewCellReply(_ locationModel:JJCommentLocationModel)
    func commentTableViewCellExpand(_ locationModel:JJCommentLocationModel)
}


class JJCommentTableViewCell:UITableViewCell {
    let userNameLabel = UILabel()
    let userFromLabel = UILabel()
    let floorNumberLabel = UILabel()
    let commentLabel = UILabel()
    let upNumberLabel = UILabel()
    let upBtn = UIButton()
    let unfoldBtn = UIButton()
    let avatarImageView = UIImageView()
    var locationModel:JJCommentLocationModel!
    let showAllBtn = UIButton()
    
    weak var delegate:JJCommentTableViewCellDelegate?
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = kBackgroundColor
        contentView.backgroundColor = .clear
        
        userNameLabel.textColor = kUserNameFontColor
        userNameLabel.font = UIFont.systemFont(ofSize: 13)
        userNameLabel.backgroundColor = kSubviewBackgroundColor
        contentView.addSubview(userNameLabel)
        
        userFromLabel.textColor = kUserFromFontColor
        userFromLabel.font = UIFont.systemFont(ofSize: 10)
        userFromLabel.backgroundColor = kSubviewBackgroundColor
        contentView.addSubview(userFromLabel)
        
        floorNumberLabel.textColor = kUserFromFontColor
        floorNumberLabel.font = UIFont.systemFont(ofSize: 12)
        floorNumberLabel.textAlignment = .right
        contentView.addSubview(floorNumberLabel)
        
        commentLabel.textColor = kCommentFontColor
        commentLabel.font = kCommentFont
        commentLabel.numberOfLines = 0
        commentLabel.backgroundColor = kSubviewBackgroundColor
        contentView.addSubview(commentLabel)
        
        let touch = UITapGestureRecognizer(target: self, action: #selector(tap))
        touch.numberOfTapsRequired = 1
        commentLabel.addGestureRecognizer(touch)
        
        upNumberLabel.frame = CGRect(x: frame.size.width-75, y: kVerticalTopMarginHeight+kUserNameLabelHeight, width: 45, height: kUserNameLabelHeight)
        upNumberLabel.textColor = kUserFromFontColor
        upNumberLabel.textAlignment = .right
        upNumberLabel.font = UIFont.systemFont(ofSize: 12)
        upNumberLabel.backgroundColor = .clear
        contentView.addSubview(upNumberLabel)
        
        upBtn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        upBtn.setImage(UIImage(named: "up"), for: .normal)
        let image = UIImage(named: "up_selected")?.withRenderingMode(.alwaysTemplate)
        upBtn.setImage(image, for: .selected)
        upBtn.imageView?.tintColor = RGB(229, 43, 51)
        upBtn.addTarget(self, action: #selector(voteUp), for: .touchUpInside)
        contentView.addSubview(upBtn)
        
        unfoldBtn.frame = CGRect(x: 0, y: 0, width: 200, height: 16)
        unfoldBtn.setImage(UIImage(named: "unflod"), for: .normal)
        unfoldBtn.setTitle("Show the hidden", for: .normal)
        unfoldBtn.setTitleColor(RGB(153, 153, 153), for: .normal)
        unfoldBtn.addTarget(self, action: #selector(unfold), for: .touchUpInside)
        unfoldBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 125, 0, -125)
        unfoldBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        contentView.addSubview(unfoldBtn)
        
        showAllBtn.frame = CGRect(x: 0, y: 0, width: 57, height: 19)
        showAllBtn.layer.cornerRadius = showAllBtn.frame.size.height/2
        showAllBtn.layer.borderColor = kLineColor.cgColor
        showAllBtn.layer.borderWidth = 0.5
        showAllBtn.setTitle("All", for: .normal)
        showAllBtn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        showAllBtn.setTitleColor(kUserFromFontColor, for: .normal)
        showAllBtn.addTarget(self, action: #selector(expand), for: .touchUpInside)
        contentView.addSubview(showAllBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setUpCell(with model:JJCommentLocationModel) {
        locationModel = model
        setNeedsDisplay()
        
        for subView in contentView.subviews {
            subView.isHidden = true
        }
        
        if locationModel.type == .hide {
            unfoldBtn.center = CGPoint(x: frame.size.width/2, y: 22.5)
            unfoldBtn.isHidden = false
            return
        }
        
        if locationModel.type == .header || locationModel.type == .single {
            avatarImageView.image = UIImage(named: "avatar")
            avatarImageView.isHidden = false
        }
        
        setUpNameAndFrom()
        setUpVote()
        setUpComment()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let lineWidth:CGFloat = 0.5
        
        let context = UIGraphicsGetCurrentContext()!
        context.setLineWidth(lineWidth)
        context.setStrokeColor(kLineColor.cgColor)
        context.setFillColor(kCiteBackgroundColor.cgColor)
        context.beginPath()
        
        if locationModel.type == .header {
            let maxNestedNumber = CGFloat(integerLiteral: locationModel.nestedNumber!)
            context.fill(CGRect(x: kBaseLeftMargin, y: rect.size.height - (maxNestedNumber - 1.0) * kBaseHorizonMarginDiff,
                                width: rect.size.width-kBaseLeftMargin-kBaseRightMargin, height: kBaseHorizonMarginDiff*(maxNestedNumber-1.0)))
            for i in 0..<Int(maxNestedNumber){
                let i = CGFloat(integerLiteral: i)
                let leftMargin = kBaseLeftMargin+i*kBaseHorizonMarginDiff
                let rightMargin = kBaseRightMargin+i*kBaseHorizonMarginDiff
                context.move(to: CGPoint(x: leftMargin, y: rect.size.height))
                context.addLine(to: CGPoint(x:leftMargin, y:rect.size.height-(maxNestedNumber-i-1)*kBaseHorizonMarginDiff-lineWidth))
                context.addLine(to: CGPoint(x:rect.size.width - rightMargin, y:rect.size.height-(maxNestedNumber-i-1)*kBaseHorizonMarginDiff-lineWidth))
                context.addLine(to: CGPoint(x:rect.size.width - rightMargin, y:rect.size.height))
            }
        } else {
            if locationModel.type == .cite || locationModel.type == .hide {
                context.fill(CGRect(x:kBaseLeftMargin, y:0, width:rect.size.width-kBaseRightMargin-kBaseLeftMargin, height:rect.size.height))
            }
            
            for i in 0..<locationModel.nestedNumber! {
                let i = CGFloat(integerLiteral: i)
                let leftMargin = kBaseLeftMargin+i*kBaseHorizonMarginDiff
                let rightMargin = kBaseRightMargin+i*kBaseHorizonMarginDiff
                
                var startY:CGFloat = 0
                if (i == 4) { startY = 0.5}
                context.move(to: CGPoint(x: leftMargin, y: startY))
                context.addLine(to: CGPoint(x: leftMargin, y: rect.size.height))
                context.move(to: CGPoint(x: rect.size.width - rightMargin, y: startY))
                context.addLine(to: CGPoint(x: rect.size.width-rightMargin, y: rect.size.height))
            }
            
            if locationModel.nestedNumber!>0 {
                let nestedNumber = CGFloat(integerLiteral: locationModel.nestedNumber!)
                context.move(to: CGPoint(x:kBaseLeftMargin+(nestedNumber-1)*kBaseHorizonMarginDiff+0.5, y: rect.size.height-lineWidth))
                context.addLine(to: CGPoint(x: rect.size.width - kBaseRightMargin-(nestedNumber-1)*kBaseHorizonMarginDiff-0.5, y: rect.size.height-lineWidth))
            }
        }
        
        if locationModel.type == .single || locationModel.type == .footer {
            context.move(to: CGPoint(x: 11, y: rect.size.height-0.5))
            context.addLine(to: CGPoint(x: rect.size.width-11, y:  rect.size.height-0.5))
        }
        
        if locationModel.indexPath?.section == 0 && locationModel.indexPath?.row==0 {
            context.move(to: CGPoint(x: 11, y: 0.5))
            context.addLine(to: CGPoint(x: rect.size.width-11, y: 0.5))
        }
        
        context.strokePath()
    }
    
    
    func setUpNameAndFrom(){
        var leftMargin:CGFloat = 0.0
        var rightMargin:CGFloat = 0.0
        var topMargin:CGFloat = kVerticalTopMarginHeight
        let nestedNumber = CGFloat(integerLiteral: locationModel.nestedNumber!)
        
        if locationModel.type == .header || locationModel.type == .single {
            leftMargin = kBaseLeftMargin
            rightMargin = kBaseRightMargin + 75
        } else if locationModel.type == .cite {
            topMargin = kVerticalCiteTopMarginHeight
            leftMargin = kBaseLeftMargin+kBaseHorizonMarginDiff*(nestedNumber-1)+10
            rightMargin = kBaseRightMargin+kBaseHorizonMarginDiff*(nestedNumber-1)+45
        }
        
        if locationModel.type != .footer {
            userNameLabel.frame = CGRect(x:leftMargin, y:topMargin, width:self.frame.size.width-leftMargin-rightMargin,height: kUserNameLabelHeight)
            userFromLabel.frame = CGRect(x:leftMargin, y:topMargin+kUserNameLabelHeight+kVerticalSpaceHeight1, width:self.frame.size.width-leftMargin-rightMargin, height:kUserFromLabelHeight)
            
            
            let from = "[\(locationModel.dataSource.siteName ?? "")\(locationModel.dataSource.location)] \(timeSince(created: locationModel.dataSource.createTime))"
            userFromLabel.text = from
            userNameLabel.text = locationModel.dataSource.userName
            userFromLabel.isHidden = false
            userNameLabel.isHidden = false
            
            
            if locationModel.type == .cite {
                floorNumberLabel.frame = CGRect(x:self.frame.size.width-rightMargin,y: userNameLabel.frame.origin.y, width:37,height: kUserNameLabelHeight)
                floorNumberLabel.text = "\(locationModel.dataSource.floorNumber)"
                floorNumberLabel.isHidden = false
            }
        }
        
    }
    
    func setUpVote(){
        if locationModel.type == .header || locationModel.type == .single {
            upBtn.isHidden = false
            upBtn.center = CGPoint(x: frame.size.width-20, y: kVerticalTopMarginHeight+kUserNameLabelHeight+4)
            upNumberLabel.isHidden = false
            upNumberLabel.center = CGPoint(x: frame.size.width-52.5, y: kVerticalTopMarginHeight+kUserNameLabelHeight+kUserFromLabelHeight/2+1)
            upBtn.isSelected = locationModel.voted
            if locationModel.dataSource.upNumber > 0 {
                upNumberLabel.text = "\(locationModel.dataSource.upNumber)"
            }else {
                upNumberLabel.text = ""
            }
        }
    }
    
    func setUpComment(){
        var leftMargin=kBaseLeftMargin
        var rightMargin=kBaseRightMargin
        let nestedNumber = CGFloat(integerLiteral: locationModel.nestedNumber!)
        
        if locationModel.type == .cite {
            leftMargin = kBaseLeftMargin+kBaseHorizonMarginDiff*(nestedNumber-1)+10
            rightMargin = kBaseRightMargin+kBaseHorizonMarginDiff*(nestedNumber-1)+10
        }
        
        if locationModel.type != .header {
            var commentSize = JJCommentTableViewCell.calculateCommentSize(with: locationModel, font: kCommentFont, width: frame.size.width)
            
            if (locationModel.lengthLimiation && commentSize.height > kCommentLabelMaxlHeight) {
                commentSize.height = kCommentLabelMaxlHeight
                showAllBtn.center = CGPoint(x:frame.size.width-rightMargin-showAllBtn.frame.size.width/2, y:frame.size.height-23)
                showAllBtn.isHidden = false
            }
            
            var originY = kVerticalTopMarginHeight
            if locationModel.type == .cite{
                originY = kVerticalCiteTopMarginHeight+kUserNameLabelHeight+kVerticalSpaceHeight1+kUserFromLabelHeight+kVerticalSpaceHeight2-5
            }
            else if locationModel.type == .single {
                originY = kVerticalTopMarginHeight+kUserNameLabelHeight+kVerticalSpaceHeight1+kUserFromLabelHeight+kVerticalSpaceHeight2-5
            }
            else if locationModel.type == .footer{
                originY = 10-4
            }
            
            commentLabel.frame = CGRect(x:leftMargin, y:originY, width:self.frame.size.width-leftMargin-rightMargin,height: commentSize.height)
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 5
            commentLabel.attributedText = NSAttributedString(string: locationModel.dataSource.content, attributes: [.font:commentLabel.font,.paragraphStyle:paragraphStyle])
            
            
            commentLabel.isHidden = false
        }
    }
    
    
    // class method
    
    static func calculateCommentSize(with model:JJCommentLocationModel, font:UIFont, width:CGFloat) -> CGSize {
        var leftMargin=kBaseLeftMargin
        var rightMargin=kBaseRightMargin+20
        let nestedNumber = CGFloat(integerLiteral: model.nestedNumber!)
        if (model.type == .cite )
        {
            leftMargin = kBaseLeftMargin+kBaseHorizonMarginDiff*(nestedNumber-1)+10
            rightMargin = kBaseRightMargin+kBaseHorizonMarginDiff*(nestedNumber-1)+10
        }
        
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        let calculate = NSString(string: model.dataSource.content).boundingRect(with: CGSize(width: width-leftMargin-rightMargin, height: 1000), options: .usesLineFragmentOrigin, attributes: [.font:font,.paragraphStyle:paragraphStyle], context: nil)
        
        let size = CGSize(width:calculate.width,height:CGFloat(integerLiteral:Int(calculate.height))+1)
        return size
    }
    
    static func calculateCellHeight(with model:JJCommentLocationModel, and width:CGFloat) -> CGFloat {
        
        var height:CGFloat!
        
        if (model.type == .header) {
            let maxNestedNum = CGFloat(integerLiteral: model.nestedNumber!-1)
            
            height = kVerticalTopMarginHeight+kUserNameLabelHeight+kVerticalSpaceHeight1+kUserFromLabelHeight+kVerticalBottomMarginHeight+kBaseHorizonMarginDiff*(maxNestedNum-1)
        } else if(model.type == .hide){
            height = 45
        } else {
            var commentHeight = JJCommentTableViewCell.calculateCommentSize(with: model, font: kCommentFont, width: width).height
            
            var showHideHeight:CGFloat = 0
            if model.lengthLimiation && commentHeight > kCommentLabelMaxlHeight {
                commentHeight = kCommentLabelMaxlHeight;
                showHideHeight = kVerticalSpaceHeight1+19;
            }
            
            if (model.type == .footer){
                height = 10+commentHeight+18+showHideHeight-9
            }
            else if (model.type == .single){
                height =  kVerticalTopMarginHeight+kUserNameLabelHeight+kVerticalSpaceHeight1+kUserFromLabelHeight+kVerticalSpaceHeight2+kVerticalBottomMarginHeight+commentHeight+showHideHeight-9
            }
                
            else{
                height =  kVerticalCiteTopMarginHeight+kUserNameLabelHeight+kVerticalSpaceHeight1+kUserFromLabelHeight+kVerticalSpaceHeight2+kVerticalCiteBottomMarginHeight+commentHeight + showHideHeight-9;
            }
        }
        
        return height;
    }
    
    
    // MARK: delegate
    
    @objc func tap() {
        
    }
    
    @objc func voteUp(){
        
    }
    
    @objc func expand() {
        locationModel.lengthLimiation = false
        delegate?.commentTableViewCellExpand(locationModel)
    }
    
    @objc func unfold() {
        delegate?.commentTableViewCellUnfold(locationModel)
    }
}


















