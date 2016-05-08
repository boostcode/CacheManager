//
//  Manager.swift
//  AwesomeSwift
//
//  Created by Matteo Crippa on 31/03/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import Foundation
import RealmSwift

public protocol CacheManagerDelegate {
    func cacheHasUpdate()
}

public class CacheManager<T where T: Object> {

    private var realm = RealmProvider.realm()

    var items: Results<T>! {
        didSet {
            delegate?.cacheHasUpdate()
        }
    }

    public var count: Int {
        return items.count
    }

    public var delegate: CacheManagerDelegate?

    public var ignoreOnUpdate: [String] = []

    public var sort: String? {
        didSet {
            syncCacheItems()
        }
    }

    public var sortAscending: Bool? {
        didSet {
            syncCacheItems()
        }
    }

    public var filter: NSPredicate? {
        didSet {
            syncCacheItems()
        }
    }

    public init() {
        syncCacheItems()
    }

    public func getRemoteItems(completion: (error: NSError?)->()) {}
}

extension CacheManager {
    private func getCacheItems<T: Object>(type: T.Type) -> Results<T> {
        return realm.objects(T)
    }

    private func syncCacheItems() {

        var tmp = getCacheItems(T)

        if let filter = self.filter {
            tmp = tmp.filter(filter)
        }

        if let order = self.sort {
            tmp = tmp.sorted(order, ascending: sortAscending!)
        }

        items = tmp

    }
}

extension CacheManager {
    public func itemAt(index: Int) -> T? {
        if 0..<count ~= index {
            return items[index]
        } else {
            return nil
        }
    }
    public func itemFirst() -> T? {
        if count > 0 {
            return items[0]
        } else {
            return nil
        }
    }
    public func itemLast() -> T? {
        if count > 0 {
            return items[count-1]
        } else {
            return nil
        }
    }
}

extension CacheManager {
    public func itemAdd(item: T) {
        // swiftlint:disable force_try
        try! realm.write {

            if let currentObject = try! realm.objectForPrimaryKey(T.self, key: item[T.primaryKey()!]!) {

                for ignore in ignoreOnUpdate {
                    if let current = currentObject[ignore] {
                        item[ignore] = current
                    }
                }
            }

            realm.add(item, update: true)
            syncCacheItems()
        }
    }
    public func itemAddFromArray(items: [T]) {
        for item in items {
            itemAdd(item)
        }
    }
    public func itemUpdate(item: T) {
        // swiftlint:disable force_try
        try! realm.write {
            realm.add(item, update: true)
            syncCacheItems()
        }
    }
    public func itemUpdate(item: T, key: String, value: AnyObject) {
        try! realm.write {
            item[key] = value
            syncCacheItems()
            delegate?.cacheHasUpdate()
        }
    }
    public func itemRemove(item: T) {
        // swiftlint:disable force_try
        try! realm.write {
            realm.delete(item)
            syncCacheItems()
        }
    }
    public func itemRemoveAll() {
        // swiftlint:disable force_try
        try! realm.write {
            realm.deleteAll()
            syncCacheItems()
        }
    }

}


class RealmProvider {
    class func realm() -> Realm {
        if let _ = NSClassFromString("QuickSpec") {
            // swiftlint:disable force_try
            return try! Realm(
                configuration: Realm.Configuration(
                    path: nil,
                    inMemoryIdentifier: "test",
                    encryptionKey: nil,
                    readOnly: false,
                    schemaVersion: 0,
                    migrationBlock: nil,
                    objectTypes: nil
                ))
        } else {
            // swiftlint:disable force_try
            return try! Realm()
        }
    }
}
