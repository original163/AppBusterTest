//
//  AlertPresenter.swift.swift
//  AppBusterTest
//
//  Created by Денис Денисов on 13.12.2021.
//

import Foundation
import UIKit

class AlertPresenter {
    func showAlert(title: String, message: String, preferredStyle: UIAlertController.Style, action: UIAlertAction) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        alert.addAction(action)
        
        
        
    }
}
