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

class CommentViewController: UIViewController {
    
    let table = JJCommentTableView(1)
    var popularList = [JJCommentLocationModel]()
    var latestList = [JJCommentLocationModel]()
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
        
        updateCurrentTime()
        table.setUpUI()
        
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
                if let rawComments = data["comments"] as? [String:[String:Any]],
                    let rawStructure = data["commentIds"] as? [String] {
                    table.reload(comments: rawComments, structure: rawStructure, in: 0)
                }
            }
            
        }
        
    }
}















