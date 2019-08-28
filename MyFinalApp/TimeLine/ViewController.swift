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
    // refreshControlのインスタンス化
    var refreshControl = UIRefreshControl()
   
    // 投稿情報を入れる箱
    var items = [NSDictionary]()
    // 全ドキュメントIDをもたせる箱
    var allDocumentID: [String] = []
    // ドキュメントIDをもたせる箱
    var documentID: String = ""
    
    // 投稿の中身を監視する
    var itemsListener: ListenerRegistration?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // インスタンス化
        navigationController?.delegate = self
        // navigationbarの戻るボタンに文字を入れない処理
        let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButtonItem
        
        tableView.delegate = self
        tableView.dataSource = self
        refreshControl.attributedTitle = NSAttributedString(string: "引っ張って更新")
        // アクションを指定
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        // tableViewに追加
        tableView.addSubview(refreshControl)
        fetch()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 監視開始
        startLiseningForItems()
        fetch()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // 監視終了
        stopListeningForItems()
   //     items = [NSDictionary]()
    //    allDocumentID = []
    }

    // データの取得
    func fetch() {
        // getで全件取得
        db.collection("postData").getDocuments() {(querySnapshot, err) in
            // 一時保管場所
            var tempItem = [NSDictionary]()
            var tempID: [String] = []
            // 全アイテム数回
            for item in querySnapshot!.documents {
                let dict = item.data()
                let document = item.documentID
                tempItem.append(dict as NSDictionary)
                tempID.append(document)
            }
            self.allDocumentID = tempID
            print("allDocumentID: \(self.allDocumentID)")
            self.items = tempItem
            self.tableView.reloadData()
           }
    }
    
    // ユーザーの情報をとってくる
    func startLiseningForItems() {
        itemsListener = db.collection("postData").addSnapshotListener ({ (snapshot, error) in
            if let error = error {
                print("データ取得失敗: ", error)
                return
            }
            guard let snapShot = snapshot else {
                print("error: \(error!)")
                return
            }
            // 一時保管場所
            var tempItem = [NSDictionary]()
            for item in snapShot.documents {
                let dict = item.data()
                tempItem.append(dict as NSDictionary)
            }
            self.items = tempItem
            self.tableView.reloadData()
        })
        
    }
    
    private func stopListeningForItems() {
        itemsListener?.remove()
        itemsListener = nil
    }
    
    // 更新
    @objc func refresh() {
        //初期化
        items = [NSDictionary]()
        allDocumentID = []
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
    
    // セルの何番目が押されたかを見るやつ
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 画面遷移させるやつ
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Detail") as! DetailViewController
        print("indexPath.row: \(indexPath.row)")
        vc.item = items[indexPath.row]
        print("allDocumentID[indexPath.row] \(allDocumentID[indexPath.row])")
        vc.itemID = allDocumentID[indexPath.row]
        // 遷移
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
   
    
    // セルの設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    

}
