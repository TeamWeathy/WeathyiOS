//
//  InfiniteScrollCVC.swift
//  Weathy
//
//  Created by 이예슬 on 2021/01/07.
//

import UIKit

protocol MonthCellDelegate{
    func selectedMonthDateDidChange(_ selectedDate: Date)
}

class InfiniteMonthlyCVC: UICollectionViewCell {
    
    static let identifier = "InfiniteMonthlyCVC"
    
    let screen = UIScreen.main.bounds
    var dateComponents = DateComponents()
    var lastComponents = DateComponents()
    var nextComponents = DateComponents()
    var lastDate = Date()
    var isThisMonth = true
    let today = Date()
    var selectedDate = Date()
    var monthCellDelegate: MonthCellDelegate?
    var lastSelectedIdx = Date().firstWeekday - 1 + Date().day
    var monthlyWeathyList: [CalendarOverview?] = []
    @IBOutlet weak var monthlyCalendarCV: UICollectionView!
    
    
    override func awakeFromNib(){
        super.awakeFromNib()
        monthlyCalendarCV.delegate = self
        monthlyCalendarCV.dataSource = self
        selectedDateDidChange(selectedDate)
        monthlyWeathyList = []
        callMonthlyWeathy()
        
    }
    
    //MARK: - Network
    
    func callMonthlyWeathy(){
        MonthlyWeathyService.shared.getMonthlyCalendar(userID: 61, startDate: selectedDate.startDate, endDate: selectedDate.endDate){ (networkResult) -> (Void) in
            switch networkResult {
                case .success(let data):
                    if let monthlyData = data as? [CalendarOverview?]{
                        print(">>netsucess",monthlyData)
                        self.monthlyWeathyList = monthlyData
                        DispatchQueue.main.async {
                            self.monthlyCalendarCV.reloadData()
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
    
    //MARK: - Calendar Methods
    
    func selectedDateDidChange(_ selected: Date){
        self.selectedDate = selected
        lastComponents.year = Calendar.current.component(.year, from: selectedDate)
        lastComponents.month = Calendar.current.component(.month, from: selectedDate)
        if lastComponents.month == 1{
            lastComponents.year! -= 1
            lastComponents.month = 12
        }
        
        else{
            lastComponents.month! -= 1
        }
        lastDate = Calendar.current.date(from: lastComponents)!
        
        if selectedDate.year == Date().year && selectedDate.month == Date().month{
            isThisMonth = true
        }
        else{
            isThisMonth = false
        }
        
    }
    
}

//MARK: UICollectionViewDelegate

extension InfiniteMonthlyCVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if lastSelectedIdx != indexPath.item{
            if let cell = collectionView.cellForItem(at: [0,lastSelectedIdx]) as? MonthlyCalendarCVC{
                cell.isSelected = false
            }
            if let cell = collectionView.cellForItem(at: indexPath) as? MonthlyCalendarCVC{
                var selectedComponent = DateComponents()
                selectedComponent.day = indexPath.item - (selectedDate.firstWeekday - 1 + selectedDate.day)
                selectedDate = Calendar.current.date(byAdding: selectedComponent, to: selectedDate)!
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ChangeData"), object: selectedDate)
                monthCellDelegate?.selectedMonthDateDidChange(selectedDate)
                lastSelectedIdx = indexPath.item
            }
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(Int((308*screen.width/375)/7)), height: CGFloat(516/CGFloat(selectedDate.monthlyLines)))
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
}

//MARK: - UICollectionView DataSource

extension InfiniteMonthlyCVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(">>net",selectedDate,selectedDate.monthlyLines*7,monthlyWeathyList.count,monthlyWeathyList)
        return selectedDate.monthlyLines*7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MonthlyCalendarCVC.identifier, for: indexPath) as? MonthlyCalendarCVC else { return UICollectionViewCell() }
        cell.setDay()
        ///이번달
        if indexPath.item >= selectedDate.firstWeekday && indexPath.item < selectedDate.firstWeekday+selectedDate.numberOfMonth{
            //현재 날짜(현재달)
            if indexPath.item % 7 == 0{
                cell.setRedday()
            }
            if indexPath.item % 7 == 6{
                cell.setSaturday()
            }
            cell.dayLabel.text = String(indexPath.item-selectedDate.firstWeekday+1)
            
            if indexPath.item-selectedDate.firstWeekday+1 == selectedDate.day{
                cell.isSelected = true
            }
            
            ///현재달이 오늘을 포함하고 있는 경우
            if selectedDate.currentYearMonth == Date().currentYearMonth{
                if indexPath.item-selectedDate.firstWeekday+1 == Date().day{
                    cell.setToday()
                }
            }
        }
        
        
        
        ///이전달
        else if indexPath.item < selectedDate.firstWeekday{
            
            let numberOfMonth = lastDate.numberOfMonth
            cell.dayLabel.text = String(numberOfMonth-selectedDate.firstWeekday+1+indexPath.item)
            cell.setNonCurrent()
            
        }
        ///다음달
        else if indexPath.item >= selectedDate.firstWeekday+selectedDate.numberOfMonth{
            ///indexPath.item == firstWeekday+numberOfMonth
            cell.dayLabel.text = String(indexPath.item - (selectedDate.firstWeekday + selectedDate.numberOfMonth) + 1)
            cell.setNonCurrent()
            
        }
        
        ///데이터 표시
        if monthlyWeathyList.count == 7{
            if let data = monthlyWeathyList[indexPath.item]{
                cell.setData(high: data.temperature.maxTemp, low: data.temperature.minTemp)
            }
            
            
        }
        
        
        return cell
        
    }
}
