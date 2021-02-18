//
//  OverviewWeather.swift
//  Weathy
//
//  Created by inae Lee on 2021/02/18.
//

import Foundation

// MARK: - OverviewWeather

struct OverviewWeather: Codable {
    let region: Region
    let dailyWeather: DailyWeather
    let hourlyWeather: HourlyWeather
}
