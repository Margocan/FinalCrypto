import Foundation

protocol Networking {
    func fetchData<T: Decodable>(endpoint: APIEndpoint, completion: @escaping (Result<[T], Error>) -> Void)
}
