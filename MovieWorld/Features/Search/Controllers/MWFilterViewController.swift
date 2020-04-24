//
//  MWFilterViewController.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 4/23/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit
import MultiSlider

class MWFilterViewController: MWViewController {
    
    private var offsets: UIEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    
    private var selectedCountries: [String?] = [] {
        didSet {
            self.setUpCountries()
            self.checkReset()
        }
    }
    
    private var selectedYear: String = "" {
        didSet {
            self.yearView.value = self.selectedYear
            self.checkReset()
        }
    }
    
    private var pickerData: [String] = []
    
    private var selectedRatingRange: (from: Float, to: Float)? {
        didSet {
            self.ratingView.value = "from \(self.selectedRatingRange?.from ?? 1.0) to \(self.selectedRatingRange?.to ?? 10.0)"
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
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.backgroundColor = .clear
        return picker
    }()
    
    private lazy var datePickerToolBar: UIToolbar = UIToolbar()
    
    private lazy var viewWithLowAlpha: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var ratingView: MWLabelsWithArrowView = {
        let view: MWLabelsWithArrowView = MWLabelsWithArrowView()
        view.hasArrow = false
        view.title = "Rating"
        view.value = "from \(self.selectedRatingRange?.from ?? 1.0) to \(self.selectedRatingRange?.to ?? 10.0)"
        return view
    }()
    
    private lazy var ratingSlider: MultiSlider = {
        let slider = MultiSlider()
        slider.minimumValue = 1
        slider.maximumValue = 10
        slider.value = [1, 10]
        slider.hasRoundTrackEnds = true
        slider.outerTrackColor = .lightGray
        slider.tintColor = UIColor(named: "accentColor")
        slider.orientation = .horizontal
        slider.snapStepSize = 0.1
        slider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
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
            make.top.equalTo(self.countryView.snp.bottom).offset(self.offsets.top)
        }
        
        self.ratingView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(self.yearView.snp.bottom).offset(self.offsets.top)
        }
        
        self.ratingSlider.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(self.offsets.left)
            make.right.equalToSuperview().inset(self.offsets.right)
            make.top.equalTo(self.ratingView.snp.bottom)
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
        self.contentView.addSubview(self.ratingView)
        self.contentView.addSubview(self.ratingSlider)
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
        
        self.datePickerToolBar.translatesAutoresizingMaskIntoConstraints = false
        self.datePickerToolBar.setItems(items, animated: true)
        self.datePickerToolBar.tintColor = UIColor(named: "accentColor")
        self.datePickerToolBar.sizeToFit()
    }
    
    private func setUpPickerData() {
        let maxYear = Date().toIntYear
        let minYear = Date().toIntYear - 100
        for year in minYear...maxYear {
            self.pickerData.append(String(year))
        }
    }
    
    private func setUpYear() {
        if self.selectedYear.isEmpty {
            self.selectedYear = Date().toYear
        }
        
        for (id, year) in self.pickerData.enumerated() {
            if year == self.selectedYear {
                self.datePicker.selectRow(id, inComponent: 0, animated: true)
            }
        }
    }
    
    private func checkReset() {
        if !self.selectedCountries.isEmpty
            || !self.selectedYear.isEmpty
            || (self.selectedRatingRange != nil) {
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
        self.navigationController?.navigationBar.layer.zPosition = 0
        self.datePicker.removeFromSuperview()
        self.datePickerToolBar.removeFromSuperview()
        self.viewWithLowAlpha.removeFromSuperview()
        self.updateViewConstraints()
    }
    
    @objc private func resetButtonDidTapped() {
        self.selectedCountries = []
        self.selectedYear = ""
        self.ratingSlider.value = [1, 10]
        self.selectedRatingRange = nil
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
        self.navigationController?.navigationBar.layer.zPosition = -1
        
        self.contentView.addSubview(self.viewWithLowAlpha)
        self.contentView.addSubview(self.datePickerToolBar)
        self.contentView.addSubview(self.datePicker)
        
        self.viewWithLowAlpha.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.datePickerToolBar.snp.top)
        }
        self.datePickerToolBar.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.datePicker.snp.top)
        }
        
        self.datePicker.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
        }
        
        self.setUpYear()
    }
    
    @objc private func sliderChanged() {
        let minSliderValue = Float(self.ratingSlider.value.first ?? 1.0)
        let maxSliderValue = Float(self.ratingSlider.value.last ?? 10.0)
        self.selectedRatingRange = (from: minSliderValue, to: maxSliderValue)
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
