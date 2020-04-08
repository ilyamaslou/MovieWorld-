//
//  MWCastViewController.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 4/3/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MWCastViewController: MWViewController {
    
    private var movieFullCast: [[Any]]? = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.register(MWCastMemberTableViewCell.self,
                           forCellReuseIdentifier: Constants.singleCastMemberTableViewCellId)
        tableView.register(MWCrewMemberTableViewCell.self,
                           forCellReuseIdentifier: Constants.singleCrewMemberTableViewCellId)
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .always
    }
    
    override func initController() {
        super.initController()
        self.title = "Cast"
        
        self.contentView.addSubview(self.tableView)
    }
    
    override func updateViewConstraints() {
        
        self.tableView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().inset(10)
        }
        
        super.updateViewConstraints()
    }
    
    init(cast: MWMovieCastResponse?) {
        super.init()
        self.movieFullCast = cast?.getFullCast()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MWCastViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movieFullCast?[section].count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.movieFullCast?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let castMember = self.movieFullCast?[indexPath.section][indexPath.row] as? MWMovieCastMember {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: Constants.singleCastMemberTableViewCellId) as? MWCastMemberTableViewCell
                else { fatalError("The registered type for the cell does not match the casting") }
            
            cell.selectionStyle = .none
            cell.set(castMember: castMember)
            
            return cell
        } else if let crewMember = self.movieFullCast?[indexPath.section][indexPath.row] as? MWMovieCrewMember {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: Constants.singleCrewMemberTableViewCellId) as? MWCrewMemberTableViewCell
                else { fatalError("The registered type for the cell does not match the casting") }
            
            cell.selectionStyle = .none
            cell.set(crewMember: crewMember)
            
            return cell
        } else {
            fatalError("You have some problems with members of cast")
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard  let groupMember = self.movieFullCast?[section].first as? MWMovieCrewMember
            else { return UIView() }
        
        let view = UIView()
        view.backgroundColor = .white
        
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 17,  weight: .bold)
        titleLabel.text = groupMember.job
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(24)
            make.bottom.equalToSuperview().inset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview()
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 0 else { return }
        MWI.s.pushVC(MWMemberViewController(member: self.movieFullCast?[indexPath.section][indexPath.row]))
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 57
        }
    }
}

