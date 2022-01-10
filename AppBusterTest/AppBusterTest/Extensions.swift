//
//  Extensions.swift
//  AppBusterTest
//
//  Created by Денис Денисов on 10.01.2022.
//

import Foundation
import UIKit
extension GreetingVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if userNameTextField.text == "" {
            let alert = UIAlertController(title: "No input", message: "Please enter nickaname", preferredStyle: .alert)
            let action = UIAlertAction(title: "ok", style: .cancel)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        } else {
            if let username = userNameTextField.text {
                let previewVC = PreviewVC(username: username)
                previewVC.modalPresentationStyle = .fullScreen
                present(previewVC, animated: true)
            }
        }
        userNameTextField.endEditing(true)
        return true
    }
}
