//
//  OnBoardingSecondVC.swift
//  Weathy
//
//  Created by 송황호 on 2021/01/07.
//

import UIKit

class OnBoardingSecondVC: UIViewController {

    @IBOutlet var gestureStart: UISwipeGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let right = UISwipeGestureRecognizer(target: self, action: #selector(actGesture(_:)))
      right.direction = .right
        self.view.addGestureRecognizer(right)
      
      
        let left = UISwipeGestureRecognizer(target: self, action: #selector(actGesture(_:)))
      left.direction = .left
        self.view.addGestureRecognizer(left)
    }
    
    @IBAction func actGesture(_ sender: UISwipeGestureRecognizer) {
        
        /// 오른쪽 -> 왼쪽
        if sender.direction == .left {
            print("left")
            guard let storyboard = self.storyboard else {
                return
            }
            guard let gestureEndViewController = storyboard.instantiateViewController(withIdentifier: "OnBoardingThirdVC") as? OnBoardingThirdVC
            else {
                return
            }
            self.navigationController?.pushViewController(gestureEndViewController, animated: true)
        }
        
        /// 왼쪽 -> 오른쪽
        if sender.direction == .right {

            self.navigationController?.popViewController(animated: true)
        }
    }
    
}
