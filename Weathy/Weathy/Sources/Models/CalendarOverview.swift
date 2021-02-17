//
//  CalendarOverview.swift
//  Weathy
//
//  Created by 이예슬 on 2021/02/18.
//

import Foundation

struct CalendarOverview: Codable {
    var id: Int
    var date: String
    var stampId: Int
    var temperature: HighLowTemp
}
