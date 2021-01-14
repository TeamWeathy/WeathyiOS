//
//  APIConstants.swift
//  Weathy
//
//  Created by 이예슬 on 2020/12/31.
//

import Foundation

struct APIConstants{
    static let baseURL = "http://ec2-15-164-146-132.ap-northeast-2.compute.amazonaws.com:3000"
    
    // Main
    static let getWeatherByLocationURL = baseURL + "/weather/overview"
    
    static func getRecommendedWeathyURL(userId: Int, code: String, date: String) -> String {
        return baseURL + "/users/\(userId)/weathy/recommend?code=\(code)&date=\(date)"
    }
    
    static func getHourlyWeatherURL(code: String, date: String) -> String {
        return baseURL + "/weather/forecast/hourly?code=\(code)&date=\(date)"
    }
}
