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
    
    // MARK: FIXME Divide into parts
    func request<T: Decodable>(urlPath: String,
                               querryParameters: [String : String],
                               succesHandler: @escaping ((T) -> Void),
                               errorHandler: @escaping ((MWNetError) -> Void)) {
        
        let fullPath = baseUrl + urlPath
        
        let url = getUrlWithParams(fullPath: fullPath, params: querryParameters)
        
        guard let requestUrl = URL(string: url)
            else { return }
        
        let request = URLRequest(url: requestUrl)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                DispatchQueue.main.async {
                    errorHandler(.networkError(error: error))
                }
                return
            }
            
            guard let response = response as? HTTPURLResponse
                else {
                    DispatchQueue.main.async {
                        errorHandler(.unknown)
                    }
                    return
            }
            
            if let data = data {
                do {
                    switch response.statusCode {
                    case 200...300:
                        let values = try JSONDecoder().decode(T.self, from: data)
                        DispatchQueue.main.async {
                            succesHandler(values)
                        }
                    case 401:
                        let value = try JSONDecoder().decode(MWSpecialError.self, from: data)
                        DispatchQueue.main.async {
                            errorHandler(.error401(error: value))
                        }
                    case 404 :
                        let value = try JSONDecoder().decode(MWSpecialError.self, from: data)
                        DispatchQueue.main.async {
                            errorHandler(.error404(error: value))
                        }
                    default:
                        break
                    }
                } catch {
                    DispatchQueue.main.async {
                        errorHandler(.jsonDecodingFailed(text: "JSON Decoding Failed"))
                    }
                }
            }
        }
        task.resume()
    }
    
    
}

struct URLPaths {
    static let popularMovies: String = "movie/popular"
    static let topRatedMovies: String = "movie/top_rated"
    static let nowPlayingMovies: String = "movie/now_playing"
    static let upcomingMovies: String = "movie/upcoming"
    static let getGenres: String = "genre/movie/list"
}
