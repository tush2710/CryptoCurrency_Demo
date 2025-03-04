//
//  CoinPriceHistoryDTO+Mapping.swift
//  EquityGroupTest_TusharZade
//
//  Created by Tushar Zade on 03/03/25.
//

import Foundation

// MARK: - CoinPriceHistoryDTO
struct CoinPriceHistoryDTO: Codable {
    let status: String
    let data: CoinPriceHistoryDataClass
    
}

extension CoinPriceHistoryDTO {
    func toDomain() -> [PriceHistory] {
        return data.history.map { $0.toDomain() }
    }
}

// MARK: - DataClass
struct CoinPriceHistoryDataClass: Codable {
    let change: String
    let history: [HistoryDTO]
}

// MARK: - History
struct HistoryDTO: Codable {
    let price: String?
    let timestamp: Int
}

extension HistoryDTO {
    func toDomain() -> PriceHistory{
        PriceHistory(
            id: PriceHistory.Identifier(UUID().uuidString),
            price: Double(price ?? "0") ?? 0.0,
            date: Date(timeIntervalSince1970: TimeInterval(timestamp)))
    }
}
