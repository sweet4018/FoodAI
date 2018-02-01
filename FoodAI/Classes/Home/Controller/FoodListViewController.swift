//
//  FoodListViewController.swift
//  FoodAI
//
//  Created by ChenZheng-Yang on 2018/2/1.
//  Copyright © 2018年 ChenCheng-Yang. All rights reserved.
//

import UIKit
import Alamofire
import MJRefresh

class FoodListViewController: UIViewController {

    // MARK: - Properties
    
    public var location: String!
    public var foodType: String!
    
    var restaurants = [Restaurant]()
    
    @IBOutlet weak var mainTableView: UITableView!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigation()
        setData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
    
    fileprivate func setNavigation() {
        
        title = "在\(location!)好吃的\(foodType!)"
    }
    
    // MARK: - Set Data
    
    fileprivate func setData() {

        // TableView
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.register(UINib(nibName: FoodListTableViewCell.className, bundle: nil), forCellReuseIdentifier: FoodListTableViewCell.cellReuseIdentifier)
        mainTableView.refreshControl = UIRefreshControl()
        mainTableView.refreshControl?.backgroundColor = .white
        mainTableView.refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
        let footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(lodaDataWithNextPage))
        footer?.stateLabel.text = "正在幫你找更棒的餐廳"
        footer?.stateLabel.isHidden = false
        mainTableView.mj_footer = footer
        
        loadData()
    }

    // MARK: - Load Data
    
    @objc func loadData() {
        
        self.mainTableView.refreshControl?.beginRefreshing()
        NetworkTool.shared.loadFoodListData(location: location, foodType: foodType) { [weak self](success, data) in
            
            if success {
                self!.restaurants.removeAll()
                self!.restaurants = data
                self!.mainTableView.reloadData()
            }
            self!.mainTableView.refreshControl?.endRefreshing()
        }
    }
    
    @objc func lodaDataWithNextPage() {

        self.mainTableView.mj_footer.beginRefreshing()

        NetworkTool.shared.loadFoodListWithNextPage { [weak self](success, data) in
            
            if success {
                
                self!.restaurants += data
                self!.mainTableView.reloadData()
            }
            self!.mainTableView.mj_footer?.endRefreshing()
        }
    }
}

extension FoodListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: FoodListTableViewCell.cellReuseIdentifier, for: indexPath) as! FoodListTableViewCell
        cell.restaurant = restaurants[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    
}
