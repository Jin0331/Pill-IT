//
//  Protocol.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/10/24.
//

import Foundation
import UIKit
import RealmSwift

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
    func periodSelectPresent()
    func startDateSelectPresent()
    func completeButtonAction()
}

protocol PillSpecificAction : AnyObject {
    func addButtonAction()
    func completeButtonAction()
}

protocol PillNotificationAction : AnyObject {
    func containPillButton(_ groupID : String?, _ data : [Pill]?)
    func notiDoneButton(_ pk : ObjectId?)
}
