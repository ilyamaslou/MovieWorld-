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

    var choosenFilters: ((_ genres: Set<String>?, _ countries: [String?]?, _ year: String?, _ ratingRange: (Float, Float)?) -> Void)?

    private var edgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    private let collectionViewHeight: Int = 70

    private var selectedCountries: [String?]? {
        didSet {
            self.setUpCountries()
            self.checkReset()
        }
    }

    private var selectedYear: String? {
        didSet {
            self.setUpYear()
            self.checkReset()
        }
    }

    private var pickerData: [String] = []

    private var selectedRatingRange: (from: Float, to: Float)? {
        didSet {
            self.setUpSlider()
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

    private lazy var collectionView: MWGenresCollectionViewController = MWGenresCollectionViewController()

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
        picker.backgroundColor = .white
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

    private lazy var showButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "accentColor")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Show", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(showButtonDidTapped), for: .touchUpInside)
        return button
    }()

    init(filters: (genres: Set<String>?, countries: [String?]?, year: String?, ratingRange: (Float, Float)?)?) {
        super.init()
        guard let filters = filters else { return }
        self.collectionView.filteredGenres = filters.genres ?? []
        self.selectedCountries = filters.countries
        self.selectedYear = filters.year
        self.selectedRatingRange = filters.ratingRange

        self.setUpDataOnViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func initController() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(checkReset),
                                               name: .genresChanged, object: nil)

        self.checkReset()
        self.setUpView()
        self.setUpToolbar()
        self.setUpPickerData()
    }

    override func updateViewConstraints() {
        self.collectionView.view.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(self.edgeInsets.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(self.collectionViewHeight)
        }

        self.countryView.snp.makeConstraints { (make) in
            make.top.equalTo(self.collectionView.view.snp.bottom).offset(self.edgeInsets.top)
            make.left.right.equalToSuperview()
        }

        self.yearView.snp.makeConstraints { (make) in
            make.top.equalTo(self.countryView.snp.bottom).offset(self.edgeInsets.top)
            make.left.right.equalToSuperview()
        }

        self.ratingView.snp.makeConstraints { (make) in
            make.top.equalTo(self.yearView.snp.bottom).offset(self.edgeInsets.top)
            make.left.right.equalToSuperview()
        }

        self.ratingSlider.snp.makeConstraints { (make) in
            make.top.equalTo(self.ratingView.snp.bottom)
            make.left.right.equalToSuperview().inset(self.edgeInsets)
        }

        self.showButton.snp.makeConstraints { (make) in
            make.top.greaterThanOrEqualTo( self.ratingSlider.snp.bottom)
            make.left.right.equalToSuperview().inset(self.edgeInsets)
            make.bottom.equalToSuperview().inset(32)
        }

        super.updateViewConstraints()
    }

    private func setUpView() {
        self.title = "Filter"
        self.navigationItem.setRightBarButton(self.resetBarButton, animated: true)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureDone))
        self.contentView.addGestureRecognizer(tapGesture)

        self.contentView.addSubview(self.collectionView.view)
        self.contentView.addSubview(self.countryView)
        self.contentView.addSubview(self.yearView)
        self.contentView.addSubview(self.ratingView)
        self.contentView.addSubview(self.ratingSlider)
        self.contentView.addSubview(self.showButton)
    }

    private func setUpDataOnViews() {
        self.setUpCountries()
        self.setUpYear()
        self.setUpSlider()
        self.collectionView.updateGenresByFiltered()

        self.checkReset()
    }

    private func setUpCountries() {
        var countries = ""
        guard let selectedCountries = self.selectedCountries else { return }
        for country in selectedCountries {
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
        var dateToPick: String = ""
        if self.selectedYear == nil {
            dateToPick = Date().toYear
        } else if let selectedYear = self.selectedYear {
            dateToPick = selectedYear
        }

        for (id, year) in self.pickerData.enumerated() {
            if year == dateToPick {
                self.datePicker.selectRow(id, inComponent: 0, animated: true)
            }
        }
        self.yearView.value = self.selectedYear ?? ""
    }

    private func setUpSlider() {
        self.ratingView.value = "from \(self.selectedRatingRange?.from ?? 1.0) to \(self.selectedRatingRange?.to ?? 10.0)"
        self.ratingSlider.value = [CGFloat(self.selectedRatingRange?.from ?? 1.0),
                                   CGFloat(self.selectedRatingRange?.to ?? 10.0)]
    }

    private func updateResetButton(hasNewValues: Bool) {
        self.resetBarButton.tintColor = hasNewValues ? UIColor(named: "accentColor") : UIColor(named: "shadowColor")
        self.resetBarButton.isEnabled = hasNewValues ? true : false
    }

    @objc private func checkReset() {
        if self.selectedCountries != nil
            || self.selectedYear != nil
            || self.selectedRatingRange != nil
            || !self.collectionView.filteredGenres.isEmpty {
            self.updateResetButton(hasNewValues: true)
        } else {
            self.updateResetButton(hasNewValues: false)
        }
    }

    @objc func tapGestureDone() {
        self.navigationController?.navigationBar.layer.zPosition = 0
        self.datePicker.removeFromSuperview()
        self.datePickerToolBar.removeFromSuperview()
        self.viewWithLowAlpha.removeFromSuperview()
        self.updateViewConstraints()
    }

    @objc private func resetButtonDidTapped() {
        self.selectedCountries = nil
        self.countryView.value = ""
        self.selectedYear = nil
        self.yearView.value = ""
        self.selectedRatingRange = nil
        self.ratingSlider.value = [1, 10]
        self.collectionView.filteredGenres = []
        self.collectionView.setUpGenres()
        self.checkReset()
    }

    @objc private func countryViewDidTapped() {
        let controller: FilterCountryViewController = FilterCountryViewController(selectedCountries: self.selectedCountries ?? [])
        MWI.s.pushVC(controller)

        controller.choosenCountries = { [weak self] (countries) in
            guard let self = self else { return }
            self.selectedCountries = countries
        }
    }

    @objc private func yearViewDidTapped() {
        self.navigationController?.navigationBar.layer.zPosition = -1
        self.selectedYear = self.selectedYear ?? Date().toYear

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

    @objc private func showButtonDidTapped() {
        guard let choosenFilters = self.choosenFilters else { return }
        let filteredGenres = self.collectionView.filteredGenres.isEmpty ? nil : self.collectionView.filteredGenres
        choosenFilters(filteredGenres,
                       self.selectedCountries,
                       self.selectedYear,
                       self.selectedRatingRange)
        MWI.s.popVC()
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
