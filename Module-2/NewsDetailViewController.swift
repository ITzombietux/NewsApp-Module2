//
//  NewsDetailViewController.swift
//  Module-2
//
//  Created by Reinder de Vries on 25/09/2018.
//  Copyright © 2018 LearnAppMaking. All rights reserved.
//

import UIKit
import WebKit
import Alamofire

class NewsDetailViewController: UIViewController, WKNavigationDelegate
{
    @IBOutlet weak var imageView:UIImageView?
    @IBOutlet weak var titleLabel:UILabel?
    @IBOutlet weak var authorLabel:UILabel?
    @IBOutlet weak var webView:WKWebView?
    @IBOutlet weak var heightConstraint:NSLayoutConstraint?
    var author:String?
    
    var article:Article?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if article == nil {
            return
        }
        
        self.title = article!.title
        
        titleLabel?.text = article!.title
        authorLabel?.text = article!.author
        
        webView?.navigationDelegate = self
        webView?.scrollView.isScrollEnabled = false
        
        webView?.loadHTMLString("""
            <html>
            <head>
            <style>body { font-family: -apple-system, Helvetica; sans-serif; }</style>
            <meta name="viewport" content="width=device-width, initial-scale=1">
            </head>
            <body>
            <p>\(article!.content)</p>
            <p><a href="\(article!.articleURL)">Read the full article</a></p>
            </body>
            </html>
            """, baseURL: nil)
        
        imageView?.image = nil
        
        if let thumbnailURL:URL = URL(string:article!.thumbnailURL)
        {
            Alamofire.request(thumbnailURL).responseData { response in
                
                if let data = response.result.value {
                    self.imageView?.image = UIImage(data: data)
                }
            }
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)
    {
        webView.evaluateJavaScript("document.readyState", completionHandler: { result, error in
            
            if result == nil || error != nil {
                return
            }
            
            webView.evaluateJavaScript("document.body.offsetHeight", completionHandler: { result, error in
                if let height = result as? CGFloat {
                    self.heightConstraint?.constant = height
                }
            })
        })
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void)
    {
        if navigationAction.navigationType == .linkActivated
        {
            if let url = navigationAction.request.url
            {
                decisionHandler(.cancel)
                UIApplication.shared.openURL(url)
                return
            }
        }
        
        decisionHandler(.allow)
    }
}
