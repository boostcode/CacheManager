//
//  ManagerTests.swift
//  AwesomeSwift
//
//  Created by Matteo Crippa on 31/03/2016.
//  Copyright © 2016 boostco.de. All rights reserved.
//

import Nimble
import Quick
import RealmSwift

@testable import CacheManager

class ManagerTests: QuickSpec {
    override func spec() {
        
        var sut: DummyManager!
        var realm: Realm!
        
        var dummy: DummyObject!
        var dummy2: DummyObject!
        
        beforeEach() {
            sut = DummyManager()
            
            dummy = DummyObject()
            dummy.name = "dummy"
            dummy2 = DummyObject()
            dummy2.name = "dummy2"
            
            realm = RealmProvider.realm()
            // swiftlint:disable force_try
            try! realm.write {
                realm.deleteAll()
            }
        }
        
        describe("manager") {
            context("items counter") {
                it("exists") {
                    expect(sut.itemsCount).toNot(beNil())
                }
                it("is 0 at init") {
                    expect(sut.itemsCount).to(equal(0))
                }
                it("is the same values of array items") {
                    expect(sut.itemsCount).to(equal(sut.items.count))
                }
            }
            context("items array") {
                it("exists") {
                    expect(sut.items).toNot(beNil())
                }
                it("can get item at index") {
                    sut.itemAdd(dummy)
                    let check = sut.itemAt(0)
                    expect(sut.itemAt(0)).to(equal(check))
                }
                it("can't get item out of range") {
                    sut.itemAdd(dummy)
                    expect(sut.itemAt(7)).to(beNil())
                }
                it("can add item") {
                    expect(sut.items.count).to(equal(0))
                    sut.itemAdd(dummy)
                    expect(sut.items.count).to(equal(1))
                    expect(sut.itemAt(0)).to(equal(dummy))
                }
                it("can't add the same item more than once") {
                    expect(sut.items.count).to(equal(0))
                    sut.itemAdd(dummy)
                    expect(sut.items.count).to(equal(1))
                    sut.itemAdd(dummy)
                    expect(sut.items.count).to(equal(1))
                }
                it("can remove item") {
                    expect(sut.items.count).to(equal(0))
                    sut.itemAdd(dummy)
                    expect(sut.items.count).to(equal(1))
                    sut.itemAdd(dummy2)
                    expect(sut.items.count).to(equal(2))
                    sut.itemRemoveAt(0)
                    expect(sut.items.count).to(equal(1))
                    sut.itemRemoveAt(0)
                    expect(sut.items.count).to(equal(0))
                }
                it("can remove all items") {
                    expect(sut.items.count).to(equal(0))
                    sut.itemAdd(dummy)
                    sut.itemAdd(dummy2)
                    expect(sut.items.count).to(equal(2))
                    sut.itemRemoveAll()
                    expect(sut.items.count).to(equal(0))
                }
                it("can't remove out of range") {
                    expect(sut.items.count).to(equal(0))
                    sut.itemAdd(dummy)
                }
            }
            context("realm cache") {
                it("exists") {
                    expect(sut.realm).toNot(beNil())
                }
                it("add added") {
                    expect(sut.realm.objects(DummyObject).count).to(equal(0))
                    sut.itemAdd(dummy)
                    expect(sut.realm.objects(DummyObject).count).to(equal(1))
                }
                it("removes delete") {
                    expect(sut.realm.objects(DummyObject).count).to(equal(0))
                    sut.itemAdd(dummy)
                    expect(sut.realm.objects(DummyObject).count).to(equal(1))
                    sut.itemRemoveAll()
                    expect(sut.realm.objects(DummyObject).count).to(equal(0))
                }
                it("handle cache") {
                    expect(sut.realm.objects(DummyObject).count).to(equal(0))
                    sut.itemAdd(dummy)
                    expect(sut.realm.objects(DummyObject).count).to(equal(1))
                    expect(sut.itemsCount).to(equal(1))
                    // test removing only item locally and not in cache
                    sut.items.removeAll()
                    expect(sut.realm.objects(DummyObject).count).to(equal(1))
                    expect(sut.itemsCount).to(equal(0))
                    // try to restore locally the realm cache
                    sut.itemsFromCache()
                    expect(sut.realm.objects(DummyObject).count).to(equal(1))
                    expect(sut.itemsCount).to(equal(1))
                }
            }
        }
    }
}

class DummyObject: Object {
    dynamic var name: String = ""
}

class DummyManager: CacheManager {
    required init() {
        super.init()
        super.items = [DummyObject]()
    }
    
    override func itemsFromCache() {
        // swiftlint:disable force_try
        super.items = Array(try! realm.objects(DummyObject))
    }
    
}
