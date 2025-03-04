//
//  FavouriteRepository.swift
//  EquityGroupTest_TusharZade
//
//  Created by Tushar Zade on 04/03/25.
//

import Foundation
import CoreData

protocol FavouriteRepository : BaseRepository {

}

struct  FavouritDataRepository : FavouriteRepository {
    typealias T = Coin

    func create(record: Coin, completion: (Bool) -> Void) {
        let coins = Favourites(context: CoreDataStorage.shared.context)
        coins.uuid = String(record.id)
        coins.symbol = record.symbol
        coins.name = record.name
        coins.color = record.color
        coins.iconUrl = record.iconUrl
        coins.marketCap = record.marketCap
        coins.price = record.price
        coins.listedAt = Int64(record.listedAt ?? 0)
        coins.tier = Int64(record.tier ?? 0)
        coins.change = record.change
        coins.rank = Int64(record.rank ?? 0)
        CoreDataStorage.shared.saveContext(completion: completion)
    }

    func getAll() -> [Coin]? {

        let records = CoreDataStorage.shared.fetchManagedObject(managedObject: Favourites.self)
        guard records != nil && records?.count != 0 else {return nil}

        var results: [Coin] = []
        records!.forEach({ (cdFavourites) in
            results.append(cdFavourites.convertToCoin())
        })

        return results
    }

    func get(byIdentifier id: String) -> Coin? {

        let Coin = getCdFavourites(byId: id)
        guard Coin != nil else {return nil}

        return (Coin?.convertToCoin())!
    }

    func update(record: Coin) -> Bool {
        return true
    }

    func delete(byIdentifier id: String) -> Bool {

        let Coin = getCdFavourites(byId: id)
        guard Coin != nil else {return false}

        CoreDataStorage.shared.context.delete(Coin!)
        CoreDataStorage.shared.saveContext { _ in }

        return true
    }

    private func getCdFavourites(byId id: String) -> Favourites?{
        let fetchRequest = NSFetchRequest<Favourites>(entityName: "Favourites")
        let fetchById = NSPredicate(format: "uuid==%@", id as CVarArg)
        fetchRequest.predicate = fetchById

        let result = try! CoreDataStorage.shared.context.fetch(fetchRequest)
        guard result.count != 0 else {return nil}

        return result.first
    }
}
