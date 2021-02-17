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
