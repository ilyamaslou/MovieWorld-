//
//  FilterCountryViewController.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 4/23/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class FilterCountryViewController: MWViewController {

    //MARK: - variable

    var choosenCountries: (([String?]?) -> Void)?

    //MARK: - private variables

    private var recievedSelectedCountries: [String?]?
    private var selectedCountryKey: Int = 0
    private var languagesConfiguration: [MWLanguageConfiguration] = []

    private var countries: [(country: String?, isSelected: Bool)] = [] {
        didSet {
            self.filteredCountries = self.countries
        }
    }

    private var filteredCountries: [(country: String?, isSelected: Bool)] = []

    //MARK:- gui variables

    private lazy var searchController = UISearchController(searchResultsController: nil)

    private lazy var resetBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Reset",
                                     style: .plain,
                                     target: self,
                                     action: #selector(self.resetButtonDidTapped))
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
                           forCellReuseIdentifier: MWCountryFilterTableViewCell.reuseIdentifier)
        return tableView
    }()

    //MARK: - initialization

    init(selectedCountries: [String?]?) {
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
        self.makeConstraints()
    }

    //MARK: - constraints

    private func makeConstraints() {
        self.contentView.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    //MARK: - set navigation bar

    private func presetNavBar() {
        self.title = "Country"
        self.navigationItem.setRightBarButton(self.resetBarButton, animated: true)
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.navigationItem.searchController = searchController
        self.searchController.searchBar.delegate = self
    }

    //MARK: - setters

    private func setSelectedCountries() {
        guard let recievedSelectedCountries = self.recievedSelectedCountries else { return }
        for (id, country) in self.countries.enumerated() {
            for selectedCountry in recievedSelectedCountries {
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

    //MARK: - send selected action

    private func didSendChoosedCountries() {
        guard let choosenCountries = self.choosenCountries else { return }
        var selectedCountries: [String?]? = []
        selectedCountries?.append(contentsOf: self.countries.filter{ $0.isSelected == true }.map{ $0.country })
        selectedCountries = (selectedCountries?.isEmpty ?? false) ? nil : selectedCountries
        choosenCountries(selectedCountries)
    }

    //MARK: - resetButton actions

    @objc private func resetButtonDidTapped() {
        self.recievedSelectedCountries = nil
        self.setUpLanguages()
        self.didSendChoosedCountries()
        self.checkReset()
        self.tableView.reloadData()
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

    //MARK: - update content action

    private func updateCountry(filteredCountry: (country: String?, isSelected: Bool)) {
        for (id, country) in self.countries.enumerated() {
            if country.country == filteredCountry.country {
                self.countries[id].isSelected = filteredCountry.isSelected
            }
        }
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension FilterCountryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.filteredCountries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MWCountryFilterTableViewCell.reuseIdentifier) as? MWCountryFilterTableViewCell
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

//MARK: - UISearchResultsUpdating, UISearchBarDelegate

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
