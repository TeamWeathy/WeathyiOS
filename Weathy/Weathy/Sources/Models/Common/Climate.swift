//
//  Climate.swift
//  Weathy
//
//  Created by inae Lee on 2021/01/15.
//

import UIKit

struct Climate {
    static func getClimateAssetName(_ climateId: Int) -> String{
        switch (climateId % 100) {
        case 1:
            return climateId < 100 ? "ic_clearsky_day" : "ic_clearsky_night"
        case 2:
            return climateId < 100 ? "ic_fewclouds_day" : "ic_fewclouds_night"
        case 3:
            return "ic_scatteredclouds"
        case 4:
            return "ic_scatteredclouds"
        case 9:
            return climateId < 100 ? "icShowerrainDay" : "icShowerrainNight"
        case 10:
            return "icRain"
        case 11:
            return "ic_thunderstorm"
        case 13:
            return "ic_snow"
        case 15:
            return "ic_mist"
        default:
            return ""
        }
    }
}
