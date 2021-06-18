//
//  RecordNVC.swift
//  Weathy
//
//  Created by 송황호 on 2021/01/13.
//

import UIKit

class RecordNVC: UINavigationController {

    static let identifier = "RecordNVC"
    
    var origin: AccessOrigin?
    var dateToday: Date?
    var dateString: String = "0000-00-00"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        judgeWhereFrom()
        sendData()
        
        // Do any additional setup after loading the view.
    }
    

}

extension RecordNVC {
    
    func judgeWhereFrom() {
        switch origin {
        case .plusRecord:
            print("플러스 버튼에서의 접근")
            /// 앱 델리게이트에서 년, 월, 일을 받아와 문자열로 변환
            let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
            
            if let savedData = appDelegate.overviewData {
                dateString = "\(String((savedData.dailyWeather.date.year)!))-\(String(format: "%02d", savedData.dailyWeather.date.month))-\(String(format: "%02d", savedData.dailyWeather.date.day))"
                
                /// 년, 월, 일을 Date 형식으로 변환
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                dateFormatter.locale = Locale(identifier: "ko-Kr")
                
                let dateTimeString: String = "\(dateString) 00:00:00"
                dateToday = dateFormatter.date(from: dateTimeString)
            }
            
        case .calendarRecord:
            print("캘린더에서의 접근")
        case .none:
            print("잘못된 접근")
            self.showToast(message: "잘못된 접근입니다.")
            dateString = ""
        }
    }
    
    func sendData() {
        
        guard let root = self.viewControllers[0] as? RecordStartVC else {
            return
        }
        
        root.dateToday = dateToday
        root.dateString = dateString
    }
    
}

enum AccessOrigin {
    case plusRecord
    case calendarRecord
}
