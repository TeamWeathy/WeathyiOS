//
//  UserDefaults+Extensions.swift
//  Weathy
//
//  Created by inae Lee on 2021/02/24.
//

import UIKit

extension UserDefaults {
    func isExistUserDefaults(_ key: String) -> Bool {
        UserDefaults.standard.object(forKey: key) != nil
    }
}
