//
//  HomeViewController.swift
//  FoodAI
//
//  Created by ChenZheng-Yang on 2018/1/31.
//  Copyright © 2018年 ChenCheng-Yang. All rights reserved.
//

import UIKit
import ApiAI
import AVFoundation

class HomeViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var mainLb: UILabel!
    
    @IBOutlet weak var messageTextField: UITextField!
    
    var foodTypeStr: String = ""
    var locationStr: String = ""
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        setData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - setData
    
    fileprivate func setData() {
        
        messageTextField.delegate = self
    }

    // MARK: - Button Action
    
    @IBAction func sendMessageAction(_ sender: Any) {
        
        processAiAPI()
    }
    
    // MARK: - 語音處理
    
    let speechSynthesizer = AVSpeechSynthesizer()
    
    /// 說話
    func speechAndText(text: String) {
        
        let speechUtterance = AVSpeechUtterance(string: text)
        speechSynthesizer.speak(speechUtterance)
        UIView.animate(withDuration: 2.0, delay: 0.0, options: .curveEaseInOut, animations: {
            self.mainLb.text = text
        }, completion: nil)
    }
    
    // MARK: - AI API 處理
    func processAiAPI() {
        
        let request = ApiAI.shared().textRequest()
        
        if let text = self.messageTextField.text, text != "" {
            request?.query = text
        } else {
            return
        }
        
        // AI API回傳處理
        request?.setMappedCompletionBlockSuccess({ (request, response) in
            
            let response = response as! AIResponse
            
            if let textResponse = response.result.fulfillment.messages[0]["speech"] {
                
                // 若有得到參數
                if let par = response.result.parameters {
                    
                    if let foodType = par["FoodType"], let location = par["Location"] {
                        
                        self.foodTypeStr = (foodType as! AIResponseParameter).stringValue!
                        self.locationStr = (location as! AIResponseParameter).stringValue!
                        
                        // 獲得到想吃的類型及位置
                        if self.foodTypeStr.count > 0 && self.locationStr.count > 0 {
                            
                            print("想吃什麼\(self.foodTypeStr)  在哪？\(self.locationStr)")
                            self.performSegue(withIdentifier: "showFoodList", sender: nil)
                        }
                    }
                }
                
                self.speechAndText(text: textResponse as! String)
            }
            
        }, failure: { (request, error) in
            print(error!)
        })
        
        // 發起要求
        ApiAI.shared().enqueue(request)
        messageTextField.text = ""
    }
}

// MARK: - TextField Delegate
extension HomeViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        processAiAPI()
        
        return true
    }
}

// MARK: - Segue
extension HomeViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showFoodList" {
            
            let destinationVC = segue.destination as! FoodListViewController
            destinationVC.foodType = foodTypeStr
            destinationVC.location = locationStr
        }
    }
    
}
