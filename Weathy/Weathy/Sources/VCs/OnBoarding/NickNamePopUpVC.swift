//
//  NickNamePopUpVC.swift
//  Weathy
//
//  Created by inae Lee on 2021/02/27.
//

import UIKit

class NickNamePopUpVC: UIViewController {
    // MARK: - IBOutlets

    @IBOutlet var popUpView: UIView!
    @IBOutlet var confirmButton: UIButton!

    // MARK: - Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }

    // MARK: - Custom Methods

    func setView() {
        popUpView.dropShadow(color: .black, offSet: CGSize(width: 0, height: 3), opacity: 0.4, radius: 20)
        popUpView.makeRounded(cornerRadius: 15)

        confirmButton.backgroundColor = UIColor.mintMain
        confirmButton.makeRounded(cornerRadius: 30)
    }

    // MARK: - IBActions

    @IBAction func touchUpConfirmButton(_ sender: Any) {
        print("확인")
        dismiss(animated: true, completion: nil)
    }
}
