//
//  Extension+ Scrollview.swift
//  MyFinalApp
//
//  Created by VERTEX24 on 2019/08/20.
//  Copyright © 2019 VERTEX24. All rights reserved.
//

import Foundation
import UIKit


extension UIScrollView {
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesBegan(touches, with: event)
        print("touchesBegan")
    }
}
