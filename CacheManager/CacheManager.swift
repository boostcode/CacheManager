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

    init() {
        syncItems()
    }

    private func getItems<T: Object>(type: T.Type) -> Results<T> {
        return realm.objects(T)
    }

    private func syncItems() {
        items = getItems(T)
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
            realm.add(item, update: true)
            syncItems()
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
            syncItems()
        }
    }
    public func itemUpdate(item: T, key: String, value: AnyObject) {
        try! realm.write {
            item[key] = value
        }
    }
    public func itemRemove(item: T) {
        // swiftlint:disable force_try
        try! realm.write {
            realm.delete(item)
            syncItems()
        }
    }
    public func itemRemoveAll() {
        // swiftlint:disable force_try
        try! realm.write {
            realm.deleteAll()
            syncItems()
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
