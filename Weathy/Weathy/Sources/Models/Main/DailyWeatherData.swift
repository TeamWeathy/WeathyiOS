//
//  DailyWeatherData.swift
//  Weathy
//
//  Created by inae Lee on 2021/01/15.
//

import Foundation

// MARK: - DailyWeatherData
struct DailyWeatherData: Codable {
    let dailyWeatherList: [DailyWeather]
    let message: String
}
