//
//  ViewController.swift
//  JJCommentLayout
//
//  Created by Michael Lu on 4/18/18.
//  Copyright © 2018 Michael Lu. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    
    var brower = WKWebView(frame: .zero)
    var inputBar:JJBottomInputView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        brower.navigationDelegate = self
        inputBar = JJBottomInputView(){
            [unowned self] in
            self.showList()
        }
        
        view.addSubview(brower)
        view.addSubview(inputBar)

        brower.translatesAutoresizingMaskIntoConstraints = false
        inputBar.translatesAutoresizingMaskIntoConstraints = false
        
        let allViews = ["brower":brower, "inputBar":inputBar] as [String : Any]
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[brower][inputBar(43)]|", options: [], metrics: nil, views: allViews))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[brower]|", options: [], metrics: nil, views: allViews))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[inputBar]|", options: [], metrics: nil, views: allViews))
        
        
        
        if let url = URL(string: "https://www.youtube.com"){
            let req = URLRequest(url:url)
            brower.load(req)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //wk delegate
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }

    func showList() {
        performSegue(withIdentifier: "ShowComment", sender: nil)
    }

}

