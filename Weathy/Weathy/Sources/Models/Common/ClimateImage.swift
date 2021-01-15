//
//  Climate.swift
//  Weathy
//
//  Created by inae Lee on 2021/01/15.
//

import UIKit

struct ClimateImage {
    static func getClimateAssetName(_ climateId: Int) -> String{
        switch (climateId % 100) {
        case 1:
            return climateId < 100 ? "ic_clearsky_day" : "ic_clearsky_night"
        case 2:
            return climateId < 100 ? "ic_fewclouds_day" : "ic_fewclouds_night"
        case 3:
            return "ic_scatteredclouds"
        case 4:
            return "ic_brokenclouds"
        case 9:
            return climateId < 100 ? "icShowerrainDay" : "icShowerrainNight"
        case 10:
            return "icRain"
        case 11:
            return "ic_thunderstorm"
        case 13:
            return "ic_snow"
        case 50:
            return "ic_mist"
        default:
            return ""
        }
    }
    
    static func getClimateMainBgName(_ climateId: Int) -> String {
        switch (climateId % 100) {
        case 1, 2:
            return climateId < 100 ? "mainBgMorningSun" : "mainBgNightStar"
        case 3:
            return climateId < 100 ? "main_bg_morning" : "mainBgNight"
        case 4:
            return climateId < 100 ? "mainBgCloudy" : "mainBgNight"
        case 9:
            return climateId < 100 ? "icShowerrainDay" : "icShowerrainNight"
        case 10, 13:
            return climateId < 100 ? "mainBgSnowrainDay" : "mainBgSnowrainNight"
        case 11, 50:
            return climateId < 100 ? "mainBgCloudy" : "mainBgNight"
        default:
            return ""
        }
    }
    
    static func getClimateMainBlurBarName(_ climateId: Int) -> String {
        switch (climateId % 100) {
        case 1, 2, 3:
            return climateId < 100 ? "mainscroll_box_topblur_morning" : "mainscroll_box_topblur_night"
        case 4, 9, 10, 11, 13, 50:
            return climateId < 100 ? "mainscroll_box_topblur_snowrain" : "mainscroll_box_topblur_night"
        default:
            return ""
        }
    }
    
    static func getSearchClimateMainBlurBarName(_ climateId: Int) -> String {
        switch (climateId % 100) {
        case 1, 2, 3:
            return climateId < 100 ? "search_box_topblur_morning" : "search_box_topblur_night"
        case 4, 9, 10, 11, 13, 50:
            return climateId < 100 ? "search_box_topblur_snowrain" : "search_box_topblur_night"
        default:
            return ""
        }
    }

    
    static func getClimateMainIllust(_ climateId: Int) -> String {
        switch (climateId % 100) {
        case 1:
            return climateId < 100 ? "mainImgClearskyDay" : "mainImgClearskyNight"
        case 2:
            return climateId < 100 ? "mainImgFewcloudsDay" : "mainImgFewcloudsNight"
        case 3:
            return climateId < 100 ? "mainImgScatteredcloudsDay" : "mainImgScatteredcloudsNight"
        case 4:
            return climateId < 100 ? "mainImgBrokencloudsDay" : "mainImgBrokencloudsNight"
        case 9:
            return climateId < 100 ? "icShowerrainDay" : "icShowerrainNight"
        case 10:
            return climateId < 100 ? "mainImgRainDay" : "mainImgRainNight"
        case 11:
            return climateId < 100 ? "mainImgThunderstormDay" : "mainImgThunderstormNight"
        case 13:
            return "mainImgSnowDay"
        case 50:
            return climateId < 100 ? "mainImgMistDay" : "mainImgMistNight"
        default:
            return ""
        }
    }
    
    static func getClimateSearchIllust(_ climateId: Int) -> String {
        switch (climateId % 100) {
        case 1:
            return climateId < 100 ? "search_img_clearsky_day" : "search_img_clearsky_night"
        case 2:
            return climateId < 100 ? "search_img_fewclouds_day" : "search_img_fewclouds_night"
        case 3:
            return climateId < 100 ? "search_img_scatteredclouds" : "search_img_scatteredclouds"
        case 4:
            return climateId < 100 ? "search_img_brokenclouds" : "search_img_brokenclouds"
        case 9:
            return climateId < 100 ? "search_img_showerrain_day" : "search_img_showerrain_nigh"
        case 10:
            return climateId < 100 ? "search_img_rain" : "search_img_rain"
        case 11:
            return climateId < 100 ? "search_img_thunderstorm" : "search_img_thunderstorm"
        case 13:
            return "search_img_snow"
        case 50:
            return climateId < 100 ? "search_img_mist" : "search_img_mist"
        default:
            return ""
        }
    }
}
