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
    
    public var monthlyLines: Int{
        if firstWeekday == 0{
            if month == 2 && isLeapMonth == false{
                return 4
            }
            else{
                return 5
            }
        }
        else{
            if firstWeekday == 6 || (firstWeekday == 5 && numberOfMonth == 31){
                return 6
            }
            else{
                return 5
            }
            
        }
    }
    
    public var startDate: String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if monthlyLines == 4{
            var startYear = self.year
            return "\(startYear)-02-01"
        }
        
        else{
            var firstComponent = DateComponents()
            firstComponent.month = month
            firstComponent.day = 1
            firstComponent.year = year
            
            var firstDate = Calendar.current.date(from: firstComponent)!
            
            var startComponent = DateComponents()
            startComponent.day = -(self.firstWeekday-1)
            
            var startDate = Calendar.current.date(byAdding: startComponent, to: firstDate)!
            
            return dateFormatter.string(from: startDate)
        }

    }
    
    public var endDate: String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if monthlyLines == 4{
            var endYear = self.year
            return "\(endYear)-02-28"
        }
        else{
            var lastComponent = DateComponents()
            lastComponent.month = month
            lastComponent.day = numberOfMonth
            lastComponent.year = year
            
            var lastDate = Calendar.current.date(from: lastComponent)!
            
            var endComponent = DateComponents()
            
            if monthlyLines == 5{
                endComponent.day = 35 - firstWeekday - numberOfMonth
            }
            else if monthlyLines == 6{
                endComponent.day = 42 - firstWeekday - numberOfMonth
            }
            
            var endDate = Calendar.current.date(byAdding: endComponent, to: lastDate)!
            
            return dateFormatter.string(from: endDate)
        }
    }
    
}
