//
//  JJCommentTableView.swift
//  JJCommentLayout
//
//  Created by Michael Lu on 4/29/18.
//  Copyright © 2018 Michael Lu. All rights reserved.
//

import Foundation
import UIKit

protocol JJCommentTableViewDelegate:AnyObject {
    
}

class JJCommentTableView:UIView, UITableViewDataSource, UITableViewDelegate {
    let table = UITableView()
    let sectionNumber: Int
    
    let dataHandler = JJCommentDataHandler(foldNumber: 4)
    var commentsData:[[JJCommentLocationModel]]
    
    // MARK: init method
    convenience init(_ sectionNumber:Int=2) {
        self.init(frame: .zero, sectionNumber:sectionNumber)
    }
    
    init(frame: CGRect, sectionNumber:Int) {
        self.sectionNumber = sectionNumber
        self.commentsData = Array(repeating: [JJCommentLocationModel](), count: sectionNumber)
        super.init(frame: frame)
    }
    
    override init(frame: CGRect) {
        sectionNumber = 2
        self.commentsData = Array(repeating: [JJCommentLocationModel](), count: sectionNumber)
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.sectionNumber = 2
        self.commentsData = Array(repeating: [JJCommentLocationModel](), count: sectionNumber)
        super.init(coder: aDecoder)
    }
    
    //MARK: UI
    func setUpUI(){
        table.delegate = self
        table.dataSource = self
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = RGB(246, 246, 246)
        table.register(JJCommentTableViewCell.self, forCellReuseIdentifier: kCommentCellIdentifier)
        table.separatorStyle = .none
        
        addSubview(table)
        table.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[table]|", options: [], metrics: nil, views: ["table":table]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[table]|", options: [], metrics: nil, views: ["table":table]))
    }
    
    //MARK: public method
    func reload(comments:[String:[String:Any]], structure:[String], in section:Int) {
        guard section < sectionNumber else {
            print("section should be less than sectionNumber")
            return
        }
        dataHandler.constuct(from: comments, and: structure) { (dataSource) in
            self.commentsData[section] = dataSource
            self.table.reloadData()
        }
    }
    
    func append(comments:[String:[String:Any]], structure:[String], in section:Int) {
        guard section < sectionNumber else {
            print("section should be less than sectionNumber")
            return
        }
        dataHandler.constuct(from: comments, and: structure) { (moreData) in
            self.commentsData[section].append(contentsOf: moreData)
            self.table.reloadData()
        }
        
    }
    
    
    // MARK: private
    func getLocationModel(by indexPath:IndexPath) -> JJCommentLocationModel {
        return commentsData[indexPath.section][indexPath.row];
    }
    
    //MARK: table datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return commentsData.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentsData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCommentCellIdentifier, for: indexPath) as! JJCommentTableViewCell
//        cell.delegate = self
        let model = getLocationModel(by:indexPath)
        model.enableReply = true
        model.indexPath = indexPath
        cell.setUpCell(with: model)
        return cell
    }
    
    //MARK: table delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let locationModel = getLocationModel(by: indexPath)
        let height = JJCommentTableViewCell.calculateCellHeight(with: locationModel, and: tableView.frame.size.width)
        return height
    }
    
    func commentTableViewCellExpand(_ locationModel: JJCommentLocationModel) {
        table.reloadRows(at: [locationModel.indexPath], with: .automatic)
    }
    
    func commentTableViewCellUnfold(_ locationModel: JJCommentLocationModel) {
        commentsData[0].remove(at: locationModel.indexPath.row)
        commentsData[0].insert(contentsOf:locationModel.hideComments, at: locationModel.indexPath.row)
        dataHandler.locateComments(locaitonList: locationModel.allComments!)
        table.reloadData()
    }
    
}
