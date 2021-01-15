//
//  RecordRateVC.swift
//  Weathy
//
//  Created by DANNA LEE on 2020/12/31.
//

import UIKit

class ModifyWeathyRateVC: UIViewController {
    
    //MARK: - Custom Variables
    
    var weathyData: CalendarWeathy?
    var dateString: String = "0000-00-00"
    
    struct Rates {
        let emoji: String
        let title: String
        let titleColor: String
        let explanation: String
        var isSelected: Bool
    }
    
    var selectedTags: [Int] = []
    var selectedStamp: Int = -1

    var rate: [Rates] = []
    
    var visitedFlag: Bool = false
    
    
    //MARK: - IBOutlets
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var explanationLabel: UILabel!
    @IBOutlet var indicatorCircle: [UIView]!
    @IBOutlet var rateCollectionView: UICollectionView!
    @IBOutlet var nextBtn: UIButton!
    @IBOutlet var finishBtn: UIButton!
    
    
    //MARK: - LifeCycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAboveCollection()
        setNextBtnEnabled()
        setTitleLabel()
        setCV()
        
        rateCollectionView.dataSource = self
        rateCollectionView.delegate = self
        


        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        animationPrac()
        setRecordedData()
    }
    
    //MARK: - IBActions
    
    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func finishBtnDidTap(_ sender: Any) {
        callModifyWeathyService()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextBtnTap(_ sender: Any) {
        let nextStoryboard = UIStoryboard(name: "ModifyWeathyText", bundle: nil)
        guard let dvc = nextStoryboard.instantiateViewController(identifier: "ModifyWeathyTextVC") as? ModifyWeathyTextVC else {
            return
        }
        
        dvc.selectedTags = selectedTags
        dvc.selectedStamp = selectedStamp
        dvc.weathyData = weathyData
        dvc.dateString = dateString
        
        self.navigationController?.pushViewController(dvc, animated: false)
    }
    

}

//MARK: - Style

extension ModifyWeathyRateVC {
    func setAboveCollection() {
//        backBtn.setBackgroundImage(UIImage(named: <#T##String#>), for: .normal)
//        dismissBtn.setBackgroundImage(UIImage(named: <#T##String#>), for: .normal)
        
        titleLabel.text = "날씨는 어땠나요?"
        titleLabel.font = UIFont(name: "AppleSDGothicNeoR00", size: 25)
        titleLabel.textColor = UIColor.mainGrey
        
        explanationLabel.text = "오늘 옷차림에 대한 느낌을 선택해주세요."
        explanationLabel.font = UIFont.SDGothicRegular16
        explanationLabel.textColor = UIColor.subGrey6
        
        indicatorCircle[0].layer.cornerRadius = 4.5
        indicatorCircle[0].backgroundColor = UIColor.mintMain
        indicatorCircle[0].alpha = 0.4
        
        indicatorCircle[1].layer.cornerRadius = 4.5
        indicatorCircle[1].backgroundColor = UIColor.mintMain
        indicatorCircle[1].alpha = 0.4
        
        indicatorCircle[2].layer.cornerRadius = 6.5
        indicatorCircle[2].backgroundColor = UIColor.mintMain
        
        nextBtn.backgroundColor = .white
        nextBtn.setTitle("다음", for: .normal)
        nextBtn.setTitleColor(.mintIcon, for: .normal)
        nextBtn.titleLabel?.font = UIFont.SDGothicSemiBold16
        nextBtn.layer.cornerRadius = 30
        nextBtn.setBorder(borderColor: .mintMain, borderWidth: 1)
        
        finishBtn.backgroundColor = .mintMain
        finishBtn.setTitle("수정완료", for: .normal)
        finishBtn.setTitleColor(.white, for: .normal)
        finishBtn.titleLabel?.font = UIFont.SDGothicSemiBold16
        finishBtn.layer.cornerRadius = 30
    }
    
    func setTitleLabel() {
        let attributedString = NSMutableAttributedString(string: "날씨는 어땠나요?", attributes: [
          .font: UIFont(name: "AppleSDGothicNeoR00", size: 25.0)!,
          .foregroundColor: UIColor.mainGrey,
          .kern: -1.25
        ])
        attributedString.addAttributes([
          .font: UIFont(name: "AppleSDGothicNeoSB00", size: 25.0)!,
          .foregroundColor: UIColor.mintIcon
        ], range: NSRange(location: 0, length: 2))
        
        titleLabel.attributedText = attributedString
    }
    
    func setCV() {
        
        rateCollectionView.showsVerticalScrollIndicator = false
        rateCollectionView.bounces = true
        
        rate = [
            Rates(emoji: "veryhot", title: "너무 더웠어요", titleColor: "imojiVeryHotText", explanation: "훨씬 얇게 입을걸 그랬어요.", isSelected: false),
            Rates(emoji: "hot", title: "더웠어요", titleColor: "orange", explanation: "좀 더 가볍게 입을걸 그랬어요.", isSelected: false),
            Rates(emoji: "good", title: "적당했어요", titleColor: "yellow", explanation: "딱 적당하게 입었어요.", isSelected: false),
            Rates(emoji: "cold", title: "추웠어요", titleColor: "green", explanation: "좀 더 따뜻하게 입을걸 그랬어요.", isSelected: false),
            Rates(emoji: "verycold", title: "너무 추웠어요", titleColor: "blue", explanation: "훨씬 두껍게 입을걸 그랬어요.", isSelected: false)
        ]
    }
    
    func setNextBtnEnabled() {
        self.nextBtn.isUserInteractionEnabled = true
        nextBtn.backgroundColor = .white
        nextBtn.setTitle("다음", for: .normal)
        nextBtn.setTitleColor(.mintIcon, for: .normal)
        nextBtn.titleLabel?.font = UIFont.SDGothicSemiBold16
        nextBtn.layer.cornerRadius = 30
        nextBtn.setBorder(borderColor: .mintMain, borderWidth: 1)
    }
    
    func setNextBtnDisabled() {
        nextBtn.isUserInteractionEnabled = false
        nextBtn.backgroundColor = .white
        nextBtn.setTitle("다음", for: .normal)
        nextBtn.setTitleColor(.subGrey3, for: .normal)
        nextBtn.titleLabel?.font = UIFont.SDGothicSemiBold16
        nextBtn.layer.cornerRadius = 30
        nextBtn.setBorder(borderColor: .subGrey3, borderWidth: 1)
    }
    
    func initPosition() {
        
        titleLabel.alpha = 0
        titleLabel.frame = CGRect(x: titleLabel.frame.origin.x, y: titleLabel.frame.origin.y-10, width: titleLabel.frame.width, height: titleLabel.frame.height)
        
        explanationLabel.alpha = 0
        explanationLabel.frame = CGRect(x: explanationLabel.frame.origin.x, y: explanationLabel.frame.origin.y-10, width: explanationLabel.frame.width, height: explanationLabel.frame.height)
        
    }
    
    func animationPrac() {
        self.initPosition()
        
        UIView.animate(withDuration: 1, animations: {
            self.titleLabel.alpha = 1
            self.titleLabel.frame = CGRect(x: self.titleLabel.frame.origin.x, y: self.titleLabel.frame.origin.y+10, width: self.titleLabel.frame.width, height: self.titleLabel.frame.height)
        })
        
        UIView.animate(withDuration: 1, delay: 0.5, animations: {
            self.explanationLabel.alpha = 1
            self.explanationLabel.frame = CGRect(x: self.explanationLabel.frame.origin.x, y: self.explanationLabel.frame.origin.y+10, width: self.explanationLabel.frame.width, height: self.explanationLabel.frame.height)
        })
    }
    
    func setRecordedData() {
        let recordedStamp: Int = weathyData!.stampId - 1
        rate[recordedStamp].isSelected = true
    }
    
    func callModifyWeathyService() {
        ModifyWeathyService.shared.modifyWeathy(userId: 63, token: "63:04nZVc9vUelbchZ6m8ALSOWbEyBIL5", date: dateString, code: 1141000000, clothArray: selectedTags, stampId: selectedStamp , feedback: weathyData?.feedback ?? "", weathyId: weathyData?.weathyId ?? -1) { (networkResult) -> (Void) in
            print(self.weathyData?.weathyId ?? -1)
            switch networkResult {
            case .success(let data):
                if let loadData = data as? RecordWeathyData {
                    print(loadData)
                }
        
                self.dismiss(animated: true) {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RecordUpdated"), object: 1)
                }
                
            case .requestErr(let msg):
                print("requestErr")
                if let message = msg as? String {
                    print(message)
                    self.showToast(message: message)
                }
                
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
    }
}

//MARK: - UICollectionViewDataSource

extension ModifyWeathyRateVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        rate.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecordRateCVC", for: indexPath) as? RecordRateCVC
        else {
            return UICollectionViewCell()
        }
        
        cell.setCell(imageName: rate[indexPath.item].emoji, titleText: rate[indexPath.item].title, titleColor: rate[indexPath.item].titleColor, description: rate[indexPath.item].explanation)
        
        if indexPath.item == 0 {
            cell.titleLabel.textColor = UIColor.imojiVeryHotText
        }
        else if indexPath.item == 1 {
            cell.titleLabel.textColor = UIColor.imojiHotText
        }
        else if indexPath.item == 2 {
            cell.titleLabel.textColor = UIColor.imojiGootText
        }
        else if indexPath.item == 3 {
            cell.titleLabel.textColor = UIColor.imojiColdText
        }
        else if indexPath.item == 4 {
            cell.titleLabel.textColor = UIColor.imojiVeryColdText
        }
        
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 20
        
        /// 분기처리
        if rate[indexPath.item].isSelected == true {
            
            cell.backgroundColor = .white
            
            UIView.animate(withDuration: 0.5, animations: {
                cell.layer.borderColor = UIColor.mintMain.cgColor
                cell.dropShadow(color: UIColor(red: 129/255, green: 226/255, blue: 210/255, alpha: 1), offSet: CGSize(width: 0, height: 0), opacity: 0.4, radius: 10)
            })
        } else {
            cell.layer.borderColor = UIColor.subGrey7.cgColor
            cell.layer.shadowRadius = 0
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: false)
        
        /// 선택된 거 빼고 모두 isSelected를 false로 변경
        for i in 0...rate.count-1 {
            if i == indexPath.item {
                if rate[i].isSelected == false {
                    rate[i].isSelected = !rate[i].isSelected
                    /// stampId
                    self.selectedStamp = indexPath.item + 1
                    self.setNextBtnEnabled()
                }
            } else {
                rate[i].isSelected = false
            }
        }
        
        self.rateCollectionView.reloadData()
    }
}


//MARK: - UICollectionViewDelegate

extension ModifyWeathyRateVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
            let cellWidth : CGFloat = collectionView.frame.width - 20
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
            return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
}
