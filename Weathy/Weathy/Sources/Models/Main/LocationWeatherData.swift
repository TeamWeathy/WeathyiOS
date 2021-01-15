//
//  LocationWeatherData.swift
//  Weathy
//
//  Created by inae Lee on 2021/01/13.
//

import Foundation

// MARK: - LocationWeatherData

struct LocationWeatherData: Codable {
    let overviewWeather: MainOverviewWeather
    let message: String
}

// MARK: - OverviewWeather
struct MainOverviewWeather: Codable {
    let region: MainRegion
    let dailyWeather: MainDailyWeather
    let hourlyWeather: MainHourlyWeather
}

// MARK: - DailyWeather
struct MainDailyWeather: Codable {
    let date: MainDateClass
    let temperature: MainTemperature
}

// MARK: - DateClass
struct MainDateClass: Codable {
    let year, month, day: Int
    let dayOfWeek: String
}

// MARK: - Temperature
struct MainTemperature: Codable {
    let maxTemp, minTemp: Int
}

// MARK: - HourlyWeather
struct MainHourlyWeather: Codable {
    let time: String?
    let temperature: Int?
    let climate: MainClimate
    let pop: Int
}

// MARK: - Climate
struct MainClimate: Codable {
    let iconID: Int
    let climateDescription: String

    enum CodingKeys: String, CodingKey {
        case iconID = "iconId"
        case climateDescription = "description"
    }
}

// MARK: - Region
struct MainRegion: Codable {
    let code: Int
    let name: String
}
