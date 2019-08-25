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
        
        let mailRef = db.collectionGroup("postData")
        let query = mailRef.whereField("userProfEmail", isEqualTo: myEmail)
        var userItems = [NSDictionary]()
        userItems.append(query as NSDictionary)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       reload()
        return
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
    
    // データの取得
    func fetch() {
        // getで全件取得
        db.collection("postData").getDocuments() {(querySnapshot, err) in
            // 一時保管場所
            var tempItem = [NSDictionary]()
            // 全アイテム数回
            for item in querySnapshot!.documents {
                let dict = item.data()
                tempItem.append(dict as NSDictionary)
            }
            self.items = tempItem
            self.tableView.reloadData()
        }
    }
    
    
    // セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // セルの数は投稿情報の数
        return items.count
    }
    
    // セルの設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        // 選択不可にする
        cell.selectionStyle = .none
        
        
        
        return cell
    }
    
    // セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    

    
   
}
