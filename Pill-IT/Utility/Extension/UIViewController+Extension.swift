//
//  UIViewController+Extension.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/15/24.
//

import UIKit

extension UIViewController {
    
    func setupSheetPresentation() {
        if let sheet = self.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true // Grabber Show/Hide 설정
        }
    }
    
    func showAlert(title: String?, message: String?, preferredStyle: UIAlertController.Style = .alert, actions: [UIAlertAction]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        for action in actions {
            alertController.addAction(action)
        }
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
}
