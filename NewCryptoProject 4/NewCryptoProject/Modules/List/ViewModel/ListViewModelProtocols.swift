import UIKit

protocol ListViewModelProtocols {
    var list: [Crypto] { get set }
    var filteredList: [Crypto] { get set }
    var icons: [IconModel] { get set }
    var reloadTableView: (() -> Void)? { get set }
    
    func fetchData()
    func fetchIcons()
    func mixIconsWithCryptos()
    func fetchStorageData()
    func addToBookMark(_ model: Crypto?)
    func resetDeletedIconStatus(_ model: Crypto?)
    func updateSearchResults(for searchController: UISearchController)
}
