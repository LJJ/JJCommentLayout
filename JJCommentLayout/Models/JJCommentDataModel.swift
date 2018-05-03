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
    let userName:String
    let userId:Int
    let avatar:String?
    let from:String
    let location:String
    let siteName:String? = nil
    let content:String
    let createTime:Date?
    let upNumber:Int
    let floorNumber:Int
    let isDelete:Bool
    let anonymous:Bool
    
    init(with dict:[String:Any]) {
        
        let userInfo = dict["user"] as! [String:Any]
        commentId = dict["commentId"] as? Int ?? 0
        userName = userInfo["nickname"] as? String ?? "No name"
        userId = userInfo["userId"] as? Int ?? 0
        avatar = userInfo["avatar"] as? String
        from = dict["ip"] as? String ?? ""
        location = userInfo["location"] as? String ?? ""
        content = dict["content"] as? String ?? ""
        
        let format =  DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        createTime = format.date(from:dict["createTime"] as? String ?? "")
        
        upNumber = dict["vote"] as? Int ?? 0
        floorNumber = dict["buildLevel"] as? Int ?? 0
        isDelete = dict["isDel"] as? Bool ?? false
        anonymous = dict["anonymous"] as? Bool ?? false
        
    }
    
}
