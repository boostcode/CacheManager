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
                it("gets item at index") {
                    sut.itemAdd(dummy)
                    let check = sut.itemAt(0)
                    expect(sut.itemAt(0)).to(equal(check))
                }
                it("doesn't get item out of range") {
                    sut.itemAdd(dummy)
                    expect(sut.itemAt(7)).to(beNil())
                }
                it("adds item") {
                    expect(sut.items.count).to(equal(0))
                    sut.itemAdd(dummy)
                    expect(sut.items.count).to(equal(1))
                    expect(sut.itemAt(0)).to(equal(dummy))
                }
                it("doesn't add the same item more than once") {
                    expect(sut.items.count).to(equal(0))
                    sut.itemAdd(dummy)
                    expect(sut.items.count).to(equal(1))
                    sut.itemAdd(dummy)
                    expect(sut.items.count).to(equal(1))
                }
                it("updates item at position") {
                    sut.itemAdd(dummy)
                    expect(sut.items.count).to(equal(1))
                    expect(sut.itemAt(0)).to(equal(dummy))
                    let success = sut.itemUpdateAt(0, item: dummy2)
                    expect(sut.items.count).to(equal(1))
                    expect(sut.itemAt(0)).to(equal(dummy2))
                    expect(success).to(beTrue())
                }
                it("doesn't update item out of range") {
                    sut.itemAdd(dummy)
                    expect(sut.items.count).to(equal(1))
                    expect(sut.itemAt(0)).to(equal(dummy))
                    let success = sut.itemUpdateAt(5, item: dummy2)
                    expect(success).to(beFalse())
                }
                it("removes item") {
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
                it("removes all items") {
                    expect(sut.items.count).to(equal(0))
                    sut.itemAdd(dummy)
                    sut.itemAdd(dummy2)
                    expect(sut.items.count).to(equal(2))
                    sut.itemRemoveAll()
                    expect(sut.items.count).to(equal(0))
                }
                it("doesn't remove out of range") {
                    expect(sut.items.count).to(equal(0))
                    sut.itemAdd(dummy)
                    expect(sut.items.count).to(equal(1))
                    let success = sut.itemRemoveAt(5)
                    expect(sut.items.count).to(equal(1))
                    expect(success).to(beFalse())
                }
            }
            context("realm cache") {
                it("exists") {
                    expect(sut.realm).toNot(beNil())
                }
                it("adds added") {
                    expect(sut.realm.objects(DummyObject).count).to(equal(0))
                    sut.itemAdd(dummy)
                    expect(sut.realm.objects(DummyObject).count).to(equal(1))
                    expect(sut.realm.objects(DummyObject)[0]).to(equal(dummy))
                }
                it("updates item"){
                    expect(sut.realm.objects(DummyObject).count).to(equal(0))
                    sut.itemAdd(dummy)
                    expect(sut.realm.objects(DummyObject).count).to(equal(1))
                    sut.itemUpdateAt(0, item: dummy2)
                    expect(sut.realm.objects(DummyObject)[0]).to(equal(dummy2))
                }
                it("removes delete") {
                    expect(sut.realm.objects(DummyObject).count).to(equal(0))
                    sut.itemAdd(dummy)
                    expect(sut.realm.objects(DummyObject).count).to(equal(1))
                    sut.itemRemoveAll()
                    expect(sut.realm.objects(DummyObject).count).to(equal(0))
                }
                it("handles cache") {
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
            context("notification") {
                it("on items update") {
                    sut.updated = false
                    expect(sut.updated).to(beFalse())
                    sut.itemAdd(dummy)
                    expect(sut.updated).to(beTrue())
                }
            }
        }
    }
}

class DummyObject: Object {
    dynamic var name: String = ""
}

class DummyManager: CacheManager {
    
    var updated = false
    
    required init() {
        super.init()
        super.items = [DummyObject]()
        super.itemsUpdated = {
            self.updated = true
        }
    }
    
    override func itemsFromCache() {
        // swiftlint:disable force_try
        super.items = Array(try! realm.objects(DummyObject))
    }

}
