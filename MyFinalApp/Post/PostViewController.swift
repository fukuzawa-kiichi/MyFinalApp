//
//  PostViewController.swift
//  MyFinalApp
//
//  Created by VERTEX24 on 2019/08/19.
//  Copyright © 2019 VERTEX24. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {

    // すべてtユーザーに記入してもらう
    // 投稿する画像
    @IBOutlet weak var imageView: UIImageView!
    // お店の名前
    @IBOutlet weak var shopTextField: UITextField!
    // お店の場所
    @IBOutlet weak var placeTextField: UITextField!
    // デースドリンクの名前
    @IBOutlet weak var baseTextField: UITextField!
    // トッピング(最大5個まで)
    // トッピング1つ目
    @IBOutlet weak var toppingTextField: UITextField!
    // 追加1項目
    @IBOutlet weak var p1TextField: UITextField!
    // 追加2項目
    @IBOutlet weak var p2TextField: UITextField!
    // 追加3項目
    @IBOutlet weak var p3TextField: UIStackView!
    // 追加4項目
    @IBOutlet weak var p4TextField: UITextField!
    // 甘さと氷の量
    @IBOutlet weak var iceTextField: UITextField!
    // 価格
    @IBOutlet weak var priceTextField: UITextField!
    // 待ち時間
    @IBOutlet weak var timeTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // 投稿ボタン
    @IBAction func postAll(_ sender: Any) {
    }
    
    // 投稿をやめるボタン
    @IBAction func cancelAll(_ sender: Any) {
    }
    
    // トッピングの項目を増やすボタン
    @IBAction func plusButton(_ sender: UIButton) {
    }
    
}
