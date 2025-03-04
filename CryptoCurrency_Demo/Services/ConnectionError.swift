//
//  ConnectionError.swift
//  EquityGroupTest_TusharZade
//
//  Created by Tushar Zade on 02/03/25.
//

import Foundation

protocol ConnectionError: Error {
    var isInternetConnectionError: Bool { get }
}

extension Error {
    var isInternetConnectionError: Bool {
        guard let error = self as? ConnectionError, error.isInternetConnectionError else {
            return false
        }
        return true
    }
}
