import UIKit

final class ListViewModel: ListViewModelProtocols {
    var list: [Crypto] = [] {
        didSet {
            ///Just for deleting useless data
            list = list.filter({$0.assetId != nil && $0.priceUsd != nil})
        }
    }
    var filteredList: [Crypto] = [] {
        didSet {
            ///Just for deleting useless data
            filteredList = filteredList.filter({$0.assetId != nil && $0.priceUsd != nil})
        }
    }
    var icons: [IconModel] = []
    
    var reloadTableView: (() -> Void)?
    
    private let dataProvider: ListDataProviderProtocol
    
    init(dataProvider: ListDataProviderProtocol) {
        self.dataProvider = dataProvider
    }
    
    func fetchData() {
        dataProvider.getAllCryptoData(endPoint: .cryptos) { [weak self] result in
            switch result {
            case .success(let result):
                self?.list = result
                self?.filteredList = result
                self?.fetchIcons()
                self?.fetchStorageData()
                self?.reloadTableView?()
            case.failure (let error):
                print("Error: \(error)")
            }
        }
    }
    
    func fetchIcons() {
        dataProvider.getAllIcons(endPoint: .icons) { [weak self] result in
            switch result {
            case .success(let icons):
                self?.icons = icons
                self?.mixIconsWithCryptos()
            case .failure(_):
                break
            }
        }
    }
    
    func mixIconsWithCryptos() {
        self.filteredList.forEach { crypto in
            icons.forEach { icon in
                if crypto.assetId == icon.assetId {
                    crypto.imageUrl = icon.url
                }
            }
        }
        self.reloadTableView?()
    }
    
    func fetchStorageData() {
        PersistentManager.shared.getList().forEach { storageData in
            self.filteredList.forEach { currentData in
                if currentData.assetId == storageData.assetId {
                    currentData.isFavorite = true
                }else {
                    currentData.isFavorite = false
                }
            }
        }
        self.reloadTableView?()
    }
    
    func addToBookMark(_ model: Crypto?) {
        guard let data = model else { return }
        if data.isFavorite ?? false {
            PersistentManager.shared.addToBookMark(data) { [weak self] in
                self?.reloadTableView?()
            }
        }else {
            PersistentManager.shared.deleteBookmark(data) { [weak self] in
                self?.reloadTableView?()
            }
        }
    }
    
    func resetDeletedIconStatus(_ model: Crypto?) {
        guard let model else { return }
        if let deletedData = list.first(where: {$0.assetId == model.assetId}) {
            deletedData.isFavorite = false
            self.reloadTableView?()
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text?.lowercased() ?? ""
        
        if searchText.isEmpty {
            filteredList = list
        } else {
            filteredList = list.filter { $0.name?.lowercased().contains(searchText) ?? false }
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.reloadTableView?()
        }
    }
    
}
