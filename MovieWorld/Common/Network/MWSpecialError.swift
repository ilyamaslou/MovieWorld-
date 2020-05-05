//
//  MWSpecialError.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 3/2/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

struct MWSpecialError: Decodable {

    //MARK:- enum

    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code", statusMessage = "status_message"
    }

    //MARK:- Parameters

    var statusCode: Int?
    var statusMessage: String?

    //MARK: - initialization

    init() {}
}
