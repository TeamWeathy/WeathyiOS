//
//  InfiniteWeeklyCVC.swift
//  Weathy
//
//  Created by 이예슬 on 2021/01/09.
//

import UIKit

protocol WeekCellDelegate{
    func selectedWeekDateDidChange(_ selectedDate: Date)
}

class InfiniteWeeklyCVC: UICollectionViewCell {
    
    static let identifier = "InfiniteWeeklyCVC"
    var selectedDate = Date()
    var lastSelectedIdx = Date().weekday
    let screen = UIScreen.main.bounds
    var weekCellDelegate: WeekCellDelegate?
    var weeklyWeathyList: [CalendarOverview?] = []
    
    @IBOutlet weak var weeklyCalendarCV: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        weeklyCalendarCV.delegate = self
        weeklyCalendarCV.dataSource = self
        callWeeklyWeathy()
        NotificationCenter.default.addObserver(self, selector: #selector(setDeleted(_:)), name: NSNotification.Name("DeleteWeathy"), object: nil)
    }
    
    //MARK: - Network
    
    func callWeeklyWeathy(){
        var start = ""
        var startComponent = DateComponents()
        var startDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        startComponent.day = -selectedDate.weekday
        startDate = Calendar.current.date(byAdding: startComponent, to: selectedDate)!
        start = dateFormatter.string(from: startDate)
        var end = ""
        var endComponent = DateComponents()
        var endDate = Date()
        endComponent.day = 7 - (selectedDate.weekday + 1)
        endDate = Calendar.current.date(byAdding: endComponent, to: selectedDate)!
        end = dateFormatter.string(from: endDate)
        
        MonthlyWeathyService.shared.getMonthlyCalendar(userID: 61, startDate: start, endDate: end){ (networkResult) -> (Void) in
            switch networkResult {
                case .success(let data):
                    if let weeklyData = data as? [CalendarOverview?]{
                        print(">>netsucess",weeklyData)
                        self.weeklyWeathyList = weeklyData
                        DispatchQueue.main.async {
                            self.weeklyCalendarCV.reloadData()
                        }
                    }
                    
                case .requestErr(let msg):
                    print(">>networkrequest",msg)
                case .serverErr:
                    print(">>networkserverErr")
                case .networkFail:
                    print(">>networknetworkFail")
                case .pathErr:
                    print(">>networkpathErr")
                    
            }
            
        }
    }
    
    @objc func setDeleted(_ noti: Notification){
        if let idx = noti.object as? Int{
            if let cell = weeklyCalendarCV.cellForItem(at:[0,idx]) as? WeeklyCalendarCVC{
                cell.emotionView.alpha = 0
            }
        }
        
    }
    
    
}
extension InfiniteWeeklyCVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 308*screen.width/375/7, height: 105*screen.width/375)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if let cell = collectionView.cellForItem(at: indexPath) as? WeeklyCalendarCVC{
            var selectedComponent = DateComponents()
            
            selectedComponent.day = indexPath.item - selectedDate.weekday
            let newSelectedDate = Calendar.current.date(byAdding: selectedComponent, to: selectedDate)!
            if newSelectedDate.compare(Date()) == .orderedDescending{
                return false
            }
            return true
            
        }
        return true
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("weekly selected",indexPath)
        if lastSelectedIdx != indexPath.item{
            if let cell = collectionView.cellForItem(at: [0,lastSelectedIdx]) as? WeeklyCalendarCVC{
                cell.isSelected = false
            }
            if let cell = collectionView.cellForItem(at: indexPath) as? WeeklyCalendarCVC{
                var selectedComponent = DateComponents()
                selectedComponent.day = indexPath.item - selectedDate.weekday
                selectedDate = Calendar.current.date(byAdding: selectedComponent, to: selectedDate)!
                weekCellDelegate?.selectedWeekDateDidChange(selectedDate)
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ChangeData"), object: selectedDate)
                lastSelectedIdx = indexPath.item
            }
        }
    }
}

extension InfiniteWeeklyCVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeeklyCalendarCVC.identifier, for: indexPath) as? WeeklyCalendarCVC else { return UICollectionViewCell() }
        cell.selectedView.alpha = 0
        cell.todayView.alpha = 0
        cell.emotionView.alpha = 0
        let tempIdx = indexPath.item + selectedDate.day-(selectedDate.weekday)
        ///토요일
        if indexPath.item == 6{
            cell.setSaturday()
        }
        else if indexPath.item == 0{
            cell.setRedDay()
        }
        else{
            cell.dayLabel.textColor = .mainGrey
        }
        if indexPath.item == selectedDate.weekday{
            cell.setSelectedDay()
        }
        else if indexPath.item > selectedDate.weekday{
            cell.emotionView.alpha = 0
        }
        ///현재주가 오늘을 포함하고 있는 경우
        if selectedDate.currentYearMonth == Date().currentYearMonth{
            if indexPath.item + selectedDate.day-(selectedDate.weekday) == Date().day{
                print("today1",selectedDate)
                cell.setToday()
            }
        }
        else if selectedDate.currentYearMonth > Date().currentYearMonth{
            cell.setGreyDay()
        }
        ///현재달
        if 0 < tempIdx && tempIdx <= selectedDate.numberOfMonth{
            cell.dayLabel.text = String(indexPath.item + selectedDate.day-(selectedDate.weekday))
        }
        ///이전달
        else if tempIdx<=0{
            var last = Date()
            var lastComponent = DateComponents()
            lastComponent.month = -1
            last = Calendar.current.date(byAdding: lastComponent, to: selectedDate)!
            cell.dayLabel.text = String(last.numberOfMonth + tempIdx)
            cell.setGreyDay()
        }
        ///다음달
        else if tempIdx > selectedDate.numberOfMonth{
            cell.dayLabel.text = String(tempIdx - selectedDate.numberOfMonth)
            cell.setGreyDay()
        }
        if weeklyWeathyList.count != 0{
            if let data = weeklyWeathyList[indexPath.item]{
                cell.setEmotionView(emotionCode: weeklyWeathyList[indexPath.item]!.stampId)
            }
            
        }
        
        return cell
        
    }
    
}
