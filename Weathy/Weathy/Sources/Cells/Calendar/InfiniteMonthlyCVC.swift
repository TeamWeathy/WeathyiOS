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
    var monthlyWeathyData: MonthlyWeathyData?
    
    @IBOutlet weak var monthlyCalendarCV: UICollectionView!
    
    
    override func awakeFromNib(){
        super.awakeFromNib()
        monthlyCalendarCV.delegate = self
        monthlyCalendarCV.dataSource = self
        initDate(selectedDate)
    }
    
    //MARK: - Calendar Methods
    func initDate(_ selected: Date){
        self.selectedDate = selected
        print("selected",selectedDate.month,selectedDate.firstWeekday)
        lastComponents.year = Calendar.current.component(.year, from: selectedDate)
        lastComponents.month = Calendar.current.component(.month, from: selectedDate)
        print("last",lastComponents)
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
        return selectedDate.monthlyLines*7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MonthlyCalendarCVC.identifier, for: indexPath) as? MonthlyCalendarCVC else { return UICollectionViewCell() }
        print("===")
        cell.setDay()
        ///이번달
        print("plz",selectedDate)
        print("month",selectedDate.month,selectedDate.numberOfMonth)
        if indexPath.item >= selectedDate.firstWeekday && indexPath.item < selectedDate.firstWeekday+selectedDate.numberOfMonth{
            //현재 날짜(현재달)
            if indexPath.item % 7 == 0{
                cell.setRedday()
            }
            if indexPath.item % 7 == 6{
                cell.setSaturday()
            }
            cell.dayLabel.text = String(indexPath.item-selectedDate.firstWeekday+1)
            print("plz",selectedDate.day)
 
            if indexPath.item-selectedDate.firstWeekday+1 == selectedDate.day{
                print("why1")
                cell.isSelected = true
            }
            
            ///현재달이 오늘을 포함하고 있는 경우
            if selectedDate.currentYearMonth == Date().currentYearMonth{
                print("why2")
                if indexPath.item-selectedDate.firstWeekday+1 == Date().day{
                    print("why1")
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
        if let high = monthlyWeathyData?.calendarOverviewList[indexPath.item]?.temperature.maxTemp{
            if let low = monthlyWeathyData?.calendarOverviewList[indexPath.item]?.temperature.minTemp{
                cell.setData(high: high, low: low)
            }
        }
    
    return cell
    
}
}
