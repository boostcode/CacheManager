//
//  Manager.swift
//  AwesomeSwift
//
//  Created by Matteo Crippa on 31/03/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import UIKit
import RealmSwift

class CacheManager {
    var items = [Object]()
    var realm = RealmProvider.realm()
    var itemsCount: Int {
        return items.count
    }

    init() {
        itemsFromCache()
    }
    func itemsFromCache() {
        // swiftlint:disable force_try
        // items = Array(try! realm.objects(Object))
    }
    func itemAt(index: Int) -> Object? {
        if 0..<itemsCount ~= index {
            return items[index]
        } else {
            return nil
        }
    }
    func itemAdd(item: Object) {
        if items.contains(item) == false {
            items.append(item)
            // swiftlint:disable force_try
            try! realm.write {
                realm.add(item)
            }
        }
    }
    func itemRemoveAt(index: Int) {
        if 0..<itemsCount ~= index {
            let item = items[index]
            items.removeAtIndex(index)
            // swiftlint:disable force_try
            try! realm.write {
                realm.delete(item)
            }
        }
    }
    func itemRemoveAll() {
        items.removeAll()
        // swiftlint:disable force_try
        try! realm.write {
            realm.deleteAll()
        }
    }
}
