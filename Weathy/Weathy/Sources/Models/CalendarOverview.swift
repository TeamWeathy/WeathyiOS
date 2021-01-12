//
//  CalendarOverview.swift
//  Weathy
//
//  Created by 이예슬 on 2021/01/13.
//

import Foundation

struct CalendarOverview: Codable {
    var calendarOverviewList: [CalendarOverviewList?]
    var message: String
}

// MARK: - CalendarOverviewList
struct CalendarOverviewList: Codable {
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
