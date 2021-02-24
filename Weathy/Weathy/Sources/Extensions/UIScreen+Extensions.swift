//
//  UIScreen+Extensions.swift
//  Weathy
//
//  Created by 이예슬 on 2021/02/24.
//

import UIKit

extension UIScreen{
    public var hasNotch: Bool{
        let deviceRatio
            = UIScreen.main.bounds.width / UIScreen.main.bounds.height
        if deviceRatio > 0.5{
            return false
        }
        else{
            return true
        }
    }
}
