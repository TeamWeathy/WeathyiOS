//
//  HourlyWeather.swift
//  Weathy
//
//  Created by inae Lee on 2021/02/18.
//

import Foundation

// MARK: - HourlyWeather

struct HourlyWeather: Codable {
    let time: String?
    let temperature: Int?
    let climate: Climate
    let pop: Int
}
