//
//  TableViewController.swift
//  MyFinalApp
//
//  Created by VERTEX24 on 2019/08/24.
//  Copyright © 2019 VERTEX24. All rights reserved.
//

import UIKit
import FirebaseFirestore

class TableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var tableVIew: UITableView!
    
    // インスタンス化
    let db = Firestore.firestore()
    // refreshControlのインスタンス化
   // private let refreshControl = UIRefreshControl()
    
    // 投稿情報を入れる箱
    var items = [NSDictionary]()
    // 何番目の情報が押されたか入れるやつ
    var selectName: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.refreshControl = refreshControl
  //      refreshControl.attributedTitle = NSAttributedString(string: "引っ張って更新")
        // アクションを指定
    //    refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        // tableViewに追加
      //  tableView.addSubview(refreshControl)
        //fetch()
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
    
    // 更新
    @objc func refresh() {
        //初期化
        items = [NSDictionary]()
        fetch()
        tableView.reloadData()
        // リフレッシュを止める
     //   refreshControl.endRefreshing()
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return items.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    
    // セルの何番目が押されたかを見るやつ
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let select = indexPath.row
        // この関数の外に持ってくため代入
        selectName = select
        // 画面遷移させるやつ
        performSegue(withIdentifier: "gotoDetail", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // 選択不可にする
        cell.selectionStyle = .none
        print(items.count)
        
        // itemsの中からindexPathのrow番目の取得
        let dict = items[indexPath.row]
        // 店の名前
        let shopNameLabel = cell.viewWithTag(1) as! UILabel
        shopNameLabel.text = dict["shopName"] as? String
        
        // タピオカ画像
        let postImageView = cell.viewWithTag(2) as! UIImageView
        // 画像情報
        let postImage = dict["postImage"]
        //NSData型に変換
        let dataPostImage = NSData(base64Encoded: postImage as! String, options: .ignoreUnknownCharacters)
        // 更にUIImage型に変換
        let  decadedPostImage = UIImage(data: dataPostImage! as Data)
        // postImageViewに代入
        postImageView.image = decadedPostImage
        
        // ベースドリンクの名前
        let baseNameLabel = cell.viewWithTag(3) as! UILabel
        baseNameLabel.text = dict["base"] as? String
        
        // プロフィール画像
        let userProfImage = cell.viewWithTag(4) as! UIImageView
        // 画像情報
        if let profImage = dict["userProfImage"] {
            //NSData型に変換
            let dataProfImage = NSData(base64Encoded: profImage as! String, options: .ignoreUnknownCharacters)
            // 更にUIImage型に変換
            let  decadedProfImage = UIImage(data: dataProfImage! as Data)
            // profileImageViewに代入
            userProfImage.image = decadedProfImage
        } else {
            // profileImageViewに代入
            userProfImage.image = #imageLiteral(resourceName: "人物アイコン")
        }
        // ユーザー名
        let userNameLabel = cell.viewWithTag(5) as! UILabel
        userNameLabel.text = dict["userProfName"] as? String
        

        return cell
    }

    // セルの高さ
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
}
