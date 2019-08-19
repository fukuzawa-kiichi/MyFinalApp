//
//  ViewController.swift
//  MyFinalApp
//
//  Created by VERTEX24 on 2019/08/19.
//  Copyright © 2019 VERTEX24. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    // インスタンス化
    let db = Firestore.firestore()
    
    // 投稿情報を入れる箱
    var items = [NSDictionary]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
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
        // 以下は最後に記載
        
        return cell
    }
    
    // セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }

    // ホームボタン
    @IBAction func homeButton(_ sender: Any) {
    }
    
    // 検索ボタン
    @IBAction func searchButton(_ sender: Any) {
    }
    
    // 投稿ボタン
    @IBAction func postButton(_ sender: Any) {
    }
    
    // 位置情報ボタン
    @IBAction func locationButton(_ sender: Any) {
    }
    
    // マイページボタン
    @IBAction func ProfileButton(_ sender: Any) {
    }
    
    
}

