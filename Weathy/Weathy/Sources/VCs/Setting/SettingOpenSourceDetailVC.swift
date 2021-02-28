//
//  OpenSourceDetailVC.swift
//  Weathy
//
//  Created by 이예슬 on 2021/02/28.
//

import UIKit

class SettingOpenSourceDetailVC: UIViewController {

    var titleText: String = ""
    var contentText: String = ""
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabel()
    }

    func setLabel(){
        titleLabel.text = titleText
        contentTextView.text = contentText
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
