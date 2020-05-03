//
//  MWNetwork.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 3/1/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import Foundation
typealias MWNet = MWNetwork

class MWNetwork {

    static let sh = MWNetwork()

    private let baseUrl: String = "https://api.themoviedb.org/3/"
    private let apiKey: String = "79d5894567be5b76ab7434fc12879584"

    private var session = URLSession(configuration: .ephemeral)
    private(set) lazy var parameters: [String: String] = ["api_key": self.apiKey]

    private init() {}

    func imageRequest(baseUrl: String,
                      size: String,
                      filePath: String,
                      succesHandler: @escaping ((Data) -> Void)) {
        let url = baseUrl + size + filePath

        guard let requestUrl = URL(string: url) else { return }

        let request = URLRequest(url: requestUrl)

        let task = self.session.dataTask(with: request) { (data, statusCode, error) in

            if let data = data, error == nil {
                    DispatchQueue.main.async {
                        succesHandler(data)
                }
            }
        }
        task.resume()
    }

    func request<T: Decodable>(urlPath: String,
                               querryParameters: [String: String],
                               succesHandler: @escaping ((T) -> Void),
                               errorHandler: @escaping ((MWNetError) -> Void)) {
        let fullPath = self.baseUrl + urlPath

        let url = getUrlWithParams(fullPath: fullPath, params: querryParameters)

        guard let requestUrl = URL(string: url) else { return }

        let request = URLRequest(url: requestUrl)

        let task = self.session.dataTask(with: request) { (data, response, error) in

            if let error = error {
                DispatchQueue.main.async {
                    errorHandler(.networkError(error: error))
                }
                return
            }

            guard let response = response as? HTTPURLResponse, let data = data
                else {
                    DispatchQueue.main.async {
                        errorHandler(.unknown)
                    }
                    return
            }

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
        task.resume()
    }
}
