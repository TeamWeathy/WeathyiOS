//
//  SearchRecentInfo.swift
//  Weathy
//
//  Created by 송황호 on 2021/01/11.
//

import Foundation

struct SearchRecentInfo {
    
    var date: String
    var time: String
    var location: String
    var weatherImage: Int
    var currentTemper: String
    var highTemper: String
    var lowTemper: String
    
    init(date: String, time: String, location: String, weatherImage: Int, currentTemper: String, highTemper: String, lowTemper: String){
        
        self.date = date
        self.time = time
        self.location = location
        self.weatherImage = weatherImage
        self.currentTemper = currentTemper
        self.highTemper = highTemper
        self.lowTemper = lowTemper
    }
}
