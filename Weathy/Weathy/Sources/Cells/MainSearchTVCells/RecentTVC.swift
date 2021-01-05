//
//  RecentTVC.swift
//  Weathy
//
//  Created by 송황호 on 2021/01/06.
//

import UIKit

class RecentTVC: UITableViewCell {

    static let identifier = "RecentTVC"
    
    @IBOutlet weak var recentBackView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        recentBackView.layer.cornerRadius = 30
        recentBackView.dropShadow(color: .gray, offSet: CGSize(width: 0, height: 0), opacity: 0.7, radius: 3)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
