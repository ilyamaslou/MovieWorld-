//
//  MWNetError.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 3/1/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit


enum MWNetError {
    case incorrectUrl(url: String)
    case networkError(error: Error)
    case serverError(statusCode: Int)
    case parsingError(error: Error)
    case jsonDecodingFailed(text: String)
    
    case unknown
    
    static func getError(error: MWNetError) -> String {
        switch error {
        case .incorrectUrl(let url):
         return "Incorrect url: \(url)"
        case .networkError(let error):
            return error.localizedDescription
        case .serverError(let statusCode):
            return "Error with: \(statusCode) statusCode"
        case .parsingError(let error):
           return error.localizedDescription
        case .jsonDecodingFailed(let text):
            return text
        case .unknown:
            return "Unknown error"
        }
    }
    //MARK: Realise 401 and 404 error
}
