//
//  SceneDelegate.swift
//  CryptoTracker
//
//  Created by Margarita Can on 18.03.2024.
//
import Foundation

final class APICaller {
    
    static let shared = APICaller ()
    
    private struct Constants {
        static let apiKey = "apikey=79018909-A313-4CE4-9C38-39DDFF99A463"
        static let assetsEndpoint = "https://rest.coinapi.io/v1/assets?"
        
    }
    private init () {}
    
    public func getAllCryptoData(completion: @escaping (Result<[Crypto], Error>) -> Void) {
        
        guard let url = URL(string: "https://rest.coinapi.io/v1/assets?apikey=79018909-A313-4CE4-9C38-39DDFF99A463") else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let cryptos = try JSONDecoder().decode([Crypto].self, from: data)
                
                completion(.success(cryptos))
            }
            catch {
                completion(.failure(error))
                
            }
        }
        task.resume()
    }

    public func getAllIcons(completion: @escaping (Result<[IconModel], Error>) -> Void) {
        
        guard let url = URL(string: "https://rest.coinapi.io/v1/assets/icons/32?apikey=79018909-A313-4CE4-9C38-39DDFF99A463") else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let cryptos = try JSONDecoder().decode([IconModel].self, from: data)
                
                completion(.success(cryptos))
            }
            catch {
                completion(.failure(error))
                
            }
        }
        task.resume()
    }
}
