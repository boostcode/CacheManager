//
//  Manager.swift
//  AwesomeSwift
//
//  Created by Matteo Crippa on 31/03/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import Foundation
import RealmSwift

public class CacheManager {
    public var items = [Object]()
    public var realm = RealmProvider.realm()
    public var itemsCount: Int {
        return items.count
    }

    required public init() {
        itemsFromCache()
    }
    public func itemsFromCache() {
        // swiftlint:disable force_try
        // items = Array(try! realm.objects(Object))
    }
    public func itemAt(index: Int) -> Object? {
        if 0..<itemsCount ~= index {
            return items[index]
        } else {
            return nil
        }
    }
    public func itemAdd(item: Object) {
        if items.contains(item) == false {
            items.append(item)
            // swiftlint:disable force_try
            try! realm.write {
                realm.add(item)
            }
        }
    }
    public func itemRemoveAt(index: Int) {
        if 0..<itemsCount ~= index {
            let item = items[index]
            items.removeAtIndex(index)
            // swiftlint:disable force_try
            try! realm.write {
                realm.delete(item)
            }
        }
    }
    public func itemRemoveAll() {
        items.removeAll()
        // swiftlint:disable force_try
        try! realm.write {
            realm.deleteAll()
        }
    }
}

class RealmProvider {
    class func realm() -> Realm {
        if let _ = NSClassFromString("XCTest") {
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
