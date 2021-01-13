//
//  LocationWeatherData.swift
//  Weathy
//
//  Created by inae Lee on 2021/01/13.
//

import Foundation

// MARK: - LocationWeatherData
struct LocationWeatherData: Codable {
    let overviewWeather: OverviewWeather
    let message: String
}

// MARK: - OverviewWeather
struct OverviewWeather: Codable {
    let region: Region
    let dailyWeather: DailyWeather
    let hourlyWeather: HourlyWeather
}

// MARK: - DailyWeather
struct DailyWeather: Codable {
    let date: DateClass
    let temperature: Temperature
}

// MARK: - DateClass
struct DateClass: Codable {
    let year, month, day: Int
    let dayOfWeek: String
}

// MARK: - Temperature
struct Temperature: Codable {
    let maxTemp, minTemp: Int
}

// MARK: - HourlyWeather
struct HourlyWeather: Codable {
    let time: String
    let temperature: Int
    let climate: Climate
    let pop: Int
}

// MARK: - Climate
struct Climate: Codable {
    let iconID: Int
    let climateDescription: String

    enum CodingKeys: String, CodingKey {
        case iconID = "iconId"
        case climateDescription = "description"
    }
}

// MARK: - Region
struct Region: Codable {
    let code: Int
    let name: String
}
