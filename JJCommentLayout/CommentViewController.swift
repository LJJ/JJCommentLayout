//
//  CommentViewController.swift
//  JJCommentLayout
//
//  Created by Michael Lu on 4/24/18.
//  Copyright © 2018 Michael Lu. All rights reserved.
//

import Foundation
import UIKit

let kCommentCellIdentifier = "kCommentCellIdentifier"

class CommentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let table = UITableView()
    var popularList:[JJCommentLocationModel]!
    var latestList:[JJCommentLocationModel]!
    var inputBar:JJBottomInputView!
    var dataHandler = JJCommentDataHandler(foldNumber: 4)
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputBar = JJBottomInputView.init(event: nil)
        inputBar.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = RGB(r: 246, g: 246, b: 246)
        table.register(JJCommentTableViewCell.self, forCellReuseIdentifier: kCommentCellIdentifier)
        table.separatorStyle = .none
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
                if let rawComments = data["comments"] as? [String:Any],
                    let rawStructure = data["commentIds"] as? [String] {
                    dataHandler.constuct(from: rawComments, and: rawStructure){(dataSource) -> Void in
                        
                    }
                }
            }
            
        }
        
    }
    
//table datasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return popularList.count
        } else {
            return latestList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCommentCellIdentifier, for: indexPath)
        
        return cell
    }
    
//table delegate
}















