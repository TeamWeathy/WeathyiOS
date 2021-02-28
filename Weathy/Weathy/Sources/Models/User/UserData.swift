//
//  UserInformation.swift
//  Weathy
//
//  Created by 송황호 on 2021/01/13.
//

import Foundation

// MARK: - UserInformation

struct UserData: Codable {
    let user: User
    let token, message: String
}
