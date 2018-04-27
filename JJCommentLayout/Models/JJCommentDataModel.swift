//
//  JJCommentDataModel.swift
//  JJCommentLayout
//
//  Created by Michael Lu on 4/23/18.
//  Copyright © 2018 Michael Lu. All rights reserved.
//

import Foundation

enum JJCommentType {
    case new, popular
}

struct JJCommentDataModel {
    let commentId:Int
    var userName:String?
    let userId:Int
    let avatar:String?
    let from:String
    let location:String
    let siteName = ""
    let content:String
    let createTime:Date
    let upNumber:Int
    let floorNumber:Int
    let isDelete:Bool
    let anonymous:Bool
    
    init?(with dict:[String:Any]) {
        
        let userInfo = dict["user"] as! [String:Any]
        guard let commentId = dict["commentId"] as? Int,
        let userId = userInfo["userId"] as? Int,
        let from = dict["ip"] as? String,
        let location = userInfo["location"] as? String,
        let content = dict["content"] as? String,
        let createTime = dict["createTime"] as? String,
        let upNumber = dict["vote"] as? Int,
        let floorNumber = dict["buildLevel"] as? Int,
        let isDelete = dict["isDel"] as? Bool,
        let anonymous = dict["anonymous"] as? Bool
        else {
            return nil
        }
        self.commentId = commentId
        self.userName = userInfo["nickname"] as? String
        if userName == nil {
            userName = "No Name"
        }
        self.userId = userId
        self.avatar = userInfo["avatar"] as? String
        self.from = from
        self.location = location
        self.content = content
        self.upNumber = upNumber
        self.floorNumber = floorNumber
        self.isDelete = isDelete
        self.anonymous = anonymous
        
        let format =  DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.createTime = format.date(from: createTime)!
    }
    
}
