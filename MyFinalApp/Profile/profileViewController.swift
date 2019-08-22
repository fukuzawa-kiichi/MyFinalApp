//
//  ProfileViewController.swift
//  MyFinalApp
//
//  Created by VERTEX24 on 2019/08/21.
//  Copyright © 2019 VERTEX24. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource {

    
    // 投稿情報を全て格納
    var items = [NSDictionary]()
    var image : UIImage!
    var name = ""
    
    @IBOutlet weak var userProfImage: UIImageView!
    @IBOutlet weak var profNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        userProfImage.image = image
        profNameLabel.text = name
       // getProfile()
    }
    /*
    // ローカルで持っているprofile情報を反映
    func getProfile() {
        // 画像情報
        
        if let profImage = UserDefaults.standard.object(forKey: "userProfImage") {
            // NSData型に変換
            let dataImage = NSData(base64Encoded: profImage as! String ,options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
            // さらにUIImage型へ変換
            let decodedImage = UIImage(data: dataImage! as Data)
            // prfileImageViewへ代入
            userProfImage.image = decodedImage
        } else {
            // なければアイコン画像をいれておく
            userProfImage.image = #imageLiteral(resourceName: "人物アイコン")
        }
        
        // 名前情報
        if let profName = UserDefaults.standard.object(forKey: "userProfName") as? String {
            // profileNameLabelへ代入
            profNameLabel.text = profName
        } else {
            // なければ匿名としておく
            profNameLabel.text = "匿名"
        }
        
    }
    */
    
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
        return 250
    }
    
    

    
   
}
