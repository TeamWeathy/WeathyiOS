//
//  RecordRateVC.swift
//  Weathy
//
//  Created by DANNA LEE on 2020/12/31.
//

import UIKit

class RecordRateVC: UIViewController {
    
    //MARK: - Custom Variables
    
    var dateToday: Date?
    var dateString: String = "0000-00-00"
    var locationCode: CLong = -1
    
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
    @IBOutlet var titleLabel: SpacedLabel!
    @IBOutlet var explanationLabel: SpacedLabel!
    @IBOutlet var indicatorCircle: [UIView]!
    @IBOutlet var rateCollectionView: UICollectionView!
    @IBOutlet var nextBtn: UIButton!
    
    
    //MARK: - LifeCycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAboveCollection()
        setNextBtnDisabled()
        setTitleLabel()
        setCV()
        
        rateCollectionView.dataSource = self
        rateCollectionView.delegate = self
        


        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        animationPrac()
    }
    
    //MARK: - IBActions
    
    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func nextBtnTap(_ sender: Any) {
        callRecordWeathyService()
    }
    

}

//MARK: - Style

extension RecordRateVC {
    func setAboveCollection() {
//        backBtn.setBackgroundImage(UIImage(named: <#T##String#>), for: .normal)
//        dismissBtn.setBackgroundImage(UIImage(named: <#T##String#>), for: .normal)
        
        titleLabel.text = "날씨는 어땠나요?"
        titleLabel.font = UIFont(name: "AppleSDGothicNeoR00", size: 25)
        titleLabel.textColor = UIColor.mainGrey
        
        explanationLabel.text = "옷차림에 대한 느낌을 선택해주세요."
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
        UIView.animate(withDuration: 0.5, animations: {
            self.nextBtn.backgroundColor = UIColor.mintMain
            self.nextBtn.setTitle("완료", for: .normal)
            self.nextBtn.setTitleColor(.white, for: .normal)
            self.nextBtn.titleLabel?.font = .SDGothicSemiBold16
            self.nextBtn.layer.cornerRadius = self.nextBtn.frame.height / 2
        })
    }
    
    func setNextBtnDisabled() {
        nextBtn.isUserInteractionEnabled = false
        nextBtn.backgroundColor = UIColor.subGrey3
        nextBtn.setTitle("완료", for: .normal)
        nextBtn.setTitleColor(.white, for: .normal)
        nextBtn.titleLabel?.font = .SDGothicSemiBold16
        self.view.layoutIfNeeded()
        nextBtn.layer.cornerRadius = nextBtn.frame.height / 2
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
    
    func callRecordWeathyService() {
        //        let loadingView = WeathyLoadingView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        //        self.view.addSubview(loadingView)
        
        RecordWeathyService.shared.recordWeathy(userId: Int(UserDefaults.standard.string(forKey: "userId") ?? "") ?? 0, date: dateString, code: locationCode, clothArray: selectedTags, stampId: selectedStamp, feedback: nil, img: nil) { (networkResult) -> (Void) in
            print(">>>>>>>", self.locationCode)
            switch networkResult {
            case .success(let data):
                print("success", data)
                
                if let loadData = data as? RecordWeathyData{
                    //                let time = DispatchTime.now() + .seconds(3)
                    //                DispatchQueue.main.asyncAfter(deadline: time, execute: {self.dodo()})
                    let nextStoryboard = UIStoryboard(name: "RecordText", bundle: nil)
                    guard let dvc = nextStoryboard.instantiateViewController(identifier: "RecordTextVC") as? RecordTextVC else {
                        return
                    }
                    
                    dvc.selectedTags = self.selectedTags
                    dvc.selectedStamp = self.selectedStamp
                    dvc.dateString = self.dateString
                    dvc.locationCode = self.locationCode
                    dvc.weathyId = loadData.weathyId
                        
                    self.compareRecentRecordDate()
                    
                    dvc.modalPresentationStyle = .fullScreen
                    self.present(dvc, animated: false, completion: nil)
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

    func compareRecentRecordDate() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko-kr")
        
        let dateInDateFormat = dateFormatter.date(from: UserDefaults.standard.string(forKey: "recentRecordDate") ?? "2000-01-01")
        
        /// 날짜 차이를 계산
        let dateDifference = Calendar.current.dateComponents([.day], from: dateInDateFormat!, to: dateToday!)
        
        /// 저장돼있던 날짜가 현재 날짜 전이면 현재 날짜를 저장
        if dateDifference.day! > 0 {
            UserDefaults.standard.setValue(dateString, forKey: "recentRecordDate")
            print(">>>>> setting complete")
        }
            
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

extension RecordRateVC: UICollectionViewDelegateFlowLayout {
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
