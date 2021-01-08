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
        return "\(year).\(month)"
    }

    public var nextYearMonth: String{
        if month == 12{
            return "\(year+1).01"
        }
        else{
            return "\(year).\(month+1)"
        }
    }
    
    public var lastYearMonth: String{
        if month == 1{
            return "\(year-1).12"
        }
        else{
            return "\(year).\(month-1)"
        }
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
