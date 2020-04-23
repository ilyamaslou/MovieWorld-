//
//  MWFilterViewController.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 4/23/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MWFilterViewController: MWViewController {
    
    private var selectedCountries: [String?] = []
    
    private lazy var resetBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Reset",
                                     style: .plain,
                                     target: self,
                                     action: #selector(resetButtonDidTapped))
        button.tintColor = UIColor(named: "shadowColor")
        return button
    }()
    
    private lazy var countryButton: UIButton = {
        var button = UIButton()
        button.setTitle("Countries", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(countryButtonDidTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func initController() {
        self.title = "Filter"
        self.navigationItem.setRightBarButton(self.resetBarButton, animated: true)
        
        self.contentView.addSubview(self.countryButton)
        self.countryButton.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
    }
    
    @objc private func resetButtonDidTapped() {
        
    }
    
    @objc private func countryButtonDidTapped() {
        let controller: FilterCountryViewController = FilterCountryViewController(selectedCountries: self.selectedCountries)
        MWI.s.pushVC(controller)
        
        controller.choosenCountries = { [weak self] (countries) in
            self?.selectedCountries = countries
        }
    }
    
    
}
