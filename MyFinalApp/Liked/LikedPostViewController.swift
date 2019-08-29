//
//  LikedPostViewController.swift
//  MyFinalApp
//
//  Created by VERTEX24 on 2019/08/27.
//  Copyright © 2019 VERTEX24. All rights reserved.
//

import UIKit
import FirebaseFirestore

class LikedPostViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // インスタンス化
    let db = Firestore.firestore()
    // refreshControlのインスタンス化
    var refreshControl = UIRefreshControl()
    // ロード中画面を触れなくする
    private let OutView = UIView()
    
    
    // 投稿情報を入れる箱
    var items = [NSDictionary]()
    // 全ドキュメントIDをもたせる箱
    var allDocumentID: [String] = []
    // ドキュメントIDをもたせる箱
    var documentID: String = ""
    // 投稿情報を入れる箱
    var item = NSDictionary()
    
    // 投稿の中身を監視する
    var itemsListener: ListenerRegistration?
    // tableView
    @IBOutlet weak var likeTableView: UITableView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        likeTableView.delegate = self
        likeTableView.dataSource = self
        refreshControl.attributedTitle = NSAttributedString(string: "引っ張って更新")
        // アクションを指定
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        // tableViewに追加
        likeTableView.addSubview(refreshControl)
        // OutViewの範囲と色
        OutView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        OutView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        // OutViewをviewにつける
        view.addSubview(OutView)
        OutView.isHidden = true
        fetch()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        fetch()
    }
 
    
    override func viewDidDisappear(_ animated: Bool) {
        // 監視終了
        stopListeningForItems()
        items = [NSDictionary]()
        allDocumentID = []
        documentID = ""
        item = NSDictionary()
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
            self.likeTableView.reloadData()
        })
        
    }
    
    private func stopListeningForItems() {
        itemsListener?.remove()
        itemsListener = nil
    }
 
    // データの取得
    func fetch() {
        // OutViewを表示
        OutView.isHidden = false
        let mailRef = db.collection("postData")
        let query = mailRef.whereField("like", isEqualTo: "1")
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
                let document = item.documentID
                tempItem.append(dict as NSDictionary)
                self.allDocumentID.append(document)
            }
            self.items = tempItem
            print("self.items.count:\(self.items.count)")
            self.likeTableView.reloadData()
        }
        // OutViewを表示
        OutView.isHidden = true
    }
    
    // 更新
    @objc func refresh() {
        //初期化
        items = [NSDictionary]()
        item = NSDictionary()
        allDocumentID = []
        documentID = ""
        fetch()
        likeTableView.reloadData()
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
        item = items[indexPath.row]
        print("item = \(item)")
        documentID = allDocumentID[indexPath.row]
        print("documentID = \(documentID)")
    }
    
    
    
    // セルの設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LikedCell", for: indexPath)
        // 選択不可にする
        cell.selectionStyle = .none
        print("items.count: \(items.count)")
        
        // itemsの中からindexPathのrow番目の取得
        let dict = items[indexPath.row]
        
        
        // プロフィール画像
        let userProfImage = cell.viewWithTag(1) as! UIImageView
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
        let userNameLabel = cell.viewWithTag(2) as! UILabel
        if dict["userProfName"] as? String != "" {
            userNameLabel.text = dict["userProfName"] as? String
        } else {
            userNameLabel.text = "ゲスト"
        }
        // タピオカ画像
        let postImageView = cell.viewWithTag(3) as! UIImageView
        // 画像情報
        let postImage = dict["postImage"]
        //NSData型に変換
        let dataPostImage = NSData(base64Encoded: postImage as! String, options: .ignoreUnknownCharacters)
        // 更にUIImage型に変換
        let  decadedPostImage = UIImage(data: dataPostImage! as Data)
        // postImageViewに代入
        postImageView.image = decadedPostImage
        
        // 店名
        let shopNameLabel = cell.viewWithTag(4) as! UILabel
        shopNameLabel.text = ("店名 : \(String(describing: dict["shopName"] as! String))")
        // 場所
        let placeLabel = cell.viewWithTag(5) as! UILabel
        placeLabel.text = ("場所 : \(String(describing: dict["place"] as! String))")
        // ベースドリンクの名前
        let baseNameLabel = cell.viewWithTag(6) as! UILabel
        baseNameLabel.text = ("ベースドリンク : \(String(describing: dict["base"] as! String))")
        // top1
        let top1Label = cell.viewWithTag(7) as! UILabel
        top1Label.text = ("+  \(String(describing: dict["top1"] as! String))")
        // top2
        let top2Label = cell.viewWithTag(8) as! UILabel
        top2Label.isHidden = true
        if dict["top2"] as! String != "" {
            top2Label.isHidden = false
            top2Label.text = ("+  \(String(describing: dict["top2"] as! String))")
        }
        // top3
        let top3Label = cell.viewWithTag(9) as! UILabel
        top3Label.isHidden = true
        if dict["top3"] as! String != "" {
            top3Label.isHidden = false
            top3Label.text = ("+  \(String(describing: dict["top3"] as! String))")
        }
        // top4
        let top4Label = cell.viewWithTag(10) as! UILabel
        top4Label.isHidden = true
        if dict["top4"] as! String != "" {
            top4Label.isHidden = false
            top4Label.text = ("+  \(String(describing: dict["top4"] as! String))")
        }
        // top5
        let top5Label = cell.viewWithTag(11) as! UILabel
        top5Label.isHidden = true
        if dict["top5"] as! String != "" {
            top5Label.isHidden = false
            top5Label.text = ("+  \(String(describing: dict["top5"] as! String))")
        }
        // 甘さと氷
        let iceLabel = cell.viewWithTag(12) as! UILabel
        iceLabel.text = ("甘さと氷の量 : \(String(describing: dict["ice"] as! String))")
        // 価格
        let priceLabel = cell.viewWithTag(13) as! UILabel
        priceLabel.text = ("価格 : \(String(describing: dict["price"] as! String))円")
        // 待ち時間
        let timeLabel = cell.viewWithTag(14) as! UILabel
        timeLabel.text = ("待ち時間 : \(String(describing: dict["time"] as! String))分")
        
        // 行きたいボタン
        let goodButton = cell.viewWithTag(15) as! UIButton
        if dict["like"] as! String == "0" {
            // いいねボタンの色
            goodButton.setTitle("♡", for: .normal)
            goodButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        } else if dict["like"] as! String == "1" {
            // いいねボタンの色
            goodButton.setTitle("❤", for: .normal)
            goodButton.setTitleColor(#colorLiteral(red: 1, green: 0.1301513699, blue: 0.7420222357, alpha: 1), for: .normal)
        } else {
            
        }
        
        return cell
    }
    
    // セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 650
    }
    
    
    
    
    @IBAction func likedBUtton(_ sender: UIButton) {
       
        
        // 選択されたボタンの座標位置を取得し
        let point = likeTableView.convert(sender.center, from: sender)
        print("point:\(point)")
        // Tableviewの座標へ変換して該当のindexPathを取得
        guard let indexPath: IndexPath = likeTableView.indexPathForRow(at: point) else {
            print("ボタン情報の取得失敗")
            return
        }
        item = items[indexPath.row]
        documentID = allDocumentID[indexPath.row]
        
        // 監視開始
        startLiseningForItems()
        
     //   let cell = likeTableView.dequeueReusableCell(withIdentifier: "LikedCell", for: indexPath)
       // let goodButton = cell.viewWithTag(15) as! UIButton
        
        if item["like"] as! String == "0" {
            // firebase更新
            db.collection("postData").document(documentID).updateData(["like": "1"])
            refresh()
        } else if item["like"] as! String == "1" {
            db.collection("postData").document(documentID).updateData(["like": "0"])
            refresh()
        }
        
    }
    
    
}
