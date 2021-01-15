//
//  DailyWeathyData.swift
//  Weathy
//
//  Created by 이예슬 on 2021/01/14.
//

import Foundation

struct DailyWeathyData: Codable{
    var weathy: CalendarWeathy?
    var message: String
}

struct CalendarWeathy: Codable{
    var region: CalendarRegion
    var dailyWeather: CalendarDailyWeather
    var hourlyWeather: CalendarHourlyWeather
    var closet: CalendarCloset
    var weathyId, stampId: Int
    var feedback: String
}

struct CalendarCloset: Codable{
    var bottom, etc, outer, top: CalendarTag
}

struct CalendarTag: Codable{
    var categoryId: Int
    var clothes: [Clothe]
}

struct CalendarDailyWeather: Codable{
    var date: CalendarDateClass
    var temperature: DailyTemperature
}

struct CalendarDateClass: Codable{
    var year, month, day: Int
    var dayOfWeek: String
}

struct DailyTemperature: Codable{
    var maxTemp, minTemp: Int
}

// MARK: - HourlyWeather
struct CalendarHourlyWeather: Codable{
    var climate: CalendarClimate
    var pop: Int
}

// MARK: - Climate
struct CalendarClimate: Codable{
    var iconId: Int
    var description: String
}

// MARK: - Region
struct CalendarRegion: Codable{
    var code: Int
    var name: String
}
