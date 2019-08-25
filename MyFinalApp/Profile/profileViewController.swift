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
        let query = mailRef.whereField("userProfEmail", isEqualTo: "a@a.com")
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
        
        return cell
    }
    
    // セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    

    
   
}
