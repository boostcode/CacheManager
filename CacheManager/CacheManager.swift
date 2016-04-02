//
//  Manager.swift
//  AwesomeSwift
//
//  Created by Matteo Crippa on 31/03/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import Foundation
import RealmSwift

public enum CachePriority {
    case LocalThenRemote
    case RemoteThenLocal
    case RemoteOnly
}

public class CacheManager {
    public var realm = RealmProvider.realm()
    public var priority: CachePriority = .LocalThenRemote
    public var items = [Object]() {
        didSet {
            itemsUpdated()
        }
    }
    public var itemsCount: Int {
        return items.count
    }
    public var itemsUpdated: () -> () = {
        // used as notification for updates (eg. table reload)
    }

    required public init() {
        if priority == .LocalThenRemote {
            itemsFromCache()
            itemsFromRemote()
        }
        // TODO: need to improve this w/ other options
    }
    public func itemsFromCache() {
        // swiftlint:disable force_try
        // items = Array(try! realm.objects(Object))
    }
    public func itemsFromRemote() {
        
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
    public func itemAddFromArray(items: [Object]) {
        for item in items {
            itemAdd(item)
        }
    }
    public func itemUpdateAt(index: Int, item: Object) -> Bool {
        if 0..<itemsCount ~= index {
            let old = items[index]
            items[index] = item
            try! realm.write {
                realm.delete(old)
                realm.add(item)
            }
            return true
        }
        return false
    }
    public func itemRemoveAt(index: Int) -> Bool {
        if 0..<itemsCount ~= index {
            let item = items[index]
            items.removeAtIndex(index)
            // swiftlint:disable force_try
            try! realm.write {
                realm.delete(item)
            }
            return true
        }
        return false
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
