//
//  RecordStartVC.swift
//  Weathy
//
//  Created by DANNA LEE on 2020/12/31.
//

import UIKit

class RecordStartVC: UIViewController {

    //MARK: - Custom Variables
    
    var month: Int = 1
    var date: Int = 1
    var day: String = "월"
    var ampm: String = "오전"
    var hour: Int = 1
    var location: String = "서울시 종로구"
    var currentTemp: Int = -2
    var maxTemp: Int = 4
    var minTemp: Int = -4
    
    
    //MARK: - IBOutlets
    
    @IBOutlet var dismissBtn: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var boxView: UIView!
    @IBOutlet var boxTimeLabel: UILabel!
    @IBOutlet var boxLocationLabel: UILabel!
    @IBOutlet var boxWeatherImageView: UIImageView!
    @IBOutlet var currentTempLabel: UILabel!
    @IBOutlet var maxTempLabel: UILabel!
    @IBOutlet var slashLabel: UILabel!
    @IBOutlet var minTempLabel: UILabel!
    @IBOutlet var modifyBtn: UIButton!
    @IBOutlet var startBtn: UIButton!
    
    
    
    //MARK: - LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAboveBox()
        setBox()
        setBelowBox()

        // Do any additional setup after loading the view.
    }
    

   

}

//MARK: - Style

extension RecordStartVC {
    func setAboveBox() {
        dismissBtn.tintColor = UIColor(red: 86/255, green: 109/255, blue: 106/255, alpha: 1)
        
        titleLabel.text = "오늘의 웨디를\n기록해볼까요?"
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont(name: "AppleSDGothicNeoSB00", size: 25)
        
        subTitleLabel.text = "기록할 위치와 날씨를 확인해 주세요."
        subTitleLabel.font = UIFont(name: "AppleSDGothicNeoR00", size: 16)
    }
    
    func setBox() {
//        boxView.setBorder(borderColor: UIColor(red: 1, green: 1, blue: 1, alpha: 0.75), borderWidth: 2)
        
        boxView.layer.borderWidth = 1
        boxView.layer.borderColor = UIColor.lightGray.cgColor
        boxView.layer.cornerRadius = 35
        
        boxTimeLabel.text = "\(month)월 \(date)일 \(day)요일 · \(ampm) \(hour)시"
        boxTimeLabel.font = UIFont(name: "AppleSDGothicNeoR00", size: 15)
        
        boxLocationLabel.text = "\(location)"
        boxLocationLabel.font = UIFont(name: "AppleSDGothicNeoSB00", size: 17)
        
        boxWeatherImageView.image = UIImage(named: "")
        
        currentTempLabel.text = "\(currentTemp)°"
        currentTempLabel.font = UIFont(name: "Roboto-Regular", size: 60)
        
        maxTempLabel.text = "\(maxTemp)°"
        maxTempLabel.font = UIFont(name: "Roboto-Regular", size: 25)
        maxTempLabel.textColor = UIColor(red: 209/255, green: 140/255, blue: 139/255, alpha: 1)
        
        slashLabel.text = "/"
        slashLabel.font = UIFont(name: "Roboto-Regular", size: 15)
        slashLabel.textColor = UIColor(red: 194/255, green: 194/255, blue: 194/255, alpha: 1)
        
        minTempLabel.text = "\(minTemp)°"
        minTempLabel.font = UIFont(name: "Roboto-Regular", size: 25)
        minTempLabel.textColor = UIColor(red: 139/255, green: 175/255, blue: 209/255, alpha: 1)
    }
    
    func setBelowBox() {
        modifyBtn.backgroundColor = UIColor.lightGray
        modifyBtn.setTitle("변경하기", for: .normal)
        modifyBtn.setTitleColor(.black, for: .normal)
        modifyBtn.layer.cornerRadius = 18
        
        startBtn.backgroundColor = UIColor.lightGray
        startBtn.setTitle("기록 시작하기", for: .normal)
        startBtn.setTitleColor(.white, for: .normal)
        startBtn.layer.cornerRadius = 30
        
    }
    
}
