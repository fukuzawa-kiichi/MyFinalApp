//
//  NewViewController.swift
//  MyFinalApp
//
//  Created by VERTEX24 on 2019/08/22.
//  Copyright © 2019 VERTEX24. All rights reserved.
//

import UIKit
import FirebaseFirestore

class NewViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // インスタンス化
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        cameraAction(sourceType: .photoLibrary)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // プロフィールへ遷移
            // storyboardのfileの特定
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            // 移動先のvcをインスタンス化
            let vc = storyboard.instantiateViewController(withIdentifier: "Tab")
            // 遷移処理
            self.present(vc, animated: true)
        return 
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
    
    
  
  
}
