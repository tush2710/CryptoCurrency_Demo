//
//  FavouritesViewModel.swift
//  EquityGroupTest_TusharZade
//
//  Created by Tushar Zade on 04/03/25.
//

import Foundation


struct FavouritestViewModelActions {
    let showCoinsDetails: (Coin) -> Void
}


protocol FavouritesViewModelInput{
    func viewDidLoad()
    func didSelectItem(at index: Int)
    func removeFavourite(_ uuid: String, completion: (Bool) -> Void)
    func refreshFavourites()
}

protocol FavouritesViewModelOutput {
    var items: Observable<[CoinsListItemViewModel]> { get }
    var isEmpty: Bool { get }
    func getAllFavourite()
}

typealias FavouritesViewModel = FavouritesViewModelInput & FavouritesViewModelOutput

final class DefaultFavouritesViewModel: FavouritesViewModel {
    private let favouritesManager: FavouritesManager
    private let actions: FavouritestViewModelActions?
    private let mainQueue: DispatchQueueType
    
    var items: Observable<[CoinsListItemViewModel]> = Observable([])
    var isEmpty: Bool { return items.value.isEmpty }
    private var favourites : [Coin] = []
    
    init(
        favouritesManager: FavouritesManager = FavouritesManager(),
        actions: FavouritestViewModelActions?,
        mainQueue: DispatchQueueType = DispatchQueue.main) {
        self.favouritesManager = favouritesManager
        self.actions = actions
        self.mainQueue = mainQueue
    }
    
    func getAllFavourite() {
        guard let favourotes = favouritesManager.fetchFavourites() else { return }
        self.favourites = favourotes
        items.value = favourotes.map(CoinsListItemViewModel.init)
    }
}
extension DefaultFavouritesViewModel {
    func viewDidLoad() { }
    
    func didSelectItem(at index: Int) {
        actions?.showCoinsDetails(favourites[index])
    }
    
    func removeFavourite(_ uuid: String, completion: (Bool) -> Void) {
        let removeFavourite = favouritesManager.removeFavourite(id: uuid)
        completion(removeFavourite)
    }
    
    func refreshFavourites() {
        self.getAllFavourite()
    }
}
