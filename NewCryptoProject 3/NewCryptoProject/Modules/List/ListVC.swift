//
//  SceneDelegate.swift
//  CryptoTracker
//
//  Created by Margarita Can on 18.03.2024.
//

import UIKit
import CoreData

final class ListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: ListViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSearchBar()
        registerCell()
        setupBindings()
        PersistentManager.shared.fetchStorageData {
            self.viewModel?.fetchData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setupBindings() {
        viewModel?.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    func registerCell() {
        let cellName = String(describing: CryptoCell.self)
        let cellNib = UINib(nibName: cellName, bundle: .main)
        tableView.register(cellNib, forCellReuseIdentifier: cellName)
    }
}

private
extension ListVC {
    func setupUI() {
        self.title = "Markets"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "bookmark.fill"), style: .done, target: self, action: #selector(favButtonTapped))
        tableView.dataSource = self
    }
    
    @objc func favButtonTapped() {
        let watchListVC = WatchListVC()
        watchListVC.delegate = self
        self.navigationController?.pushViewController(watchListVC, animated: true)
    }
    
    func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        if let searchTextField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            searchTextField.backgroundColor = .white
            searchTextField.attributedPlaceholder = NSAttributedString(string: "Search Cryptos", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor.gray])
        }
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchResultsUpdater = self
        self.navigationItem.searchController = searchController
    }
}

extension ListVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.filteredList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: "CryptoCell".self), for: indexPath) as? CryptoCell else { return UITableViewCell() }
        cell.delegate = self
        cell.configureCell(viewModel?.filteredList[indexPath.row], indexPath.row)
        return cell
    }
}

extension ListVC: CryptoCellProtocol {
    func addToBookMark(_ model: Crypto?) {
        guard let data = model else { return }
        if data.isFavorite ?? false {
            ///Remove
            PersistentManager.shared.addToBookMark(data) { [weak self] in
                self?.tableView.reloadData()
            }
        }else {
            ///Save
            PersistentManager.shared.deleteBookmark(data) { [weak self] in
                
                self?.tableView.reloadData()
            }
        }
    }
}

extension ListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text?.lowercased() {
            viewModel?.filteredList = viewModel?.list.filter { product in
                return product.name!.lowercased().contains(searchText)
            } ?? []
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } else {
            viewModel?.filteredList = viewModel?.list ?? []
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        if searchController.searchBar.text == "" {
            viewModel?.filteredList = viewModel?.list ?? []
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension ListVC: WatchListDelegate {
    func resetDeletedIconStatus(_ model: Crypto?) {
        guard let model else { return }
        if let deletedData = viewModel?.list.first(where: {$0.asset_id == model.asset_id}) {
            deletedData.isFavorite = false
            self.tableView.reloadData()
        }
    }
}
