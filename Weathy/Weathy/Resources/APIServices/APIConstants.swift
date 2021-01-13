//
//  APIConstants.swift
//  Weathy
//
//  Created by 이예슬 on 2020/12/31.
//

import Foundation

struct APIConstants{
    static let baseURL = "http://15.164.146.132:3000"
    
    /// create User Post 관련 (weathy 첫 이용시)
    static let createUserURL = baseURL + "/users"
    static let modifyUserURL = baseURL + "/users/:user-id"

    /// Login Post 관련
    static let loginURL = baseURL + "/auth/login"
    
}
