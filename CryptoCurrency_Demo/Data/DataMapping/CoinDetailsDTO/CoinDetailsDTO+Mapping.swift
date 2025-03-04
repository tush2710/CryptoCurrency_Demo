//
//  CoinDetailsDTO+Mapping.swift
//  EquityGroupTest_TusharZade
//
//  Created by Tushar Zade on 03/03/25.
//

import Foundation

struct CoinDetailsResponseDTO: Codable {
    let status: String
    let data: CoinDetailsDataClass
}

extension CoinDetailsResponseDTO {
    func toDomain() -> Coin {
        return data.coin.toCoin()
    }
}

// MARK: - DataClass
struct CoinDetailsDataClass: Codable {
    let coin: CoinDTO
}
