//
//  ClothesTagData.swift
//  Weathy
//
//  Created by DANNA LEE on 2021/01/13.
//

import Foundation

// MARK: - Welcome
struct GetClothesArrayData: Codable {
    let closet: Closet
    let message: String
}


//MARK: - Welcome
struct AddClothesData: Codable{
    let closet: Closet
    let message: String
}
