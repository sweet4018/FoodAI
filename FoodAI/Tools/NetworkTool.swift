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
    
    // MARK: - Function
    
    // MARK: FoodList
    
    /// 取得Google Map 要用的完整URL
    fileprivate func getGoolgeMapCompleteURL(location: String, foodType: String) -> String{
        
        var completeURL: String = ""
        completeURL = baseGoogleMapURL + location + "+in+" + foodType + "&key=" + APIKeys.googleMapAPIKey
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
    func loadFoodListData(location: String, foodType: String, finished: @escaping (_ success: Bool, _ nextPageToken: String, [Restaurant]) -> Void) {
     
        SVProgressHUD.show(withStatus: "努力加載中...")
        
        let url: String = getGoolgeMapCompleteURL(location: location, foodType: foodType)
        
        Alamofire.request(url.urlEncoded(), method: .get).responseJSON { (response) in
            
            guard response.result.isSuccess else {
                
                SVProgressHUD.showError(withStatus: "糟糕！讀取失敗，請稍後再試")
                finished(false, "", [])
                return
            }
            
            let json = JSON(response.result.value!)
            let nextPageToken: String = json["next_page_token"].string!
            if let result = json["results"].array {
                
                finished(true, nextPageToken, self.getFoodListWithJson(result: result))
            } else {
                SVProgressHUD.showError(withStatus: "糟糕！讀取失敗，請稍後再試")
            }
            SVProgressHUD.dismiss()
        }
    }
    
    /// 取得下一頁
    func loadFoodListWithNextPage(nextPageToken: String, finished: @escaping (_ success: Bool, [Restaurant]) -> Void) {
        
        SVProgressHUD.show(withStatus: "努力加載中...")
        
        let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?pagetoken=" + nextPageToken + "=" + APIKeys.googleMapAPIKey
        
        Alamofire.request(url.urlEncoded(), method: .get).responseJSON { (response) in
            
            guard response.result.isSuccess else {
                
                SVProgressHUD.showError(withStatus: "糟糕！讀取失敗，請稍後再試")
                finished(false, [])
                return
            }
            
            let json = JSON(response.result.value!)
            
            if let result = json["results"].array {
                
                finished(true, self.getFoodListWithJson(result: result))
            } else {
                SVProgressHUD.showError(withStatus: "糟糕！讀取失敗，請稍後再試")
            }
            SVProgressHUD.dismiss()
        }
    }
}
