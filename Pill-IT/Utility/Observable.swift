//
//  Observable.swift
//  CoinMarket
//
//  Created by JinwooLee on 2/28/24.
//

import Foundation

final class Observable<T> {
    
    private var closure : ((T) -> Void)?
    
    var value : T {
        didSet {
            closure?(value)
        }
    }
    
    init(_ text: T) {
        self.value = text
    }
    
    func bind(_ closure : @escaping (T) -> Void) {
        closure(value)
        self.closure = closure
    }
}

