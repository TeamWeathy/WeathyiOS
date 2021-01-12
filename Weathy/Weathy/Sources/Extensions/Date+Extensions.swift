//
//  Date+Extensions.swift
//  Weathy
//
//  Created by 이예슬 on 2021/01/07.
//
import Foundation

extension Date {
    public var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    public var month: Int {
         return Calendar.current.component(.month, from: self)
    }
    
    public var day: Int {
         return Calendar.current.component(.day, from: self)
    }
    
    public var weekday: Int{
        return Calendar.current.component(.weekday, from: self) - 1
    }
    
    public var monthType: Int{
        if month<10{
            return 0
        }
        else{
            return 1
        }
    }
    
    public var currentYearMonth: String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: self)
    }

    public var nextYearMonth: String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM"
        dateFormatter.timeZone = TimeZone.current
        var dateComponent = DateComponents()
        let current = self
        dateComponent.month = 1
        let nextDate = Calendar.current.date(byAdding: dateComponent, to: current)!
        return dateFormatter.string(from:nextDate)
    }
    
    public var lastYearMonth: String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM"
        dateFormatter.timeZone = TimeZone.current
        var dateComponent = DateComponents()
        let current = self
        dateComponent.month = -1
        let nextDate = Calendar.current.date(byAdding: dateComponent, to: current)!
        return dateFormatter.string(from:nextDate)
    }
    public var isLeapMonth: Bool{
        if year % 400 == 0 || (year % 4 == 0 && year % 100 != 0){
            return true
        }
        else{
            return false
        }
    }
    
    public var numberOfMonth: Int{
        let numberList = [0,31,28,31,30,31,30,31,31,30,31,30,31]
        if isLeapMonth && month == 2{
            return 29
        }
        else{
            return numberList[month]
        }
    }
    
    public var firstWeekday: Int{
        var dateComponent = DateComponents()
        dateComponent.year = Calendar.current.component(.year, from: self)
        dateComponent.month = Calendar.current.component(.month, from: self)
        dateComponent.day = 1
        dateComponent.weekday = Calendar.current.component(.weekday,from: Calendar.current.date(from: dateComponent)!)
        /// 리턴값 : 일 - 토 -> 0 - 6
        return dateComponent.weekday! - 1
    }
    
    
}
