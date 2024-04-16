import Foundation

final class WatchListViewModel: WatchListViewModelProtocols {
    var reloadCollectionView: (() -> Void)?
    var savedList: [Crypto] = []
    
    func fetchStorageData() {
        PersistentManager.shared.fetchStorageData { [weak self] in
            self?.savedList = PersistentManager.shared.getList()
            self?.reloadCollectionView?()
        }
    }
}
