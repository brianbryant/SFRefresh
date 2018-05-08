//
//  RefreshItem.swift
//  SFRefresh
//
//  Created by brian on 2018/5/8.
//  Copyright © 2018年 Brian Inc. All rights reserved.
//

import UIKit

class RefreshItem {
    
    unowned var view: UIView
    private var centerEnd: CGPoint
    private var centerStart: CGPoint

    init(view: UIView, centerEnd: CGPoint, parallaxRatio: CGFloat, sceneHeight: CGFloat) {
        self.view = view
        self.centerStart = CGPoint(x: centerEnd.x, y: centerEnd.y + (parallaxRatio * sceneHeight))
        self.centerEnd = centerEnd
        self.view.center = centerStart
    }
    
    func updateViewPositionForProgress(progress: CGFloat) {
        view.center = CGPoint(
            x: centerStart.x + (centerEnd.x - centerStart.x) * progress,
            y: centerStart.y + (centerEnd.y - centerStart.y) * progress
        )
    }
}
