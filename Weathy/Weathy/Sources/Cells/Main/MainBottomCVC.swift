//
//  MainBottomCell.swift
//  Weathy
//
//  Created by inae Lee on 2021/01/04.
//

import UIKit

enum ExtraType: String {
    case rain
    case wind
    case humidity
}

class MainBottomCVC: UICollectionViewCell {
    //MARK: - Custom Variables
    
    var hourlyWeatherData: HourlyWeatherData?
    var dailyWeatherData: DailyWeatherData?
    var extraWeatherData: ExtraWeatherData?
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var cellBackgroundImage: UIImageView!
    @IBOutlet weak var timeZoneWeatherView: UIView!
    @IBOutlet weak var weeklyWeatherView: UIView!
    @IBOutlet weak var extraWeatherView: UIView!
    @IBOutlet weak var timeZoneCenterY: NSLayoutConstraint!
    @IBOutlet weak var WeeklyCenterY: NSLayoutConstraint!
    @IBOutlet weak var extraCenterY: NSLayoutConstraint!
    @IBOutlet weak var mainBottomScrollView: UIScrollView!
    @IBOutlet weak var timeZoneWeatherCollectionView: UICollectionView!
    @IBOutlet weak var weeklyWeatherCollectionView: UICollectionView!
    @IBOutlet weak var extraWeatherCollectionView: UICollectionView!
    
    //MARK: - Life Cycle Methods
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.timeZoneCenterY.constant = UIScreen.main.bounds.height
        self.WeeklyCenterY.constant = UIScreen.main.bounds.height
        self.extraCenterY.constant = UIScreen.main.bounds.height
        
        self.timeZoneWeatherCollectionView.delegate = self
        self.timeZoneWeatherCollectionView.dataSource = self
        self.weeklyWeatherCollectionView.delegate = self
        self.weeklyWeatherCollectionView.dataSource = self
        self.extraWeatherCollectionView.delegate = self
        self.extraWeatherCollectionView.dataSource = self

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
        
        extraWeatherView.backgroundColor = .white
        extraWeatherView.makeRounded(cornerRadius: 35)
        extraWeatherView.dropShadow(color: UIColor(red: 44/255, green: 82/255, blue: 128/255, alpha: 1), offSet: CGSize(width: 0, height: 10), opacity: 0.14, radius: 50)
    }
    
    func viewScrollUp() {
        self.timeZoneCenterY.constant = UIScreen.main.bounds.height
        self.WeeklyCenterY.constant = UIScreen.main.bounds.height
        self.extraCenterY.constant = UIScreen.main.bounds.height
        
        UIView.animate(withDuration: 1.2, delay: 0, options: [.curveLinear], animations: {
            self.timeZoneWeatherView.alpha = 0
            self.weeklyWeatherView.alpha = 0
            self.extraWeatherView.alpha = 0
                        
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    func viewScrollDown() {
        self.timeZoneCenterY.constant = 21
        self.WeeklyCenterY.constant = 24
        self.extraCenterY.constant = 24
        
        UIView.animate(withDuration: 1.2, delay: 0, options: [.overrideInheritedCurve],animations: {
            self.timeZoneWeatherView.alpha = 1
            self.weeklyWeatherView.alpha = 1
            self.extraWeatherView.alpha = 1
            
            self.layoutIfNeeded()
        })
    }
    
    func changeHourlyViewData(data: HourlyWeatherData) {
        self.hourlyWeatherData = data

        timeZoneWeatherCollectionView.reloadData()
    }
    
    func changeDailyViewData(data: DailyWeatherData) {
        self.dailyWeatherData = data

        weeklyWeatherCollectionView.reloadData()
    }
    
    func changeExtraViewData(data: ExtraWeatherData) {
        self.extraWeatherData = data
        
        extraWeatherCollectionView.reloadData()
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
        case extraWeatherCollectionView:
            return 3
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch (collectionView) {
        case timeZoneWeatherCollectionView:
            guard let cell = timeZoneWeatherCollectionView.dequeueReusableCell(withReuseIdentifier: TimezoneWeatherCVC.idenfier, for: indexPath) as? TimezoneWeatherCVC else {return UICollectionViewCell()}
            if let hourly = hourlyWeatherData?.hourlyWeatherList {
                cell.setTimezoneWeatherData(hourlyData: hourly[indexPath.row], idx: indexPath.row)
            }

            cell.setCell()
            return cell
        case weeklyWeatherCollectionView:
            guard let cell = weeklyWeatherCollectionView.dequeueReusableCell(withReuseIdentifier: WeeklyWeatherCVC.identifier, for: indexPath) as? WeeklyWeatherCVC else {return UICollectionViewCell()}
            if let daily = dailyWeatherData {
                cell.setWeeklyWeatherData(data: daily.dailyWeatherList[indexPath.row], idx: indexPath.row)
            }
            
            cell.setCell()
            return cell
        case extraWeatherCollectionView:
            guard let cell = extraWeatherCollectionView.dequeueReusableCell(withReuseIdentifier: ExtraWeatherCVC.identifier, for: indexPath) as? ExtraWeatherCVC else {return UICollectionViewCell()}
            if let extra = extraWeatherData {
                switch indexPath.row {
                case 0:
                    cell.setExtraWeatherData(data: extra.extraWeather.rain, type: ExtraType.rain)
                case 1:
                    cell.setExtraWeatherData(data: extra.extraWeather.humidity, type: ExtraType.humidity)
                case 2:
                    cell.setExtraWeatherData(data: extra.extraWeather.wind, type: ExtraType.wind)
                default:
                    break
                }
            }
            
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
        case extraWeatherCollectionView:
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
