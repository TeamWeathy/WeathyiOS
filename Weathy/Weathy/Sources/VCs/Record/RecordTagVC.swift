//
//  RecordTagVC.swift
//  Weathy
//
//  Created by DANNA LEE on 2020/12/31.
//

import UIKit

class RecordTagVC: UIViewController {
    
    //MARK: - Custom Variables
    
    var notificationGenerator: UIImpactFeedbackGenerator?
    
    struct Tag {
        let id: Int
        let name: String
//        let tag: TagNameData
        var isSelected: Bool
    }
    
    struct TagTitle {
        let title: String
        var count: Int
        var isSelected: Bool
        var tagTab: [Tag]
    }
    
    var tagUpper: [Tag] = [Tag(id: -1, name: "  ", isSelected: false)]
    var tagUnder: [Tag] = [Tag(id: -1, name: "  ", isSelected: false)]
    var tagOuter: [Tag] = [Tag(id: -1, name: "  ", isSelected: false)]
    var tagEtc: [Tag] = [Tag(id: -1, name: "  ", isSelected: false)]
    
    var tagTitles: [TagTitle] = [] // 태그 카테고리
    
    let name: String = "웨디" // 사용자 닉네임
    var titleIndex: Int = 0 // 현재 선택된 태그 카테고리
    
    var visitedFlag: Bool = false // 다음 뷰로 넘어간 적이 있는지 판단
    var dvc = RecordRateVC()
    
    var myClothesTagData: ClothesTagData?
    var localizedClothesTagData: [TagCategoryData] = []
    var isSelected: [Bool] = []
    
    //MARK: - IBOutlets
    @IBOutlet var blurView: UIImageView!
    
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var explanationLabel: UILabel!
    @IBOutlet var indicatorCircle: [UIView]!
    
    @IBOutlet var tagTitleCollectionView: UICollectionView!
    @IBOutlet var tagCollectionView: UICollectionView!
    
    @IBOutlet var nextBtn: UIButton!
    
    
    
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
        
        // 초기화
        self.tagTitles = [
            TagTitle(title: "상의", count: 0, isSelected: true, tagTab: tagUpper),
            TagTitle(title: "하의", count: 0, isSelected: false, tagTab: tagUnder),
            TagTitle(title: "외투", count: 0, isSelected: false, tagTab: tagOuter),
            TagTitle(title: "기타", count: 0, isSelected: false, tagTab: tagEtc)
        ]
        
        // 초기 상태 버튼 (애니메이션 안 들어가야 해서 따로 선언)
        nextBtn.isUserInteractionEnabled = false
        nextBtn.backgroundColor = UIColor.subGrey3
        nextBtn.setTitle("다음", for: .normal)
        nextBtn.setTitleColor(.white, for: .normal)
        nextBtn.titleLabel?.font = UIFont.SDGothicSemiBold16
        nextBtn.layer.cornerRadius = 30
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if tagCollectionView.contentOffset.y <= 30 {
            blurView.alpha = tagCollectionView.contentOffset.y / 30
        }
        else {
            blurView.alpha = 1
        }
        
        animationPrac()
        callDisplayTagService()
    }
    
    
    @objc func longTap(gesture : UILongPressGestureRecognizer!) {
        if gesture.state != .ended {
            
            self.notificationGenerator = UIImpactFeedbackGenerator(style: .light)
            self.notificationGenerator?.impactOccurred()
            
            let p = gesture.location(in: self.tagCollectionView)
            
            if let indexPath = self.tagCollectionView.indexPathForItem(at: p) {
                // get the cell at indexPath (the one you long pressed)
                print(">>>", indexPath)
//                let cell = self.tagCollectionView.cellForItem(at: indexPath)
                print("long press detected")
                
                if indexPath[1] == 0 {
                    return
                }
                
                let nextStoryboard = UIStoryboard(name: "RecordTagDelete", bundle: nil)
                guard let dvc = nextStoryboard.instantiateViewController(identifier: "RecordTagDeleteVC") as? RecordTagDeleteVC else {
                    return
                }
                
                dvc.initialTagTab = titleIndex
                dvc.initialSelectedIdx = indexPath[1]
                
                dvc.modalPresentationStyle = .fullScreen
                
                self.present(dvc, animated: false, completion: nil)
            } else {
                print("couldn't find index path")
            }
        }
        
        
    }
    
    
    
    //MARK: - IBActions
    
    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func nextBtnTap(_ sender: Any) {
        
        if visitedFlag == false {
            let nextStoryboard = UIStoryboard(name: "RecordRate", bundle: nil)
            self.dvc = (nextStoryboard.instantiateViewController(identifier: "RecordRateVC") as? RecordRateVC)!
            
            visitedFlag = true
        }
        
        self.navigationController?.pushViewController(self.dvc, animated: false)
    }
    
    
}


//MARK: - Style

extension RecordTagVC {
    func setHeader() {
        titleLabel.text = "\(name)님은 오늘\n어떤 옷을 입었나요?"
        titleLabel.font = UIFont(name: "AppleSDGothicNeoR00", size: 25)
        titleLabel.textColor = UIColor.mainGrey
        titleLabel.numberOfLines = 2
        
        explanationLabel.text = "옷은 길게 눌러 삭제하고, +를 눌러 추가할 수 있어요."
        explanationLabel.font = UIFont.SDGothicRegular16
        explanationLabel.textColor = UIColor.subGrey6
        
        indicatorCircle[0].layer.cornerRadius = 4.5
        indicatorCircle[0].backgroundColor = UIColor.mintMain
        indicatorCircle[0].alpha = 0.4
        
        indicatorCircle[1].layer.cornerRadius = 6.5
        indicatorCircle[1].backgroundColor = UIColor.mintMain
        
        indicatorCircle[2].layer.cornerRadius = 4.5
        indicatorCircle[2].backgroundColor = UIColor.subGrey7
    }
    
    func setTitleLabel() {
        let attributedString = NSMutableAttributedString(string: "희지님\n어떤 옷을 입었나요?", attributes: [
            .font: UIFont(name: "AppleSDGothicNeoR00", size: 25.0)!,
            .foregroundColor: UIColor.mainGrey,
            .kern: -1.25
        ])
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        
        attributedString.addAttributes([
            .font: UIFont(name: "AppleSDGothicNeoSB00", size: 25.0)!,
            .foregroundColor: UIColor.mintIcon
        ], range: NSRange(location: 4, length: 4))
        
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
        UIView.animate(withDuration: 0.5, animations: {
            self.nextBtn.backgroundColor = UIColor.mintMain
            self.nextBtn.setTitle("다음", for: .normal)
            self.nextBtn.setTitleColor(.white, for: .normal)
            self.nextBtn.titleLabel?.font = UIFont.SDGothicSemiBold16
            self.nextBtn.layer.cornerRadius = 30
        })
    }
    
    func setNextBtnDeactivated() {
        nextBtn.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.5, animations: {
            self.nextBtn.backgroundColor = UIColor.subGrey3
            self.nextBtn.setTitle("다음", for: .normal)
            self.nextBtn.setTitleColor(.white, for: .normal)
            self.nextBtn.titleLabel?.font = UIFont.SDGothicSemiBold16
            self.nextBtn.layer.cornerRadius = 30
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
    
    func showToast(message: String) {
        let width_variable: CGFloat = 33
        let toastLabel = UILabel(frame: CGRect(x: width_variable, y: self.view.frame.size.height-165, width: view.frame.size.width-2*width_variable, height: 50))
        // 뷰가 위치할 위치를 지정해준다. 여기서는 아래로부터 100만큼 떨어져있고, 너비는 양쪽에 10만큼 여백을 가지며, 높이는 35로
        toastLabel.backgroundColor = UIColor(red: 202/255, green: 241/255, blue: 235/255, alpha: 0.6)
        toastLabel.textColor = UIColor.mainGrey
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont.SDGothicRegular16
        toastLabel.lineSetting(kernValue: -0.8)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 29.5
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 2.0, delay: 1.0, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { (isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func callDisplayTagService() {
        RecordTagService.shared.displayTag(userId: 63, token: "63:wckgTPK2NtG7JoM0p207XwsmDxOmM7") { (networkResult) -> (Void) in
            switch networkResult {
            case .success(let data):
                if let loadData = data as? ClothesTagData {
                    self.myClothesTagData = loadData
                }
                
//                print(self.myClothesTagData)
                self.processDataAtLocal()
                
                DispatchQueue.main.async {
                    self.tagCollectionView.reloadData()
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
        
        print(self.localizedClothesTagData)
        makeLocalTagData()
    }
    
    func makeLocalTagData() {
        
        print(">>> here", localizedClothesTagData[titleIndex].clothes.count, tagTitles[titleIndex].tagTab.count - 1)
        
        // viewWillAppear에서 다시 호출되었을 경우를 대비한 분기처리
        if localizedClothesTagData[titleIndex].clothes.count != tagTitles[titleIndex].tagTab.count - 1 {
            for j in 0...3 {
                for i in 0...localizedClothesTagData[j].clothes.count - 1 {
                    self.tagTitles[j].tagTab.append(Tag(id: localizedClothesTagData[j].clothes[i].id, name: localizedClothesTagData[j].clothes[i].name, isSelected: false))
                }
            }
        }
        
        print(">>>", self.tagTitles)
        print(">>>", self.tagTitles[titleIndex].tagTab.count)

    }
}

//MARK: - UICollectionViewDataSource

extension RecordTagVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        /// tagCollectionView
        if collectionView == tagCollectionView {
            
            print(">>>", tagTitles[titleIndex].tagTab.count)
            
            if tagTitles[titleIndex].tagTab.count == 1 {
                return 0
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
            
            let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longTap))
            cell.addGestureRecognizer(longPressGesture)
            
            cell.tagLabel.text = tagTitles[titleIndex].tagTab[indexPath.item].name
            print(tagTitles[titleIndex].tagTab[indexPath.item].name)
            cell.tagLabel.preferredMaxLayoutWidth = collectionView.frame.width - 32
            
            if indexPath.item == 0 {
//                cell.tagLabel.font = UIFont.SDGothicRegular15
//                cell.layer.borderWidth = 1
//                cell.layer.cornerRadius = 19.5
//                cell.layer.borderColor = UIColor.subGrey3.cgColor
//                cell.tagLabel.textColor = .black
//                cell.backgroundColor = .white
                
                cell.tagLabel.isHidden = true
                cell.addTagImage.isHidden = false
                cell.layer.borderWidth = 0
                cell.backgroundColor = .white
                print(">>>", indexPath.item)
            }
            else {
                
                print(">>>", tagTitles[titleIndex].tagTab.count, localizedClothesTagData[titleIndex].clothes.count)
                
                if tagTitles[titleIndex].tagTab[indexPath.item].isSelected == false {
                    print(">>>", indexPath.item)
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
            
            //            cell.layer.borderWidth = 1
            //            cell.layer.borderColor = UIColor.black.cgColor
            
            return cell
        }
        
        return UICollectionViewCell()
        
    }
    
  
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        /// tagCollectionView
        if collectionView == tagCollectionView {
            
            /// +가 선택됐을 경우
            if indexPath.item == 0 {
                print("I'm chosen")
                
                guard let dvc = self.storyboard?.instantiateViewController(identifier: "RecordTagAddPopupVC") as? RecordTagAddPopupVC else {
                    return
                }
                
                dvc.tagCategory = tagTitles[titleIndex].title
                dvc.tagCount = tagTitles[titleIndex].tagTab.count-1
                
                dvc.modalPresentationStyle = .overCurrentContext
                
                self.present(dvc, animated: false, completion: nil)
                
            }
            /// 태그가 선택됐을 경우
            else {
                if tagTitles[titleIndex].count < 5 {
                    collectionView.deselectItem(at: indexPath, animated: false)
                    tagTitles[titleIndex].tagTab[indexPath.item].isSelected = !tagTitles[titleIndex].tagTab[indexPath.item].isSelected
                    if tagTitles[titleIndex].tagTab[indexPath.item].isSelected == true {
                        tagTitles[titleIndex].count += 1
                    } else {
                        tagTitles[titleIndex].count -= 1
                    }
                }
                else if tagTitles[titleIndex].count == 5 {
                    if tagTitles[titleIndex].tagTab[indexPath.item].isSelected == true {
                        tagTitles[titleIndex].tagTab[indexPath.item].isSelected = false
                        tagTitles[titleIndex].count -= 1
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
                        print("선택된 것 >> ", tagTitles[i].title)
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

extension RecordTagVC: UICollectionViewDelegateFlowLayout {
    
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
        let y = scrollView.contentOffset.y
        if y <= 30 {
            blurView.alpha = y / 30
        }
        else {
            blurView.alpha = 1
        }
    }
}

