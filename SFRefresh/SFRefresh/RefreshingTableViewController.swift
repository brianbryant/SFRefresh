//
//  RefreshingTableViewController.swift
//  SFRefresh
//
//  Created by Brian on 2018/3/25.
//  Copyright © 2018年 Brian Inc. All rights reserved.
//

import UIKit

let kRefreshViewHeight: CGFloat = 2000

class RefreshingTableViewController: UITableViewController {
    
    private var refreshView: RefreshView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshView = RefreshView(frame: CGRect(x: 0, y: -kRefreshViewHeight, width: view.bounds.width, height: kRefreshViewHeight), scrollView: tableView)
        refreshView.delegate = self
        tableView.insertSubview(refreshView, at: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshView.tableViewContentOffsetY = tableView.contentOffset.y
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        #if DEBUG
            print(type(of: self), #function)
        #endif
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 30
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = "第\(indexPath.row)行"
        return cell
    }
    
    
}

extension RefreshingTableViewController: RefreshViewDelegate {
    func refreshViewDidFinish(refreshView: RefreshView) {
        sleep(3)
        refreshView.endRefreshing()
    }
}


extension RefreshingTableViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        refreshView.scrollViewDidScroll(scrollView)
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        refreshView.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
}
