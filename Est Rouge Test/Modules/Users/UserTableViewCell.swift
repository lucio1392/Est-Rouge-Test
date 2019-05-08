//
//  UserTableViewCell.swift
//  Est Rouge Test
//
//  Created by Lucio on 5/4/19.
//  Copyright © 2019 Lucio. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Imaginary

final class UserTableViewCell: UITableViewCell {

    lazy var userImageView = UIImageView()
    lazy var userNameLabel = UILabel()
    lazy var userUrlLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        userImageView.clipsToBounds = true
        userImageView.layer.cornerRadius = 40.0

        addSubview(userImageView)
        addSubview(userNameLabel)
        addSubview(userUrlLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func feedData(_ user: User) {
        userNameLabel.text = user.name
        userUrlLabel.text = user.htmlUrl

        if let imageURL = URL(string: user.avatar) {
            userImageView.setImage(url: imageURL)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        userImageView.snp.makeConstraints(userImageViewLayout())
        userNameLabel.snp.makeConstraints(userNameLabelLayout())
        userUrlLabel.snp.makeConstraints(userUrlLabelLayout())
    }


}

extension UserTableViewCell {

    fileprivate func userUrlLabelLayout() -> (ConstraintMaker) -> Void {
        return { [weak self] maker in
            guard let `self` = self else { return }
            maker.left.equalTo(self.userImageView.snp.right).offset(8.0)
            maker.bottom.equalTo(self.userImageView.snp.bottom)
        }
    }

    fileprivate func userNameLabelLayout() -> (ConstraintMaker) -> Void {
        return { [weak self] maker in
            guard let `self` = self else { return }
            maker.left.equalTo(self.userImageView.snp.right).offset(8.0)
            maker.top.equalTo(self.userImageView.snp.top)
        }
    }

    fileprivate func userImageViewLayout() -> (ConstraintMaker) -> Void {
        return { maker in
            maker.left.equalToSuperview().offset(16.0)
            maker.centerY.equalToSuperview()
            maker.width.height.equalTo(80.0)
        }
    }
    
}
