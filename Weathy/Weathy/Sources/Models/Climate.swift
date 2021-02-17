//
//  Climate.swift
//  Weathy
//
//  Created by inae Lee on 2021/02/18.
//

import Foundation

// MARK: - Climate

struct Climate: Codable {
    let iconID: Int
    let description: String?

    enum CodingKeys: String, CodingKey {
        case iconID = "iconId"
        case description
    }
}
