//
//  SceneDelegate.swift
//  CryptoTracker
//
//  Created by Margarita Can on 18.03.2024.
//

import UIKit
import CoreData


final class PersistentManager {
    
    static let shared = PersistentManager()
    
    private var savedList: [Crypto] = []
    
    func fetchStorageData(completion: @escaping (() -> Void)) {
        self.savedList.removeAll()
        DispatchQueue.main.async { [weak self] in
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
            fetchRequest.returnsObjectsAsFaults = false
            
            
            do {
                let result = try context.fetch(fetchRequest)
                self?.handleResult(result)
                completion()
            }catch {
                AlertManager.shared.showAlert(with: "Failure!", title: "Fetch request has failed.", buttonTitle: "OK") { }
            }
        }
    }
    
    func handleResult(_ results: [NSFetchRequestResult]) {
        for result in results as! [NSManagedObject] {
            if let name = result.value(forKey: "name") as? String,
               let id = result.value(forKey: "id") as? String,
               let price = result.value(forKey: "price") as? Float {
                savedList.append(.init(asset_id: id, name: name, price_usd: price, id_icon: nil, imageUrl: result.value(forKey: "url") as? String))
            }
        }
    }
    
    func addToBookMark(_ model: Crypto?, completion: @escaping (() -> Void)) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let model = model else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let saveData = NSEntityDescription.insertNewObject(forEntityName: "Favorites", into: context)
        
        saveData.setValue(model.name, forKey: "name")
        saveData.setValue(model.price_usd, forKey: "price")
        saveData.setValue(model.imageUrl, forKey: "url")
        saveData.setValue(model.asset_id, forKey: "id")
        saveData.setValue(model.isFavorite, forKey: "isFavorite")
        
        do {
            try context.save()
            completion()
            AlertManager.shared.showAlert(with: "\(model.name ?? "") has succesfully added to watchlist!", title: "Success!", buttonTitle: "OK") { }
        }catch {
            AlertManager.shared.showAlert(with: "\(model.name ?? "")has not been added to watchlist!", title: "Failure!", buttonTitle: "OK") { }
        }
    }
    
    func deleteBookmark(_ model: Crypto?, completion: @escaping (() -> Void)) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let model = model else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
        
        do {
            guard let fetchedResults = try managedContext.fetch(fetchRequest) as? [NSManagedObject] else { return }
            
            for data in fetchedResults {
                if let id = data.value(forKey: "id") as? String, let assetId = model.asset_id {
                    if id == assetId {
                        managedContext.delete(data)
                    }
                }
            }
            try managedContext.save()
            AlertManager.shared.showAlert(with: "\(model.name ?? "") has succesfully deleted from watchlist!", title: "Success!", buttonTitle: "OK") { }
            completion()
        } catch {
            AlertManager.shared.showAlert(with: "Failure!", title: "\(model.name ?? "")has not been deleted from watchlist!", buttonTitle: "OK") { }
            print(error.localizedDescription)
        }
    }
    
    func getList() -> [Crypto] {
        return savedList
    }
}
