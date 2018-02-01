//
//  Commom.swift
//  FoodAI
//
//  Created by ChenZheng-Yang on 2018/2/1.
//  Copyright © 2018年 ChenCheng-Yang. All rights reserved.
//

import Foundation
import UIKit

///TabBar高度
let kTabBarHeight: CGFloat = (UIApplication.shared.statusBarFrame.size.height > 20.0 ? 83.0:49.0)

///Navigation Height
let kNavigationBarHeight: CGFloat = 44

///螢幕寬度
let kScreenWidth = UIScreen.main.bounds.width

///螢幕高度
let kScreenHeight = UIScreen.main.bounds.height

///主題
struct Theme {
    
    ///基本背景色
    static let baseBackgroundColor: UIColor = .black
    
    ///基本文字顏色
    static let baseFontColor: UIColor = .white
    
    ///APP導航列barButtonItem文字大小
    static let NavItemFont: UIFont = UIFont.systemFont(ofSize: 16)
    
    ///APP導航列titleFont文字大小
    static let NavTitleFont: UIFont = UIFont.systemFont(ofSize: 18)
    
    ///UIApplication.sharedApplication
    static let appShare = UIApplication.shared
}

///比例
let proportion = kScreenHeight/667

/// RGBA的顏色設置
func CYColor(r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
}

struct APIKeys {
    
    /// Google Aap API Key
    static let googleMapAPIKey = "AIzaSyBscIniWYS9Z1hmAXFoK64UNkBjR5KDw0c"
    
    /// Ai API Key
    static let aiAPIKey = "ccf8d9f15921404797a12371848090d2"
}
