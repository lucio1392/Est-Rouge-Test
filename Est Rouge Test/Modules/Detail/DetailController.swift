//
//  DetailController.swift
//  Est Rouge Test
//
//  Created by Lucio on 5/4/19.
//  Copyright © 2019 Lucio. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class DetailController: BaseController<DetailView>, BindableType {

    var viewModel: DetailViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Profile"
    }

    func bindViewModel() {
        let userDetailTableView = rootView.detailUserTableView.rx

        let indicator = rootView.loadingIndicator.rx

        let loading = viewModel.loading

        let error = viewModel.error.filter { $0 != .ok }

        rootView.refreshControll.rx.controlEvent(.valueChanged)
            .map { [weak self] in
                guard let `self` = self else { return false }
                return self.rootView.refreshControll.isRefreshing
            }
            .filter { $0 }
            .map { _ in }
            .bind(to: viewModel.didPullToRefresh)
            .disposed(by: disposeBag)

        viewModel
            .users
            .do(onNext: { [weak self] users in
                guard let `self` = self else { return }
                CacheManage.default.updateCachingUser(users.first)
                self.rootView.refreshControll.endRefreshing()
            })
            .drive(userDetailTableView.items(cellIdentifier: "DetailUserCell", cellType: DetailCell.self)) { (_, user, cell) in                
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

        userDetailTableView
            .itemSelected
            .asDriver()
            .drive(onNext: { [weak self] index in
                guard let `self` = self else { return }
                self.rootView.detailUserTableView.deselectRow(at: index, animated: false)
            })
            .disposed(by: disposeBag)

    }

}
