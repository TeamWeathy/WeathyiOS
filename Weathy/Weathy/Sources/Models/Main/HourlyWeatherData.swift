//
//  HourlyWeatherData.swift
//  Weathy
//
//  Created by inae Lee on 2021/01/14.
//

import Foundation

// MARK: - HourlyWeatherData
struct HourlyWeatherData: Codable {
    let hourlyWeatherList: [MainHourlyWeather]
    let message: String
}
