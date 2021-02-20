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
    var standardDate = Date()
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        callWeeklyWeathy()
    }
    
    //MARK: - Network
    
    func callWeeklyWeathy(){
        var start = ""
        var startComponent = DateComponents()
        var startDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        startComponent.day = -standardDate.weekday
        startDate = Calendar.current.date(byAdding: startComponent, to: standardDate)!
        start = dateFormatter.string(from: startDate)
        var end = ""
        var endComponent = DateComponents()
        var endDate = Date()
        endComponent.day = 7 - (standardDate.weekday + 1)
        endDate = Calendar.current.date(byAdding: endComponent, to: standardDate)!
        end = dateFormatter.string(from: endDate)
        
        MonthlyWeathyService.shared.getMonthlyCalendar(userID: UserDefaults.standard.integer(forKey: "userId"), startDate: start, endDate: end){ (networkResult) -> (Void) in
            switch networkResult {
                case .success(let data):
                    if let weeklyData = data as? [CalendarOverview?]{
                        self.weeklyWeathyList = weeklyData
                        DispatchQueue.main.async {
                            self.weeklyCalendarCV.reloadData()
                        }
                    }
                    
                case .requestErr(let msg):
                    print("[Monthly] requestErr",msg)
                case .serverErr:
                    print("[Monthly] serverErr")
                case .networkFail:
                    print("[Monthly] networkFail")
                case .pathErr:
                    print("[Monthly] pathErr")
                    
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

//MARK: - UICollectionView Delegate

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
            
            selectedComponent.day = indexPath.item - standardDate.weekday
            let newSelectedDate = Calendar.current.date(byAdding: selectedComponent, to: standardDate)!
            if newSelectedDate.compare(Date()) == .orderedDescending{
                return false
            }
            return true
            
        }
        return true
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if lastSelectedIdx != indexPath.item{
            if let cell = collectionView.cellForItem(at: [0,lastSelectedIdx]) as? WeeklyCalendarCVC{
                cell.isSelected = false
            }
            if let cell = collectionView.cellForItem(at: indexPath) as? WeeklyCalendarCVC{
                var selectedComponent = DateComponents()
                selectedComponent.day = indexPath.item - standardDate.weekday
                standardDate = Calendar.current.date(byAdding: selectedComponent, to: standardDate)!
                weekCellDelegate?.selectedWeekDateDidChange(standardDate)
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ChangeData"), object: selectedDate)
                lastSelectedIdx = indexPath.item
            }
        }
    }
}

//MARK: - UICollectionView DataSource

extension InfiniteWeeklyCVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeeklyCalendarCVC.identifier, for: indexPath) as? WeeklyCalendarCVC else { return UICollectionViewCell() }
        cell.selectedView.alpha = 0
        cell.todayView.alpha = 0
        cell.emotionView.alpha = 0
        let tempIdx = indexPath.item + standardDate.day-(standardDate.weekday)
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
            cell.isSelected = true
            cell.setSelectedDay()
        }
        else if indexPath.item > standardDate.weekday{
            cell.emotionView.alpha = 0
        }
        ///현재주가 오늘을 포함하고 있는 경우
        if standardDate.currentYearMonth == Date().currentYearMonth{
            if indexPath.item + standardDate.day-(standardDate.weekday) == Date().day{
                cell.setToday()
            }
        }
        else if standardDate.currentYearMonth > Date().currentYearMonth{
            cell.setGreyDay()
        }
        ///현재달
        if 0 < tempIdx && tempIdx <= standardDate.numberOfMonth{
            cell.dayLabel.text = String(indexPath.item + standardDate.day-(standardDate.weekday))
        }
        ///이전달
        else if tempIdx<=0{
            var last = Date()
            var lastComponent = DateComponents()
            lastComponent.month = -1
            last = Calendar.current.date(byAdding: lastComponent, to: standardDate)!
            cell.dayLabel.text = String(last.numberOfMonth + tempIdx)
            cell.setGreyDay()
        }
        ///다음달
        else if tempIdx > standardDate.numberOfMonth{
            cell.dayLabel.text = String(tempIdx - standardDate.numberOfMonth)
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
