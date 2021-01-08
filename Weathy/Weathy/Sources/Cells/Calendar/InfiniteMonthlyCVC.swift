//
//  InfiniteScrollCVC.swift
//  Weathy
//
//  Created by 이예슬 on 2021/01/07.
//

import UIKit

class InfiniteMonthlyCVC: UICollectionViewCell {
    static let identifier = "InfiniteMonthlyCVC"
    let screen = UIScreen.main.bounds
    var monthlyLines = 5
    var dateComponents = DateComponents()
    var lastComponents = DateComponents()
    var nextComponents = DateComponents()
    var lastDate = Date()
    var isThisMonth = true
    let today = Date()
    var monthHeightConstraint = 520
    var selectedDate = Date()
    let dayList = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31]
    let monthList = [0,1,2,3,4,5,6,7,8,9,10,11,12]
    
    @IBOutlet weak var monthlyCalendarCV: UICollectionView!

    
    override func awakeFromNib(){
        super.awakeFromNib()
        monthlyCalendarCV.delegate = self
        monthlyCalendarCV.dataSource = self
        // Initialization code
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

        if selectedDate.firstWeekday == 0{
            if selectedDate.month == 2 && selectedDate.isLeapMonth == false{
                monthlyLines = 4
            }
            else{
                monthlyLines = 5
            }
        }
        else{
            if selectedDate.firstWeekday == 6 || (selectedDate.firstWeekday == 5 && selectedDate.numberOfMonth == 31){
                monthlyLines = 6
            }
            else{
                monthlyLines = 5
            }
            
        }
        
    }
    
}

//MARK: UICollectionViewDelegate

extension InfiniteMonthlyCVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath.item) is selected")
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(Int((308*screen.width/375)/7)), height: CGFloat(516/CGFloat(monthlyLines)))
        
    }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    
}

//MARK: - UICollectionView DataSource

extension InfiniteMonthlyCVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return monthlyLines*7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MonthlyCalendarCVC.identifier, for: indexPath) as? MonthlyCalendarCVC else { return UICollectionViewCell() }
            cell.setDay()
                //이번달
        print("month",selectedDate.month,selectedDate.numberOfMonth)
                if indexPath.item >= selectedDate.firstWeekday && indexPath.item < selectedDate.firstWeekday+selectedDate.numberOfMonth{
                    //현재 날짜(현재달)
                        cell.dayLabel.text = String(indexPath.item-selectedDate.firstWeekday+1)
   
                }
                //이전달
                else if indexPath.item < selectedDate.firstWeekday{
                    
                    let numberOfMonth = lastDate.numberOfMonth
                    cell.dayLabel.text = String(numberOfMonth-selectedDate.firstWeekday+1+indexPath.item)
                    cell.setNonCurrent()
                    
                }
                //다음달
                else if indexPath.item >= selectedDate.firstWeekday+selectedDate.numberOfMonth{
                    ///indexPath.item == firstWeekday+numberOfMonth
                    cell.dayLabel.text = String(indexPath.item - (selectedDate.firstWeekday + selectedDate.numberOfMonth) + 1)
                    cell.setNonCurrent()

                }
       
            return cell

    }
}
