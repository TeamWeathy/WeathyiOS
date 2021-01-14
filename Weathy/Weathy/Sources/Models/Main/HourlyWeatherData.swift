//
//  HourlyWeatherData.swift
//  Weathy
//
//  Created by inae Lee on 2021/01/14.
//

import Foundation

// MARK: - HourlyWeatherData
struct HourlyWeatherData: Codable {
    let hourlyWeatherList: [HourlyWeatherList]
    let message: String
}

// MARK: - HourlyWeatherList
struct HourlyWeatherList: Codable {
    let time: String
    let temperature: Int
    let climate: MainClimate
    let pop: Int
}
