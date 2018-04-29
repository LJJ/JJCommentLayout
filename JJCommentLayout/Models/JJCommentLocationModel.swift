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
    var indexPath:IndexPath!
    var dataSource:JJCommentDataModel!
    var voted = false
    var lengthLimiation:Bool!
    var enableReply = true
    
    
    init(commentKey:String){
        self.commentKey = commentKey
        self.lengthLimiation = true
    }
}
