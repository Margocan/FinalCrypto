import Foundation

final class ListDataProvider: ListDataProviderProtocol {
    
    private let serviceManager: Networking
    
    init(serviceManager: Networking) {
        self.serviceManager = serviceManager
    }
    
    func getAllCryptoData(endPoint: APIEndpoint, completion: @escaping (Result<[Crypto], Error>) -> Void) {
        serviceManager.fetchData(endpoint: endPoint, completion: completion)
    }
    
    func getAllIcons(endPoint: APIEndpoint, completion: @escaping (Result<[IconModel], Error>) -> Void) {
        serviceManager.fetchData(endpoint: endPoint, completion: completion)
    }
    
}
