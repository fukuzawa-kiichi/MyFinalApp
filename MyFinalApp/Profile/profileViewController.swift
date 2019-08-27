//
//  ProfileViewController.swift
//  MyFinalApp
//
//  Created by VERTEX24 on 2019/08/21.
//  Copyright © 2019 VERTEX24. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    // 投稿情報を全て格納
    var items = [NSDictionary]()
    // インスタンス化
    let db = Firestore.firestore()
    
    // 自分のメアド
    var myEmail: String = ""
    
    @IBOutlet weak var userProfImage: UIImageView!
    @IBOutlet weak var profNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        // ユーザーの情報をとってくる
        reload()
        // サーバーからデータを取ってくる
        fetch()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        reload()
        return
    }
    
    // データの取得
    func fetch() {
        let mailRef = db.collection("postData")
        let query = mailRef.whereField("userProfEmail", isEqualTo: myEmail)
        query.getDocuments { (snapshot, error) in
            if let error = error {
                print("ProfileViewControllerにて情報取得失敗", error)
                return
            }
            // 一時保管場所
            var tempItem = [NSDictionary]()
            // 全アイテム数回
            for item in snapshot!.documents {
                let dict = item.data()
                tempItem.append(dict as NSDictionary)
            }
            self.items = tempItem
            print("self.items.count:\(self.items.count)")
            self.tableView.reloadData()
        }
    }
    
    // ユーザーの情報をとってくる
    func reload() {
        // ユーザー名を代入
        let profNameDefaults = UserDefaults.standard
        let profName = profNameDefaults.string(forKey: "profName")
        profNameLabel.text = profName
        
        // ユーザー画像を代入
        let profImageDefaults = UserDefaults.standard
        let profImage = profImageDefaults.string(forKey: "profImage")
        reconversion(userProfImage, string: profImage)
        
        // ユーザーのメアドを代入
        let profEmailDefaults = UserDefaults.standard
        let profEmail = profEmailDefaults.string(forKey: "emailKey")
        myEmail = profEmail!
    }
    
    
    
    
    // セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // セルの数は投稿情報の数
        return items.count 
    }
    
    // セルの設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        // 選択不可にする
        cell.selectionStyle = .none
        
        // itemsの中からindexPathのrow番目の取得
        let dict = items[indexPath.row]
        // タピオカ画像
        let postImageView = cell.viewWithTag(1) as! UIImageView
        // 画像情報
        let postImage = dict["postImage"]
        //NSData型に変換
        let dataPostImage = NSData(base64Encoded: postImage as! String, options: .ignoreUnknownCharacters)
        // 更にUIImage型に変換
        let  decadedPostImage = UIImage(data: dataPostImage! as Data)
        // postImageViewに代入
        postImageView.image = decadedPostImage
        
        // 店名
        let shopNameLabel = cell.viewWithTag(2) as! UILabel
        shopNameLabel.text = ("店名 : \(String(describing: dict["shopName"] as! String))")
        // 場所
        let placeLabel = cell.viewWithTag(3) as! UILabel
        placeLabel.text = ("場所 : \(String(describing: dict["place"] as! String))")
        // ベースドリンクの名前
        let baseNameLabel = cell.viewWithTag(4) as! UILabel
        baseNameLabel.text = ("ベースドリンク : \(String(describing: dict["base"] as! String))")
        // top1
        let top1Label = cell.viewWithTag(5) as! UILabel
        top1Label.text = ("+  \(String(describing: dict["top1"] as! String))")
        // top2
        let top2Label = cell.viewWithTag(6) as! UILabel
        top2Label.isHidden = true
        if dict["top2"] as! String != "" {
            top2Label.isHidden = false
            top2Label.text = ("+  \(String(describing: dict["top2"] as! String))")
        }
        // top3
        let top3Label = cell.viewWithTag(7) as! UILabel
        top3Label.isHidden = true
        if dict["top3"] as! String != "" {
            top3Label.isHidden = false
            top3Label.text = ("+  \(String(describing: dict["top3"] as! String))")
        }
        // top4
        let top4Label = cell.viewWithTag(8) as! UILabel
        top4Label.isHidden = true
        if dict["top4"] as! String != "" {
            top4Label.isHidden = false
            top4Label.text = ("+  \(String(describing: dict["top4"] as! String))")
        }
        // top5
        let top5Label = cell.viewWithTag(9) as! UILabel
        top5Label.isHidden = true
        if dict["top5"] as! String != "" {
            top5Label.isHidden = false
            top5Label.text = ("+  \(String(describing: dict["top5"] as! String))")
        }
        // 甘さと氷
        let iceLabel = cell.viewWithTag(10) as! UILabel
        iceLabel.text = ("甘さと氷の量 : \(String(describing: dict["ice"] as! String))")
        // 価格
        let priceLabel = cell.viewWithTag(11) as! UILabel
        priceLabel.text = ("価格 : \(String(describing: dict["price"] as! String))円")
        // 待ち時間
        let timeLabel = cell.viewWithTag(12) as! UILabel
        timeLabel.text = ("待ち時間 : \(String(describing: dict["time"] as! String))分")
        
        
        return cell
    }
    
    // セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 650
        
    }
    
    
    
    
    
}
