//
//  Extension+ View.swift
//  MyFinalApp
//
//  Created by VERTEX24 on 2019/08/20.
//  Copyright © 2019 VERTEX24. All rights reserved.
//

import Foundation
import UIKit

// 一番下のTextFieldを見えるようにするとき使う
// UITextfieldを探す
extension UIView {
    func findFirstResponder() -> UIView? {
        if isFirstResponder {
            return self
        }
        for v in subviews {
            if let responder = v.findFirstResponder() {
                return responder
            }
        }
        return nil
    }
    
    func findSuperView<T>(ofType: T.Type) -> T? {
        if let superView = self.superview {
            switch superView {
            case let superView as T:
                return superView
            default:
                return superView.findSuperView(ofType: ofType)
            }
        }
        return nil
    }
    
    
}
