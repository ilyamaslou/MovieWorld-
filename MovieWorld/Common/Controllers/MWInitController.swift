//
//  MWInitController.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 3/5/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MWInitController: MWViewController {
    
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
    
    private lazy var group = DispatchGroup()

    
    override func initController() {
        super.initController()
        
        contentView.addSubview(loadingIndicator)
        
        loadingIndicator.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        loadingIndicator.startAnimating()
        
        loadGenres()
        group.notify(queue: .main, execute: MWI.s.setUpTabBar)
    }
    
    private func loadGenres() {
        group.enter()
        MWNet.sh.request(urlPath: URLPaths.getGenres ,
                         querryParameters: MWNet.sh.parameters,
                         succesHandler: { [weak self] (genres: MWGenreResponse)  in
                            guard let self = self else { return }
                            MWSys.sh.genres = genres.genres
                            self.group.leave()
                            
            },
                         errorHandler: { [weak self] (error) in
                            guard let self = self else { return }
                            let message = MWNetError.getError(error: error)
                            print(message)
                            self.group.leave()
        })
    }
    
}
