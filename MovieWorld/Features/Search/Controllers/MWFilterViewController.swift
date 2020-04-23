//
//  MWFilterViewController.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 4/23/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MWFilterViewController: MWViewController {
    
    private var selectedCountries: [String?] = [] {
        didSet {
            self.setUpCountries()
            self.checkReset()
        }
    }
    
    private lazy var resetBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Reset",
                                     style: .plain,
                                     target: self,
                                     action: #selector(resetButtonDidTapped))
        button.tintColor = UIColor(named: "shadowColor")
        return button
    }()
    
    private lazy var countryView: MWLabelsWithArrowView = {
        var view = MWLabelsWithArrowView()
        view.title = "Country"
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(countryViewDidTapped)))
        return view
    }()
    
    override func initController() {
        self.checkReset()
        self.setUpView()
    }
    
    override func updateViewConstraints() {
        self.countryView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
        super.updateViewConstraints()
    }
    
    private func setUpView() {
        self.title = "Filter"
        self.navigationItem.setRightBarButton(self.resetBarButton, animated: true)
        
        self.contentView.addSubview(self.countryView)
    }
    
    private func setUpCountries() {
        var countries = ""
        
        for country in self.selectedCountries {
            guard let country = country else { continue }
            countries += "\(country), "
        }
        
        if !countries.isEmpty {
            countries.removeLast(2)
        }
        
        self.countryView.value = countries
    }
    
    private func checkReset() {
        if !self.selectedCountries.isEmpty {
            self.updateResetButton(hasNewValues: true)
        } else {
            self.updateResetButton(hasNewValues: false)
        }
    }
    
    private func updateResetButton(hasNewValues: Bool) {
        self.resetBarButton.tintColor = hasNewValues ? UIColor(named: "accentColor") : UIColor(named: "shadowColor")
        self.resetBarButton.isEnabled = hasNewValues ? true : false
    }
    
    @objc private func resetButtonDidTapped() {
        self.selectedCountries = []
    }
    
    @objc private func countryViewDidTapped() {
        let controller: FilterCountryViewController = FilterCountryViewController(selectedCountries: self.selectedCountries)
        MWI.s.pushVC(controller)
        
        controller.choosenCountries = { [weak self] (countries) in
            guard let self = self else { return }
            self.selectedCountries = countries
        }
    }
    
    
}
