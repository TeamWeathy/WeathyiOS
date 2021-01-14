//
//  SearchWeatherInformation.swift
//  Weathy
//
//  Created by 송황호 on 2021/01/14.
//

import Foundation

// MARK: - SearchWeatherInformation
struct SearchWeatherInformation: Codable {
    let overviewWeatherList: [SearchOverviewWeatherList]
    let message: String
}

// MARK: - OverviewWeatherList
struct SearchOverviewWeatherList: Codable {
    let region: SearchRegion
    let dailyWeather: SearchDailyWeather
    let hourlyWeather: SearchHourlyWeather
}

// MARK: - DailyWeather
struct SearchDailyWeather: Codable {
    let date: SearchData
    let temperature: SearchTemperature
}

// MARK: - DateClass
struct SearchData: Codable {
    let year, month, day: Int
    let dayOfWeek: String
}

// MARK: - Temperature
struct SearchTemperature: Codable {
    let maxTemp, minTemp: Int
}

// MARK: - HourlyWeather
struct SearchHourlyWeather: Codable {
    let time: String
    let temperature: Int
    let climate: SearchClimate
    let pop: Int
}

// MARK: - Climate
struct SearchClimate: Codable {
    let iconID: Int
    let climateDescription: String

    enum SearchCodingKeys: String, CodingKey {
        case iconID = "iconId"
        case climateDescription = "description"
    }
}

// MARK: - Region
struct SearchRegion: Codable {
    let code: Int
    let name: String
}
