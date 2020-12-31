//
//  RecordTagVC.swift
//  Weathy
//
//  Created by DANNA LEE on 2020/12/31.
//

import UIKit

class RecordTagVC: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var dismissBtn: UIButton!
    
    @IBOutlet var nextBtn: UIButton!
    
    
    //MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

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
