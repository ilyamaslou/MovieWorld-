//
//  MWNetwork.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 3/1/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

typealias MWNet = MWNetwork

class MWNetwork {
    
    public static let sh = MWNetwork()
    
    private let baseUrl: String = "https://api.themoviedb.org/3/"
    private let apiKey: String = "79d5894567be5b76ab7434fc12879584"
    
    private lazy var session = URLSession.shared
    lazy var parameters: [String: String] = ["api_key" : apiKey]
    
    private init() {}
    
    func request<T: Decodable>(urlPath: String,
                               querryParameters: [String : String],
                               succesHandler: @escaping ((T) -> Void),
                               errorHandler: @escaping (() -> Void)) {
        
        let fullPath = baseUrl + urlPath
        
        let url = getUrlWithParams(fullPath: fullPath, params: querryParameters)
        guard let requestUrl = URL(string: url) else { fatalError() }
        
        let request = URLRequest(url: requestUrl)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            guard let response = response as? HTTPURLResponse else { fatalError() }
            
            switch response.statusCode {
            case 200...300:
                print("all fine")
                if let data = data {
                    do {
                        let values = try JSONDecoder().decode(T.self, from: data)
                        succesHandler(values)
                    } catch {
                        print("FATAL ERROR")
                    }
                }
            case 401:
                print("401 error")
            case 404 :
                print("404 error")
            default:
                break
            }
        }
        
        
        
        task.resume()
    }
    
}

struct URLPaths {
    static let popularMovies: String = "movie/popular"
    static let topMovies: String = "movie/top_rated"
}
