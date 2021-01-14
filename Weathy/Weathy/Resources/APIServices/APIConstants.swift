//
//  APIConstants.swift
//  Weathy
//
//  Created by 이예슬 on 2020/12/31.
//

import Foundation

struct APIConstants{
    static let baseURL = "http://15.164.146.132:3000"
    // 기록뷰 - 태그, 태그 추가, 태그 삭제
    static let clothesTagURL = baseURL + "/users/"
    
    // 웨디 기록
    static let recordWeathyURL = baseURL + "/weathy"
  
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
    static func getRecommendedWeathyURL(userId: Int, code: String, date: String) -> String {
        return baseURL + "/users/\(userId)/weathy/recommend?code=\(code)&date=\(date)"
    }
    
    static func getHourlyWeatherURL(code: String, date: String) -> String {
        return baseURL + "/weather/forecast/hourly?code=\(code)&date=\(date)"
    }
}
