//
//  ViewController.swift
//  MyFinalApp
//
//  Created by VERTEX24 on 2019/08/19.
//  Copyright © 2019 VERTEX24. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    // インスタンス化
    let db = Firestore.firestore()
    
    // 投稿情報を入れる箱
    var items = [NSDictionary]()
    // refreshControlのインスタンス化
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        refreshControl.attributedTitle = NSAttributedString(string: "引っ張って更新")
        // アクションを指定
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        // tableViewに追加
        tableView.addSubview(refreshControl)
        fetch()
        
    }
    
    /*
    
    // カメラ・フォトライブラリへの遷移処理
    func cameraAction(sourceType: UIImagePickerController.SourceType) {
        // カメラ・フォトライブラリが使用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            
            // インスタンス化
            let cameraPicker = UIImagePickerController()
            // ソースタイプの代入
            cameraPicker.sourceType = sourceType
            // デリゲートの接続
            cameraPicker.delegate = self
            // 画面遷移
            self.present(cameraPicker, animated: true)
        }
    }
    
    // 写真が選択された時に呼ばれる
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 取得できた画像情報の存在確認とUIImage型へキャスト。pickedImageという定数に格納
        if let pickedImage = info[.originalImage] as? UIImage {
            // ①投稿画面への遷移処理
            let storyboard: UIStoryboard = UIStoryboard(name: "Post", bundle: nil)
            guard let vc = storyboard.instantiateViewController(withIdentifier: "Post") as? PostViewController else {
                print("投稿画面への遷移失敗")
                return
            }
            // ②画像の受け渡し
            vc.willPostImage = pickedImage
            print("画像渡し成功")
            // 画面遷移
            picker.pushViewController(vc, animated: true)
            
        }
    }
    */
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
        refreshControl.endRefreshing()
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
        print(items.count)
        
        // itemsの中からindexPathのrow番目の取得
//        let dict = items[(indexPath as NSIndexPath).row]
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
        let profileImageView = cell.viewWithTag(4) as! UIImageView
        // 画像情報
        if let profImage = dict["userProfImage"] {
            //NSData型に変換
            let dataProfImage = NSData(base64Encoded: profImage as! String, options: .ignoreUnknownCharacters)
            // 更にUIImage型に変換
            let  decadedProfImage = UIImage(data: dataProfImage! as Data)
            // profileImageViewに代入
            profileImageView.image = decadedProfImage
        } else {
            // profileImageViewに代入
            profileImageView.image = #imageLiteral(resourceName: "人物アイコン")
        }
        
        // ユーザー名
        let userNameLabel = cell.viewWithTag(5) as! UILabel
        userNameLabel.text = dict["userProfName"] as? String
        
        return cell
    }
    
    // セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
  /*
    // 投稿ボタン
    @IBAction func postButton(_ sender: Any) {
        cameraAction(sourceType: .photoLibrary)
    }
    */
}
