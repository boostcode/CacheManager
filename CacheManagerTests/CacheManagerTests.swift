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

        var dummy: DummyObject!
        var dummy2: DummyObject!

        /*beforeEach() {
            sut = DummyManager()

            dummy = DummyObject()
            dummy.name = "dummy"
            dummy2 = DummyObject()
            dummy2.name = "dummy2"
        }*/

        /*describe("manager") {
            context("items counter") {
                it("exists") {
                    expect(sut.count).toNot(beNil())
                }
                it("is 0 at init") {
                    expect(sut.count).to(equal(0))
                }
                it("is the same values of array items") {
                    expect(sut.count).to(equal(sut.items.count))
                }
            }
            context("items array") {
                it("exists") {
                    expect(sut.items).toNot(beNil())
                }
                it("returns first item") {
                    sut.itemAdd(dummy)
                    expect(sut.itemFirst()).to(equal(dummy))
                }
                it("returns last item") {
                    sut.itemAdd(dummy)
                    expect(sut.itemLast()).to(equal(dummy))
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
                it("adds items from array") {
                    expect(sut.items.count).to(equal(0))
                    sut.itemAddFromArray([dummy, dummy2])
                    expect(sut.items.count).to(equal(2))
                    expect(sut.itemAt(0)).to(equal(dummy))
                    expect(sut.itemAt(1)).to(equal(dummy2))
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
            context("notification") {
                it("on items update") {
                    sut.updated = false
                    expect(sut.updated).to(beFalse())
                    sut.itemAdd(dummy)
                    expect(sut.updated).to(beTrue())
                }
            }
        }*/
    }
}

class DummyObject: Object {
    dynamic var name: String = ""
}

class DummyManager: CacheManager<DummyObject>, CacheManagerDelegate {

    var updated = false

    func cacheHasUpdate() {
        self.updated = true
    }

}
