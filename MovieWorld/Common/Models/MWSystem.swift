//
//  MWSystem.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 3/6/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

typealias MWSys = MWSystem

class MWSystem {

    //MARK: - static variables

    static let sh = MWSystem()

    //MARK:- Parameters

    var genres: [MWGenre] = []
    var configuration: MWConfiguration?
    var languages: [MWLanguageConfiguration] = []

    //MARK: - initialization

    private init() {}
}
