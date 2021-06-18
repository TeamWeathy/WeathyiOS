//
//  RecordTagVC.swift
//  Weathy
//
//  Created by DANNA LEE on 2020/12/31.
//

import UIKit

class RecordTagDeleteVC: UIViewController {
    
    //MARK: - Custom Variables
    
    var tagUpper: [Tag] = []
    var tagUnder: [Tag] = []
    var tagOuter: [Tag] = []
    var tagEtc: [Tag] = []
    
    var tagTitles: [TagTitle] = []
    
    let name: String = "웨디"
    var titleIndex: Int = 0
    var initialTagTab: Int = 0
    var initialSelectedIdx: Int?
    var initialYOffset: CGFloat = 0
    
    var isInitialized: Bool = false
    
    var selectedTags: [Int] = []
    var tagCount: Int = 1
    
    //MARK: - IBOutlets
    @IBOutlet var blurView: UIImageView!
    
    @IBOutlet var titleLabel: SpacedLabel!
    @IBOutlet var explanationLabel: SpacedLabel!
    
    @IBOutlet var tagTitleCollectionView: UICollectionView!
    @IBOutlet var tagCollectionView: UICollectionView!
    
    @IBOutlet var cancelBtn: UIButton!
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
        initialBtn()
        setCancelBtn()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if tagCollectionView.contentOffset.y <= 30 {
            blurView.alpha = tagCollectionView.contentOffset.y / 30
        }
        else {
            blurView.alpha = 1
        }
        
        animationPrac()
        initSetting()
        

    }
    
    
    
    
    //MARK: - IBActions
    
    @IBAction func cancleBtnTap(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func nextBtnTap(_ sender: Any) {
        guard let dvc = self.storyboard?.instantiateViewController(identifier: "RecordTagDeletePopupVC") as? RecordTagDeletePopupVC else {
            return
        }
        
        dvc.modalPresentationStyle = .overCurrentContext
        
        var tagWillBeDeletedCount = 0
        
        for i in 0...3 {
            tagWillBeDeletedCount += tagTitles[i].count
        }
        
        dvc.tagCount = tagWillBeDeletedCount
        dvc.selectedTags = selectedTags
        
        self.present(dvc, animated: false, completion: nil)
        
    }
    
    
}


//MARK: - Style

extension RecordTagDeleteVC {
    
    func initSetting() {
        /// + 자리에 있던 아이 삭제
        for i in 0...3 {
            tagTitles[i].tagTab.removeFirst()
            tagTitles[i].count = 0
            
            if tagTitles[i].tagTab.count == 0 {
                continue
            }
            
            /// isSelected 초기화
            for j in 0...tagTitles[i].tagTab.count - 1 {
                tagTitles[i].tagTab[j].isSelected = false
            }
        }
        
        /// 삭제 탭 부를 때 선택했던 셀은 기본적으로 선택돼있게
        if let selectedIdx = initialSelectedIdx {
            tagTitles[initialTagTab].tagTab[selectedIdx-1].isSelected = true
            selectedTags.append(tagTitles[initialTagTab].tagTab[selectedIdx-1].id)
            tagTitles[initialTagTab].count = 1
        }
        
        titleIndex = initialTagTab
        tagTitles[initialTagTab].isSelected = true
        tagCollectionView.contentOffset.y = self.initialYOffset
        
        if selectedTags.count >= 1 {
//            setNextBtnActivated()
            nextBtn.isUserInteractionEnabled = true
            nextBtn.backgroundColor = .pink
        }
        
        tagCollectionView.reloadData()
        tagTitleCollectionView.reloadData()
        
        
        
//        print(">>>>>>", tagTitles)
    }
    
    func initialBtn() {
        nextBtn.isUserInteractionEnabled = false
        nextBtn.backgroundColor = .subGrey3
        nextBtn.setTitle("삭제하기", for: .normal)
        nextBtn.setTitleColor(.white, for: .normal)
        nextBtn.titleLabel?.font = UIFont.SDGothicSemiBold16
        self.view.layoutIfNeeded()
        nextBtn.layer.cornerRadius = self.nextBtn.frame.height / 2
    }
    
    func setHeader() {
        titleLabel.numberOfLines = 2
        
        explanationLabel.text = "여러 개 선택도 가능해요."
        explanationLabel.font = UIFont.SDGothicRegular16
        explanationLabel.textColor = UIColor.subGrey6
    }
    
    func setTitleLabel() {
        let attributedString = NSMutableAttributedString(string: "삭제할 옷을\n선택해주세요.", attributes: [
            .font: UIFont(name: "AppleSDGothicNeoR00", size: 25.0)!,
            .foregroundColor: UIColor.mainGrey,
            .kern: -1.25
        ])
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        
        attributedString.addAttributes([
            .font: UIFont(name: "AppleSDGothicNeoSB00", size: 25.0)!,
            .foregroundColor: UIColor.pink
        ], range: NSRange(location: 0, length: 5))
        
        titleLabel.attributedText = attributedString
    }
    
    func setTagSelected(cell: RecordTagCVC) {
        cell.addTagImage.isHidden = true
        cell.tagLabel.isHidden = false
        cell.tagLabel.font = UIFont.SDGothicRegular15
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 20
        cell.tagLabel.textColor = UIColor.pink
        cell.layer.borderColor = UIColor.pink.cgColor
        cell.backgroundColor = UIColor.white
    }
    
    func setTagUnselected(cell: RecordTagCVC) {
        cell.addTagImage.isHidden = true
        cell.tagLabel.isHidden = false
        cell.tagLabel.font = UIFont.SDGothicRegular15
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 20
        cell.tagLabel.textColor = UIColor.mainGrey
        cell.layer.borderColor = UIColor.subGrey3.cgColor
        cell.backgroundColor = UIColor.white
    }
    
    func setNextBtnActivated() {
        nextBtn.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.5, animations: {
            self.nextBtn.backgroundColor = UIColor.pink
            self.nextBtn.setTitle("삭제하기", for: .normal)
            self.nextBtn.setTitleColor(.white, for: .normal)
            self.nextBtn.titleLabel?.font = UIFont.SDGothicSemiBold16
            self.nextBtn.layer.cornerRadius = self.nextBtn.frame.height / 2
        })
    }
    
    func setNextBtnDeactivated() {
        nextBtn.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.5, animations: {
            self.nextBtn.backgroundColor = UIColor.subGrey3
            self.nextBtn.setTitle("삭제하기", for: .normal)
            self.nextBtn.setTitleColor(.white, for: .normal)
            self.nextBtn.titleLabel?.font = UIFont.SDGothicSemiBold16
            self.nextBtn.layer.cornerRadius = self.nextBtn.frame.height / 2
        })
    }
    
    func setCancelBtn() {
//        /// 송편 되는 문제 해결 - 레이아웃이 변경 됐을 때 반영
//        self.view.layoutIfNeeded()
        
        self.cancelBtn.backgroundColor = UIColor.white
        self.cancelBtn.setBorder(borderColor: UIColor.subGrey2, borderWidth: 1)
        self.cancelBtn.setTitle("취소", for: .normal)
        self.cancelBtn.setTitleColor(UIColor.subGrey6, for: .normal)
        self.cancelBtn.titleLabel?.font = UIFont.SDGothicSemiBold16
        self.cancelBtn.layer.cornerRadius = self.cancelBtn.frame.height / 2
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
}

//MARK: - UICollectionViewDataSource

extension RecordTagDeleteVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        /// tagCollectionView
        if collectionView == tagCollectionView {
//            print(">>>", tagTitles[titleIndex].title ,tagTitles[titleIndex].tagTab.count)
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
            
            if isInitialized == false {
                tagCollectionView.contentOffset.y = self.initialYOffset
                isInitialized = true
            }
            
            cell.tagLabel.text = tagTitles[titleIndex].tagTab[indexPath.item].name
            cell.tagLabel.preferredMaxLayoutWidth = collectionView.frame.width - 32
            
            if tagTitles[titleIndex].tagTab[indexPath.item].isSelected == false {
                setTagUnselected(cell: cell)
            }
            else {
                setTagSelected(cell: cell)
            }
            
            return cell
        }
        
        
        /// tagTitleCollectionView
        else if collectionView == tagTitleCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecordTagTitleCVC", for: indexPath) as? RecordTagTitleCVC
            else {
                return UICollectionViewCell()
            }
            cell.setCell(title: tagTitles[indexPath.item].title, total: tagTitles[indexPath.item].tagTab.count, count: tagTitles[indexPath.item].count, isSelected: tagTitles[indexPath.item].isSelected, isDeleteView: true)
            
            return cell
        }
        
        return UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        /// tagCollectionView
        if collectionView == tagCollectionView {
            
        
            collectionView.deselectItem(at: indexPath, animated: false)
            
            tagTitles[titleIndex].tagTab[indexPath.item].isSelected = !tagTitles[titleIndex].tagTab[indexPath.item].isSelected
            
            if tagTitles[titleIndex].tagTab[indexPath.item].isSelected == true {
                selectedTags.append(tagTitles[titleIndex].tagTab[indexPath.item].id)
                tagTitles[titleIndex].count += 1
                self.tagCount += 1
            } else {
                let selectedId = tagTitles[titleIndex].tagTab[indexPath.item].id
                let selectedIndex = selectedTags.firstIndex(of: selectedId)
                selectedTags.remove(at: selectedIndex!)
                tagTitles[titleIndex].count -= 1
                self.tagCount -= 1
            }
            
            if tagTitles[titleIndex].tagTab[indexPath.item].isSelected {
                setTagSelected(cell: collectionView.cellForItem(at: indexPath) as! RecordTagCVC)
            } else {
                setTagUnselected(cell: collectionView.cellForItem(at: indexPath) as! RecordTagCVC)
            }
            
            UIView.performWithoutAnimation {
                self.tagTitleCollectionView.reloadItems(at: [IndexPath(item: titleIndex, section: 0)])
            }
            
            if tagTitles[0].count >= 1 || tagTitles[1].count >= 1 || tagTitles[2].count >= 1 ||
                tagTitles[3].count >= 1 {
                self.setNextBtnActivated()
            }
            else {
                self.setNextBtnDeactivated()
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

extension RecordTagDeleteVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == tagTitleCollectionView {
            let cellWidth : CGFloat = collectionView.frame.width/4 - 6
            let cellHeight : CGFloat = collectionView.frame.height
            
            return CGSize(width: cellWidth, height: cellHeight)
        } else {
            if let cell = collectionView.cellForItem(at: indexPath) {
                return CGSize(width: cell.frame.width, height: cell.frame.height)
            }
            
            return CGSize(width: 0, height: 0)
        }
        
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

