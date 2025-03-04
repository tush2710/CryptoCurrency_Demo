//
//  Favourites+CoreDataProperties.swift
//  EquityGroupTest_TusharZade
//
//  Created by Tushar Zade on 04/03/25.
//
//

import Foundation
import CoreData


@objc(Favourites)
public class Favourites: NSManagedObject {

}
extension Favourites {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favourites> {
        return NSFetchRequest<Favourites>(entityName: "Favourites")
    }

    @NSManaged public var uuid: String?
    @NSManaged public var symbol: String?
    @NSManaged public var name: String?
    @NSManaged public var color: String?
    @NSManaged public var iconUrl: String?
    @NSManaged public var marketCap: String?
    @NSManaged public var price: String?
    @NSManaged public var listedAt: Int64
    @NSManaged public var tier: Int64
    @NSManaged public var change: String?
    @NSManaged public var rank: Int64

}

extension Favourites : Identifiable {

}

extension Favourites{
    func convertToCoin() -> Coin {
        return Coin(
            id: Coin.Identifier(uuid ?? ""),
            symbol: symbol ?? "",
            name: name ?? "",
            color: color,
            iconUrl: iconUrl ?? "",
            marketCap: marketCap,
            price: price ?? "",
            listedAt: Int(listedAt),
            tier: Int(tier),
            change: change,
            rank: Int(rank),
            sparkline: [],
            lowVolume: nil,
            coinrankingUrl: nil,
            volume24h: nil,
            btcPrice: nil,
            contractAddresses: nil,
            allTimeHigh: nil
        )
    }
}
