//
//  DetailViewModel.swift
//  Est Rouge Test
//
//  Created by Lucio on 5/4/19.
//  Copyright © 2019 Lucio. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class DetailViewModel: BaseViewModel {

    //output {
    var users: Driver<[User]> = PublishSubject<[User]>().asDriver(onErrorJustReturn: [])

    var error: Driver<APIValidationError> = PublishSubject<APIValidationError>().asDriver(onErrorJustReturn: .commonError)

    var loading: Driver<Bool> = PublishSubject<Bool>().asDriver(onErrorJustReturn: false)

    //input {
    let didPullToRefresh: PublishSubject<Void> = PublishSubject<Void>()

    //}

    init(_ user: User) {

        super.init()

        let userDetailResponseResult = API.shared.detailUser(userId: "\(user.id)").share(replay: 1)

        let didPullToRefresh = self.didPullToRefresh.flatMap {
            return userDetailResponseResult
        }

        let userSuccess = userDetailResponseResult
            .flatMapLatest(self.user(user.id))

        let userError = userDetailResponseResult
            .flatMapLatest(self.errorRequest())

        let didPullToRefreshSuccess = didPullToRefresh.flatMapLatest(self.user(user.id))

        let didPullToRefreshError = didPullToRefresh.flatMapLatest(self.errorRequest())

        let listUsers = Observable.of(userSuccess, didPullToRefreshSuccess).merge()

        let errorRequest = Observable.of(userError, didPullToRefreshError).merge()

        self.users = listUsers.asDriver(onErrorJustReturn: [])

        self.error = errorRequest.asDriver(onErrorJustReturn: .commonError)

        self.loading = userDetailResponseResult
            .map { _ in false}
            .startWith(true)
            .asDriver(onErrorJustReturn: false)
    }

    func ignoreNil<A>(x: A?) -> Observable<A> {
        return x.map { Observable.just($0) } ?? Observable.empty()
    }

    fileprivate func user(_ userId: Int) -> (Response<User>) -> Observable<[User]> {
        return { result in
            switch result {
            case .failure:
                guard let cachedUser = CacheManage.default.getUser(userId) else {
                    return Observable.just([])
                }
                return Observable.just([cachedUser])
            case .success(let user):
                return Observable.just([user])
            }
        }
    }

    fileprivate func errorRequest() -> (Response<User>) -> Observable<APIValidationError> {
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
