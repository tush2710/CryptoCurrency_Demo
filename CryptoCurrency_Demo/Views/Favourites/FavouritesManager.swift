//
//  FavouritesManager.swift
//  EquityGroupTest_TusharZade
//
//  Created by Tushar Zade on 04/03/25.
//

import Foundation

struct FavouritesManager
{
    private let _favouritesRepository = FavouritDataRepository()
    
    func addFavourite(record: Coin, completion: (Bool) -> Void) {
        _favouritesRepository.create(record: record, completion: completion)
    }

    func fetchFavourites() -> [Coin]? {
        return _favouritesRepository.getAll()
    }

    func fetchFavourite(byIdentifier id: String) -> Coin?{
        return _favouritesRepository.get(byIdentifier: id)
    }

    func updateFavourite(product: Coin) -> Bool {
        return _favouritesRepository.update(record: product)
    }

    func removeFavourite(id: String) -> Bool {
        return _favouritesRepository.delete(byIdentifier: id)
    }
}
