//
//  RecordRateVC.swift
//  Weathy
//
//  Created by DANNA LEE on 2020/12/31.
//

import UIKit

class RecordRateVC: UIViewController {
    
    //MARK: - Custom Variables
    
    
    //MARK: - IBOutlets
    
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var dismissBtn: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var explanationLabel: UILabel!
    @IBOutlet var stepOneImageView: UIImageView!
    @IBOutlet var stepTwoImageView: UIImageView!
    @IBOutlet var rateCollectionView: UICollectionView!
    @IBOutlet var nextBtn: UIButton!
    
    
    //MARK: - LifeCycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAboveCollection()
        setNextBtn()

        // Do any additional setup after loading the view.
    }
    

}

//MARK: - Style

extension RecordRateVC {
    func setAboveCollection() {
//        backBtn.setBackgroundImage(UIImage(named: <#T##String#>), for: .normal)
//        dismissBtn.setBackgroundImage(UIImage(named: <#T##String#>), for: .normal)
        
        titleLabel.text = "날씨는 어땠나요?"
        titleLabel.font = UIFont(name: "AppleSDGothicNeoSB00", size: 25)
        
        explanationLabel.text = "오늘 옷차림에 대한 느낌을 선택해주세요."
        explanationLabel.font = UIFont(name: "AppleSDGothicNeoR00", size: 16)
        
//        stepOneImageView.image = UIImage(named: <#T##String#>)
//        stepTwoImageView.image = UIImage(named: <#T##String#>)
    }
    
    func setNextBtn() {
        nextBtn.backgroundColor = UIColor.lightGray
        nextBtn.setTitle("다음", for: .normal)
        nextBtn.setTitleColor(.white, for: .normal)
        nextBtn.layer.cornerRadius = 30
    }
}
