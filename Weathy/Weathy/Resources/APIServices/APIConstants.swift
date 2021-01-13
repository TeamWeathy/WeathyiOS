//
//  APIConstants.swift
//  Weathy
//
//  Created by 이예슬 on 2020/12/31.
//

import Foundation

struct APIConstants{
    static let baseURL = "http://15.164.146.132:3000"
    
    ///calendar url
    static let calendarURL = baseURL + "/users/:user-id/calendar?start={start_date}&end={end_date}"
}
