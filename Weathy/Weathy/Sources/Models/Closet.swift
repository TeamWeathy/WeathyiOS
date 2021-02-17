//
//  Closet.swift
//  Weathy
//
//  Created by DANNA LEE on 2021/02/18.
//

import Foundation

// MARK: - Closet
struct Closet: Codable {
    let top, bottom, outer, etc: Category
}

// MARK: - Bottom
struct Category: Codable {
    let categoryID: Int
    let clothes: [Clothes]

    enum CodingKeys: String, CodingKey {
        case categoryID = "categoryId"
        case clothes
    }
}

// MARK: - Clothes
struct Clothes: Codable {
    let id: Int
    let name: String
}
