//
//  RecordTagVC.swift
//  Weathy
//
//  Created by DANNA LEE on 2020/12/31.
//

import UIKit

class ModifyWeathyTagVC: UIViewController {
    
    //MARK: - Custom Variables
    
    var weathyData: CalendarWeathy?
    
    var notificationGenerator: UIImpactFeedbackGenerator?
    
    var tagUpper: [Tag] = [Tag(id: -1, name: "  ", isSelected: false)]
    var tagUnder: [Tag] = [Tag(id: -1, name: "  ", isSelected: false)]
    var tagOuter: [Tag] = [Tag(id: -1, name: "  ", isSelected: false)]
    var tagEtc: [Tag] = [Tag(id: -1, name: "  ", isSelected: false)]
    
    var tagTitles: [TagTitle] = [] // 태그 카테고리
    
    let name: String = "웨디" // 사용자 닉네임
    var titleIndex: Int = 0 // 현재 선택된 태그 카테고리
    
    var visitedFlag: Bool = false // 다음 뷰로 넘어간 적이 있는지 판단
    var dvc = ModifyWeathyRateVC()
    
    var isInitialVisit: Bool = true
    
    var myClothesTagData: ClothesTagData?
    var localizedClothesTagData: [TagCategoryData] = []
    var selectedTags: [Int] = []
    
    var isAdded: Bool = false
    
    var scrollYOffset: CGFloat = 0
    
    //MARK: - IBOutlets
    @IBOutlet var blurView: UIImageView!
    
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var explanationLabel: UILabel!
    @IBOutlet var indicatorCircle: [UIView]!
    
    @IBOutlet var tagTitleCollectionView: UICollectionView!
    @IBOutlet var tagCollectionView: UICollectionView!
    
    @IBOutlet var nextBtn: UIButton!
    @IBOutlet var finishBtn: UIButton!
    
    
    
    //MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tagCollectionView.dataSource = self
        tagCollectionView.delegate = self
        let layout = TagFlowLayout()
        layout.estimatedItemSize = CGSize(width: 140, height: 40)
        tagCollectionView.collectionViewLayout = layout
        
        tagTitleCollectionView.dataSource = self
        tagTitleCollectionView.delegate = self
        
        setHeader()
        setTitleLabel()
        
        // 초기 상태 버튼 (애니메이션 안 들어가야 해서 따로 선언)
        nextBtn.backgroundColor = .white
        nextBtn.setTitle("다음", for: .normal)
        nextBtn.setTitleColor(.subGrey3, for: .normal)
        nextBtn.titleLabel?.font = UIFont.SDGothicSemiBold16
        nextBtn.layer.cornerRadius = 30
        nextBtn.setBorder(borderColor: .subGrey3, borderWidth: 1)
        
        NotificationCenter.default.addObserver(self, selector: #selector(tagAdded(_:)), name: NSNotification.Name("TagAdded"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        print("viewWillAppear called")
        
        if tagCollectionView.contentOffset.y <= 30 {
            blurView.alpha = tagCollectionView.contentOffset.y / 30
        }
        else {
            blurView.alpha = 1
        }
        
        // 타이틀 애니메이션
        animationPrac()
        
        // 초기화
        self.tagTitles = [
            TagTitle(title: "상의", count: 0, isSelected: false, tagTab: tagUpper),
            TagTitle(title: "하의", count: 0, isSelected: false, tagTab: tagUnder),
            TagTitle(title: "외투", count: 0, isSelected: false, tagTab: tagOuter),
            TagTitle(title: "기타", count: 0, isSelected: false, tagTab: tagEtc)
        ]
        tagTitles[titleIndex].isSelected = true
    
        callDisplayTagService()
    }
    
    @objc func tagAdded(_ noti : Notification){
        let isAdded = noti.object
        self.viewWillAppear(true)
        self.showToast(message: "태그가 추가되었어요!")
    }
    
    //MARK: - IBActions
    
    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func nextBtnTap(_ sender: Any) {
        
        if visitedFlag == false {
            let nextStoryboard = UIStoryboard(name: "ModifyWeathyRate", bundle: nil)
            self.dvc = (nextStoryboard.instantiateViewController(identifier: "ModifyWeathyRateVC") as? ModifyWeathyRateVC)!
            
            visitedFlag = true
        }
        
        dvc.selectedTags = selectedTags
        dvc.weathyData = weathyData
        
        self.navigationController?.pushViewController(self.dvc, animated: false)
    }
    
    @IBAction func finishBtnDidTap(_ sender: Any) {
        if tagTitles[0].count >= 1 || tagTitles[1].count >= 1 || tagTitles[2].count >= 1 ||
            tagTitles[3].count >= 1 {
            self.dismiss(animated: true, completion: nil)
        }
        else {
            self.showToast(message: "태그를 한 개 이상 선택해주세요.")
        }
        
        
    }
}


//MARK: - Style

extension ModifyWeathyTagVC {
    func setHeader() {
        titleLabel.numberOfLines = 2
        titleLabel.text = "\(name)님\n어떤 옷을 입었나요?"
        titleLabel.font = UIFont(name: "AppleSDGothicNeoR00", size: 25)
        titleLabel.textColor = .mainGrey
        
        explanationLabel.text = "수정하기에서는 태그를 삭제할 수 없어요."
        explanationLabel.font = UIFont.SDGothicRegular16
        explanationLabel.textColor = UIColor.subGrey6
        
        indicatorCircle[0].layer.cornerRadius = 4.5
        indicatorCircle[0].backgroundColor = UIColor.mintMain
        indicatorCircle[0].alpha = 0.4
        
        indicatorCircle[1].layer.cornerRadius = 6.5
        indicatorCircle[1].backgroundColor = UIColor.mintMain
        
        indicatorCircle[2].layer.cornerRadius = 4.5
        indicatorCircle[2].backgroundColor = UIColor.subGrey7
        
        finishBtn.backgroundColor = .mintMain
        finishBtn.setTitle("수정완료", for: .normal)
        finishBtn.setTitleColor(.white, for: .normal)
        finishBtn.titleLabel?.font = UIFont.SDGothicSemiBold16
        finishBtn.layer.cornerRadius = 30
    }
    
    func setTitleLabel() {
        
        let attributedString = NSMutableAttributedString(string: titleLabel.text ?? "")
        attributedString.addAttribute(NSAttributedString.Key(rawValue: kCTFontAttributeName as String),
                                      value: UIFont(name: "AppleSDGothicNeoSB00", size: 25.0)!, range: (titleLabel.text! as NSString).range(of: "어떤 옷"))
        attributedString.addAttribute(.foregroundColor, value: UIColor.mintIcon, range: (titleLabel.text! as NSString).range(of: "어떤 옷"))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        
        titleLabel.attributedText = attributedString
    }
    
    func setTagSelected(cell: RecordTagCVC) {
        cell.addTagImage.isHidden = true
        cell.tagLabel.isHidden = false
        cell.tagLabel.font = UIFont.SDGothicRegular15
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 20
        cell.tagLabel.textColor = UIColor.mintIcon
        cell.layer.borderColor = UIColor.mintMain.cgColor
        cell.backgroundColor = UIColor.white
    }
    
    func setTagUnselected(cell: RecordTagCVC) {
        cell.addTagImage.isHidden = true
        cell.tagLabel.isHidden = false
        cell.tagLabel.font = UIFont.SDGothicRegular15
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 20
        cell.tagLabel.textColor = UIColor.subGrey6
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.backgroundColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1)
    }
    
    func setNextBtnActivated() {
        nextBtn.isUserInteractionEnabled = true
        finishBtn.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.5, animations: {
            self.finishBtn.backgroundColor = .mintMain
            self.finishBtn.setTitle("수정완료", for: .normal)
            self.finishBtn.setTitleColor(.white, for: .normal)
            self.finishBtn.titleLabel?.font = UIFont.SDGothicSemiBold16
            self.finishBtn.layer.cornerRadius = 30
            
            self.nextBtn.backgroundColor = .white
            self.nextBtn.setTitle("다음", for: .normal)
            self.nextBtn.setTitleColor(.mintIcon, for: .normal)
            self.nextBtn.titleLabel?.font = UIFont.SDGothicSemiBold16
            self.nextBtn.layer.cornerRadius = 30
            self.nextBtn.setBorder(borderColor: .mintMain, borderWidth: 1)
        })
    }
    
    func setNextBtnDeactivated() {
        nextBtn.isUserInteractionEnabled = false
        finishBtn.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.5, animations: {
            self.finishBtn.backgroundColor = .subGrey3
            self.finishBtn.setTitle("수정완료", for: .normal)
            self.finishBtn.setTitleColor(.white, for: .normal)
            self.finishBtn.titleLabel?.font = UIFont.SDGothicSemiBold16
            self.finishBtn.layer.cornerRadius = 30
            
            self.nextBtn.backgroundColor = .white
            self.nextBtn.setTitle("다음", for: .normal)
            self.nextBtn.setTitleColor(.subGrey3, for: .normal)
            self.nextBtn.titleLabel?.font = UIFont.SDGothicSemiBold16
            self.nextBtn.layer.cornerRadius = 30
            self.nextBtn.setBorder(borderColor: .subGrey3, borderWidth: 1)
        })
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
    
    func callDisplayTagService() {
        RecordTagService.shared.displayTag(userId: 63, token: "63:wGO5NhErgyg0JR9W6i0ZJcOHox0Bi5") { (networkResult) -> (Void) in
            switch networkResult {
            case .success(let data):
                if let loadData = data as? ClothesTagData {
                    self.myClothesTagData = loadData
                }
                
//                print(self.myClothesTagData)
                self.processDataAtLocal()
                
                DispatchQueue.main.async {
                    self.tagCollectionView.reloadData()
                    self.tagTitleCollectionView.reloadData()
                }
                
            case .requestErr(let msg):
                print("requestErr")
                if let message = msg as? String {
                    print(message)
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
    
    func processDataAtLocal() {
        self.localizedClothesTagData = [
            self.myClothesTagData!.top,
            self.myClothesTagData!.bottom,
            self.myClothesTagData!.outer,
            self.myClothesTagData!.etc
        ]

        makeLocalTagData()
    }
    
    func makeLocalTagData() {
        
        /// viewWillAppear에서 다시 호출되었을 경우를 대비한 분기처리
        if localizedClothesTagData[titleIndex].clothes?.count != tagTitles[titleIndex].tagTab.count - 1 || localizedClothesTagData[titleIndex].clothes?.count == 0 {
            
            for j in 0...3 {
                
                if localizedClothesTagData[j].clothes?.count == 0 {
                    break
                }
                else {
                    for i in 0...localizedClothesTagData[j].clothes!.count - 1 {
                        self.tagTitles[j].tagTab.append(Tag(id: localizedClothesTagData[j].clothes![i].id, name: localizedClothesTagData[j].clothes![i].name, isSelected: false))
                    }
                }
            }
        }
        
        if isInitialVisit == true {
            setInitialRecordedData()
        }
        else {
            setMaintainedData()
        }

    }
    
    /// 뷰 진입이 처음일 때 수정 전 등록해놨던 태그 유지
    func setInitialRecordedData() {
        
        var currentTag: Int = -1
        
        /// 이미 선택돼있는 태그 id 값 비교해 isSelected 변경 (상의)
        if weathyData?.closet.top.clothes != nil {
            for i in 0...(weathyData?.closet.top.clothes.count)! - 1 {
                currentTag = (weathyData?.closet.top.clothes[i].id)!
                
                for b in 0...tagTitles[0].tagTab.count {
                    if tagTitles[0].tagTab[b].id == currentTag {
                        tagTitles[0].tagTab[b].isSelected = true
                        selectedTags.append(currentTag)
                        tagTitles[0].count += 1
                        break
                    }
                }
            }
        }
        
        if weathyData?.closet.bottom.clothes != nil {
            for i in 0...(weathyData?.closet.bottom.clothes.count)! - 1 {
                currentTag = (weathyData?.closet.bottom.clothes[i].id)!
                
                for b in 0...tagTitles[1].tagTab.count {
                    if tagTitles[1].tagTab[b].id == currentTag {
                        tagTitles[1].tagTab[b].isSelected = true
                        selectedTags.append(currentTag)
                        tagTitles[1].count += 1
                        break
                    }
                }
            }
        }
        
        if weathyData?.closet.outer.clothes != nil {
            for i in 0...(weathyData?.closet.outer.clothes.count)! - 1 {
                currentTag = (weathyData?.closet.outer.clothes[i].id)!
                
                for b in 0...tagTitles[2].tagTab.count {
                    if tagTitles[2].tagTab[b].id == currentTag {
                        tagTitles[2].tagTab[b].isSelected = true
                        selectedTags.append(currentTag)
                        tagTitles[2].count += 1
                        break
                    }
                }
            }
        }
        
        if weathyData?.closet.etc.clothes != nil {
            for i in 0...(weathyData?.closet.etc.clothes.count)! - 1 {
                currentTag = (weathyData?.closet.etc.clothes[i].id)!
                
                for b in 0...tagTitles[3].tagTab.count {
                    if tagTitles[3].tagTab[b].id == currentTag {
                        tagTitles[3].tagTab[b].isSelected = true
                        selectedTags.append(currentTag)
                        tagTitles[3].count += 1
                        break
                    }
                }
            }
        }
        
        if tagTitles[0].count >= 1 || tagTitles[1].count >= 1 || tagTitles[2].count >= 1 ||
            tagTitles[3].count >= 1 {
            setNextBtnActivated()
        }
        
        isInitialVisit = false
    }
    
    /// 뷰 진입이 처음이 아닐 때 원래 선택돼있던 태그 유지
    func setMaintainedData() {
        var currentTag = -1
        
        if selectedTags != [] {
            for i in 0...selectedTags.count - 1 {
                currentTag = selectedTags[i]
                for j in 0...3 {
                    for b in 0...tagTitles[j].tagTab.count - 1 {
                        if tagTitles[j].tagTab[b].id == currentTag {
                            tagTitles[j].tagTab[b].isSelected = true
                            tagTitles[j].count += 1
                            break
                        }
                    }
                }
            }
        }
    }
    
    func callModifyWeathyService() {
        ModifyWeathyService.shared.modifyWeathy(userId: 63, token: "63:wGO5NhErgyg0JR9W6i0ZJcOHox0Bi5", date: "2021-01-13", code: 1141000000, clothArray: selectedTags, stampId: weathyData?.stampId ?? -1, feedback: weathyData?.feedback ?? "", weathyId: weathyData?.weathyId ?? -1) { (networkResult) -> (Void) in
            print(self.weathyData?.weathyId ?? -1)
            switch networkResult {
            case .success(let data):
                if let loadData = data as? RecordWeathyData {
                    print(loadData)
                }
                self.dismiss(animated: true) {
                    self.showToast(message: "웨디에 내용이 추가되었어요!")
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

extension ModifyWeathyTagVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        /// tagCollectionView
        if collectionView == tagCollectionView {
            
//            print(">>> tag", titleIndex, tagTitles[titleIndex].tagTab.count)
            
            if tagTitles[titleIndex].tagTab.count == 1 {
                return 1
            }
            
            return tagTitles[titleIndex].tagTab.count
        }
        
        /// tagTitleCollectionView
        else if collectionView == tagTitleCollectionView {
            return tagTitles.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        /// tagCollectionView
        if collectionView == tagCollectionView {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecordTagCVC", for: indexPath) as? RecordTagCVC
            else {
                return UICollectionViewCell()
            }
            
            cell.tagLabel.text = tagTitles[titleIndex].tagTab[indexPath.item].name

            cell.tagLabel.preferredMaxLayoutWidth = collectionView.frame.width - 32
            
            if indexPath.item == 0 {
                cell.tagLabel.isHidden = true
                cell.addTagImage.isHidden = false
                cell.layer.borderWidth = 0
                cell.backgroundColor = .white
            }
            else {
                
                if tagTitles[titleIndex].tagTab[indexPath.item].isSelected == false {
                    setTagUnselected(cell: cell)
                }
                else {
                    setTagSelected(cell: cell)
                }
            }
            
            return cell
        }
        
        
        /// tagTitleCollectionView
        else if collectionView == tagTitleCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecordTagTitleCVC", for: indexPath) as? RecordTagTitleCVC
            else {
                return UICollectionViewCell()
            }
            cell.setCell(title: tagTitles[indexPath.item].title, total: tagTitles[titleIndex].tagTab.count, count: tagTitles[indexPath.item].count, isSelected: tagTitles[indexPath.item].isSelected, isDeleteView: false)
            
            return cell
        }
        
        return UICollectionViewCell()
        
    }
    
  
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        /// tagCollectionView
        if collectionView == tagCollectionView {
            
            /// +가 선택됐을 경우
            if indexPath.item == 0 {
//                print("I'm chosen")
                
                if tagTitles[titleIndex].tagTab.count <= 50 {
                    let nextStoryboard = UIStoryboard(name: "RecordTag", bundle: nil)
                    
                    guard let dvc = nextStoryboard.instantiateViewController(identifier: "RecordTagAddPopupVC") as? RecordTagAddPopupVC else {
                        return
                    }
                    
                    dvc.tagIndex = titleIndex + 1
                    dvc.tagCategory = tagTitles[titleIndex].title
                    dvc.tagCount = tagTitles[titleIndex].tagTab.count-1
                    
                    dvc.modalPresentationStyle = .overCurrentContext
                    
                    self.present(dvc, animated: false, completion: nil)
                }
                else {
                    showToast(message: "태그를 추가하려면 기존 태그를 삭제해주세요.")
                }
                
                
            }
            /// 태그가 선택됐을 경우
            else {
                if tagTitles[titleIndex].count < 5 {
                    collectionView.deselectItem(at: indexPath, animated: false)
                    tagTitles[titleIndex].tagTab[indexPath.item].isSelected = !tagTitles[titleIndex].tagTab[indexPath.item].isSelected
                    if tagTitles[titleIndex].tagTab[indexPath.item].isSelected == true {
                        selectedTags.append(tagTitles[titleIndex].tagTab[indexPath.item].id)
                        tagTitles[titleIndex].count += 1
//                        print(">>>", selectedTags)
                    } else {
                        let selectedId = tagTitles[titleIndex].tagTab[indexPath.item].id
                        let selectedIndex = selectedTags.firstIndex(of: selectedId)
                        selectedTags.remove(at: selectedIndex!)
                        tagTitles[titleIndex].count -= 1
//                        print(">>>", selectedTags)
                    }
                }
                else if tagTitles[titleIndex].count == 5 {
                    if tagTitles[titleIndex].tagTab[indexPath.item].isSelected == true {
                        tagTitles[titleIndex].tagTab[indexPath.item].isSelected = false
                        let selectedId = tagTitles[titleIndex].tagTab[indexPath.item].id
                        let selectedIndex = selectedTags.firstIndex(of: selectedId)
                        selectedTags.remove(at: selectedIndex!)
                        tagTitles[titleIndex].count -= 1
//                        print(">>>", selectedTags)
                    }
                    else {
                        showToast(message: "태그는 카테고리당 5개만 선택할 수 있어요.")
                    }
                }
                else {
                    
                }
                
                DispatchQueue.main.async{
                    self.tagCollectionView.reloadData()
                    self.tagTitleCollectionView.reloadData()
                }
                
                if tagTitles[0].count >= 1 || tagTitles[1].count >= 1 || tagTitles[2].count >= 1 ||
                    tagTitles[3].count >= 1 {
                    self.setNextBtnActivated()
                }
                else {
                    self.setNextBtnDeactivated()
                }
            }
            
        }
        
        /// tagTitleCollectionView
        else if collectionView == tagTitleCollectionView {
            collectionView.deselectItem(at: indexPath, animated: false)
            tagCollectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            
            /// 선택된 거 빼고 모두 isSelected를 false로 변경
            for i in 0...tagTitles.count-1 {
                if i == indexPath.item {
                    
                    if tagTitles[i].isSelected == true {
                        //                        self.titleIndex = i
//                        print("선택된 것 >> ", tagTitles[i].title)
                    } else {
                        self.titleIndex = i
                        tagTitles[i].isSelected = !tagTitles[i].isSelected
                        
                    }
                    
                } else {
                    tagTitles[i].isSelected = false
                }
            }
            
            self.tagTitleCollectionView.reloadData()
            self.tagCollectionView.reloadData()
        }
        
    }
}


//MARK: - UICollectionViewDelegateFlowLayout

extension ModifyWeathyTagVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth : CGFloat = collectionView.frame.width/4 - 6
        let cellHeight : CGFloat = collectionView.frame.height
        
        return CGSize(width: cellWidth, height: cellHeight)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        /// tagCollectionView
        if collectionView == tagCollectionView {
            return 10
        }
        
        /// tagTitleCollectionView
        else if collectionView == tagTitleCollectionView {
            return 0
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        /// tagCollectionView
        if collectionView == tagCollectionView {
            return 8
        }
        
        /// tagTitleCollectionView
        else if collectionView == tagTitleCollectionView {
            return 0
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        /// tagCollectionView
        if collectionView == tagCollectionView {
            return UIEdgeInsets(top: 30, left: 0, bottom: 50, right: 0)
        }
        
        /// tagTitleCollectionView
        else if collectionView == tagTitleCollectionView {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        return UIEdgeInsets()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scrollYOffset = scrollView.contentOffset.y
        if self.scrollYOffset <= 30 {
            blurView.alpha = self.scrollYOffset / 30
        }
        else {
            blurView.alpha = 1
        }
    }
}



