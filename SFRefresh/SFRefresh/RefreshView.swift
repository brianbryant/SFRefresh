//
//  RefreshView.swift
//  SFRefresh
//
//  Created by brian on 2018/5/8.
//  Copyright © 2018年 Brian Inc. All rights reserved.
//

import UIKit

let kSceneHeight: CGFloat = 120

protocol RefreshViewDelegate: class {
    func refreshViewDidFinish(refreshView: RefreshView)
}

class RefreshView: UIView {

    private unowned var scrollView: UIScrollView
    var tableViewContentOffsetY: CGFloat = 0
    private var progress: CGFloat = 0
    var refreshItems = [RefreshItem]()
    
    var isRefreshing = false
    weak var delegate: RefreshViewDelegate?
    
    init(frame: CGRect, scrollView: UIScrollView) {
        self.scrollView = scrollView
        super.init(frame: frame)
        clipsToBounds = true
        updateBackgroundColor()
        setupRefreshItems()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RefreshView {
    
    func setupRefreshItems() {
        
        let buildingImageView = UIImageView(image: UIImage(named: "buildings"))
        let sunImageView = UIImageView(image: UIImage(named: "sun"))
        let groundImageView = UIImageView(image: UIImage(named: "ground"))
        let capeBackImageView = UIImageView(image: UIImage(named: "cape_back"))
        let catImageView = UIImageView(image: UIImage(named: "cat"))
        let capeFrontImageView = UIImageView(image: UIImage(named: "cape_front"))
        
        refreshItems = [
            RefreshItem(view: buildingImageView, centerEnd: CGPoint(x: scrollView.bounds.midX, y: bounds.height - groundImageView.bounds.height - buildingImageView.bounds.height * 0.5), parallaxRatio: 1.5, sceneHeight: kSceneHeight),
            RefreshItem(view: sunImageView, centerEnd: CGPoint(x: bounds.width * 0.1, y: bounds.height - groundImageView.bounds.height - sunImageView.bounds.height), parallaxRatio: 3, sceneHeight: kSceneHeight),
            RefreshItem(view: groundImageView, centerEnd: CGPoint(x: scrollView.bounds.midX, y: bounds.height - groundImageView.bounds.height * 0.5), parallaxRatio: 0.5, sceneHeight: kSceneHeight),
            RefreshItem(view: capeBackImageView, centerEnd: CGPoint(x: scrollView.bounds.midX, y: bounds.height - groundImageView.bounds.height * 0.5 - capeBackImageView.bounds.height * 0.5), parallaxRatio: -1, sceneHeight: kSceneHeight),
            RefreshItem(view: catImageView, centerEnd: CGPoint(x: scrollView.bounds.midX, y: bounds.height - groundImageView.bounds.height * 0.5 - catImageView.bounds.height * 0.5), parallaxRatio: 1, sceneHeight: kSceneHeight),
            RefreshItem(view: capeFrontImageView, centerEnd: CGPoint(x: scrollView.bounds.midX, y: bounds.height - groundImageView.bounds.height * 0.5 - capeFrontImageView.bounds.height * 0.5), parallaxRatio: -1, sceneHeight: kSceneHeight),
        ]
        
        for refreshItem in refreshItems {
            addSubview(refreshItem.view)
        }
    }
}

extension RefreshView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        print("scrollView.contentInset.top", scrollView.contentInset.top, "scrollView.contentOffset.y = ", scrollView.contentOffset.y)
        
        if isRefreshing {
            return
        }
        
        // 1. 刷新视图可见区域的高度
        let refreshViewVisibleHeight = tableViewContentOffsetY - scrollView.contentOffset.y
        // 2. 计算当前的滚动进度
        progress = min(1, refreshViewVisibleHeight / kSceneHeight)
        // 3. 根据进度改变RefreshView背景色
        updateBackgroundColor()
        // 4. 根据进度改变RefreshItem的位置
        updateRefreshItemPositions()
    }
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print("isRefreshing = ", isRefreshing, "progress = ", progress)
        if !isRefreshing && progress == 1 {
            print("begin scrollView.contentOffset.y", scrollView.contentOffset.y, "targetContentOffset.pointee.y = ", targetContentOffset.pointee.y)
            beginRefreshing()
            targetContentOffset.pointee = CGPoint(x: 0, y: -scrollView.contentInset.top)
//            targetContentOffset.pointee.y -= scrollView.contentInset.top
//            scrollView.setContentOffset(CGPoint(x: 0, y: -scrollView.contentInset.top), animated: true)
            print("scrollView.contentOffset.y", scrollView.contentOffset.y, "targetContentOffset.pointee = ", targetContentOffset.pointee)
            delegate?.refreshViewDidFinish(refreshView: self)
        }
    }
}

extension RefreshView {
    
    func beginRefreshing() {
        isRefreshing = true
        UIView.animate(withDuration: 2, delay: 0, options: .curveEaseInOut, animations: {
            self.scrollView.contentInset.top += kSceneHeight
        }) { (isFinished) in
            print("begin isFinished = ", isFinished)
        }
    }
    
    func endRefreshing() {
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
            self.scrollView.contentInset.top -= kSceneHeight
        }) { (isFinished) in
            print("end isFinished = ", isFinished)
            self.isRefreshing = false
        }
    }
}

extension RefreshView {
    func updateBackgroundColor() {
        backgroundColor = UIColor(white: 0.7 * progress + 0.2, alpha: 1.0)
    }
    
    func updateRefreshItemPositions() {
        for refreshItem in refreshItems {
            refreshItem.updateViewPositionForProgress(progress: progress)
        }
    }
}
