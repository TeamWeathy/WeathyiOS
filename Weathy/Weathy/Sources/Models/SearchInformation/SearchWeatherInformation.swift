//
//  SearchWeatherInformation.swift
//  Weathy
//
//  Created by 송황호 on 2021/01/14.
//

import Foundation

// MARK: - SearchWeatherInformation
struct SearchWeatherInformation: Codable {
    let overviewWeatherList: [OverviewWeatherList]
    let message: String
}

// MARK: - OverviewWeatherList
struct OverviewWeatherList: Codable {
    let region: searchRegion
    let dailyWeather: searchDailyWeather
    let hourlyWeather: searchHourlyWeather
}

// MARK: - DailyWeather
struct searchDailyWeather: Codable {
    let date: searchDateClass
    let temperature: searchTemperature
}

// MARK: - DateClass
struct searchDateClass: Codable {
    let year, month, day: Int
    let dayOfWeek: String
}

// MARK: - Temperature
struct searchTemperature: Codable {
    let maxTemp, minTemp: Int
}

// MARK: - HourlyWeather
struct searchHourlyWeather: Codable {
    let time: String
    let temperature: Int
    let climate: Climate
    let pop: Int
}

// MARK: - Region
struct searchRegion: Codable {
    let code: CLong
    let name: String
}
