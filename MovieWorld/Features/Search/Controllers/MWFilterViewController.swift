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
    
    private var selectedYear: String = Date().toYear {
        didSet {
            self.yearView.value = self.selectedYear
        }
    }
    
    private var pickerData: [String] = []
    
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
    
    private lazy var yearView: MWLabelsWithArrowView = {
        var view = MWLabelsWithArrowView()
        view.title = "Year"
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(yearViewDidTapped)))
        return view
    }()
    
    private lazy var datePicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
    private lazy var datePickerToolBar: UIToolbar = UIToolbar()
    
    override func initController() {
        self.checkReset()
        self.setUpView()
        self.setUpToolbar()
        self.setUpPickerData()
    }
    
    override func updateViewConstraints() {
        self.countryView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
        
        self.yearView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.countryView.snp.bottom).offset(16)
        }
        super.updateViewConstraints()
    }
    
    private func setUpView() {
        self.title = "Filter"
        self.navigationItem.setRightBarButton(self.resetBarButton, animated: true)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureDone))
        self.contentView.addGestureRecognizer(tapGesture)
        
        self.contentView.addSubview(self.countryView)
        self.contentView.addSubview(self.yearView)
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
    
    private func setUpToolbar() {
        var items = [UIBarButtonItem]()
        items.append(
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        )
        items.append(
            UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tapGestureDone))
        )
        datePickerToolBar.setItems(items, animated: true)
        datePickerToolBar.tintColor = UIColor(named: "accentColor")
        datePickerToolBar.sizeToFit()
    }
    
    private func setUpPickerData() {
        let maxYear = Date().toIntYear
        let minYear = Date().toIntYear - 100
        for year in minYear...maxYear {
            self.pickerData.append(String(year))
        }
    }
    
    private func setUpYear() {
        for (id, year) in self.pickerData.enumerated() {
            if year == self.selectedYear {
                self.datePicker.selectRow(id, inComponent: 0, animated: true)
            }
        }
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
    
    @objc func tapGestureDone() {
        self.datePicker.removeFromSuperview()
        self.datePickerToolBar.removeFromSuperview()
        self.updateViewConstraints()
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
    
    @objc private func yearViewDidTapped() {
        self.contentView.addSubview(self.datePickerToolBar)
        self.contentView.addSubview(self.datePicker)
        
        self.datePickerToolBar.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.datePicker.snp.top)
        }
        
        self.datePicker.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
        }
        
        self.setUpYear()
    }
}

extension MWFilterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        self.pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        return self.selectedYear = self.pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerData[row]
    }
}
