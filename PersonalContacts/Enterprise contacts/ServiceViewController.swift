//
//  ServiceViewController.swift
//  Enterprise contacts
//
//  Created by andrey on 3/1/16.
//  Copyright © 2016 Andrey. All rights reserved.
//

import UIKit

class ServiceViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    let xmlUrlString = "http://storage.space-o.ru/testXmlFeed.xml"
    
    override func viewDidLayoutSubviews() {
        if let rect = self.navigationController?.navigationBar.frame {
            let y = rect.size.height + rect.origin.y
            self.textView.contentInset = UIEdgeInsetsMake(y, 0, self.bottomLayoutGuide.length, 0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        self.navigationItem.title = "Service"
        
        spinner?.startAnimating()

        let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
        dispatch_async(dispatch_get_global_queue(qos, 0)) {
            guard let xmlUrl = NSURL(string: self.xmlUrlString) else {return}
            let xmlData = NSData(contentsOfURL: xmlUrl)
            dispatch_async(dispatch_get_main_queue()) {
                do {
                    if let data = xmlData{
                        let xmlDoc = try AEXMLDocument(xmlData: data)
                        
                        if let quotes = xmlDoc.root["quotes"]["quote"].all {
                            for quote in quotes {
                                let date = quote["date"].stringValue
                                let text = quote["text"].stringValue
                                self.textView.text? += "\(date)\n\(text)\n\n"
                            }
                        }
                        self.spinner.stopAnimating()
                    }
                } catch {
                    print("\(error)")
                }
            }
        }
    }
}
