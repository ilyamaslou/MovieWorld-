//
//  MWNetError.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 3/1/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

enum MWNetError {

    //MARK:- enum cases

    case incorrectUrl(url: String)
    case networkError(error: Error)
    case serverError(statusCode: Int)
    case parsingError(error: Error)
    case jsonDecodingFailed(text: String)
    case error401(error: MWSpecialError)
    case error404(error: MWSpecialError)
    case unknown

    //MARK:- action with cases 

    func getErrorDesription() -> String {
        switch self {
        case .incorrectUrl(let url):
            return "Incorrect url: \(url)".local(args: url)
        case .networkError(let error):
            return error.localizedDescription
        case .serverError(let statusCode):
            return "Error with: \(statusCode) statusCode".local(args: statusCode)
        case .parsingError(let error):
            return error.localizedDescription
        case .jsonDecodingFailed(let text):
            return text
        case .unknown:
            return "Unknown error".local()
        case .error401(let error):
            return error.statusMessage ?? "error 401".local()
        case .error404(let error):
            return error.statusMessage ?? "error 404".local()
        }
    }
}
