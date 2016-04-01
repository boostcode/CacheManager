//
//  RealmProvider.swift
//  AwesomeSwift
//
//  Created by Matteo Crippa on 27/03/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import UIKit
import RealmSwift

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
