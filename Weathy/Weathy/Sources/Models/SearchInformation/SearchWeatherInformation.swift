//
//  SearchWeatherInformation.swift
//  Weathy
//
//  Created by 송황호 on 2021/01/14.
//

import Foundation

// MARK: - SearchWeatherInformation
struct SearchWeatherInformation: Codable {
    let overviewWeatherList: [OverviewWeather]
    let message: String
}
