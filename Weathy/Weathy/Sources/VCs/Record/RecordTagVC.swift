//
//  RecordTagVC.swift
//  Weathy
//
//  Created by DANNA LEE on 2020/12/31.
//

import UIKit

class RecordTagVC: UIViewController {
    
    //MARK: - Custom Variables
    
    struct Tag {
        var name: String
        var isSelected: Bool
    }
    
    struct TagTitle {
        let title: String
        var count: Int
        var isSelected: Bool
    }
    
    var tags: [Tag] = [
        Tag(name: " + ", isSelected: false),
        Tag(name: "후드티", isSelected: false),
        Tag(name: "반팔티", isSelected: false),
        Tag(name: "니트", isSelected: false),
        Tag(name: "기모후드티", isSelected: false),
        Tag(name: "폴로니트", isSelected: false),
        Tag(name: "목폴라", isSelected: false),
        Tag(name: "히트텍", isSelected: false),
        Tag(name: "기모맨투맨(흰색)", isSelected: false),
        Tag(name: "후드티", isSelected: false),
        Tag(name: "반팔티", isSelected: false),
        Tag(name: "니트", isSelected: false),
        Tag(name: "기모후드티", isSelected: false),
        Tag(name: "폴로니트", isSelected: false),
        Tag(name: "목폴라", isSelected: false),
        Tag(name: "히트텍", isSelected: false),
        Tag(name: "기모맨투맨(흰색)", isSelected: false),
        Tag(name: "후드티", isSelected: false),
        Tag(name: "반팔티", isSelected: false),
        Tag(name: "니트", isSelected: false),
        Tag(name: "기모후드티", isSelected: false),
        Tag(name: "폴로니트", isSelected: false),
        Tag(name: "목폴라", isSelected: false),
        Tag(name: "히트텍", isSelected: false),
        Tag(name: "기모맨투맨(흰색)", isSelected: false),
        Tag(name: "후드티", isSelected: false),
        Tag(name: "반팔티", isSelected: false),
        Tag(name: "니트", isSelected: false),
        Tag(name: "기모후드티", isSelected: false),
        Tag(name: "폴로니트", isSelected: false),
        Tag(name: "목폴라", isSelected: false),
        Tag(name: "히트텍", isSelected: false),
        Tag(name: "기모맨투맨(흰색)", isSelected: false),
        Tag(name: "후드티", isSelected: false),
        Tag(name: "반팔티", isSelected: false),
        Tag(name: "니트", isSelected: false),
        Tag(name: "기모후드티", isSelected: false),
        Tag(name: "폴로니트", isSelected: false),
        Tag(name: "목폴라", isSelected: false),
        Tag(name: "히트텍", isSelected: false),
        Tag(name: "기모맨투맨(흰색)", isSelected: false),
        Tag(name: "후드티", isSelected: false),
        Tag(name: "반팔티", isSelected: false),
        Tag(name: "니트", isSelected: false),
        Tag(name: "기모후드티", isSelected: false),
        Tag(name: "폴로니트", isSelected: false),
        Tag(name: "목폴라", isSelected: false),
        Tag(name: "히트텍", isSelected: false),
        Tag(name: "기모맨투맨(흰색)", isSelected: false)
    ]
    
    var tagTitles: [TagTitle] = [
        TagTitle(title: "상의", count: 0, isSelected: true),
        TagTitle(title: "하의", count: 0, isSelected: false),
        TagTitle(title: "외투", count: 0, isSelected: false),
        TagTitle(title: "기타", count: 0, isSelected: false)
    ]
    
    let name: String = "웨디"
    var titleIndex: Int = 0
    
    //MARK: - IBOutlets
    
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var dismissBtn: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var explanationLabel: UILabel!
    
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

        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - IBActions
    
    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextBtnTap(_ sender: Any) {
        let nextStoryboard = UIStoryboard(name: "RecordRate", bundle: nil)
        guard let dvc = nextStoryboard.instantiateViewController(identifier: "RecordRateVC") as? RecordRateVC else {
            return
        }
        
        self.navigationController?.pushViewController(dvc, animated: true)
    }
    

}


//MARK: - Style

extension RecordTagVC {
    func setHeader() {
        titleLabel.text = "\(name)님은 오늘\n어떤 옷을 입었나요?"
        titleLabel.font = UIFont(name: "AppleSDGothicNeoR00", size: 25)
        titleLabel.textColor = UIColor.mainGrey
        titleLabel.numberOfLines = 2
        
        explanationLabel.text = "+를 눌러 추가하고, 꾹 눌러 삭제할 수 있어요."
        explanationLabel.font = UIFont.SDGothicRegular16
        explanationLabel.textColor = UIColor.subGrey6
    }
}

//MARK: - UICollectionViewDataSource

extension RecordTagVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        /// tagCollectionView
        if collectionView == tagCollectionView {
            return tags.count
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
            
            if tags[indexPath.item].isSelected == false {
                cell.tagLabel.text = tags[indexPath.item].name
                cell.tagLabel.textColor = UIColor.subGrey6
                cell.tagLabel.font = UIFont.SDGothicRegular15
                cell.tagLabel.preferredMaxLayoutWidth = collectionView.frame.width - 80
                cell.layer.borderColor = UIColor.clear.cgColor
                cell.layer.borderWidth = 1
                cell.layer.cornerRadius = 20
                cell.backgroundColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1)

            } else {
                cell.tagLabel.text = tags[indexPath.item].name
                cell.tagLabel.textColor = UIColor.mintIcon
                cell.tagLabel.preferredMaxLayoutWidth = collectionView.frame.width - 32
                cell.layer.borderColor = UIColor.mintMain.cgColor
                cell.layer.borderWidth = 1
                cell.layer.cornerRadius = 20
                cell.backgroundColor = UIColor.white
            }
            
            return cell
        }
        
        /// tagTitleCollectionView
        else if collectionView == tagTitleCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecordTagTitleCVC", for: indexPath) as? RecordTagTitleCVC
            else {
                return UICollectionViewCell()
            }
            cell.setCell(title: tagTitles[indexPath.item].title, count: tagTitles[indexPath.item].count, isSelected: tagTitles[indexPath.item].isSelected)
            
//            cell.layer.borderWidth = 1
//            cell.layer.borderColor = UIColor.black.cgColor
            
            return cell
        }
        
        return UICollectionViewCell()
       
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        /// tagCollectionView
        if collectionView == tagCollectionView {
            
            print(tagTitles[titleIndex].count)
            
            if tagTitles[titleIndex].count < 5 {
                collectionView.deselectItem(at: indexPath, animated: false)
                tags[indexPath.item].isSelected = !tags[indexPath.item].isSelected
                if tags[indexPath.item].isSelected == true {
                    tagTitles[titleIndex].count += 1
                } else {
                    tagTitles[titleIndex].count -= 1
                }
                self.tagCollectionView.reloadData()
                self.tagTitleCollectionView.reloadData()
            } else if tagTitles[titleIndex].count == 5 {
                if tags[indexPath.item].isSelected == true {
                    tags[indexPath.item].isSelected = false
                    tagTitles[titleIndex].count -= 1
                }
                self.tagCollectionView.reloadData()
                self.tagTitleCollectionView.reloadData()
            } else {
                
            }
            
        }
        
        /// tagTitleCollectionView
        else if collectionView == tagTitleCollectionView {
            collectionView.deselectItem(at: indexPath, animated: false)
            
            /// 선택된 거 빼고 모두 isSelected를 false로 변경
            for i in 0...tagTitles.count-1 {
                if i == indexPath.item {
                    tagTitles[i].isSelected = !tagTitles[i].isSelected
                    
                    if tagTitles[i].isSelected == true {
                        self.titleIndex = i
                        print("선택된 것 >> ", tagTitles[i].title)
                    } else {
                        
                    }
                    
                } else {
                    tagTitles[i].isSelected = false
                }
            }
            
            self.tagTitleCollectionView.reloadData()
        }
        
    }
}


//MARK: - UICollectionViewDelegateFlowLayout

extension RecordTagVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == tagTitleCollectionView {
            let cellWidth : CGFloat = collectionView.frame.width/4 - 6
            let cellHeight : CGFloat = collectionView.frame.height
            
            return CGSize(width: cellWidth, height: cellHeight)
        }
        
        return CGSize()
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
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        /// tagTitleCollectionView
        else if collectionView == tagTitleCollectionView {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        return UIEdgeInsets()
    }
}

