//
//  UsersController.swift
//  Est Rouge Test
//
//  Created by Lucio on 5/4/19.
//  Copyright © 2019 Lucio. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

final class UsersController: BaseController<UsersView> {

    var viewModel: UsersViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "User List"
    }
}

extension UsersController: BindableType {

    func bindViewModel() {

        let usersTableView = rootView.listUsersTableView.rx

        let indicator = rootView.loadingIndicator.rx

        let loading = viewModel.loading

        let error = viewModel
                        .error
                        .filter { $0 != .ok }

        rootView.refreshControll.rx.controlEvent(.valueChanged)
            .map { [weak self] in
                guard let `self` = self else { return false }
                return self.rootView.refreshControll.isRefreshing
            }
            .filter { $0 }
            .map { _ in }
            .bind(to: viewModel.didPullToRefresh)
            .disposed(by: disposeBag)

        usersTableView
            .setDelegate(self)
            .disposed(by: disposeBag)        

        viewModel
            .users
            .do(onNext: { [weak self] users in
                guard let `self` = self else { return }
                CacheManage.default.cachingListUsers(users)               
                self.rootView.refreshControll.endRefreshing()
            })
            .drive(usersTableView.items(cellIdentifier: "UserCell", cellType: UserTableViewCell.self)) { (_, user, cell) in
                cell.feedData(user)
            }
            .disposed(by: disposeBag)        

        error
            .do(onNext: { [weak self] _ in
                guard let `self` = self else { return }                
                self.rootView.refreshControll.endRefreshing()
            })
            .map {
                $0.localizedDescription
            }
            .drive(onNext: { Alert.shared.show($0) })
            .disposed(by: disposeBag)


        loading
            .drive(indicator.isAnimating)
            .disposed(by: disposeBag)

        loading
            .map { !$0 }
            .drive(indicator.isHidden)
            .disposed(by: disposeBag)

        usersTableView
            .itemSelected
            .asDriver()
            .drive(onNext: { [weak self] index in
                guard let `self` = self else { return }
                self.rootView.listUsersTableView.deselectRow(at: index, animated: false)
            })
            .disposed(by: disposeBag)

        usersTableView
            .modelSelected(User.self)
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let `self` = self else { return }
                var detailController = DetailController()
                detailController.bind(to: DetailViewModel($0))
                self.navigationController?.pushViewController(detailController, animated: true)
        })
            .disposed(by: disposeBag)
    }


}

extension UsersController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }

}
