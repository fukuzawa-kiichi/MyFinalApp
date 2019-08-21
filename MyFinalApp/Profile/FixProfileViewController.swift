//
//  FixProfileViewController.swift
//  MyFinalApp
//
//  Created by VERTEX24 on 2019/08/21.
//  Copyright © 2019 VERTEX24. All rights reserved.
//

import UIKit
import FirebaseAuth


class FixProfileViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // プロフィール画像
    @IBOutlet weak var fixProfImage: UIImageView!
    // 名前
    @IBOutlet weak var fixprofName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getProfile()
        
    }
    
    // ローカルで持っているprofile情報を反映
    func getProfile() {
        // 画像情報
        if let profImage = UserDefaults.standard.object(forKey: "profileImage") {
            let dataImage = NSData(base64Encoded: profImage as! String, options: .ignoreUnknownCharacters)
            // 更にUIImage型に変換
            let decodedImage = UIImage(data: dataImage! as Data)
            // profileImageViewに代入
            fixProfImage.image = decodedImage
        } else {
            // なければアイコンを入れる
            fixProfImage.image = #imageLiteral(resourceName: "人物アイコン")
        }
        // 名前の情報
        if let profName = UserDefaults.standard.object(forKey: "userName") as? String {
            // userNameTextFieldに代入
            fixprofName.text = profName
        } else {
            fixprofName.text = "匿名"
        }
    }
    
    // カメラとフォトライブラリーへの遷移処理
    func photoAction(sourceType: UIImagePickerController.SourceType) {
        // カメラとフォトライブラリが使用可能かをチェック
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            // インスタンス作成
            let cameraPicker = UIImagePickerController()
            // ソースタイプの代入
            cameraPicker.sourceType = sourceType
            // デリゲートの接続
            cameraPicker.delegate = self
            // 画面遷移
            self.present(cameraPicker, animated: true)
        }
    }
    
    
    // カメラ・フォトライブラリへの遷移処理
    func cameraAction(sourceType: UIImagePickerController.SourceType) {
        // カメラ・フォトライブラリが使用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            
            // インスタンス作成
            let cameraPicker = UIImagePickerController()
            // ソースタイプの代入
            cameraPicker.sourceType = sourceType
            // デリゲートの接続
            cameraPicker.delegate = self
            // 画面遷移
            self.present(cameraPicker, animated: true)
        }
    }
    
    // 写真が選択されたときの関数
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 所得で来た画像情報の存在処理
        if let pickedImage = info[.originalImage] as? UIImage {
            fixProfImage.contentMode = .scaleToFill
            fixProfImage.image = pickedImage
        }
        // pickerは閉じる
        picker.dismiss(animated: true)
    }
    
    
    
    // 画像を変えるボタン
    @IBAction func imageButton(_ sender: Any) {
        // アクションシートを定義
        let alert = UIAlertController(title: "選択してください", message: nil, preferredStyle: .actionSheet)
        // カメラ機能
        let openCamera = UIAlertAction(title: "カメラ", style: .default, handler: {(action: UIAlertAction) in
            self.photoAction(sourceType: .camera)
        })
        // アルバム
        let openPhotos = UIAlertAction(title: "アルバム", style: .default, handler: {(action: UIAlertAction) in
             self.photoAction(sourceType: .photoLibrary)
        })
        // キャンセル
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel)
        // アラートの追加
        alert.addAction(openCamera)
        alert.addAction(openPhotos)
        alert.addAction(cancelAction)
        // 表示
        present(alert, animated: true)
    }
    // 決定
    @IBAction func addFix(_ sender: Any) {
        var data:NSData = NSData()
        // imageの存在確認
        if let image = fixProfImage.image {
            data = image.jpegData(compressionQuality: 0.1)! as NSData
        }
        let base64String = data.base64EncodedString(options: .lineLength64Characters) as String
        // textFieldの中身をuserNameに代入
        let userName = fixprofName.text
        // アプリ内に保存
        // プロフィール画像
        UserDefaults.standard.set(base64String, forKey: "profileImage")
        // ユーザー名
        UserDefaults.standard.set(userName, forKey: "userName")
        // 遷移
        dismiss(animated: true)
    }
    // キーボードを消す
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if fixprofName.isFirstResponder {
            fixprofName.resignFirstResponder()
        }
    }
}
