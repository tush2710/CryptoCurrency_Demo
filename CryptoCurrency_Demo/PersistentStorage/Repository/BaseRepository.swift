//
//  BaseRepository.swift
//  EquityGroupTest_TusharZade
//
//  Created by Tushar Zade on 04/03/25.
//

import Foundation

protocol BaseRepository {
    associatedtype T

    func create(record: T, completion: (Bool) -> Void )
    func getAll() -> [T]?
    func get(byIdentifier id: String) -> T?
    func update(record: T) -> Bool
    func delete(byIdentifier id: String) -> Bool
}
