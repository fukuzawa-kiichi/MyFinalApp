//
//  AppDelegate.swift
//  MyFinalApp
//
//  Created by VERTEX24 on 2019/08/19.
//  Copyright © 2019 VERTEX24. All rights reserved.
//

import UIKit
import Firebase


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // ユーザーネームの保存先
    var myName: String?
    // ユーザーイメージの保存先
    var myImage: String?
    
    // 初期化処理
    override init() {
        super.init()
        FirebaseApp.configure()
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 画面を2秒表示
        sleep(2)
        
        // アプリに保存されている自分の名前をuserProfNameに格納します。
        let userDefaultsName = UserDefaults.standard
        myName = userDefaultsName.object(forKey: "myName") as? String
        let userDefaultsImage = UserDefaults.standard
        myImage = userDefaultsImage.object(forKey: "myImage") as? String
        
        // navigationbarの戻るボタンを黒にする
        UINavigationBar.appearance().tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // myNameとmyImageに格納されている入力内容をアプリに保存します。
        let userDefaultsName = UserDefaults.standard
        userDefaultsName.set(myName, forKey: "myName")
        print("名前保存")
         let userDefaultsImage = UserDefaults.standard
        userDefaultsImage.set(myImage, forKey: "myImage")
        print("画像保存")
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

