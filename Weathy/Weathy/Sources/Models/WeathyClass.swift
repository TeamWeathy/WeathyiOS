//
//  Weathy.swift
//  Weathy
//
//  Created by 이예슬 on 2021/02/18.
//

import Foundation

struct WeathyClass: Codable {
    var region: Region
    var dailyWeather: DailyWeather
    var hourlyWeather: HourlyWeather
    var closet: Closet
    var weathyId, stampId: Int
    var feedback: String?
    var imgUrl: String?
}
