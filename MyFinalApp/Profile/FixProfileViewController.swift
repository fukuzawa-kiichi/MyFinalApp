//
//  FixProfileViewController.swift
//  MyFinalApp
//
//  Created by VERTEX24 on 2019/08/21.
//  Copyright © 2019 VERTEX24. All rights reserved.
//

import UIKit



class FixProfileViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
   // let userDefaultsName = UserDefaults.standard
 //   let userDefaultsImage = UserDefaults.standard
    var fixName: String = ""
    var fixImage:UIImage!
    
    // プロフィール画像
    @IBOutlet weak var userProfImage: UIImageView!
    // 名前
    @IBOutlet weak var userProfName: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userProfName.delegate = self
        
        // AppDelegateを参照にするための定数
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // AppDelegateに定義したlastTetxtを参照し,MemoTextViewに格納する
        userProfName.text = appDelegate.myName
       reconversion(userProfImage)
    }
    
    // MemoTextViewになにか入力されたとき動作する
    func textViewDidChange(_ MemoTextView: UITextField) {
        fixName = userProfName.text!
    /*    // AppDelegateを呼び出して変数に格納する
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // MemoTextViewに書かれた内容をAppDelegateのlastTextにか更新していく
        appDelegate.myName = fixName
 */
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
            userProfImage.contentMode = .scaleToFill
            userProfImage.image = pickedImage
            fixImage = pickedImage
        }
        // pickerは閉じる
        picker.dismiss(animated: true)
    }
    
    // 端末に名前のデータを保存する
    func saveText(){
        
        fixName = userProfName.text!
        // AppDelegateを呼び出して変数に格納する
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.myName = fixName
    //    userDefaultsName.set(fixName, forKey: "myName")
        print("名前入れたよ")
    }
    
    // 端末に画像のデータを保存
    func changeString() {
        // base64型(String型)に変換する
        // プロフィール画像
        var profileImageData:NSData = NSData()
         let profileImage = fixImage!
            profileImageData = profileImage.jpegData(compressionQuality: 0.1)! as NSData
        let base64ProfileImage = profileImageData.base64EncodedString(options: .lineLength64Characters) as String
        // AppDelegateを呼び出して変数に格納する
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.myImage = base64ProfileImage
    //    userDefaultsImage.set(fixImage, forKey: "myImage")
        print("変換できたよ!")
    }
    
    // プロフィールへ遷移
    func toProf() {
        // storyboardのfileの特定
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        // 移動先のvcをインスタンス化
        let vc = storyboard.instantiateViewController(withIdentifier: "Navigation")
        // 遷移処理
        self.present(vc, animated: true)
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
        // アプリ内に保存
        // プロフィール画像をデータに保存
        changeString()
        // 端末にデータを保存
        saveText()
        // プロフィールへ遷移
        toProf()
    }
    // キーボードを消す
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if userProfName.isFirstResponder {
            userProfName.resignFirstResponder()
        }
    }
}