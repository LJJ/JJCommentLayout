//
//  CommentViewController.swift
//  JJCommentLayout
//
//  Created by Michael Lu on 4/24/18.
//  Copyright © 2018 Michael Lu. All rights reserved.
//

import Foundation
import UIKit
import Darwin

let kCommentCellIdentifier = "kCommentCellIdentifier"

class CommentViewController: UIViewController, JJCommentTableViewDelegate {
    
    let table = JJCommentTableView(2)
    var popularList = [JJCommentLocationModel]()
    var latestList = [JJCommentLocationModel]()
    var inputBar:JJBottomInputView!
    var dataHandler = JJCommentDataHandler(foldNumber: 4)
    
    var page = 1
    
    var rawData:[String:Any]!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateCurrentTime()
        table.setUpUI()
        table.delegate = self
        
        inputBar = JJBottomInputView.init(event: nil)
        inputBar.translatesAutoresizingMaskIntoConstraints = false
        table.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(table)
        view.addSubview(inputBar)
        
        let allViews = ["table":table,"inputBar":inputBar] as [String : Any]
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[table][inputBar(43)]|", options: [], metrics: nil, views: allViews))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[table]|", options: [], metrics: nil, views: allViews))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[inputBar]|", options: [], metrics: nil, views: allViews))
        loadComments()
    }
    
    func loadComments(){
        if let path = Bundle.main.path(forResource: "test", ofType: "json") {
            var dict:[String:Any]!
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
            } catch {
                
            }
            if let data = dict["data"] as? [String:Any] {
                rawData = data
                if let rawComments = rawData["comments"] as? [String:[String:Any]],
                    let rawStructure = rawData["commentIds"] as? [String] {
                    table.reload(comments: rawComments, structure: Array(rawStructure[0..<10]), in: 0)
                    table.reload(comments: rawComments, structure: Array(rawStructure[0..<10]), in: 1)
                }
            }
        }
    }
    
    func loadMore(){
        if let rawComments = rawData["comments"] as? [String:[String:Any]],
            let rawStructure = rawData["commentIds"] as? [String] {
            page += 1
            if page*10<=rawStructure.count {
                
                DispatchQueue.global().async {
                    sleep(6) //simulate internet work
                    DispatchQueue.main.async {
                        self.table.append(comments: rawComments, structure: Array(rawStructure[(self.page-1)*10..<self.page*10]), in: 1)
                        self.table.setTableFooter(title: "idle", status: .idle)
                    }
                }
            }
        }
    }
    
    
    //MARK: comment tableview delegate
    func commentTableHitBottom() {
        table.setTableFooter(title: "Loading more", status: .busy)
        loadMore()
        
    }
    
    
}















