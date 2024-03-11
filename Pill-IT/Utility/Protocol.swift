//
//  Protocol.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/10/24.
//

import Foundation

protocol RegisterPillAction : AnyObject {
    
    func disMissPresent()
    func completePillRegister()
}
