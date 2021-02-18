//
//  DateClass.swift
//  Weathy
//
//  Created by inae Lee on 2021/02/18.
//

import Foundation

// MARK: - DateClass

struct DateClass: Codable {
    let year: Int?
    var month, day: Int
    let dayOfWeek: String
}
