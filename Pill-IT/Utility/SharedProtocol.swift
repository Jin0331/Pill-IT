//
//  Protocol.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/10/24.
//

import Foundation
import UIKit

protocol PillRegisterAction : AnyObject {
    func disMissPresent()
    func completePillRegister()
    func defaultImageButtonClicked()
    func defaultButtonAction()
    func cameraGalleryButtonAction()
    func webSearchButtonAction()
}

protocol PillListAction : AnyObject {
    func completeToast()
    func fetchPillTable()
}

protocol PillManagementAction : AnyObject {
    func alarmVCTransition()
}

protocol PillAlarmReigsterAction : AnyObject {
    func dismissPresent()
    func periodSelectPresent()
    func startDateSelectPresent()
}
