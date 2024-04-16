import Foundation

protocol ListDataProviderProtocol {
    func getAllCryptoData(endPoint: APIEndpoint, completion: @escaping (Result<[Crypto], Error>) -> Void)
    func getAllIcons(endPoint: APIEndpoint, completion: @escaping (Result<[IconModel], Error>) -> Void)
}
