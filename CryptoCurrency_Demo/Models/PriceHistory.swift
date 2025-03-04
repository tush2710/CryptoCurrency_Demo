//
//  PriceHistory.swift
//  EquityGroupTest_TusharZade
//
//  Created by Tushar Zade on 03/03/25.
//

import Foundation

struct PriceHistory : Equatable, Identifiable {
    typealias Identifier = String
    let id: Identifier
    let price: Double
    let date: Date
}
