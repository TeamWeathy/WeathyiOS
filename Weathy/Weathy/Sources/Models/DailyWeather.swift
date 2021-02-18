//
//  DailyWeather.swift
//  Weathy
//
//  Created by inae Lee on 2021/02/18.
//

import Foundation

// MARK: - DailyWeather

struct DailyWeather: Codable {
    let date: DateClass
    let temperature: HighLowTemp
    let climate: Climate?
    let climateID: Int?

    enum CodingKeys: String, CodingKey {
        case date
        case temperature
        case climate
        case climateID = "climateId"
    }
}
