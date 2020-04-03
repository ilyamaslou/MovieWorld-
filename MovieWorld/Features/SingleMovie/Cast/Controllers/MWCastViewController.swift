//
//  MWCastViewController.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 4/3/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MWCastViewController: MWViewController {
    
    private var movieFullCast: MWMovieCastResponse?
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    private lazy var contentViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .green
        return view
    }()
    
    private lazy var castTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.register(MWCastMemberTableViewCell.self, forCellReuseIdentifier: Constants.singleCastMemberTableViewCellId)
        return tableView
    }()
    
    private lazy var crewTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.register(MWCrewMemberTableViewCell.self, forCellReuseIdentifier: Constants.singleCrewMemberTableViewCellId)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .always
    }
    
    override func initController() {
        super.initController()
        self.title = "Cast"
        
        self.contentView.addSubview(self.scrollView)
        self.scrollView.addSubview(self.contentViewContainer)
        self.contentViewContainer.addSubview(self.castTableView)
        self.contentViewContainer.addSubview(self.crewTableView)
        
        
    }
    
    override func updateViewConstraints() {
        
        self.scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.contentViewContainer.snp.makeConstraints { (make) in
            make.top.right.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.size.equalTo(CGSize(width: 2000, height: 3000))
        }
        
        self.castTableView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(16)
        }
        
        self.crewTableView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.castTableView.snp.bottom).offset(16)
            make.bottom.equalToSuperview().inset(10)
        }
        
        super.updateViewConstraints()
    }
    
    init(cast: MWMovieCastResponse?) {
        super.init()
        self.movieFullCast = cast
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MWCastViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.castTableView {
            return self.movieFullCast?.cast.count ?? 0
        }
        
        return self.movieFullCast?.crew.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.castTableView {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: Constants.singleCastMemberTableViewCellId) as? MWCastMemberTableViewCell
                else { fatalError("The registered type for the cell does not match the casting") }
            
            cell.selectionStyle = .none
            
            cell.set(castMember: self.movieFullCast?.cast[indexPath.row])
            
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.singleCrewMemberTableViewCellId) as? MWCrewMemberTableViewCell
            else { fatalError("The registered type for the cell does not match the casting") }
        
        cell.selectionStyle = .none
        
        cell.set(crewMember: self.movieFullCast?.crew[indexPath.row])
        
        return cell
    }
}
