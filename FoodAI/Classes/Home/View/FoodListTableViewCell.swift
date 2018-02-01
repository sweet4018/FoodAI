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
        
        //https://lh4.googleusercontent.com/-1wzlVdxiW14/USSFZnhNqxI/AAAAAAAABGw/YpdANqaoGh4/s1600-w400/Google%2BSydney
        
        //https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=CmRaAAAAuPkibOAOJhs6zo0LdbNQcUKkJ-9yx_6yv5wBueWyXasuZuyk1A3XBl-yDBuPdlBIqm4leIfithLcs2rpb224tFOe7YxokRq74U1aVLF_o1M953DkM1prK2ct7iNk58q3EhBCiVf3M87kRJzqnHMYMSqCGhQjVviU8x0_WrwkJ8XC6JnWV3bipg&key=AIzaSyBscIniWYS9Z1hmAXFoK64UNkBjR5KDw0c

        //https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=CnRtAAAATLZNl354RwP_9UKbQ_5Psy40texXePv4oAlgP4qNEkdIrkyse7rPXYGd9D_Uj1rVsQdWT4oRz4QrYAJNpFX7rzqqMlZw2h2E2y5IKMUZ7ouD_SlcHxYq1yL4KbKUv3qtWgTK0A6QbGh87GB3sscrHRIQiG2RrmU_jF4tENr9wGS_YxoUSSDrYjWmrNfeEHSGSc3FyhNLlBU&key=AIzaSyBscIniWYS9Z1hmAXFoK64UNkBjR5KDw0c
        
// CmRbAAAAhOFZHaRJxz6xPoPoMi1QWPD293ssZD-r87le03gFB5sdxMIGpOBkq_WzyzYZ9uauCxxQhKMdOZSI_Vib6Te82tdVpeihsjn4cxiuy1JIp7CUFyWF_zh0n2vhJ5e92WLiEhAsExMu7SzjRvt88NexNaQRGhQhBLKbcb3QyiZu-MN4ZAMIafpxzQ
        
        return url
    }
    
}
