//
//  CalendarOverview.swift
//  Weathy
//
//  Created by 이예슬 on 2021/01/13.
//

import Foundation

struct MonthlyWeathyData: Codable {
    var calendarOverviewList: [CalendarOverview?]?
    var message: String
}
