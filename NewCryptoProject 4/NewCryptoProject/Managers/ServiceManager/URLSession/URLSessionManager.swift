import Foundation

final class URLSessionManager: Networking {
    
    func fetchData<T>(endpoint: APIEndpoint, completion: @escaping (Result<[T], Error>) -> Void) where T : Decodable {
        
        guard let url = URL(string: Constant.baseURL + endpoint.rawValue + Constant.apiKey) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 0)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode([T].self, from: data)
                completion(.success(decodedData))
            }catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
