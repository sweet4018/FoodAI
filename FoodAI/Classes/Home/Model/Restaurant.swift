//
//  Restaurant.swift
//  FoodAI
//
//  Created by ChenZheng-Yang on 2018/2/1.
//  Copyright © 2018年 ChenCheng-Yang. All rights reserved.
//

import UIKit

class Restaurant: NSObject {

    var formatted_address: String?
    var name: String?
    var opening_hours: Dictionary<String, Any>?
    var open_now: Bool?
    var rating: Float?
    var photos: Array<[String: Any]>?
    var photoReference: String?
    var reference: String?
    
    init(dict: [String: Any]) {
        
        formatted_address = dict["formatted_address"] as? String ?? ""
        name = dict["name"] as? String ?? ""
        opening_hours = dict["opening_hours"] as? Dictionary ?? [:]
        open_now = self.opening_hours!["open_now"] as? Bool ?? false
        rating = dict["rating"] as? Float ?? 0.0
        
        photos = dict["photos"] as? Array ?? []
        photoReference = self.photos![0]["photo_reference"] as? String ?? ""
        reference = dict["reference"] as? String ?? ""
        
    }
}
