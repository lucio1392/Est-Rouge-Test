//
//  API.swift
//  Est Rouge Test
//
//  Created by Lucio on 5/6/19.
//  Copyright © 2019 Lucio. All rights reserved.
//

import Foundation
import RxSwift


enum APIEndpoint {
    static let listUsers = "https://api.github.com/users"
    static let detailUser = "https://api.github.com/user"

    case listUsersEndpoint
    case detailUserEndpoint(String)

    var endPoint: URL? {
        switch self {
        case .listUsersEndpoint:
            return URL(string: APIEndpoint.listUsers)
        case .detailUserEndpoint(let userId):
            return URL(string: APIEndpoint.detailUser + "/\(userId)")
        }
    }
}

enum APIValidationError: Error {
    case errorEndpoint
    case commonError
    case parsingError
    case ok

    var localizedDescription: String {
        switch self {
        case .commonError:
            return "Error orcur"
        case .errorEndpoint:
            return "Error endpoint"
        case .parsingError:
            return "Error can not parsing model"
        case .ok:
            return ""
        }
    }
}

typealias Response<T> = Result<T, APIValidationError>

protocol APIProtocol {
    func listUsers() -> Observable<Response<[User]>>
    func detailUser(userId: String) -> Observable<Response<User>>
}

class API: APIProtocol {

    static let shared = API()

    private init() {}

    private func request<T>(_ endpoint: URL?) -> Observable<Response<T>> where T: Decodable {
        guard let endpoint = endpoint else {
            return Observable.just(.failure(.errorEndpoint))
        }

        return URLSession.shared
            .rx.response(request: URLRequest(url: endpoint))
            .retry(1)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))        
            .map { result -> Result<T, APIValidationError> in
                if result.response.statusCode == 200 {

                    do {
                        let resulModel = try JSONDecoder().decode(T.self, from: result.data)
                        return .success(resulModel)
                    } catch {
                        return .failure(.parsingError)
                    }

                }

                return .failure(.commonError)
        }.catchErrorJustReturn(.failure(.commonError))
    }

    func listUsers() -> Observable<Response<[User]>> {
        return request(APIEndpoint.listUsersEndpoint.endPoint)
    }


    func detailUser(userId: String) -> Observable<Response<User>> {
        return request(APIEndpoint.detailUserEndpoint(userId).endPoint)
    }

}
