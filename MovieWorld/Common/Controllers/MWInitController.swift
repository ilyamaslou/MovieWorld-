//
//  MWInitController.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 3/5/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MWInitController: MWViewController {

    //MARK: - private variable

    private var group = DispatchGroup()

    //MARK:- gui variable

    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = UIColor(named: "accentColor")

        if #available(iOS 13.0, *) {
            indicator.style = .large
        } else {
            indicator.style = .whiteLarge
        }

        return indicator
    }()

    //MARK: - initialization

    override func initController() {
        super.initController()
        self.contentView.addSubview(self.loadingIndicator)
        self.makeConstraints()
        self.loadingIndicator.startAnimating()

        self.loadGenres()
        self.loadLanguages()
        self.loadConfiguration()
        self.group.notify(queue: .main, execute: MWI.s.setUpTabBar)
    }

    // MARK: - constraints

    private func makeConstraints() {
        self.loadingIndicator.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }

    //MARK:- request functions

    private func loadGenres() {
        self.group.enter()
        MWNet.sh.request(urlPath: URLPaths.getGenres,
                         querryParameters: MWNet.sh.parameters,
                         succesHandler: { [weak self] (genres: MWGenreResponse)  in
                            MWCDHelp.sh.saveGenres(genres: genres.genres)
                            MWSys.sh.genres = genres.genres
                            self?.group.leave()
            },
                         errorHandler: { [weak self] (error) in
                            let message = error.getErrorDesription()
                            print(message)
                            MWSys.sh.genres = MWCDHelp.sh.fetchGenres().mwGenres
                            self?.group.leave()
        })
    }

    private func loadConfiguration() {
        self.group.enter()
        MWNet.sh.request(urlPath: URLPaths.getConfiguration,
                         querryParameters: MWNet.sh.parameters,
                         succesHandler: { [weak self] (configuration: MWConfiguration)  in
                            MWCDHelp.sh.saveImageConfiguration(imageConfiguration: configuration.images ?? MWImageConfiguration())
                            MWSys.sh.configuration = configuration
                            self?.group.leave()
            },
                         errorHandler: { [weak self] (error) in
                            let message = error.getErrorDesription()
                            print(message)
                            MWSys.sh.configuration = MWConfiguration(images: MWCDHelp.sh.fetchImageConfiguration().mwConfiguration)
                            self?.group.leave()
        })
    }

    private func loadLanguages() {
        self.group.enter()
        MWNet.sh.request(urlPath: URLPaths.getLanguages,
                         querryParameters: MWNet.sh.parameters,
                         succesHandler: { [weak self] (languages: [MWLanguageConfiguration])  in
                            MWSys.sh.languages = languages
                            self?.group.leave()
            },
                         errorHandler: { [weak self] (error) in
                            let message = error.getErrorDesription()
                            print(message)
                            self?.group.leave()
        })
    }
}
