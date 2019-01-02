//
//  ParseNewsTableTableViewController.swift
//  Module-2
//
//  Created by zombietux on 14/12/2018.
//  Copyright © 2018 LearnAppMaking. All rights reserved.
//

import UIKit
import Parse
import Bolts
import Alamofire

class ParseNewsTableViewController: PFQueryTableViewController {
    
    var segmentedControl:UISegmentedControl?

    override init(style: UITableView.Style, className: String!)
    {
        super.init(style: style, className: className)
        
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
        self.objectsPerPage = 25
        
        self.parseClassName = className
//        self.tableView.rowHeight = 88
        self.tableView.allowsSelection = true
    }
    
    required init(coder aDecoder:NSCoder)
    {
        fatalError("NSCoding not supported")
    }
    
    @objc func onSegmentedControlValueChanged(segmentedControl:UISegmentedControl)
    {
        self.loadObjects()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentedControl = UISegmentedControl(items: ["All", "Guides", "Interviews"])
        segmentedControl!.addTarget(self, action: #selector(onSegmentedControlValueChanged(segmentedControl:)), for: UIControl.Event.valueChanged)
        segmentedControl!.selectedSegmentIndex = 0
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 355, height: 50.0))
        headerView.addSubview(segmentedControl!)
        
        segmentedControl!.frame = CGRect(x: 10, y: 10, width: 355, height: 30)
        
        tableView.tableHeaderView = headerView
        
        tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "cellIdentifier")

    }
    
    override func queryForTable() -> PFQuery<PFObject>
    {
        var query:PFQuery = PFQuery(className:self.parseClassName ?? "")
        
        if objects != nil && objects!.count == 0
        {
            query.cachePolicy = PFCachePolicy.cacheThenNetwork
        }
        
        if segmentedControl != nil && segmentedControl!.selectedSegmentIndex > 0
        {
            query.whereKey("category", equalTo: segmentedControl!.selectedSegmentIndex == 1 ? "Guides" : "Interviews")
        }
        
        query.order(byAscending: "title")
        
        return query
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, object: PFObject?) -> PFTableViewCell?
    {
        var cell:NewsTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier") as? NewsTableViewCell
        
        if cell == nil
        {
            cell = Bundle.main.loadNibNamed("NewsTableViewCell", owner: self, options: nil)?[0] as? NewsTableViewCell
        }
        
        if  let title           = object?["title"] as? String,
            let excerpt         = object?["excerpt"] as? String,
            let thumbnailURL    = object?["thumbnailURL"] as? String
        {
            cell!.titleLabel?.text = title
            cell!.excerptLabel?.text = excerpt
            
            Alamofire.request(thumbnailURL).responseData {
                response in
                
                if let data = response.result.value {
                    cell!.thumbnailView?.image = UIImage(data: data)
                }
            }
        }
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        var detailVC:NewsDetailViewController = NewsDetailViewController(nibName: "NewsDetailViewController", bundle:nil)
        
        if  let object = self.object(at: indexPath),
            let title = object["title"] as? String,
            let excerpt = object["excerpt"] as? String,
            let thumbnailURL = object["thumbnailURL"] as? String,
            let articleURL = object["articleURL"] as? String
        {
            var article:Article = Article()
            article.title = title
            article.content = excerpt
            article.thumbnailURL = thumbnailURL
            article.articleURL = articleURL
            
            detailVC.article = article
            detailVC.title = title
        }
        
        navigationController?.pushViewController(detailVC, animated:true)
    }
}
