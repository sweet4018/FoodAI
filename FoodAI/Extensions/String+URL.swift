//
//  String+URL.swift
//  FoodAI
//
//  Created by ChenZheng-Yang on 2018/2/1.
//  Copyright © 2018年 ChenCheng-Yang. All rights reserved.
//

import Foundation

extension String {
    
    /// 將原始的url編碼為合法的url（有中文會有問題）
    func urlEncoded() -> String {
        let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        return encodeUrlString ?? ""
    }
}
