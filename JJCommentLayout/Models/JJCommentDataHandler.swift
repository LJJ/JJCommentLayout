//
//  JJCommentDataHandler.swift
//  JJCommentLayout
//
//  Created by Michael Lu on 4/24/18.
//  Copyright © 2018 Michael Lu. All rights reserved.
//

import Foundation

let kMaxDefaultFloorNumber = 7
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
            let locationModelList = self.locationList(from: structureInfo, and: commentDataModels)
            let tableList = self.calculateLocation(by: locationModelList)
            DispatchQueue.main.async {
                complete(tableList)
            }
        }
    }
    
    
    func dataModels(from rawDict:[String:[String:Any]]) -> [String:JJCommentDataModel] {
        var res = [String:JJCommentDataModel]()
        for (key, value) in rawDict {
            res[key] = JJCommentDataModel(with: value)
        }
        return res
    }
    
    func locationList(from stuctionInfo:[String], and commentDataModels:[String:JJCommentDataModel]) -> [[JJCommentLocationModel]] {
        var res = [[JJCommentLocationModel]]()
        for structStr in stuctionInfo {
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
    
    
    func calculateLocation(by locationModelList:[[JJCommentLocationModel]]) -> [JJCommentLocationModel] {
        var res = [JJCommentLocationModel]()
        for (index, value) in locationModelList.enumerated() {
            var aLocationList = value
            if aLocationList.count<2{
                let locationModel = aLocationList.first!
                locationModel.type = .single
                res.append(locationModel)
            } else {
                let headerDataModel = aLocationList.last!.dataSource!
                let key = "header\(headerDataModel.commentId)"
                let headerLocationModel = JJCommentLocationModel(commentKey: key)
                headerLocationModel.dataSource = headerDataModel
                aLocationList.insert(headerLocationModel, at: 0)
                if aLocationList.count > kMaxDefaultFloorNumber {
                    let hideList = Array(aLocationList[foldNumber/2+1...aLocationList.count-foldNumber/2])
                    let hideLocationModel = JJCommentLocationModel(commentKey: "hide\(index)")
                    hideLocationModel.hideComments = hideList
                    hideLocationModel.allComments = aLocationList
                    aLocationList.removeSubrange(foldNumber/2+1...aLocationList.count-foldNumber/2)
                    aLocationList.insert(hideLocationModel, at: foldNumber/2+1)
                }
                locateComments(locaitonList: aLocationList)
                res.append(contentsOf: aLocationList)
            }
        }
        return res
    }
    
    func locateComments(locaitonList:[JJCommentLocationModel]){
        let commentAmount = locaitonList.count - 1
        for (index, locationModel) in locaitonList.enumerated(){
            locationModel.realFloorNumber = index
            if index > 0 {
                if commentAmount - locationModel.realFloorNumber >= kMaxNestedCount {
                    locationModel.nestedNumber = kMaxNestedCount
                    locationModel.type = .cite
                } else {
                    locationModel.nestedNumber = commentAmount-locationModel.realFloorNumber
                    if locationModel.hideComments == nil {
                        if locationModel.nestedNumber==0 { locationModel.type = .footer}
                        else {locationModel.type = .cite}
                    } else{
                        locationModel.type = .hide
                    }
                }
            }
        }
        let model1 = locaitonList[0]
        let model2 = locaitonList[1]
        model1.realFloorNumber = 0
        model1.nestedNumber = model2.nestedNumber
        model1.type = .header
    }
}



















