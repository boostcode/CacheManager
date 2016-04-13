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

private protocol CacheManagerProtocol {
    associatedtype T: Object
    var realm: Realm { get }
    var count: Int { get }
    var items: List<T> { get }
    var _items: List<T> { get set }
}

public class CacheManager<T where T: Object>: CacheManagerProtocol {

    init() {
        items = List<T>()
    }

    public var realm: Realm {
        return RealmProvider.realm()
    }
    var items: List<T> {
        didSet {
            delegate?.cacheHasUpdate()
        }
    }
    private var _items: List<T> {
        get {
            return self.items
        }
        set (newValue) {
            if newValue != items {
                self.items = newValue
            }
        }
    }

    public var count: Int {
        return items.count
    }

    public var delegate: CacheManagerDelegate?

}

extension CacheManager {
    public func itemAt(index: Int) -> Object? {
        if 0..<count ~= index {
            return items[index]
        } else {
            return nil
        }
    }
    public func itemFirst() -> Object? {
        if count > 0 {
            return items[0]
        } else {
            return nil
        }
    }
    public func itemLast() -> Object? {
        if count > 0 {
            return items[count-1]
        } else {
            return nil
        }
    }
}

extension CacheManager {
    public func itemAdd(item: Object) {
       /* if items.contains(item) == false {
            // swiftlint:disable force_try
            try! realm.write {
                realm.add(item)
            }
        }*/
    }
    public func itemAddFromArray(items: [Object]) {
        for item in items {
            itemAdd(item)
        }
    }
    public func itemUpdateAt(index: Int, item: Object) -> Bool {
        if 0..<count ~= index {
            let old = items[index]
            try! realm.write {
                realm.delete(old)
                realm.add(item)
            }
            return true
        }
        return false
    }
    public func itemRemoveAt(index: Int) -> Bool {
        if 0..<count ~= index {
            let item = items[index]
            // swiftlint:disable force_try
            try! realm.write {
                realm.delete(item)
            }
            return true
        }
        return false
    }
    public func itemRemoveAll() {
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
