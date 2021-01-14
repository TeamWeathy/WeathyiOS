//
//  DailyWeatherData.swift
//  Weathy
//
//  Created by inae Lee on 2021/01/15.
//

import Foundation

// MARK: - DaliyWeatherData
struct DaliyWeatherData: Codable {
    let dailyWeatherList: [MainDailyWeather]
    let message: String
}
