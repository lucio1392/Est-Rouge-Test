//
//  UsersViewModel.swift
//  Est Rouge Test
//
//  Created by Lucio on 5/4/19.
//  Copyright © 2019 Lucio. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class UsersViewModel: BaseViewModel {

    //output {
    var users: Driver<[User]> = PublishSubject<[User]>().asDriver(onErrorJustReturn: [])

    var error: Driver<APIValidationError> = PublishSubject<APIValidationError>().asDriver(onErrorJustReturn: .commonError)

    var loading: Driver<Bool> = PublishSubject<Bool>().asDriver(onErrorJustReturn: false)

    //}

    //input {
    let didPullToRefresh: PublishSubject<Void> = PublishSubject<Void>()
    //}

    override init() {

        super.init()

        let listUsersResponseResult = API.shared.listUsers().share(replay: 1).debug("Main Request")

        let didPullToRefresh = self.didPullToRefresh.flatMap {
            return listUsersResponseResult
        }

        let listUserSuccess = listUsersResponseResult
            .flatMapLatest(self.listUsers())

        let listUserError = listUsersResponseResult
            .flatMapLatest(self.errorRequest())

        let didPullToRefreshSuccess = didPullToRefresh.flatMapLatest(self.listUsers())

        let didPullToRefreshError = didPullToRefresh.flatMapLatest(self.errorRequest())

        let listUsers = Observable.of(listUserSuccess, didPullToRefreshSuccess).merge()

        let errorRequest = Observable.of(listUserError, didPullToRefreshError).merge()

        self.users = listUsers.asDriver(onErrorJustReturn: [])

        self.error = errorRequest.asDriver(onErrorJustReturn: .commonError)

        self.loading = listUsersResponseResult
            .map { _ in false}
            .startWith(true)
            .asDriver(onErrorJustReturn: false)

    }

    fileprivate func listUsers() -> (Response<[User]>) -> Observable<[User]> {
        return { result in
            switch result {
            case .failure:
                return Observable.just(CacheManage.default.getCachingListUsers())
            case .success(let users):
                return Observable.just(users)
            }
        }
    }

    fileprivate func errorRequest() -> (Response<[User]>) -> Observable<APIValidationError> {
        return { result in
            switch result {
            case .failure(let error):
                return Observable.just(error)
            case .success:
                return Observable.just(.ok)
            }
        }
    }

}
