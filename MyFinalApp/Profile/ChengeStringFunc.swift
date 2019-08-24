//
//  ChengeStringFunc.swift
//  MyFinalApp
//
//  Created by VERTEX24 on 2019/08/23.
//  Copyright © 2019 VERTEX24. All rights reserved.
//

import UIKit

func reconversion(_ sender: UIImageView, string: String?) {
    // 画像情報
    if let profImage = string {
        //NSData型に変換
        let dataProfImage = NSData(base64Encoded: profImage, options: .ignoreUnknownCharacters)
        // 更にUIImage型に変換
        let  decadedProfImage = UIImage(data: dataProfImage! as Data)
        // profileImageViewに代入
        sender.image = decadedProfImage
    }else {
        sender.image = #imageLiteral(resourceName: "人物アイコン")
    }
    print("代入成功")
}

