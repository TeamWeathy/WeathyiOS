//
//  OnBoardingFirstVC.swift
//  Weathy
//
//  Created by 송황호 on 2021/01/07.
//

import UIKit

class OnBoardingFirstVC: UIViewController {
    
    
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
            guard let gestureEndViewController = storyboard.instantiateViewController(withIdentifier: "firstViewController") as? firstViewController else {
                return
            }
            self.navigationController?.pushViewController(gestureEndViewController, animated: true)
        }
        
        /// 왼쪽 -> 오른쪽
        if sender.direction == .right {
            print("right")
            self.dismiss(animated: true)
        }
    }
    
}


class firstViewController: UIViewController {
    
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
            guard let gestureEndViewController = storyboard.instantiateViewController(withIdentifier: "ThirdViewController") as? ThirdViewController else {
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



class secondViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}


class ThirdViewController: UIViewController {
    
    @IBOutlet var gestureStart: UISwipeGestureRecognizer!
    @IBOutlet weak var OnButton: UIButton!
    @IBOutlet weak var onButtonContstantHeight: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let right = UISwipeGestureRecognizer(target: self, action: #selector(actGesture(_:)))
        
        right.direction = .right
        self.view.addGestureRecognizer(right)
        
        
        //        let left = UISwipeGestureRecognizer(target: self, action: #selector(actGesture(_:)))
        //      left.direction = .left
        //        self.view.addGestureRecognizer(left)
        
        prepareanimation()
    }
    
    // 화면이 나타날 때!
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showAnimation()
    }
    
    // 오토레이아웃 원상복귀 시키기!
    private func prepareanimation(){
        onButtonContstantHeight.constant = 10
        OnButton.alpha = 0
    
    }
    
    private func showAnimation(){


        
        UIView.animate(withDuration: 1, delay: 0, options: .allowUserInteraction, animations: {self.OnButton.alpha = 1;         self.OnButton.transform = CGAffineTransform(translationX: 0, y: -30)}, completion: nil)
       
        }
    
    
    @IBAction func actGesture(_ sender: UISwipeGestureRecognizer) {
        /// 오른쪽 -> 왼쪽
        if sender.direction == .left {
            print("left")
            guard let storyboard = self.storyboard else {
                return
            }
            guard let gestureEndViewController = storyboard.instantiateViewController(withIdentifier: "firstViewController") as? firstViewController else {
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
