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
    func commentTableHitBottom()
}

class JJCommentTableView:UIView, UITableViewDataSource, UITableViewDelegate {
    let table = UITableView()
    let sectionNumber: Int
    
    weak var delegate:JJCommentTableViewDelegate?
    
    let dataHandler = JJCommentDataHandler(foldNumber: 4)
    var commentsData:[[JJCommentLocationModel]]
    var tableFooterView:JJTableFooterView!
    var sectionFooterViews = [JJTableSectionFooterView]()
    
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
        
        tableFooterView = JJTableFooterView(frame: CGRect(x: 0, y: 0, width: 0, height: 65))
        table.tableFooterView = tableFooterView
        tableFooterView.autoresizingMask = [.flexibleWidth]
    }
    
    //MARK: public method
    func reload(comments:[String:[String:Any]], structure:[String], in section:Int) {
        guard section < sectionNumber else {
            print("section should be less than sectionNumber")
            return
        }
        commentsData[section] = dataHandler.constuct(from: comments, and: structure)
        table.reloadData()
    }
    
    func append(comments:[String:[String:Any]], structure:[String], in section:Int) {
        guard section < sectionNumber else {
            print("section should be less than sectionNumber")
            return
        }
        
        commentsData[section].append(contentsOf: dataHandler.constuct(from: comments, and: structure))
        table.reloadData()
    }
    
    func setFooter(title:String, status:FooterStatus, in section:Int) {
        let footer = sectionFooterViews[section]
        footer.change(to: status, with: title)
    }
    
    func setTableFooter(title:String, status:FooterStatus) {
        tableFooterView.change(to: status, with: title)
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
        let model = getLocationModel(by:indexPath)
        model.enableReply = true
        model.indexPath = indexPath
        cell.setUpCell(with: model)
        cell.unfoldBtn.addTarget(self, action: #selector(unfold(sender:)), for: .touchUpInside)
        cell.showAllBtn.addTarget(self, action: #selector(expand(sender:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 37))
        header.backgroundColor = .clear
        let bgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 70, height: 37))
        bgView.image = UIImage(named: "header")
        bgView.backgroundColor = .clear
        bgView.contentMode = .left
        header.addSubview(bgView)
        let label = UILabel(frame: CGRect(x: 0, y: 5, width: 70, height: 30))
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .white
        label.backgroundColor = .clear
        label.text = section == 0 ? "Hot":"New"
        header.addSubview(label)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 37
    }
    
    //MARK: table delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let locationModel = getLocationModel(by: indexPath)
        let height = JJCommentTableViewCell.calculateCellHeight(with: locationModel, and: tableView.frame.size.width)
        return height
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableFooterView.getStatus() == .idle {
            delegate?.commentTableHitBottom()
        }
    }
    
    
    //MARK: Cell action
    @objc func expand(sender:UIButton) {
        let cell = sender.superview!.superview! as! JJCommentTableViewCell
        cell.locationModel.lengthLimiation = false
        table.reloadRows(at: [cell.locationModel.indexPath], with: .automatic)
    }
    
    @objc func unfold(sender:UIButton) {
        let cell = sender.superview!.superview! as! JJCommentTableViewCell
        let locationModel = cell.locationModel!
        commentsData[locationModel.indexPath.section].remove(at:locationModel.indexPath.row)
        commentsData[locationModel.indexPath.section].insert(contentsOf: locationModel.hideComments, at: locationModel.indexPath.row)
        dataHandler.locateComments(locaitonSequence: locationModel.allComments)
        table.reloadData()
    }
    
}
