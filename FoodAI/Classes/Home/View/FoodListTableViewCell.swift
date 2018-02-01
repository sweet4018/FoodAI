//
//  FoodListTableViewCell.swift
//  FoodAI
//
//  Created by ChenZheng-Yang on 2018/2/1.
//  Copyright © 2018年 ChenCheng-Yang. All rights reserved.
//

import UIKit
import SDWebImage

class FoodListTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    static let className: String = "FoodListTableViewCell"
    static let cellReuseIdentifier: String = "foodListCell"
    
    @IBOutlet weak var openNowLb: UILabel!
    @IBOutlet weak var ratingLb: UILabel!
    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var addressLb: UILabel!
    
    @IBOutlet weak var mainImageView: UIImageView!
    
    var restaurant: Restaurant? {
        didSet {
            
            openNowLb.text = (restaurant?.open_now!)! ? "營業中" : "休息中"
            ratingLb.text = "評價：" + String(format:"%.1f", (restaurant?.rating)!)
            nameLb.text = restaurant?.name!
            addressLb.text = restaurant?.formatted_address!
            
            let url: URL = URL(string: self.getPhotoUrl(photoreference: (restaurant?.photoReference!)!))!
            mainImageView.sd_setImage(with: url, completed: nil)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    // MARK: - Process Photo
    
    fileprivate func getPhotoUrl(photoreference: String) -> String {
        
        let url: String = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=" + String(format:"%.0f", kScreenWidth) + "&photoreference=" + photoreference + "&key=" + APIKeys.googleMapAPIKey

        return url
    }
    
}
