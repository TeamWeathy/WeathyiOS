//
//  UserInformation.swift
//  Weathy
//
//  Created by 송황호 on 2021/01/13.
//

import Foundation

// MARK: - UserInformation

struct UserInformation: Codable {
    let user: UserData
    let token, message: String
}

// MARK: - User

struct UserData: Codable {
    let id: Int
    let nickname: String
}
