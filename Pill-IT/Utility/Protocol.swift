//
//  Protocol.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/10/24.
//

import Foundation

protocol PillRegisterAction : AnyObject {
    func disMissPresent()
    func completePillRegister()
    func defaultButtonAction()
    func cameraGalleryButtonAction()
    func webSearchButtonAction()
}

protocol PillListAction : AnyObject {
    func completeToast()
}
