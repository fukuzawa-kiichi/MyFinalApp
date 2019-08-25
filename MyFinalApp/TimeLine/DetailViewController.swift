//
//  DetailViewController.swift
//  MyFinalApp
//
//  Created by VERTEX24 on 2019/08/24.
//  Copyright © 2019 VERTEX24. All rights reserved.
//

import UIKit
import FirebaseFirestore

class DetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    // 投稿情報を入れる箱
    var item = NSDictionary()
    // インスタンス化
    let db = Firestore.firestore()
    

    // 店名
    @IBOutlet weak var shopName: UINavigationItem!
    // 投稿者の画像
    @IBOutlet weak var postUserProfImage: UIImageView!
    // 投稿者の名前
    @IBOutlet weak var postUserProfName: UILabel!
    // 投稿画像
    @IBOutlet weak var postImage: UIImageView!
    // ベースドリンク
    @IBOutlet weak var base: UILabel!
    // トッピング
    @IBOutlet weak var top1: UILabel!
    @IBOutlet weak var top2: UILabel!
    @IBOutlet weak var top3: UILabel!
    @IBOutlet weak var top4: UILabel!
    @IBOutlet weak var top5: UILabel!
    // 甘さと氷
    @IBOutlet weak var ice: UILabel!
    // 価格
    @IBOutlet weak var price: UILabel!
    // 場所
    @IBOutlet weak var place: UILabel!
    // 時間
    @IBOutlet weak var time: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 店名
        shopName = item["shopName"] as? UINavigationItem
        // 投稿画像
        let postImg = item["postImage"] as? String
        reconversion(postImage, string: postImg)
        // 投稿者の名前
        postUserProfName.text = item["userProfName"] as? String
        // 投稿者の画像
        let profImg = item["userProfImage"] as? String
        reconversion(postUserProfImage, string: profImg)
        // base
        base.text = item["base"] as? String
        // top1
        top1.text = item["top1"] as? String
        // top2
        top2.text = item["top2"] as? String
        // top3
        top3.text = item["top3"] as? String
        // top4
        top4.text = item["top4"] as? String
        // top5
        top5.text = item["top5"] as? String
        // ice
        ice.text = item["ice"] as? String
        // price
        price.text = item["price"] as? String
        // place
        place.text = item["place"] as? String
        // time
        time.text = item["time"] as? String
    }
    

}
