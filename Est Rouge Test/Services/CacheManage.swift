//
//  CacheManage.swift
//  Est Rouge Test
//
//  Created by Lucio on 5/7/19.
//  Copyright © 2019 Lucio. All rights reserved.
//

import Foundation
import Cache
import RxSwift

fileprivate let cachedKey = "ListUsers"

final class CacheManage {

    static let `default` = CacheManage()

    private init() {}

    private lazy var storage: Storage<[User]>? = {
        let diskConfig = DiskConfig(name: "CachedData", expiry: .never, maxSize: 10000, directory: try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask,
                                                                                                                                appropriateFor: nil, create: true).appendingPathComponent("MyPreferences"),protectionType: FileProtectionType.complete)

        let memoryConfig = MemoryConfig(expiry: .never, countLimit: 1000, totalCostLimit: 0)
        let storage = try? Storage(diskConfig: diskConfig, memoryConfig: memoryConfig, transformer: TransformerFactory.forCodable(ofType: [User].self))
        return storage
    }()

    func cachingListUsers(_ users: [User]) {
        do {
            if let storageExsiting = try storage?.existsObject(forKey: cachedKey), storageExsiting, users.count > 0  {
                try storage?.removeObject(forKey: cachedKey)
            }

            guard users.count > 0 else {
                return
            }

            try storage?.setObject(users, forKey: cachedKey)
        } catch let error {
            print(error)
        }
    }

    func updateCachingUser(_ user: User?) {
        guard let user = user else { return }
        cachingListUsers(getCachingListUsers().map { $0 == user ? user : $0 })
    }

    func getCachingListUsers() -> [User] {
        do {
            return try storage?.object(forKey: cachedKey) ?? []
        } catch let error {
            print(error)
            return []
        }
    }

    func getUser(_ userId: Int) -> User? {
        return getCachingListUsers().filter { $0.id == userId }.first
    }

}
