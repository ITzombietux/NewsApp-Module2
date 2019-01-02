//
//  NewsTableViewController.swift
//  Module-2
//
//  Created by Reinder de Vries on 30-03-15.
//  Copyright (c) 2015 LearnAppMaking. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController
{
    /// Property with news item titles
    var titles:[String] = [
        "New York Lakers Score Again!",
        "Apple Presents New iWatch",
        "Deeplink.me Wants To Break Open App Discovery",
        "Silly Cat Attempts Jump And Hits Air",
        "New MacBook Air So Thin People Can't See It",
        "Higgs-Boson Finally Discovered In Scientists Coat"
    ]
    
    /// Property with news item authors
    var authors:[String] = [
        "Bob",
        "Alice",
        "Reinder",
        "[Your name]",
        "Ford",
        "Zaphod"
    ]

    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return titles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        // Dequeue a table view cell
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier")
        
        // If there's no cell, create one
        if(cell == nil) {
            cell = UITableViewCell(style:UITableViewCell.CellStyle.subtitle, reuseIdentifier:"cellIdentifier")
        }
        
        // Set the text and detail text
        cell!.textLabel?.text = titles[indexPath.row]
        cell!.detailTextLabel?.text = authors[indexPath.row]

        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        var detailVC:NewsDetailViewController = NewsDetailViewController(nibName: "NewsDetailViewController", bundle:nil)
        
        detailVC.title = titles[indexPath.row]
        detailVC.author = authors[indexPath.row]
        
        navigationController?.pushViewController(detailVC, animated:true)
    }
}
