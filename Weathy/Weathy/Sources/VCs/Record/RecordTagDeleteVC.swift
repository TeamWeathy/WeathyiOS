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
    var initialSelectedIdx: Int = 0
    
    var selectedTags: [Int] = []
    
    //MARK: - IBOutlets
    @IBOutlet var blurView: UIImageView!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var explanationLabel: UILabel!
    
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
        setCancelBtn()
        
        /// + 자리에 있던 아이 삭제
        for i in 0...3 {
            tagTitles[i].tagTab.removeFirst()
            
            /// isSelected 초기화
            for j in 0...tagTitles[i].tagTab.count - 1 {
                tagTitles[i].tagTab[j].isSelected = false
            }
        }
        
        /// 삭제 탭 부를 때 선택했던 셀은 기본적으로 선택돼있게
        titleIndex = initialTagTab
        tagTitles[initialTagTab].tagTab[initialSelectedIdx-1].isSelected = true
        tagTitles[initialTagTab].count = 1
        tagTitles[initialTagTab].isSelected = true
        selectedTags.append(tagTitles[initialTagTab].tagTab[initialSelectedIdx-1].id)
        
        nextBtn.isUserInteractionEnabled = true
        nextBtn.backgroundColor = UIColor.pink
        nextBtn.setTitle("삭제하기", for: .normal)
        nextBtn.setTitleColor(.white, for: .normal)
        nextBtn.titleLabel?.font = UIFont.SDGothicSemiBold16
        nextBtn.layer.cornerRadius = 30
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        blurView.alpha = 0
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
            self.nextBtn.layer.cornerRadius = 30
        })
    }
    
    func setNextBtnDeactivated() {
        nextBtn.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.5, animations: {
            self.nextBtn.backgroundColor = UIColor.subGrey3
            self.nextBtn.setTitle("삭제하기", for: .normal)
            self.nextBtn.setTitleColor(.white, for: .normal)
            self.nextBtn.titleLabel?.font = UIFont.SDGothicSemiBold16
            self.nextBtn.layer.cornerRadius = 30
        })
    }
    
    func setCancelBtn() {
        self.cancelBtn.backgroundColor = UIColor.white
        self.cancelBtn.setBorder(borderColor: UIColor.subGrey2, borderWidth: 1)
        self.cancelBtn.setTitle("취소", for: .normal)
        self.cancelBtn.setTitleColor(UIColor.subGrey6, for: .normal)
        self.cancelBtn.titleLabel?.font = UIFont.SDGothicSemiBold16
        self.cancelBtn.layer.cornerRadius = 30
    }
}

//MARK: - UICollectionViewDataSource

extension RecordTagDeleteVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        /// tagCollectionView
        if collectionView == tagCollectionView {
            print(">>>", tagTitles[titleIndex].title ,tagTitles[titleIndex].tagTab.count)
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
            } else {
                let selectedId = tagTitles[titleIndex].tagTab[indexPath.item].id
                let selectedIndex = selectedTags.firstIndex(of: selectedId)
                selectedTags.remove(at: selectedIndex!)
                tagTitles[titleIndex].count -= 1
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

extension RecordTagDeleteVC: UICollectionViewDelegateFlowLayout {
    
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

