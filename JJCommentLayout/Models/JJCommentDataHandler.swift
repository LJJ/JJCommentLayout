//
//  JJCommentDataHandler.swift
//  JJCommentLayout
//
//  Created by Michael Lu on 4/24/18.
//  Copyright © 2018 Michael Lu. All rights reserved.
//

import Foundation

let kMaxDefaultFloorNumber = 7 //activate comment folding
let kFloorFoldNumber = 5
let kMaxNestedCount = 5

class JJCommentDataHandler{
    
    let foldNumber:Int
    
    init(foldNumber:Int) {
        self.foldNumber = foldNumber
    }
    
    func constuct(from commentDict:[String:[String:Any]],and structureInfo:[String], complete:@escaping ([JJCommentLocationModel])->Void) {
        DispatchQueue.global(qos: .default).async {
            let commentDataModels = self.dataModels(from: commentDict)
            let locationSeqList = self.locationSequenceList(from: structureInfo, and: commentDataModels)
            let tableList = self.jointLocationSequence(by: locationSeqList)
            DispatchQueue.main.async {
                complete(tableList)
            }
        }
    }
    
    
    fileprivate func dataModels(from rawDict:[String:[String:Any]]) -> [String:JJCommentDataModel] {
        var res = [String:JJCommentDataModel]()
        for (key, value) in rawDict {
            res[key] = JJCommentDataModel(with: value)
        }
        return res
    }
    
   fileprivate func locationSequenceList(from stuctionInfo:[String], and commentDataModels:[String:JJCommentDataModel]) -> [[JJCommentLocationModel]] {
        var res = [[JJCommentLocationModel]]()
        for structStr in stuctionInfo {
            guard structStr.count > 0 else {
                continue
            }
            let idList = structStr.components(separatedBy: ",")
            var partRes = [JJCommentLocationModel]()
            for commentId in idList{
                if let dataModel = commentDataModels[commentId], !dataModel.isDelete {
                    let locationModel = JJCommentLocationModel(commentKey: commentId)
                    locationModel.dataSource = dataModel
                    partRes.append(locationModel)
                }
            }
            if partRes.count>0{
                res.append(partRes)
            }
        }
        return res
    }
    
    
    fileprivate func jointLocationSequence(by locationSequenceList:[[JJCommentLocationModel]]) -> [JJCommentLocationModel] {
        var res = [JJCommentLocationModel]()
        for (index, value) in locationSequenceList.enumerated() {
            var locationSequence = value
            // comment with quote
            if locationSequence.count > 1 {
                let headerDataModel = locationSequence.last!.dataSource!
                let key = "header\(headerDataModel.commentId)"
                let headerLocationModel = JJCommentLocationModel(commentKey: key)
                headerLocationModel.dataSource = headerDataModel
                locationSequence.insert(headerLocationModel, at: 0)
                
                
                //deal with the folding case
                if locationSequence.count > kMaxDefaultFloorNumber {
                    let hideLocationModel = JJCommentLocationModel(commentKey: "hide\(index)")
                    let hiddenRange = foldNumber/2+1..<locationSequence.count-foldNumber/2
                    hideLocationModel.hideComments = Array(locationSequence[hiddenRange])
                    hideLocationModel.allComments = locationSequence
                    locationSequence.removeSubrange(hiddenRange)
                    locationSequence.insert(hideLocationModel, at: foldNumber/2+1)
                }
                locateComments(locaitonSequence: locationSequence)
            }
            res.append(contentsOf: locationSequence)
        }
        return res
    }
    
    
    // set type, floor number, nestedNumber of locationModel
    func locateComments(locaitonSequence:[JJCommentLocationModel]){
        if locaitonSequence.count == 1 {
            let locationModel = locaitonSequence.first!
            locationModel.type = .single
            locationModel.realFloorNumber = 0
            locationModel.nestedNumber = 0
            return
        }
        
        let commentAmount = locaitonSequence.count - 1
        for (index, locationModel) in locaitonSequence.enumerated(){
            locationModel.realFloorNumber = index
            if index > 0 {
                if commentAmount - locationModel.realFloorNumber >= kMaxNestedCount {
                    locationModel.nestedNumber = kMaxNestedCount
                    locationModel.type = .cite
                } else {
                    locationModel.nestedNumber = commentAmount-locationModel.realFloorNumber
                    if locationModel.hideComments == nil {
                        if locationModel.nestedNumber==0 {
                            locationModel.type = .footer
                        }
                        else {locationModel.type = .cite}
                    } else{
                        locationModel.type = .hide
                    }
                }
            }
        }
        let headerLocationModel = locaitonSequence[0]
        headerLocationModel.type = .header
        headerLocationModel.nestedNumber = locaitonSequence[1].nestedNumber
    }
}



















