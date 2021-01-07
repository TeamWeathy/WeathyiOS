//
//  InfiniteScrollCVC.swift
//  Weathy
//
//  Created by 이예슬 on 2021/01/07.
//

import UIKit

class InfiniteScrollCVC: UICollectionViewCell {
    static let identifier = "InfiniteScrollCVC"
    var monthlyLines = 5
    var dateComponents = DateComponents()
    var lastComponents = DateComponents()
    var nextComponents = DateComponents()
    var isThisMonth = true
    let today = Date()
    var firstDayOfMonth = 0
    @IBOutlet weak var monthlyCalendarCV: UICollectionView!
    var monthHeightConstraint = 520
    
    override func awakeFromNib(){
        super.awakeFromNib()
        monthlyCalendarCV.delegate = self
        monthlyCalendarCV.dataSource = self
        // Initialization code
//        initDate("2021.1")
    }
    
    //MARK: - Calendar Methods
    func initDate(_ dateString:String){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM"
        let date = dateFormatter.date(from: dateString)
        dateComponents.year = Calendar.current.component(.year,from: date!)
        dateComponents.month = Calendar.current.component(.month, from: date!)
        if dateComponents.year == Calendar.current.component(.year,from: today) && dateComponents.month == Calendar.current.component(.month, from: today){
            isThisMonth = true
        }
        else{
            isThisMonth = false
        }
        print("444444",dateComponents)
        dateComponents.day = 1
        dateComponents.weekday = Calendar.current.component(.weekday,from: Calendar.current.date(from:dateComponents)!)
//        0-6 월-일
//        if dateComponents.weekday == 1{
//            firstDayOfMonth = 6
//        }
//        else{
//            firstDayOfMonth = dateComponents.weekday! - 2
//        }
        firstDayOfMonth = dateComponents.weekday! - 1
        
        if dateComponents.month == 2{
            if dateComponents.year! % 400 == 0 || (dateComponents.year! % 4 == 0 && dateComponents.year! % 100 != 0){
                dateComponents.isLeapMonth = true
            }
        }
        else{
            dateComponents.isLeapMonth = false
        }
        if firstDayOfMonth == 0{
            if dateComponents.month == 2 && dateComponents.isLeapMonth == false{
                monthlyLines = 4
            }
            else{
                monthlyLines = 5
            }
        }
        else{
            if firstDayOfMonth == 6 || (firstDayOfMonth == 5 && numberOfMonthList[dateComponents.month!] == 31){
                monthlyLines = 6
            }
            else{
                monthlyLines = 5
            }
            
        }
        dateComponents.day = Calendar.current.component(.day,from: today)
        
    }
    
}

//MARK: UICollectionViewDelegate

extension InfiniteScrollCVC: UICollectionViewDelegateFlowLayout{
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
        return CGSize(width: CGFloat(Int((screen.width-60)/7)), height: CGFloat(monthHeightConstraint)/CGFloat(monthlyLines))
        
    }
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    //        return UIEdgeInsets(top: 0, left: 1, bottom: 0, right: )
    //    }
    
}

//MARK: - UICollectionView DataSource

extension InfiniteScrollCVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return monthlyLines*7
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            print("~~~CVC",dateComponents)
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MonthlyCalendarCVC.identifier, for: indexPath) as? MonthlyCalendarCVC else { return UICollectionViewCell() }
            cell.setDay()
            cell.setCorner()
            //윤달
            if dateComponents.isLeapMonth == true{
                //이번달
                if indexPath.item >= firstDayOfMonth && indexPath.item < firstDayOfMonth+29{
                    //현재 날짜(현재달)
                    if isThisMonth{
                        //오늘
                        if indexPath.item-firstDayOfMonth+1 == dateComponents.day{
                            cell.setToday()
                        }
                        //미래
                        else if indexPath.item - firstDayOfMonth+1 > dateComponents.day!{
                            cell.hideFuture()
                        }
                        //과거
                        cell.dayLabel.text = String(day[indexPath.item-firstDayOfMonth+1])
                    }
                    //과거날짜
                    else{
                        cell.dayLabel.text = String(day[indexPath.item-firstDayOfMonth+1])
                    }
                    
                }
                //이전달
                else if indexPath.item < firstDayOfMonth{
                    let numberOfMonth = numberOfMonthList[1]
                    cell.dayLabel.text = String(day[numberOfMonth-firstDayOfMonth+1+indexPath.item])
                    cell.dayLabel.textColor = .lightGray
                    
                }
                //다음달
                else if indexPath.item >= firstDayOfMonth+numberOfMonthList[dateComponents.month!]{
                    
                    cell.dayLabel.text = String(day[indexPath.item - (firstDayOfMonth+29) + 1 ])
                    cell.dayLabel.textColor = .lightGray
                    if isThisMonth{
                        cell.hideFuture()
                    }
                }
            }
            //윤달X
            else{
                //이번달
                if indexPath.item >= firstDayOfMonth && indexPath.item < firstDayOfMonth+numberOfMonthList[dateComponents.month!]{
                    //현재 날짜(현재달)
                    if isThisMonth{
                        //오늘
                        if indexPath.item-firstDayOfMonth+1 == dateComponents.day{
                            cell.setToday()
                        }
                        //미래
                        else if indexPath.item - firstDayOfMonth+1 > dateComponents.day!{
                            cell.hideFuture()
                        }
                        //과거
                        cell.dayLabel.text = String(day[indexPath.item-firstDayOfMonth+1])
                    }
                    //과거날짜
                    else{
                        cell.dayLabel.text = String(day[indexPath.item-firstDayOfMonth+1])
                    }
                    
                }
                //이전달
                else if indexPath.item < firstDayOfMonth{
                    var lastMonth = dateComponents.month! - 1
                    if dateComponents.month! == 1{
                        lastMonth = 12
                    }
                    let numberOfMonth = numberOfMonthList[lastMonth]
                    cell.dayLabel.text = String(day[numberOfMonth-firstDayOfMonth+1+indexPath.item])
                    cell.dayLabel.textColor = .lightGray
                    
                }
                //다음달
                else if indexPath.item >= firstDayOfMonth+numberOfMonthList[dateComponents.month!]{
                    cell.dayLabel.text = String(day[indexPath.item - (firstDayOfMonth+numberOfMonthList[dateComponents.month!]) + 1 ])
                    cell.dayLabel.textColor = .lightGray
                    if isThisMonth{
                        cell.hideFuture()
                    }
                }
            }
            
            
            return cell
        
        
        
    }
}
