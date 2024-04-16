import Foundation
import CoreData

protocol PersistentManagerProtocols {
    var savedList: [Crypto] { get set }
    
    func fetchStorageData(completion: @escaping (() -> Void))
    func handleResult(_ results: [NSFetchRequestResult])
    func addToBookMark(_ model: Crypto?, completion: @escaping (() -> Void))
    func deleteBookmark(_ model: Crypto?, completion: @escaping (() -> Void))
    func getList() -> [Crypto]
}
