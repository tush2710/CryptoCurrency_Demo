//
//  DiscoverViewModel.swift
//  EquityGroupTest_TusharZade
//
//  Created by Tushar Zade on 02/03/25.
//

import Foundation

struct CoinsListViewModelActions {
    let showCoinsDetails: (Coin) -> Void
    let showFavourites: () -> Void
}

enum CoinsListViewModelLoading {
    case fullScreen
    case nextPage
}

protocol CoinsListViewModelInput{
    func viewDidLoad()
    func update()
    func didLoadNextPage()
    func didSelectItem(at index: Int)
    func didSelectFavouriteButton()
}

protocol CoinsListViewModelOutput {
    var items: Observable<[CoinsListItemViewModel]> { get }
    var loading: Observable<CoinsListViewModelLoading?> { get }
    var query: Observable<String> { get }
    var error: Observable<String> { get }
    var isEmpty: Bool { get }
    var errorTitle: String { get }
    var orderBy: Observable<OrderBy> { get set }
    func getCoinsList(loading: CoinsListViewModelLoading)
    func getAllFavourite() -> [Coin]
    func addFavourite(_ uuid: String, completion: (Bool) -> Void)
    func removeFavourite(_ uuid: String, completion: (Bool) -> Void)
    func refreshFavourites()
}

typealias CoinsListViewModel = CoinsListViewModelInput & CoinsListViewModelOutput

final class DefaultCoinsListViewModel: CoinsListViewModel {
    
    var errorTitle: String = "Error!"
    
    private let actions: CoinsListViewModelActions?
    private let coinsRepository: CoinsRepository
    private let favouritesManager: FavouritesManager
    var currentPage: Int = 0
    var totalPageCount: Int = 1
    var hasMorePages: Bool { currentPage < totalPageCount }
    var nextPage: Int { hasMorePages ? items.value.count : currentPage }
    private var pages: [CoinsPage] = []
    private var coinsLoadTask: Cancellable? { willSet { coinsLoadTask?.cancel() } }
    private let mainQueue: DispatchQueueType
    private var favourites : [Coin] = []
    
    
    var items: Observable<[CoinsListItemViewModel]> = Observable([])
    var loading: Observable<CoinsListViewModelLoading?> = Observable(.none)
    var query: Observable<String> = Observable("")
    var error: Observable<String> = Observable("")
    var orderBy: Observable<OrderBy> = Observable(.price)
    var isEmpty: Bool { return items.value.isEmpty }
    
    
    init(
        actions: CoinsListViewModelActions? = nil,
        coinsRepo: CoinsRepository,
        mainQueue: DispatchQueueType = DispatchQueue.main,
        favoritesManager: FavouritesManager = FavouritesManager()
    ) {
        self.actions = actions
        self.coinsRepository = coinsRepo
        self.mainQueue = mainQueue
        self.favouritesManager = favoritesManager
    }
    
    private func appendPage(_ coinsPage: CoinsPage) {
        currentPage = coinsPage.page
        totalPageCount = coinsPage.totalPages

        pages = pages
            .filter { $0.page != coinsPage.page }
        + [coinsPage]

        items.value = pages.coins.map(CoinsListItemViewModel.init)
    }
    
    private func resetPages() {
        currentPage = 0
        totalPageCount = 1
        pages.removeAll()
        items.value.removeAll()
    }
    
    func getCoinsList(loading: CoinsListViewModelLoading) {
        self.loading.value = loading
        coinsRepository.fetchCoinsList(page: nextPage, orderBy: orderBy.value) { result in
            if case .success(let success) = result {
                self.mainQueue.async {
                    switch result {
                    case .success(var page):
                        if self.favourites.isEmpty {
                            let favorites = self.getAllFavourite()
                            self.favourites = favorites
                        }
                        page.coins = page.coins.map({ coin in
                            var modifiedCoin = coin
                            if self.favourites.contains(where: { $0.id == coin.id }){
                                modifiedCoin.isFavourite = true
                            }
                            return modifiedCoin
                        })
                        self.appendPage(page)
                        
                    case .failure(let error):
                        self.handle(error: error)
                    }
                    self.loading.value = .none
                }
            } else if case .failure(let error) = result {
                self.mainQueue.async {
                    if let dataTransferError = error as? DataTransferError, case .networkFailure(.limitReached) = dataTransferError {
                        self.error.value = NSLocalizedString("You've reached the API request limit.", comment: "")
                    } else {
                        self.handle(error: error)
                    }
                }
            }
        }
    }
    
    private func handle(error: Error) {
        self.error.value = error.isInternetConnectionError ?
            NSLocalizedString("No internet connection", comment: "") :
        error.localizedDescription
    }

    func update() {
        resetPages()
        getCoinsList(loading: .fullScreen)
    }
    
    func refreshFavourites(){
        let favorites = self.getAllFavourite()
        items.value = items.value.map({ coinItem in
            var modifiedCoin = coinItem
            modifiedCoin.isFavourite = favorites.contains(where: { "\($0.id)" == coinItem.uuid })
            return modifiedCoin
        })
    }
}


extension DefaultCoinsListViewModel {
    func viewDidLoad() { }
    
    func didLoadNextPage() {
        guard hasMorePages, loading.value == .none else { return }
        getCoinsList(loading: .nextPage)
    }
    
    func didSelectFavouriteButton() {
        actions?.showFavourites()
    }
    
    func didSelectItem(at index: Int) {
        actions?.showCoinsDetails(pages.coins[index])
    }
    
    func addFavourite(_ uuid: String, completion: (Bool) -> Void) {
        guard let coinIndex = pages.coins.firstIndex(where: { "\($0.id)" == uuid} ) else { return }
        let coin = pages.coins[coinIndex]
        favouritesManager.addFavourite(record: coin, completion: completion)
    }
    
    func removeFavourite(_ uuid: String, completion: (Bool) -> Void) {
        let removeFavourite = favouritesManager.removeFavourite(id: uuid)
        completion(removeFavourite)
    }
    
    func getAllFavourite() -> [Coin] {
        guard let favourotes = favouritesManager.fetchFavourites() else { return []}
        self.favourites  = favourotes
        return favourotes
    }
}

private extension Array where Element == CoinsPage {
    var coins: [Coin] { flatMap { $0.coins } }
}
