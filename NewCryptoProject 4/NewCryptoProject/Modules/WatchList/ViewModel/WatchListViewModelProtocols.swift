import Foundation

protocol WatchListViewModelProtocols {
    var savedList: [Crypto] { get set }
    
    func fetchStorageData()
    var reloadCollectionView: (() -> Void)? { get set }
}
