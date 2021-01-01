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
    
    var tags : [Tag] = [
        Tag(name: " + ", isSelected: false),
        Tag(name: "후드티", isSelected: false),
        Tag(name: "반팔티", isSelected: false),
        Tag(name: "니트", isSelected: false),
        Tag(name: "기모후드티", isSelected: false),
        Tag(name: "폴로니트", isSelected: false),
        Tag(name: "목폴라", isSelected: false),
        Tag(name: "히트텍", isSelected: false),
        Tag(name: "기모맨투맨(흰색)", isSelected: false)
    ]
    
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

// MARK: - UICollectionViewDataSource

extension RecordTagVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        /// tagCollectionView
        if collectionView == tagCollectionView {
            return tags.count
        }
        
        /// tagTitleCollectionView
        else if collectionView == tagTitleCollectionView {
            
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
                cell.tagLabel.textColor = .black
                cell.tagLabel.preferredMaxLayoutWidth = collectionView.frame.width - 32
                cell.layer.borderColor = UIColor.lightGray.cgColor
                cell.layer.borderWidth = 1
                cell.layer.cornerRadius = 20

            } else {
                cell.tagLabel.text = tags[indexPath.item].name
                cell.tagLabel.textColor = UIColor(red: 71/255, green: 192/255, blue: 172/255, alpha: 1)
                cell.tagLabel.preferredMaxLayoutWidth = collectionView.frame.width - 32
                cell.layer.borderColor = UIColor(red: 71/255, green: 192/255, blue: 172/255, alpha: 1).cgColor
                cell.layer.borderWidth = 1
                cell.layer.cornerRadius = 20
            }
            
            return cell
        }
        
        /// tagTitleCollectionView
        else if collectionView == tagTitleCollectionView {
            
        }
        
        return UICollectionViewCell()
       
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        /// tagCollectionView
        if collectionView == tagCollectionView {
            collectionView.deselectItem(at: indexPath, animated: false)
            tags[indexPath.item].isSelected = !tags[indexPath.item].isSelected
            self.tagCollectionView.reloadData()
        }
        
        /// tagTitleCollectionView
        else if collectionView == tagTitleCollectionView {
            
        }
        
    }
}


//MARK: - UICollectionViewDelegateFlowLayout

extension RecordTagVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        /// tagCollectionView
        if collectionView == tagCollectionView {
            return CGSize(width: 200, height: 30)
        }
        
        /// tagTitleCollectionView
        else if collectionView == tagTitleCollectionView {
            
        }
        
        return CGSize()
    }
}

