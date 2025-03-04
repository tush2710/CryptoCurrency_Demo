//
//  APIEndPoint.swift
//  EquityGroupTest_TusharZade
//
//  Created by Tushar Zade on 02/03/25.
//

import Foundation

struct APIEndpoints {
    
    static func getCoinsList(with coinListRequestDTO: CoinsListRequestDTO) -> Endpoint<CoinsListResponseDTO> {
        return Endpoint(
            path: "coins",
            method: .get,
            queryParametersEncodable: coinListRequestDTO
        )
    }
    
    static func getCoinsDeatails(with uuid: String, query: CoinDetailsRequestDTO) -> Endpoint<CoinDetailsResponseDTO> {
        return Endpoint(
            path: "coin/\(uuid)",
            method: .get,
            queryParametersEncodable: query
        )
    }
    
    static func getCoinPriceHistory(with uuid: String, query: CoinDetailsRequestDTO) -> Endpoint<CoinPriceHistoryDTO> {
        return Endpoint(
            path: "coin/\(uuid)/history",
            method: .get,
            queryParametersEncodable: query
        )
    }
}
