//
//  ExtraWeather.swift
//  Weathy
//
//  Created by inae Lee on 2021/02/18.
//

import Foundation

// MARK: - ExtraWeather

struct ExtraWeather: Codable {
    let rain, humidity, wind: ExtraData
}

// MARK: - ExtraType

struct ExtraData: Codable {
    let value: Double
    let rating: Int
}
