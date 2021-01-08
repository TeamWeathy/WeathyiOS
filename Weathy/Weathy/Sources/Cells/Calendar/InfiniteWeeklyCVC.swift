//
//  InfiniteWeeklyCVC.swift
//  Weathy
//
//  Created by 이예슬 on 2021/01/09.
//

import UIKit

class InfiniteWeeklyCVC: UICollectionViewCell {
    static let identifier = "InfiniteWeeklyCVC"
    var selectedDate = Date()
    let screen = UIScreen.main.bounds
    @IBOutlet weak var weeklyCalendarCV: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        weeklyCalendarCV.delegate = self
        weeklyCalendarCV.dataSource = self
        
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
    
}

extension InfiniteWeeklyCVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeeklyCalendarCVC.identifier, for: indexPath) as? WeeklyCalendarCVC else { return UICollectionViewCell() }
        cell.selectedView.alpha = 0
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
            print("here1")
//            weekdayLabelCollection[indexPath.item].textColor = .white
            cell.setToday()
        }
        else if indexPath.item > selectedDate.weekday{
            cell.emotionView.alpha = 0
        }
        if tempIdx>0{
            cell.dayLabel.text = String(indexPath.item + selectedDate.day-(selectedDate.weekday))
        }
        else if tempIdx<=0{
            var lastMonth = selectedDate.month - 1
            if lastMonth == 0{
                lastMonth = 12
            }
            cell.dayLabel.text = String(selectedDate.numberOfMonth-(selectedDate.weekday)-1+indexPath.item)
            cell.setGreyDay()
        }
        
        return cell
    
    }

}
