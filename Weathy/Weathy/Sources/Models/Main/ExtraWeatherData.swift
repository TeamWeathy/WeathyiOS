//
//  ExtraWeatherData.swift
//  Weathy
//
//  Created by inae Lee on 2021/01/15.
//

import Foundation

// MARK: - ExtraWeatherData
struct ExtraWeatherData: Codable {
    let extraWeather: ExtraWeather
    let message: String
}

// MARK: - ExtraWeather
struct ExtraWeather: Codable {
    let rain, humidity, wind: ExtraData
}

// MARK: - ExtraType
struct ExtraData: Codable {
    let value: Double
    let rating: Int
}
