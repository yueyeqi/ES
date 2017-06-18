//
//  NewsViewController.swift
//  es_club
//
//  Created by 岳业骑 on 2017/6/7.
//  Copyright © 2017年 岳业骑. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {

    var segmentCtr: HMSegmentedControl?
    var webViewProgressView: NJKWebViewProgressView?
    var webViewProgress: NJKWebViewProgress?
    
    let scrollView: UIScrollView! = UIScrollView()
    var webView: UIWebView?
    var table: UITableView?
    var indexSelect: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createSegment()
        createScrollView()
        webView?.loadRequest(URLRequest(url: URL(string: "http://news.maxjia.com/maxnews/app/detail/lol/71512")!))
    }
    
    //设置分段
    func createSegment() {
        segmentCtr = HMSegmentedControl(sectionTitles: ["正文", "评论"])
        segmentCtr?.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 30)
        segmentCtr?.backgroundColor = UIColor.DefalutColor()
        
        segmentCtr?.titleTextAttributes = NSDictionary(objects: [UIColor.lightGray, UIFont.systemFont(ofSize: 14)], forKeys: [NSForegroundColorAttributeName as NSCopying, NSFontAttributeName as NSCopying]) as! [AnyHashable : Any]
        
        segmentCtr?.selectedTitleTextAttributes = NSDictionary(object: UIColor.white, forKey: NSForegroundColorAttributeName as NSCopying) as! [AnyHashable : Any]
        
        segmentCtr?.selectionStyle = .arrow
        segmentCtr?.segmentWidthStyle = .fixed
        segmentCtr?.selectionIndicatorLocation = .down
        segmentCtr?.selectionIndicatorColor = UIColor.white
        
//        segmentCtr?.addTarget(self, action: #selector(segmentedControlChangedValue(segCtr:)), for: UIControlEvents.valueChanged)
        
        view.addSubview(segmentCtr!)
    }
    
    func createScrollView() {
        scrollView.delegate = self
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(30)
            make.left.equalTo(view).offset(0)
            make.right.equalTo(view).offset(0)
            make.bottom.equalTo(view).offset(0)
        }
        
        webView?.removeFromSuperview()
        table?.removeFromSuperview()
        
        //webView设置
        webView = UIWebView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        webView?.scrollView.bounces = false
        webView?.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        webView?.scalesPageToFit = true
        webView?.isMultipleTouchEnabled = true
        webView?.isUserInteractionEnabled = true
        createWebProgress()
        
        //table设置
        table = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 50), style: .grouped)
        table?.delegate = self
        table?.dataSource = self
        table?.backgroundColor = UIColor.groupTableViewBackground
        table?.separatorColor = table?.backgroundColor
        
        //cell设置
        table?.register(UINib(nibName: "homeCell", bundle: nil), forCellReuseIdentifier: "homeCell")
        
        scrollView.addSubview(webView!)
        scrollView.addSubview(table!)
        
        webView?.snp.makeConstraints({ (make) in
            make.leading.equalTo(scrollView.snp.leading)
            make.top.equalTo(scrollView.snp.top)
//            make.trailing.equalTo((table?.snp.trailing)!)
            make.bottom.equalTo(scrollView.snp.bottom)
            make.width.equalTo(view)
            make.height.equalTo(scrollView.snp.height)
        })
        
        table?.snp.makeConstraints({ (make) in
            make.leading.equalTo((webView?.snp.trailing)!)
            make.top.equalTo(scrollView.snp.top)
            make.bottom.equalTo(scrollView.snp.bottom)
            make.width.equalTo(view)
            make.height.equalTo(scrollView.snp.height)
            make.trailing.equalTo(scrollView.snp.trailing)
        })
        
    }
    
    
    //  创建webView进度条
    func createWebProgress() {
        webViewProgress = NJKWebViewProgress()
        webView?.delegate = webViewProgress
        webViewProgress?.webViewProxyDelegate = self
        webViewProgress?.progressDelegate = self
        
        let navBounds: CGRect = (self.navigationController?.navigationBar.bounds)!
        let barFrame = CGRect(x: 0, y: navBounds.size.height + 28, width: navBounds.size.width, height: 2)
        
        webViewProgressView = NJKWebViewProgressView(frame: barFrame)
        webViewProgressView?.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleTopMargin]
        webViewProgressView?.setProgress(0, animated: true)
        self.navigationController?.navigationBar.addSubview(webViewProgressView!)
    }

}

extension NewsViewController: UIScrollViewDelegate {
    
    //ScrollView切换tableview刷新事件
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == scrollView {
            let contentOffsetX = scrollView.contentOffset.x
            let index = Int(contentOffsetX/UIScreen.main.bounds.width)
            segmentCtr?.setSelectedSegmentIndex(UInt(index), animated: true)
            indexSelect = (segmentCtr?.selectedSegmentIndex)! + 1
        }
    }
    
}

extension NewsViewController: UIWebViewDelegate {
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
    }
}

extension NewsViewController: NJKWebViewProgressDelegate {
    func webViewProgress(_ webViewProgress: NJKWebViewProgress!, updateProgress progress: Float) {
        webViewProgressView?.setProgress(progress, animated: true)
    }
    
}

//MARK: - TableView代理事件
extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! homeCell
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "newsID", sender: nil)
    }
    
}
