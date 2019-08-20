//
//  Struct.swift
//  MyFinalApp
//
//  Created by VERTEX24 on 2019/08/20.
//  Copyright © 2019 VERTEX24. All rights reserved.
//

import Foundation
import UIKit


// Keyboard の Notification.userInfo をマッピングする Struct
struct UIKeyboardInfo {
    let frame: CGRect
    let animationDuration: TimeInterval
    let animationCurve: UIView.AnimationOptions
    
    init?(info: [AnyHashable : Any]) {
        guard
            let frame = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let curve = info[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
            else { return nil }
        self.frame = frame
        animationDuration = duration
        animationCurve = UIView.AnimationOptions(rawValue: curve)
    }
}

