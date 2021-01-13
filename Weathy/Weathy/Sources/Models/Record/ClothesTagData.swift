//
//  ClothesTagData.swift
//  Weathy
//
//  Created by DANNA LEE on 2021/01/13.
//

import Foundation

// MARK: - Welcome
struct GetClothesArrayData: Codable {
    let closet: ClothesTagData
    let message: String
}

// MARK: - Closet
struct ClothesTagData: Codable {
    let top, bottom, outer, etc: TagCategoryData
}

// MARK: - Bottom
struct TagCategoryData: Codable {
    let categoryID: Int
    let clothes: [TagNameData]

    enum CodingKeys: String, CodingKey {
        case categoryID = "categoryId"
        case clothes
    }
}

// MARK: - Clothe
struct TagNameData: Codable {
    let id: Int
    let name: String
//    var isSelected: Bool = false
}
