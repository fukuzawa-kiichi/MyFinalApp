//
//  PostViewController.swift
//  MyFinalApp
//
//  Created by VERTEX24 on 2019/08/19.
//  Copyright © 2019 VERTEX24. All rights reserved.
//

import UIKit
import FirebaseFirestore

class PostViewController: UIViewController {
    
    // インスタンス化
    let db = Firestore.firestore()
    // pickerで選択した写真を受け取る変数
    var willPostImage: UIImage = UIImage()
    
    // ユーザーの名前
    var userProfName: String = ""
    // ユーザーの画像
    var userProfImage: UIImageView = UIImageView()
    
    
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
    @IBOutlet weak var p3TextField: UITextField!
    // 追加4項目
    @IBOutlet weak var p4TextField: UITextField!
    // 甘さと氷の量
    @IBOutlet weak var iceTextField: UITextField!
    // 価格
    @IBOutlet weak var priceTextField: UITextField!
    // 待ち時間
    @IBOutlet weak var timeTextField: UITextField!
    // scrollView
    @IBOutlet weak var scrollView: UIScrollView!
    // トッピングの項目を追加するボタンたち
    @IBOutlet weak var plusButton1: UIButton!
    @IBOutlet weak var plusButton2: UIButton!
    @IBOutlet weak var plusButton3: UIButton!
    @IBOutlet weak var plusButton4: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // pickerで選択した画像を投稿用写真へ反映
        imageView.image = willPostImage
        // AppDelegateを参照にするための定数
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // AppDelegateに定義したlastTetxtを参照し,MemoTextViewに格納する
        userProfName = appDelegate.myName!
        userProfImage.image = appDelegate.myImage
        
        p1TextField.isHidden = true
        p2TextField.isHidden = true
        p3TextField.isHidden = true
        p4TextField.isHidden = true
        plusButton1.isHidden = false
        plusButton2.isHidden = true
        plusButton3.isHidden = true
        plusButton4.isHidden = true
    }
    
    
    // 一番下のTextFieldを見えるようにするとき使う
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    // 一番下のTextFieldを見えるようにするとき使う
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
        super.viewWillDisappear(animated)
    }
    // 一番下のTextFieldを見えるようにするとき使う
    @objc private func onKeyboardWillShow(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let keyboardInfo = UIKeyboardInfo(info: userInfo),
            let inputView = view.findFirstResponder(),
            let scrollView = inputView.findSuperView(ofType: UIScrollView.self)
            else { return }
        
        let inputRect = inputView.convert(inputView.bounds, to: scrollView)
        let keyboardRect = scrollView.convert(keyboardInfo.frame, from: nil)
        let offsetY = inputRect.maxY - keyboardRect.minY
        if offsetY > 0 {
            let contentOffset = CGPoint(x: scrollView.contentOffset.x, y: scrollView.contentOffset.y + offsetY)
            scrollView.contentOffset = contentOffset
        }
        // 例えば iPhoneX の Portrait 表示だと bottom に34ptほど隙間ができるのでその分を差し引く
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardInfo.frame.height - view.safeAreaInsets.bottom, right: 0)
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }
    // 一番下のTextFieldを見えるようにするとき使う
    @objc private func onKeyboardWillHide(_ notification: Notification) {
        guard
            let inputView = view.findFirstResponder(),
            let scrollView = inputView.findSuperView(ofType: UIScrollView.self)
            else { return }
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    // キーボードを閉じる処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if shopTextField.isFirstResponder {
            shopTextField.resignFirstResponder()
        }
        if placeTextField.isFirstResponder {
            placeTextField.resignFirstResponder()
        }
        if baseTextField.isFirstResponder {
            baseTextField.resignFirstResponder()
        }
        if toppingTextField.isFirstResponder {
            toppingTextField.resignFirstResponder()
        }
        if p1TextField.isFirstResponder {
            p1TextField.resignFirstResponder()
        }
        if p2TextField.isFirstResponder {
            p2TextField.resignFirstResponder()
        }
        if p3TextField.isFirstResponder {
            p3TextField.resignFirstResponder()
        }
        if p4TextField.isFirstResponder {
            p4TextField.resignFirstResponder()
        }
        if iceTextField.isFirstResponder {
            iceTextField.resignFirstResponder()
        }
        if priceTextField.isFirstResponder {
            priceTextField.resignFirstResponder()
        }
        if timeTextField.isFirstResponder {
            timeTextField.resignFirstResponder()
        }
    }
    
    
    // 投稿ボタン
    @IBAction func postButton(_ sender: Any) {
        // 店名
        let shopName = shopTextField.text
        // 場所
        let place = placeTextField.text
        // ベースドリンク
        let base = baseTextField.text
        // トッピング
        let top1 = toppingTextField.text
        let top2 = p1TextField.text
        let top3 = p2TextField.text
        let top4 = p3TextField.text
        let top5 = p4TextField.text
        
        // 投稿画像
        var postImageData: NSData = NSData()
        if let postImage = imageView.image {
            postImageData = postImage.jpegData(compressionQuality: 0.1)! as NSData
        }
        let base64PostImage = postImageData.base64EncodedString(options: .lineLength64Characters) as String
        // プロフィール画像
        var profileImageData:NSData = NSData()
        if let profileImage = userProfImage.image {
            profileImageData = profileImage.jpegData(compressionQuality: 0.1)! as NSData
        }
        let base64ProfileImage = profileImageData.base64EncodedString(options: .lineLength64Characters) as String
        
        // サーバーに飛ばす箱(辞書型)
        let postData: NSDictionary = ["userProfName": userProfName, "userProfImage": base64ProfileImage, "shopName": shopName ?? "", "place": place ?? "", "postImage": base64PostImage, "base": base ?? "", "top1": top1 ?? "", "top2": top2 ?? "", "top3": top3 ?? "", "top4": top4 ?? "", "top5": top5 ?? ""]
        // 辞書ごとFirestoreの"user"へpost
        db.collection("postData").addDocument(data: postData as! [String : Any])
        
        // 画面を消してタイムラインに戻る
        self.dismiss(animated: true)
    }
    
    // 投稿をやめるボタン
    @IBAction func cancelAll(_ sender: Any) {
    }
    
    // トッピングの項目を増やすボタン
    @IBAction func plusButton(_ sender: UIButton) {
        
        if toppingTextField.text != "" {
            switch sender.tag {
            case 1:
                plusButton1.isHidden = true
                p1TextField.isHidden = false
                plusButton2.isHidden = false
            case 2:
                if p1TextField.text != "" {
                    plusButton2.isHidden = true
                    p2TextField.isHidden = false
                    plusButton3.isHidden = false
                }
            case 3:
                if p2TextField.text != "" {
                    plusButton3.isHidden = true
                    p3TextField.isHidden = false
                    plusButton4.isHidden = false
                }
            default :
                if p3TextField.text != "" {
                    plusButton4.isHidden = true
                    p4TextField.isHidden = false
                }
            }
        }
    }
    
}



