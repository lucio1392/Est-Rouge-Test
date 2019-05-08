//
//  DetailCell.swift
//  Est Rouge Test
//
//  Created by Lucio on 5/7/19.
//  Copyright © 2019 Lucio. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

final class DetailCell: UITableViewCell {

    lazy var userImageView = UIImageView()

    lazy var usernameLabel: UILabel = {
        let usernameLabel = UILabel()
        usernameLabel.textColor = .black
        return usernameLabel
    }()

    lazy var locationLabel: UILabel = {
        let locationLabel = UILabel()
        locationLabel.textColor = .gray
        return locationLabel
    }()

    lazy var aboutSection: SectionView = {
        let aboutSection = SectionView()
        aboutSection.titleLabel.text = "About"
        return aboutSection
    }()

    lazy var bioLabel: UILabel = {
        let bioLabel = UILabel()
        bioLabel.numberOfLines = 3
        bioLabel.lineBreakMode = .byWordWrapping
        return bioLabel
    }()

    lazy var statsSection: SectionView = {
        let statsSection = SectionView()
        statsSection.titleLabel.text = "Stats"
        return statsSection
    }()

    lazy var publicRepoStat: StatsDetailView = {
        let publicRepoStat = StatsDetailView()
        return publicRepoStat
    }()

    lazy var followersRepoStat: StatsDetailView = {
        let followersRepoStat = StatsDetailView()
        return followersRepoStat
    }()

    lazy var followingRepoStat: StatsDetailView = {
        let followingRepoStat = StatsDetailView()
        return followingRepoStat
    }()

    fileprivate lazy var stats: [StatsDetailView] = [self.publicRepoStat, self.followersRepoStat, self.followingRepoStat]

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        userImageView.layer.cornerRadius = 40.0
        userImageView.clipsToBounds = true

        addSubview(userImageView)
        addSubview(usernameLabel)
        addSubview(locationLabel)

        //
        addSubview(aboutSection)
        aboutSection.addSubview(bioLabel)

        //
        addSubview(statsSection)
        statsSection.addSubview(publicRepoStat)
        statsSection.addSubview(followersRepoStat)
        statsSection.addSubview(followingRepoStat)

        publicRepoStat.backgroundColor = .red
        followingRepoStat.backgroundColor = .green
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        userImageView.snp.makeConstraints(userImageLayout())
        usernameLabel.snp.makeConstraints(usernameLayout())
        locationLabel.snp.makeConstraints(locationLayout())

        //

        aboutSection.snp.makeConstraints(aboutSectionLayout())
        bioLabel.snp.makeConstraints(bioLayout())

        //

        statsSection.snp.makeConstraints(statsSectionLayout())

        stats.enumerated().forEach { $0.element.snp.makeConstraints(statLayout($0.offset)) }
    }

    func feedData(_ user: User) {
        if let imageUrl = URL(string: user.avatar) {
            userImageView.setImage(url: imageUrl)
        }

        usernameLabel.text = user.name
        locationLabel.text = user.location ?? "No Location"
        bioLabel.text = user.bio ?? "Bio updating"

        publicRepoStat.feedData("\(user.publicRepos ?? 0)", statTitle: "Public Repo")
        followingRepoStat.feedData("\(user.following ?? 0)", statTitle: "Following")
        followersRepoStat.feedData("\(user.followers ?? 0)", statTitle: "Follower")
    }

}

extension DetailCell {
    private func userImageLayout() -> (ConstraintMaker) -> Void {
        return { maker in
            maker.left.equalToSuperview().offset(16.0)
            maker.top.equalToSuperview().offset(16.0)
            maker.width.height.equalTo(80.0)
        }
    }

    private func usernameLayout() -> (ConstraintMaker) -> Void {
        return { [weak self] maker in
            guard let `self` = self else { return }
            maker.left.equalTo(self.userImageView.snp.right).offset(8.0)
            maker.top.equalTo(self.userImageView.snp.top)
        }
    }

    private func locationLayout() -> (ConstraintMaker) -> Void {
        return { [weak self] maker in
            guard let `self` = self else { return }
            maker.left.equalTo(self.usernameLabel.snp.left)
            maker.bottom.equalTo(self.userImageView.snp.bottom)
        }
    }

    //
    private func aboutSectionLayout() -> (ConstraintMaker) -> Void {
        return { [weak self] maker in
            guard let `self` = self else { return }
            maker.height.equalTo(150.0)
            maker.top.equalTo(self.userImageView.snp.bottom).offset(8.0)
            maker.left.right.equalToSuperview()
        }
    }

    private func bioLayout() -> (ConstraintMaker) -> Void {
        return { [weak self] maker in
            guard let `self` = self else { return }
            maker.left.equalTo(self.aboutSection.titleLabel.snp.left)
            maker.right.equalToSuperview().offset(8.0)
            maker.top.equalTo(self.aboutSection.titleLabel.snp.bottom).offset(16.0)
        }
    }

    //
    private func statsSectionLayout() -> (ConstraintMaker) -> Void {
        return { [weak self] maker in
            guard let `self` = self else { return }
            maker.height.equalTo(150.0)
            maker.top.equalTo(self.aboutSection.snp.bottom)
            maker.left.right.equalToSuperview()
        }
    }

    private func statLayout(_ position: Int) -> (ConstraintMaker) -> Void {
        return { [weak self] maker in
            guard let `self` = self else { return }
            maker.top.equalTo(self.statsSection.titleLabel.snp.bottom).offset(4.0)
            maker.bottom.equalToSuperview()
            maker.width.equalToSuperview().dividedBy(self.stats.count)
            _ = position == 0 ? maker.left.equalToSuperview() : maker.left.equalTo(self.stats[position - 1].snp.right)
        }
    }



}

final class SectionView: BaseView {

    lazy var seperatorLineView: UIView = {
        let seperatorLineView = UIView()
        seperatorLineView.backgroundColor = .gray
        return seperatorLineView
    }()

    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        titleLabel.textColor = .black
        return titleLabel
    }()

    init() {
        super.init(frame: .zero)
        addSubview(seperatorLineView)
        addSubview(titleLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()

        seperatorLineView.snp.makeConstraints(seperatorLineLayout())
        titleLabel.snp.makeConstraints(titleLayout())
    }

    fileprivate func seperatorLineLayout() -> (ConstraintMaker) -> Void {
        return { maker in
            maker.height.equalTo(1.0)
            maker.top.equalToSuperview()
            maker.width.equalToSuperview()
        }
    }

    fileprivate func titleLayout() -> (ConstraintMaker) -> Void {
        return { maker in
            maker.top.equalTo(self.seperatorLineView.snp.bottom).offset(16.0)
            maker.left.right.equalToSuperview().offset(8.0)
        }
    }
}

final class StatsDetailView: BaseView {

    lazy var statLabel: UILabel = {
        let statsLabel = UILabel()
        statsLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        statsLabel.textColor = .red
        return statsLabel
    }()

    lazy var statLabelTitle: UILabel = {
        let statsLabelTitle = UILabel()
        statsLabelTitle.textColor = .gray
        return statsLabelTitle
    }()

    override func loadView() {
        super.loadView()

        addSubview(statLabel)
        addSubview(statLabelTitle)

        statLabelTitle.snp.makeConstraints(statsTitleLayout())
        statLabel.snp.makeConstraints(statsLayout())
    }

    func feedData(_ stat: String, statTitle: String) {
        statLabel.text = stat
        statLabelTitle.text = statTitle.capitalized
    }

    fileprivate func statsLayout() -> (ConstraintMaker) -> Void {
        return { maker in
            maker.top.equalToSuperview().offset(8.0)
            maker.left.equalToSuperview().offset(16.0)
        }
    }

    fileprivate func statsTitleLayout() -> (ConstraintMaker) -> Void {
        return { maker in
            maker.left.equalTo(self.statLabel.snp.left)
            maker.top.equalTo(self.statLabel.snp.bottom).offset(8.0)
        }
    }

}
