//
//  MainBottomCell.swift
//  Weathy
//
//  Created by inae Lee on 2021/01/04.
//

import UIKit

class MainBottomCVC: UICollectionViewCell {
    //MARK: - Custom Variables
    
    var hourlyWeatherData: HourlyWeatherData?
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var cellBackgroundImage: UIImageView!
    @IBOutlet weak var timeZoneWeatherView: UIView!
    @IBOutlet weak var weeklyWeatherView: UIView!
    @IBOutlet weak var detailWeatherView: UIView!
    @IBOutlet weak var timeZoneCenterY: NSLayoutConstraint!
    @IBOutlet weak var WeeklyCenterY: NSLayoutConstraint!
    @IBOutlet weak var detailCenterY: NSLayoutConstraint!
    @IBOutlet weak var mainBottomScrollView: UIScrollView!
    @IBOutlet weak var timeZoneWeatherCollectionView: UICollectionView!
    @IBOutlet weak var weeklyWeatherCollectionView: UICollectionView!
    @IBOutlet weak var detailWeatherCollectionView: UICollectionView!
    
    //MARK: - Life Cycle Methods
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.timeZoneCenterY.constant = UIScreen.main.bounds.height
        self.WeeklyCenterY.constant = UIScreen.main.bounds.height
        self.detailCenterY.constant = UIScreen.main.bounds.height
        
        self.timeZoneWeatherCollectionView.delegate = self
        self.timeZoneWeatherCollectionView.dataSource = self
        self.weeklyWeatherCollectionView.delegate = self
        self.weeklyWeatherCollectionView.dataSource = self
        self.detailWeatherCollectionView.delegate = self
        self.detailWeatherCollectionView.dataSource = self

        self.layoutIfNeeded()
    }
    
    //MARK: - Custom Methods
    func setCell() {
        // remove: 스크롤 후 배경 픽스된 것 없으면 삭제
//        cellBackgroundImage.image = UIImage(named: "search_bg_morning")
        
        timeZoneWeatherView.backgroundColor = .white
        timeZoneWeatherView.makeRounded(cornerRadius: 35)
        timeZoneWeatherView.dropShadow(color: UIColor(red: 44/255, green: 82/255, blue: 128/255, alpha: 1), offSet: CGSize(width: 0, height: 10), opacity: 0.14, radius: 50)
        
        weeklyWeatherView.backgroundColor = .white
        weeklyWeatherView.makeRounded(cornerRadius: 35)
        weeklyWeatherView.dropShadow(color: UIColor(red: 44/255, green: 82/255, blue: 128/255, alpha: 1), offSet: CGSize(width: 0, height: 10), opacity: 0.14, radius: 50)
        
        detailWeatherView.backgroundColor = .white
        detailWeatherView.makeRounded(cornerRadius: 35)
        detailWeatherView.dropShadow(color: UIColor(red: 44/255, green: 82/255, blue: 128/255, alpha: 1), offSet: CGSize(width: 0, height: 10), opacity: 0.14, radius: 50)
    }
    
    func viewScrollUp() {
        self.timeZoneCenterY.constant = UIScreen.main.bounds.height
        self.WeeklyCenterY.constant = UIScreen.main.bounds.height
        self.detailCenterY.constant = UIScreen.main.bounds.height
        
        UIView.animate(withDuration: 1.2, delay: 0, options: [.curveLinear], animations: {
            self.timeZoneWeatherView.alpha = 0
            self.weeklyWeatherView.alpha = 0
            self.detailWeatherView.alpha = 0
                        
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    func viewScrollDown() {
        self.timeZoneCenterY.constant = 21
        self.WeeklyCenterY.constant = 24
        self.detailCenterY.constant = 24
        
        UIView.animate(withDuration: 1.2, delay: 0, options: [.overrideInheritedCurve],animations: {
            self.timeZoneWeatherView.alpha = 1
            self.weeklyWeatherView.alpha = 1
            self.detailWeatherView.alpha = 1
            
            self.layoutIfNeeded()
        })
    }
    
    func changeHourlyViewData(data: HourlyWeatherData) {
        self.hourlyWeatherData = data
//
//        print("-----")
//        print(hourlyWeatherData?.hourlyWeatherList)
        timeZoneWeatherCollectionView.reloadData()
    }
}

//MARK: - 주석 종류

extension MainBottomCVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch (collectionView) {
        case timeZoneWeatherCollectionView:
            return hourlyWeatherData?.hourlyWeatherList.count ?? 0
        case weeklyWeatherCollectionView:
            return 7
        case detailWeatherCollectionView:
            return 3
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch (collectionView) {
        case timeZoneWeatherCollectionView:
            guard let cell = timeZoneWeatherCollectionView.dequeueReusableCell(withReuseIdentifier: "TImezoneWeatherCVC", for: indexPath) as? TImezoneWeatherCVC else {return UICollectionViewCell()}
            if let hourly = hourlyWeatherData?.hourlyWeatherList {
                cell.setTimezoneWeatherData(hourlyData: hourly[indexPath.row], idx: indexPath.row)
            }

            cell.setCell()
            return cell
        case weeklyWeatherCollectionView:
            guard let cell = weeklyWeatherCollectionView.dequeueReusableCell(withReuseIdentifier: "WeeklyWeatherCVC", for: indexPath) as? WeeklyWeatherCVC else {return UICollectionViewCell()}
            
            cell.setCell()
            return cell
        case detailWeatherCollectionView:
            guard let cell = detailWeatherCollectionView.dequeueReusableCell(withReuseIdentifier: DetailWeatherCVC.identifier, for: indexPath) as? DetailWeatherCVC else {return UICollectionViewCell()}
            
            cell.setCell()
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension MainBottomCVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch (collectionView) {
        case timeZoneWeatherCollectionView, weeklyWeatherCollectionView:
            return CGSize(width: collectionView.bounds.size.width / 7, height: collectionView.bounds.size.height)
        case detailWeatherCollectionView:
            return CGSize(width: collectionView.bounds.size.width / 3, height: collectionView.bounds.size.height)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
