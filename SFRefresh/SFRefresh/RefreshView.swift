//
//  RefreshView.swift
//  SFRefresh
//
//  Created by brian on 2018/5/8.
//  Copyright © 2018年 Brian Inc. All rights reserved.
//

import UIKit

let kSceneHeight: CGFloat = 120

class RefreshView: UIView {

    private unowned var scrollView: UIScrollView
    var tableViewContentOffsetY: CGFloat = 0
    private var progress: CGFloat = 0
    var refreshItems = [RefreshItem]()
    
    init(frame: CGRect, scrollView: UIScrollView) {
        self.scrollView = scrollView
        super.init(frame: frame)
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
        // 1. 刷新视图可见区域的高度
        let refreshViewVisibleHeight = tableViewContentOffsetY - scrollView.contentOffset.y
        // 2. 计算当前的滚动进度
        progress = min(1, refreshViewVisibleHeight / kSceneHeight)
        // 3. 根据进度改变RefreshView背景色
        updateBackgroundColor()
        // 4. 根据进度改变RefreshItem的位置
        updateRefreshItemPositions()
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
