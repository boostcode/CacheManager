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

open class CacheManager<T> where T: Object {

    fileprivate var realm = RealmProvider.realm()

    var items: Results<T>! {
        didSet {
            delegate?.cacheHasUpdate()
        }
    }

    open var count: Int {
        return items.count
    }

    open var delegate: CacheManagerDelegate?

    open var ignoreOnUpdate: [String] = []

    open var sort: String? {
        didSet {
            syncCacheItems()
        }
    }

    open var sortAscending: Bool? {
        didSet {
            syncCacheItems()
        }
    }

    open var filter: NSPredicate? {
        didSet {
            syncCacheItems()
        }
    }

    public init() {
        syncCacheItems()
    }

    open func getRemoteItems(_ completion: (_ error: String?)->Void) {}
}

extension CacheManager {
    fileprivate func getCacheItems<T: Object>(_ type: T.Type) -> Results<T> {
        return realm.objects(T.self)
    }

    fileprivate func syncCacheItems() {
        var tmp = getCacheItems(T.self)

        if let filter = self.filter {
            tmp = tmp.filter(filter)
        }

        if let order = self.sort {
            tmp = tmp.sorted(byKeyPath: order, ascending: sortAscending!)
        }

        items = tmp

    }
}

// MARK: - Getter
extension CacheManager {
    public func itemAll() -> [T?] {
        return items.map({ $0 })
    }
    public func itemAt(_ index: Int) -> T? {
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

// MARK: - Setters
extension CacheManager {
    public func itemAdd(_ item: T, forceSync: Bool = true) {
        // swiftlint:disable force_try
        try! realm.write {

            if let currentObject = realm.object(ofType: T.self, forPrimaryKey: item[T.primaryKey()!]! as AnyObject) {

                for ignore in ignoreOnUpdate {
                    if let current = currentObject[ignore] {
                        item[ignore] = current
                    }
                }
            }

            realm.add(item, update: true)
            if forceSync == true {
                syncCacheItems()
            }
        }
    }
    public func itemAddFromArray(_ items: [T]) {
        for item in items {
            itemAdd(item, forceSync: false)
        }
        syncCacheItems()
    }
    public func itemUpdate(_ item: T) {
        // swiftlint:disable force_try
        try! realm.write {
            realm.add(item, update: true)
            syncCacheItems()
        }
    }
    public func itemUpdate(_ item: T, key: String, value: AnyObject) {
        try! realm.write {
            item[key] = value
            syncCacheItems()
            delegate?.cacheHasUpdate()
        }
    }
    public func itemRemove(_ item: T) {
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

// MARK: - Realm handler
class RealmProvider {
    class func realm() -> Realm {
        if let _ = NSClassFromString("QuickSpec") {
            // swiftlint:disable force_try
            return try! Realm(
                configuration: Realm.Configuration(
                    fileURL: nil,
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
