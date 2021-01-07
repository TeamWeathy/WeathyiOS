//
//  TagCVCCollectionViewCell.swift
//  Weathy
//
//  Created by DANNA LEE on 2021/01/01.
//

import UIKit

class RecordTagCVC: UICollectionViewCell {
    
    
    // MARK: - IBOutlets
    
    @IBOutlet var tagLabel: UILabel!
    @IBOutlet var addTagImage: UIImageView!
    
    override func awakeFromNib() {
        addTagImage.image = UIImage(named: "recordBtnAddtag")
    }
    
}
