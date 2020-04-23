//
//  FilterCountryViewController.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 4/23/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class FilterCountryViewController: MWViewController {
    
    var choosenCountries: (([String?]) -> ())?
    
    private var recievedSelectedCountries: [String?] = []
    private var selectedCountryKey: Int = 0
    private var languagesConfiguration: [MWLanguageConfiguration] = []
    
    private var countries: [(country: String?, isSelected: Bool)] = [] {
        didSet {
            self.filteredCountries = self.countries
        }
    }
    
    private var filteredCountries: [(country: String?, isSelected: Bool)] = []
    
    private lazy var searchController = UISearchController(searchResultsController: nil)
    
    private lazy var resetBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Reset",
                                     style: .plain,
                                     target: self,
                                     action: #selector(resetButtonDidTapped))
        button.tintColor = UIColor(named: "shadowColor")
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.register(MWCountryFilterTableViewCell.self,
                           forCellReuseIdentifier: Constants.singleCrewMemberTableViewCellId)
        return tableView
    }()
    
    init(selectedCountries: [String?] = [] ) {
        super.init()
        self.recievedSelectedCountries = selectedCountries
        self.setSelectedCountries()
        self.checkReset()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initController() {
        super.initController()
        self.presetNavBar()
        self.setUpLanguages()
        self.setUpView()
    }
    
    private func presetNavBar() {
        self.title = "Country"
        self.navigationItem.setRightBarButton(self.resetBarButton, animated: true)
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.navigationItem.searchController = searchController
        self.searchController.searchBar.delegate = self
    }
    
    private func setUpView() {
        self.contentView.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func setSelectedCountries() {
        for (id,country) in self.countries.enumerated() {
            for selectedCountry in self.recievedSelectedCountries {
                if country.country == selectedCountry {
                    self.countries[id].isSelected = true
                }
            }
        }
    }
    
    private func setUpLanguages() {
        self.countries = []
        self.languagesConfiguration = MWSys.sh.languages
        self.languagesConfiguration.removeFirst()
        for country in self.languagesConfiguration {
            self.countries.append((country: country.englishName, isSelected: false))
        }
        self.countries.sort { ($0.country ?? "") < ($1.country ?? "") }
    }
    
    private func updateCountry(filteredCountry: (country: String? ,isSelected: Bool)) {
        for (id,country) in self.countries.enumerated() {
            if country.country == filteredCountry.country {
                self.countries[id].isSelected = filteredCountry.isSelected
            }
        }
    }
    
    private func didSendChoosedCountries() {
        var selectedCountries: [String?] = []
        for country in self.countries {
            if country.isSelected == true {
                selectedCountries.append(country.country)
            }
        }
        guard let choosenCountries = choosenCountries else { return }
        choosenCountries(selectedCountries)
    }
    
    private func checkReset() {
        var selected: [String?] = []
        for country in self.countries {
            if country.isSelected == true {
                selected.append(country.country)
            }
        }
        
        if !selected.isEmpty {
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
        self.recievedSelectedCountries = []
        self.setUpLanguages()
        self.didSendChoosedCountries()
        self.checkReset()
        self.tableView.reloadData()
    }
}

extension FilterCountryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.filteredCountries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.singleCrewMemberTableViewCellId) as? MWCountryFilterTableViewCell
            else { fatalError("The registered type for the cell does not match the casting") }
        
        cell.set(country: self.filteredCountries[indexPath.row])
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let text = searchController.searchBar.text else { return }
        if !text.isEmpty {
            self.filteredCountries[indexPath.row].isSelected = !self.filteredCountries[indexPath.row].isSelected
            self.updateCountry(filteredCountry: self.filteredCountries[indexPath.row])
            self.tableView.reloadData()
            self.updateSearchResults(for: self.searchController)
        } else {
            self.countries[indexPath.row].isSelected = !self.countries[indexPath.row].isSelected
            self.tableView.reloadData()
        }
        
        self.checkReset()
        self.didSendChoosedCountries()
    }
}

extension FilterCountryViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        if text.isEmpty {
            self.filteredCountries = self.countries
        } else {
            self.filteredCountries = self.countries.filter { ($0.country?.contains(text) ?? false) }
        }
        
        self.tableView.reloadData()
    }
}
