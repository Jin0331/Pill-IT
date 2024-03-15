//
//  UIViewController+Extension.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/15/24.
//

import UIKit

extension UIViewController {
    
    func setupSheetPresentation() {
        guard let self = self as? RegisterPillViewController else { return }
        if let sheet = self.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true // Grabber Show/Hide 설정
        }
    }
}
