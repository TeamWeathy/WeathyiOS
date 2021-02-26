//
//  APIConstants.swift
//  Weathy
//
//  Created by 이예슬 on 2020/12/31.
//

import Foundation

struct APIConstants {
    static let baseURL = "http://15.164.146.132:3001"
    // 기록뷰 - 태그, 태그 추가, 태그 삭제x
    static let clothesTagURL = baseURL + "/users/"
    
    // 웨디 기록
    static let recordWeathyURL = baseURL + "/weathy"
    
    /// monthly url
    static let monthlyWeathyURL = baseURL + "/users/:user-id/calendar?start={start_date}&end={end_date}"
    
    /// weekly url
    static let dailyWeathyURL = baseURL + "/weathy?date={date}"
    
    /// delete url
    static let deleteWeathyURL = baseURL + "/weathy/:weathy-id"
  
    // Main WeatherByLocation
    static let getWeatherByLocationURL = baseURL + "/weather/overview"
  
    /// Create User Post 관련 (weathy 첫 이용시)
    static let createUserURL = baseURL + "/users"
    static let modifyUserURL = baseURL + "/users/:user-id"

    /// Login Post 관련
    static let loginURL = baseURL + "/auth/login"
    
    /// Search Weather 관련
    static let searchURL = baseURL + "/weather/overviews?keyword={keyword}&date={date}"
  
    // Main Card View 관련
    static func getRecommendedWeathyURL(userId: Int, code: Int, date: String) -> String {
        baseURL + "/users/\(userId)/weathy/recommend?code=\(String(code))&date=\(date)"
    }
    
    static func getHourlyWeatherURL(code: Int, date: String) -> String {
        baseURL + "/weather/forecast/hourly?code=\(String(code))&date=\(date)"
    }
    
    static func getDailyWeatherURL(code: Int, date: String) -> String {
        baseURL + "/weather/forecast/daily?code=\(String(code))&date=\(date)"
    }
    
    static func getExtraWeatherURL(code: Int, date: String) -> String {
        baseURL + "/weather/daily/extra?code=\(String(code))&date=\(date)"
    }
}
