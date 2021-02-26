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
    @IBOutlet var confirmButtonLabel: SpacedLabel!

    // MARK: - Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }

    // MARK: - Custom Methods

    func setView() {
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)

        popUpView.dropShadow(color: UIColor(red: 39/255, green: 39/255, blue: 39/255, alpha: 1), offSet: CGSize(width: 0, height: 3), opacity: 0.4, radius: 20)
        popUpView.makeRounded(cornerRadius: 15)

        confirmButton.backgroundColor = UIColor.mintMain
        confirmButton.makeRounded(cornerRadius: confirmButton.frame.height/2)

        confirmButtonLabel.text = "확인"
        confirmButtonLabel.textColor = .white
        confirmButtonLabel.font = UIFont.SDGothicSemiBold16
        confirmButtonLabel.characterSpacing = -0.8
    }

    // MARK: - IBActions

    @IBAction func touchUpConfirmButton(_ sender: Any) {
        guard let preVC = presentingViewController as? NickNameVC else { return }
//        preVC.isClosePopUp = true
        preVC.dismiss(animated: true, completion: nil)
    }
}
