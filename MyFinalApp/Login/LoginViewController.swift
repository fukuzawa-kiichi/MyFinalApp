//
//  LoginViewController.swift
//  MyFinalApp
//
//  Created by VERTEX24 on 2019/08/19.
//  Copyright © 2019 VERTEX24. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    // メールアドレスを打つとこ
    @IBOutlet weak var emailTextField: UITextField!
    // パスワード打つとこ
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    // キーボードを閉じる処理
    // タッチされたかを判断
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // キーボードが開いていたら
        if (emailTextField.isFirstResponder) {
            // 閉じる
            emailTextField.resignFirstResponder()
        }
        if (passwordTextField.isFirstResponder) {
            passwordTextField.resignFirstResponder()
        }
    }
    
    // タイムラインへ遷移
    func toTimeLine() {
        // storyboardのfileの特定
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        // 移動先のvcをインスタンス化
        let vc = storyboard.instantiateViewController(withIdentifier: "Main")
        // 遷移処理
        self.present(vc, animated: true)
    }
    
    // エラーが帰ってきた場合のアラート
    func showErrorAlert(error: Error?) {
        
        let alert = UIAlertController(title: "エラー", message: error?.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(okAction)
        // 表示
        self.present(alert, animated: true)
    }
    
    
    
    // ログインボタン
    @IBAction func userLogin(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        // FirebaseAuthのログイン処理
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if let error = error {
                print("ログイン失敗")
                // エラーアラートの表示
                self.showErrorAlert(error: error)
            } else {
                // 認証成功
                print("ログイン成功")
                // タイムラインへ遷移
                self.toTimeLine()
            }
        })
    }
    
    // 新規登録ボタン
    @IBAction func createUser(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        // FirebaseAuthの新規登録処理
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if let error = error {
                print("新規作成失敗")
                // エラーアラートの表示
                self.showErrorAlert(error: error)
            } else {
                // 認証成功
                print("新規作成成功")
                // タイムラインへ遷移
                self.toTimeLine()
            }
        })
    }
}
