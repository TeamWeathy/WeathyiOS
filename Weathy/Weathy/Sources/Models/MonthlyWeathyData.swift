//
//  CalendarOverview.swift
//  Weathy
//
//  Created by 이예슬 on 2021/01/13.
//

import Foundation

struct MonthlyWeathyData: Codable {
    var calendarOverviewList: [CalendarOverview?]
    var message: String
}

// MARK: - CalendarOverviewList
struct CalendarOverview: Codable {
    var id, stampID: Int
    var temperature: Temperature

    enum CodingKeys: String, CodingKey {
        case id
        case stampID = "stampId"
        case temperature
    }
}

// MARK: - Temperature
struct Temperature: Codable {
    var maxTemp, minTemp: Int
}
