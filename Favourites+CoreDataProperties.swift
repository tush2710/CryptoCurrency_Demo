//
//  Favourites+CoreDataProperties.swift
//  EquityGroupTest_TusharZade
//
//  Created by Tushar Zade on 04/03/25.
//
//

import Foundation
import CoreData


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
    @NSManaged public var tier: Int16
    @NSManaged public var change: String?
    @NSManaged public var rank: Int32

}

extension Favourites : Identifiable {

}
