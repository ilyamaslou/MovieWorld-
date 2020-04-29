//
//  MWSystem.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 3/6/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

typealias MWSys = MWSystem

class MWSystem {

    static let sh = MWSystem()

    var genres: [MWGenre] = []
    var configuration: MWConfiguration?

    private init() {}
}
