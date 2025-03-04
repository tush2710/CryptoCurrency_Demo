//
//  CoinsListRequestDTO+Mapping.swift
//  EquityGroupTest_TusharZade
//
//  Created by Tushar Zade on 02/03/25.
//

import Foundation

struct CoinsListRequestDTO: Encodable {
    let offset: Int
    let limit: Int = 20
    let orderBy: String?
}

enum OrderBy: String, Encodable{
    case price
    case change
}

