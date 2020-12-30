//
//  RecordRateVC.swift
//  Weathy
//
//  Created by DANNA LEE on 2020/12/31.
//

import UIKit

class RecordRateVC: UIViewController {
    
    //MARK: - Custom Variables
    
    struct Rates {
        let emoji: String
        let title: String
        let titleColor: String
        let explanation: String
        var isSelected: Bool
    }

    var rate: [Rates] = []
    
    
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
        setNextBtnDisabled()
        setCV()
        
        rateCollectionView.dataSource = self
        rateCollectionView.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self


        // Do any additional setup after loading the view.
    }
    
    //MARK: - IBActions
    
    @IBAction func nextBtnTap(_ sender: Any) {
        let nextStoryboard = UIStoryboard(name: "RecordText", bundle: nil)
        guard let dvc = nextStoryboard.instantiateViewController(identifier: "RecordTextVC") as? RecordTextVC else {
            return
        }
        
        self.navigationController?.pushViewController(dvc, animated: true)
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
    
    func setCV() {
        rate = [
            Rates(emoji: "pencil.circle", title: "너무 더워요", titleColor: "black", explanation: "훨씬 얇게 입을걸 그랬어요.", isSelected: false),
            Rates(emoji: "pencil.circle", title: "더워요", titleColor: "black", explanation: "좀 더 가볍게 입을걸 그랬어요.", isSelected: false),
            Rates(emoji: "pencil.circle", title: "적당해요", titleColor: "black", explanation: "딱 적당하게 입었어요.", isSelected: false),
            Rates(emoji: "pencil.circle", title: "추워요", titleColor: "black", explanation: "좀 더 따뜻하게 입을걸 그랬어요.", isSelected: false),
            Rates(emoji: "pencil.circle", title: "너무 추워요", titleColor: "black", explanation: "훨씬 두껍게 입을걸 그랬어요.", isSelected: false)
        ]
    }
    
    func setNextBtnEnabled() {
        nextBtn.isUserInteractionEnabled = true
        nextBtn.backgroundColor = UIColor.green
        nextBtn.setTitle("다음", for: .normal)
        nextBtn.setTitleColor(.white, for: .normal)
        nextBtn.layer.cornerRadius = 30
    }
    
    func setNextBtnDisabled() {
        nextBtn.isUserInteractionEnabled = false
        nextBtn.backgroundColor = UIColor.lightGray
        nextBtn.setTitle("다음", for: .normal)
        nextBtn.setTitleColor(.white, for: .normal)
        nextBtn.layer.cornerRadius = 30
    }
}

//MARK: - UICollectionViewDataSource

extension RecordRateVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        rate.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecordRateCVC", for: indexPath) as? RecordRateCVC
        else {
            return UICollectionViewCell()
        }
        
        cell.setCell(imageName: rate[indexPath.item].emoji, titleText: rate[indexPath.item].title, titleColor: rate[indexPath.item].titleColor, description: rate[indexPath.item].explanation)
        
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 20
        
        /// 분기처리
        if rate[indexPath.item].isSelected == true {
            cell.layer.borderColor = UIColor(red: 0.506, green: 0.886, blue: 0.824, alpha: 1).cgColor
            cell.layer.shadowRadius = 20
            cell.layer.shadowColor = UIColor(red: 0.506, green: 0.886, blue: 0.824, alpha: 0.4).cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.layer.masksToBounds = false
            cell.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else {
            cell.layer.borderColor = UIColor.lightGray.cgColor
            cell.layer.shadowRadius = 0
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: false)
        
        /// 선택된 거 빼고 모두 isSelected를 false로 변경
        for i in 0...rate.count-1 {
            if i == indexPath.item {
                rate[i].isSelected = !rate[i].isSelected
                
                if rate[i].isSelected == true {
                    self.setNextBtnEnabled()
                } else {
                    self.setNextBtnDisabled()
                }
                
            } else {
                rate[i].isSelected = false
            }
        }
        
        self.rateCollectionView.reloadData()
    }
}


//MARK: - UICollectionViewDelegate

extension RecordRateVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
            let cellWidth : CGFloat = collectionView.frame.width
            let cellHeight : CGFloat = 80
            
            return CGSize(width: cellWidth, height: cellHeight)
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 12
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 0
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 0, left: 0, bottom: 1, right: 0)
        }
}


//MARK: - UIGestureRecognizerDelegate

extension UIViewController : UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool { return true
    }
}

