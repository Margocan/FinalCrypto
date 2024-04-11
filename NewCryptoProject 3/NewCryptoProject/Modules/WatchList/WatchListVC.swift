//
//  SceneDelegate.swift
//  CryptoTracker
//
//  Created by Margarita Can on 18.03.2024.
//

import UIKit
import CoreData

protocol WatchListDelegate: AnyObject {
    func resetDeletedIconStatus(_ model: Crypto?)
}

final class WatchListVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    weak var delegate: WatchListDelegate?
    
    var savedList: [Crypto] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetch()
    }
}

private
extension WatchListVC {
    func setupUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        let cellIdentifier = String(describing: FavCell.self)
        let nib = UINib(nibName: cellIdentifier, bundle: .main)
        collectionView.register(nib, forCellWithReuseIdentifier: cellIdentifier)
        
        self.title = "Watchlist"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func fetch() {
        PersistentManager.shared.fetchStorageData { [weak self] in
            self?.savedList = PersistentManager.shared.getList()
            self?.collectionView.reloadData()
        }
    }
}

extension WatchListVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: FavCell.self), for: indexPath) as? FavCell else { return UICollectionViewCell() }
        cell.delegate = self
        cell.configureCell(savedList[indexPath.row], indexPath.row)
        return cell
    }
}

extension WatchListVC: FavCellProtocol {
    func deleteBookmark(_ index: Int?) {
        guard let index else { return }
        PersistentManager.shared.deleteBookmark(savedList[index]) { [weak self] in
            self?.delegate?.resetDeletedIconStatus(self?.savedList[index])
            self?.fetch()
        }
    }
}
