//
//  TemplateController.swift
//  Easy Group Messaging
//
//  Created by studenty on 23/12/14.
//  Copyright (c) 2014 studenty. All rights reserved.
//

import UIKit

class TemplateController: UITableViewController {
    
    var categoryName: String!
    
    var getListUrl = ""
    var data = [MessageTemplate]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getListUrl = Category.baseUrl + "GetMessages.ashx"
        getListUrl += "?ContentLangCode=en-US"
        getListUrl += "&Category=" + categoryName
        
        fetch()
    }
    
    func fetch(){
        self.data = []
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
            NSLog("Downloading started! For: " + self.getListUrl)
            var query = self.getListUrl
            query = query.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            let nsurl = NSURL(string: query)
            let noJsonData = NSData(contentsOfURL: nsurl!)
            let nsdata = NSData(contentsOfURL: nsurl!)
            let json = NSJSONSerialization.JSONObjectWithData(nsdata!, options: NSJSONReadingOptions.AllowFragments, error: nil) as 	[String: AnyObject]
            
            if let Data: AnyObject = json["Data"] {
                let dataValue = Data as [[String: AnyObject]]
                for category in dataValue {
                    var item = MessageTemplate()
                    item.date = category["Date"] as String
                    item.likeCount = category["LikeCount"] as Int
                    item.text = category["Text"] as String
                    
                    self.data.append(item)
                }
                dispatch_async(dispatch_get_main_queue(), {
                    NSLog("Downloading finished!")
                    self.tableView.reloadData()
                })
            }
        })
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
        
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TemplateTextCell") as UITableViewCell
        let template = data[indexPath.item]
        cell.textLabel!.text = template.text
        cell.detailTextLabel?.text = template.date
        
        return cell
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}