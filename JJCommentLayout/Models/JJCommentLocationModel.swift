//
//  JJCommentLocationModel.swift
//  JJCommentLayout
//
//  Created by Michael Lu on 4/23/18.
//  Copyright © 2018 Michael Lu. All rights reserved.
//

import Foundation

enum JJLocationType {
    case single, cite, header, footer, hide
}

class JJCommentLocationModel {
    let commentKey:String
    var realFloorNumber:Int!
    var nestedNumber:Int?
    var type:JJLocationType!
    var hideComments:[JJCommentLocationModel]?
    var allComments:[JJCommentLocationModel]?
    var indexPath:NSIndexPath?
    var dataSource:JJCommentDataModel!
    var voted:Bool!
    var lengthLimiation:Bool!
    var enableReply:Bool!
    
    
    init(commentKey:String){
        self.commentKey = commentKey
        self.lengthLimiation = true
    }
}
