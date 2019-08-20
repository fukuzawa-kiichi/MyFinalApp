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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
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
        cameraAction(sourceType: .photoLibrary)
    }
    
    // 位置情報ボタン
    @IBAction func locationButton(_ sender: Any) {
    }
    
    // マイページボタン
    @IBAction func ProfileButton(_ sender: Any) {
    }
    
    
}

