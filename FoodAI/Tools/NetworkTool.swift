//
//  NetworkTool.swift
//  FoodAI
//
//  Created by ChenZheng-Yang on 2018/2/1.
//  Copyright © 2018年 ChenCheng-Yang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class NetworkTool: NSObject {

    // MARK: - Properties
    
    static let shared = NetworkTool()
    
    let baseGoogleMapURL: String = "https://maps.googleapis.com/maps/api/place/textsearch/json?language=zh-TW&query="
    
    /// 使用過的URL要記下來以便下一頁用
    var googleMapWithNextPageURL: String! = ""
    
    var nextPageToken: String! = ""
    
    /// 有沒有更多頁
    var hasMore: Bool = false
    
    // MARK: - Function
    
    // MARK: FoodList
    
    /// 取得Google Map 要用的完整URL
    fileprivate func getGoolgeMapCompleteURL(location: String, foodType: String) -> String{
        
        var completeURL: String = ""
        completeURL = baseGoogleMapURL + location + "+in+" + foodType + "&key=" + APIKeys.googleMapAPIKey
        self.googleMapWithNextPageURL = completeURL // 記下來，下一頁時會用到
        return completeURL
    }
    
    /// 美食清單解析
    func getFoodListWithJson(result: Array<JSON>) -> [Restaurant] {
        
        var foodList: [Restaurant] = []
        
        for restaurant in result {
            
            let oneRestaurant = Restaurant(dict: restaurant.dictionaryObject!)
            foodList.append(oneRestaurant)
        }
        
        return foodList
    }
    
    /// 讀取美食清單
    func loadFoodListData(location: String, foodType: String, finished: @escaping (_ success: Bool, [Restaurant]) -> Void) {
     
        SVProgressHUD.show(withStatus: "努力加載中...")
        
        let url: String = getGoolgeMapCompleteURL(location: location, foodType: foodType)
        
        Alamofire.request(url.urlEncoded(), method: .get).responseJSON { (response) in
            
            guard response.result.isSuccess else {
                
                SVProgressHUD.showError(withStatus: "糟糕！讀取失敗，請稍後再試")
                finished(false, [])
                return
            }
            
            let json = JSON(response.result.value!)
            
            if let token = json["next_page_token"].string {
                self.nextPageToken = token
                self.hasMore = true
            } else {
                self.hasMore = false
            }
            
            if let result = json["results"].array {
                
                finished(true, self.getFoodListWithJson(result: result))
            } else {
                SVProgressHUD.showError(withStatus: "糟糕！讀取失敗，請稍後再試")
            }
            SVProgressHUD.dismiss()
        }
    }
    
    /// 取得下一頁
    func loadFoodListWithNextPage(finished: @escaping (_ success: Bool, [Restaurant]) -> Void) {
        
        SVProgressHUD.show(withStatus: "努力加載中...")
        
        // 沒有下一頁的話
        if !hasMore {
            finished(false, [])
            SVProgressHUD.dismiss()
            return
        }
        
        let url = self.googleMapWithNextPageURL + "&pagetoken=" + self.nextPageToken
        
        Alamofire.request(url.urlEncoded(), method: .get).responseJSON { (response) in
            
            guard response.result.isSuccess else {
                
                SVProgressHUD.showError(withStatus: "糟糕！讀取失敗，請稍後再試")
                finished(false, [])
                return
            }
            
            let json = JSON(response.result.value!)
            if let token = json["next_page_token"].string {
                self.nextPageToken = token
                self.hasMore = true
            } else {
                self.hasMore = false
            }
            
            if let result = json["results"].array {
                
                finished(true, self.getFoodListWithJson(result: result))
            } else {
                SVProgressHUD.showError(withStatus: "糟糕！讀取失敗，請稍後再試")
            }
            SVProgressHUD.dismiss()
        }
    }
}
