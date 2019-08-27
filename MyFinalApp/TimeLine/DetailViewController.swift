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
    // 投稿情報のID
    var itemID: String = ""
    // インスタンス化
    let db = Firestore.firestore()
    
    // 配列の中身を監視する
    var itemListener: ListenerRegistration?
    
    
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
    
    // いいねボタン
    @IBOutlet weak var goodButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        top2.isHidden = true
        top3.isHidden = true
        top4.isHidden = true
        top5.isHidden = true
        
        changeGoodButton()
        
        
        // 店名
        shopName.title = item["shopName"] as? String
        // 投稿画像
        let postImg = item["postImage"] as? String
        reconversion(postImage, string: postImg)
        // 投稿者の名前
        postUserProfName.text = item["userProfName"] as? String
        // 投稿者の画像
        let profImg = item["userProfImage"] as? String
        reconversion(postUserProfImage, string: profImg)
        // base
        base.text = ("ベースドリンク : \(String(describing: item["base"] as! String))")
        // top1
        top1.text = ("+ \(String(describing: item["top1"] as! String))")
        // top2
        if item["top2"] as! String != "" {
            top2.isHidden = false
            top2.text = ("+ \(String(describing: item["top2"] as! String))")
        }
        // top3
        if item["top3"] as! String != "" {
            top3.isHidden = false
            top3.text = ("+ \(String(describing: item["top3"] as! String))")
        }
        // top4
        if item["top4"] as! String != "" {
            top4.isHidden = false
            top4.text = ("+ \(String(describing: item["top4"] as! String))")
        }
        // top5
        if item["top5"] as! String != "" {
            top5.isHidden = false
            top5.text = ("+ \(String(describing: item["top5"] as! String))")
        }
        // ice
        ice.text = ("甘さと氷の量 : \(String(describing: item["ice"] as! String))")
        // price
        price.text = ("価格 : \(String(describing: item["price"] as! String))円")
        // place
        place.text = ("場所 : \(String(describing: item["place"] as! String))")
        // time
        time.text = ("待ち時間 : \(String(describing: item["time"] as! String))分")
        
        // 監視スタート
        startLiseningForItem()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // 監視終了
        stopListeningForItem()
    }
    
    
    func changeGoodButton() {
        // いいねボタンの色
        if item["like"] as! String == "0" {
            // いいねボタンの色
            goodButton.setTitle("♡", for: .normal)
            goodButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            
        } else {
            // いいねボタンの色
            goodButton.setTitle("❤", for: .normal)
            goodButton.setTitleColor(#colorLiteral(red: 1, green: 0.1301513699, blue: 0.7420222357, alpha: 1), for: .normal)
        }
    }
    
    // ユーザーの情報をとってくる
    func startLiseningForItem() {
        itemListener = db.collection("postData").document(itemID).addSnapshotListener ({ (snapshot, error) in
            if let error = error {
                print("データ取得失敗: ", error)
                return
            }
            guard let snapShot = snapshot else {
                print("error: \(error!)")
                return
            }
            self.item = NSDictionary()
            self.item = snapShot.data()! as NSDictionary
        })

        }
    
    private func stopListeningForItem() {
        itemListener?.remove()
        itemListener = nil
    }
    
    
    @IBAction func likedPostButton(_ sender: Any) {
        if item["like"] as! String == "0" {
            // firebase更新
            db.collection("postData").document(itemID).updateData(["like": "1"])
            
            // いいねボタンの色
            goodButton.setTitle("❤", for: .normal)
            goodButton.setTitleColor(#colorLiteral(red: 1, green: 0.1301513699, blue: 0.7420222357, alpha: 1), for: .normal)
            
        } else if item["like"] as! String == "1" {
            db.collection("postData").document(itemID).updateData(["like": "0"])
            // いいねボタンの色
            goodButton.setTitle("♡", for: .normal)
            goodButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        }
    }
    
    
    
    
}
