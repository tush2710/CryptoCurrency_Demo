//
//  DispatchQueueType.swift
//  EquityGroupTest_TusharZade
//
//  Created by Tushar Zade on 02/03/25.
//

import Foundation

protocol DispatchQueueType {
    func async(execute work: @escaping () -> Void)
}

extension DispatchQueue: DispatchQueueType {
    func async(execute work: @escaping () -> Void) {
        async(group: nil, execute: work)
    }
}
