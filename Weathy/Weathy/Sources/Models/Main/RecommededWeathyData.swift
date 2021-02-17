//
//  RecommededWeathy.swift
//  Weathy
//
//  Created by inae Lee on 2021/01/14.
//

import Foundation

// MARK: - RecommendedWeathyData
struct RecommendedWeathyData: Codable {
    let weathy: MainWeathy
    let message: String?
}

// MARK: - Weathy
struct MainWeathy: Codable {
    let region: MainRegion
    let dailyWeather: MainDailyWeather
    let hourlyWeather: MainHourlyWeather
    let closet: Closet
    let weathyID, stampID: Int
    let feedback: String

    enum CodingKeys: String, CodingKey {
        case region, dailyWeather, hourlyWeather, closet
        case weathyID = "weathyId"
        case stampID = "stampId"
        case feedback
    }
}

// MARK: - Closet
//struct Closet: Codable {
//    let top, bottom, outer, etc: MainCategory
//}

// MARK: - Bottom
struct MainCategory: Codable {
    let categoryID: Int
    let clothes: [Clothe]

    enum CodingKeys: String, CodingKey {
        case categoryID = "categoryId"
        case clothes
    }
}

// MARK: - Clothe
struct Clothe: Codable {
    let id: Int
    let name: String
}
