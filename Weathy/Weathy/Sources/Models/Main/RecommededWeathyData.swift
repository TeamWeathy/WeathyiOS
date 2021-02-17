//
//  RecommededWeathy.swift
//  Weathy
//
//  Created by inae Lee on 2021/01/14.
//

import Foundation

// MARK: - RecommendedWeathyData

struct RecommendedWeathyData: Codable {
    let weathy: WeathyClass
    let message: String?
}
